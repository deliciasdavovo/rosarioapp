#!/usr/bin/env bash
#
# Baixa todas as imagens dos mistérios (hospedadas no Cloudinary) para ./images/,
# para que o app as sirva localmente. Assim as fotos funcionam OFFLINE (o app é um
# PWA) e deixam de depender do serviço externo, que pode ficar indisponível.
#
# Uso (rode na raiz do projeto, num computador com internet):
#   bash scripts/download-mystery-images.sh
#
# Depois, faça commit da pasta images/ gerada.
#
set -euo pipefail

# Vai para a raiz do projeto (um nível acima de scripts/)
cd "$(dirname "$0")/.."

mkdir -p images

# Extrai todas as URLs do Cloudinary referenciadas no index.html
urls=$(grep -oE "https://res.cloudinary.com/[^'\"]+" index.html | sort -u)
total=$(printf '%s\n' "$urls" | grep -c . || true)

echo "Encontradas $total imagens em index.html. Baixando para ./images/ ..."
echo

ok=0
fail=0
skip=0
while IFS= read -r url; do
  [ -z "$url" ] && continue
  name="${url##*/}"        # nome do arquivo (parte final da URL)
  dest="images/$name"

  # Pula se já existe e tem conteúdo (permite retomar downloads interrompidos)
  if [ -s "$dest" ]; then
    skip=$((skip + 1))
    echo "  = já existe: $name"
    continue
  fi

  if curl -fsSL "$url" -o "$dest"; then
    ok=$((ok + 1))
    echo "  ✓ $name"
  else
    fail=$((fail + 1))
    rm -f "$dest"   # remove arquivo parcial/vazio em caso de erro
    echo "  ✗ FALHOU: $name  ($url)"
  fi
done <<< "$urls"

echo
echo "Concluído: $ok baixadas, $skip já existiam, $fail falharam (de $total)."
if [ "$fail" -ne 0 ]; then
  echo
  echo "Atenção: algumas imagens falharam ao baixar."
  echo "Se TODAS falharam, provavelmente a conta Cloudinary está com cota"
  echo "estourada, suspensa ou com entrega restrita — verifique o painel do Cloudinary."
  exit 1
fi
echo "Pronto! Agora faça: git add images && git commit -m \"Adiciona imagens locais dos mistérios\""
