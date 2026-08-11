#!/usr/bin/env bash
#
# Traz para o repositório as imagens dos mistérios que ainda são servidas pelo
# Cloudinary e reescreve o index.html para apontar ao jsDelivr, que serve os
# arquivos daqui mesmo.
#
#   ./scripts/migrar-imagens.sh            # baixa e reescreve o index.html
#   ./scripts/migrar-imagens.sh --dry-run  # só mostra o que faria
#
# O que baixar está em scripts/imagens-cloudinary.tsv, uma linha por imagem:
#
#   <url do Cloudinary><TAB><caminho de destino no repositório>
#
# Depois de rodar, confira as imagens, faça o commit dos arquivos novos junto
# com o index.html e envie para o GitHub. As URLs do jsDelivr só passam a
# responder depois que o commit chega ao branch main.

set -euo pipefail

RAIZ="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MANIFESTO="$RAIZ/scripts/imagens-cloudinary.tsv"
HTML="$RAIZ/index.html"
BASE_JSDELIVR="https://cdn.jsdelivr.net/gh/deliciasdavovo/rosarioapp@main"

DRY_RUN=0
[ "${1:-}" = "--dry-run" ] && DRY_RUN=1

[ -f "$MANIFESTO" ] || { echo "manifesto não encontrado: $MANIFESTO" >&2; exit 1; }
[ -f "$HTML" ]      || { echo "index.html não encontrado: $HTML" >&2; exit 1; }

# Guarda os pares "url<TAB>destino" que baixaram de fato, para reescrever só o
# que existe — uma imagem que falhou continua apontando para o Cloudinary em vez
# de virar um link quebrado.
MIGRADAS="$(mktemp)"
trap 'rm -f "$MIGRADAS"' EXIT

baixadas=0
puladas=0
falhas=0

while IFS=$'\t' read -r url destino; do
  [ -n "${url:-}" ] || continue
  case "$url" in \#*) continue ;; esac

  alvo="$RAIZ/$destino"

  if [ -f "$alvo" ]; then
    echo "já existe   $destino"
    printf '%s\t%s\n' "$url" "$destino" >> "$MIGRADAS"
    puladas=$((puladas + 1))
    continue
  fi

  if [ "$DRY_RUN" = 1 ]; then
    echo "baixaria    $destino"
    baixadas=$((baixadas + 1))
    continue
  fi

  mkdir -p "$(dirname "$alvo")"

  # Baixa para um temporário e só move depois de validar, para nunca deixar um
  # arquivo truncado no lugar de uma imagem.
  tmp="$alvo.parcial"
  if ! curl -fsSL --max-time 120 -o "$tmp" "$url"; then
    echo "FALHOU      $destino  ($url)" >&2
    rm -f "$tmp"
    falhas=$((falhas + 1))
    continue
  fi

  # JPEG começa com FF D8 FF. Uma página de erro do Cloudinary passaria pelo
  # curl com status 200 em alguns casos, mas não por esta checagem.
  if [ "$(head -c 3 "$tmp" | od -An -tx1 | tr -d ' \n')" != "ffd8ff" ]; then
    echo "NÃO É JPEG  $destino  ($url)" >&2
    rm -f "$tmp"
    falhas=$((falhas + 1))
    continue
  fi

  mv "$tmp" "$alvo"
  echo "baixou      $destino  ($(wc -c < "$alvo" | tr -d ' ') bytes)"
  printf '%s\t%s\n' "$url" "$destino" >> "$MIGRADAS"
  baixadas=$((baixadas + 1))
done < "$MANIFESTO"

echo
echo "imagens: $baixadas baixadas, $puladas já no repositório, $falhas com erro"

if [ "$DRY_RUN" = 1 ]; then
  echo "(--dry-run: o index.html não foi tocado)"
  exit 0
fi

if [ ! -s "$MIGRADAS" ]; then
  echo "nada para reescrever no index.html"
  exit 0
fi

# Troca literal de URL por URL. As URLs do Cloudinary têm % e & do escape de
# acentos, então a substituição é feita como texto puro, não como regex.
python3 - "$HTML" "$MIGRADAS" "$BASE_JSDELIVR" <<'PY'
import sys

caminho_html, caminho_migradas, base = sys.argv[1], sys.argv[2], sys.argv[3]

with open(caminho_html, encoding='utf-8') as f:
    html = f.read()

trocas = 0
ausentes = []
with open(caminho_migradas, encoding='utf-8') as f:
    for linha in f:
        linha = linha.rstrip('\n')
        if not linha:
            continue
        url, destino = linha.split('\t')
        if url not in html:
            ausentes.append(url)
            continue
        html = html.replace(url, f'{base}/{destino}')
        trocas += 1

with open(caminho_html, 'w', encoding='utf-8') as f:
    f.write(html)

print(f'index.html: {trocas} URLs trocadas do Cloudinary para o jsDelivr')
for url in ausentes:
    print(f'  aviso: já não estava no index.html: {url}')
PY

restantes=$(grep -c 'res\.cloudinary\.com/ds53z2vv8/image' "$HTML" || true)
echo "ainda no Cloudinary (imagens): $restantes"
echo
echo "Próximo passo: git add images scripts index.html && git commit && git push"
