#!/usr/bin/env python3
"""Põe imagens novas num mistério: copia os arquivos para images/<pasta>/ e
insere as URLs do jsDelivr no imageUrls correspondente do index.html.

    python3 scripts/adicionar-imagens.py visitacao /caminho/IMG_8437.jpeg ...

As imagens de um mistério ficam ordenadas pelo nome do arquivo, então mandar
em lotes ou de uma vez dá no mesmo. Rodar de novo com um arquivo já presente
apenas o sobrescreve, sem duplicar a URL.
"""

import re
import shutil
import sys
from pathlib import Path

RAIZ = Path(__file__).resolve().parent.parent
HTML = RAIZ / 'index.html'
BASE = 'https://cdn.jsdelivr.net/gh/deliciasdavovo/rosarioapp@main'

# Pasta de imagens -> título do mistério no index.html.
MISTERIOS = {
    'anunciacao': 'A Anunciação do Anjo a Maria',
    'visitacao': 'A Visitação de Maria a Isabel',
    'nascimento': 'O Nascimento de Jesus',
    'apresentacao-templo': 'A Apresentação no Templo',
    'encontro-templo': 'O Encontro de Jesus no Templo',
    'batismo-jordao': 'O Batismo no Jordão',
    'bodas-cana': 'A Auto-revelação nas Bodas de Caná',
    'anuncio-reino': 'O Anúncio do Reino de Deus',
    'transfiguracao': 'A Transfiguração',
    'instituicao-eucaristia': 'A Instituição da Eucaristia',
    'agonia-horto': 'A Agonia no Horto',
    'flagelacao': 'A Flagelação',
    'coroacao-espinhos': 'A Coroação de Espinhos',
    'carrega-cruz': 'Jesus Carrega a Cruz',
    'crucificacao-morte': 'A Crucificação e Morte',
    'ressurreicao': 'A Ressurreição',
    'ascensao': 'A Ascensão',
    'espirito-santo': 'A Vinda do Espírito Santo',
    'assuncao': 'A Assunção de Maria',
    'coroacao-maria': 'A Coroação de Maria',
}


def copiar(pasta, origens):
    """Copia cada arquivo para images/<pasta>/, sempre com extensão .jpg."""
    destino_dir = RAIZ / 'images' / pasta
    destino_dir.mkdir(parents=True, exist_ok=True)
    copiados = []
    for origem in origens:
        origem = Path(origem)
        if not origem.is_file():
            sys.exit(f'arquivo não encontrado: {origem}')
        with open(origem, 'rb') as f:
            if f.read(3) != b'\xff\xd8\xff':
                sys.exit(f'não é um JPEG: {origem}')
        # Anexos chegam com um prefixo aleatório ("a1b2c3d4-IMG_8437.jpeg");
        # o que identifica a imagem é o nome original.
        nome = re.sub(r'^[0-9a-f]{6,}-', '', origem.stem)
        destino = destino_dir / (nome + '.jpg')
        shutil.copyfile(origem, destino)
        destino.chmod(0o644)
        copiados.append(destino)
    return copiados


def reescrever(pasta):
    """Regrava o imageUrls do mistério com tudo que existe na pasta."""
    titulo = MISTERIOS[pasta]
    arquivos = sorted((RAIZ / 'images' / pasta).glob('*.jpg'))
    urls = [f'{BASE}/images/{pasta}/{a.name}' for a in arquivos]

    linhas = HTML.read_text(encoding='utf-8').split('\n')

    # Acha o título do mistério e, logo abaixo dele, o seu imageUrls.
    try:
        i = next(n for n, l in enumerate(linhas) if l.strip() == f"title: '{titulo}',")
    except StopIteration:
        sys.exit(f'título não encontrado no index.html: {titulo}')
    try:
        ini = next(n for n in range(i, min(i + 12, len(linhas)))
                   if linhas[n].strip().startswith('imageUrls:'))
    except StopIteration:
        sys.exit(f'imageUrls não encontrado abaixo de: {titulo}')

    # O bloco vai até a linha que fecha o array — numa linha só quando vazio.
    if linhas[ini].strip() == 'imageUrls: [],':
        fim = ini
    else:
        fim = next(n for n in range(ini, len(linhas)) if linhas[n].strip() in ('],', ']'))

    recuo = ' ' * (len(linhas[ini]) - len(linhas[ini].lstrip()))
    novo = [f'{recuo}imageUrls: ['] + [f"{recuo}  '{u}'," for u in urls] + [f'{recuo}],']
    linhas[ini:fim + 1] = novo

    HTML.write_text('\n'.join(linhas), encoding='utf-8')
    return urls


def main():
    if len(sys.argv) < 3:
        sys.exit(__doc__)
    pasta = sys.argv[1]
    if pasta not in MISTERIOS:
        sys.exit(f'pasta desconhecida: {pasta}\nopções: {", ".join(sorted(MISTERIOS))}')

    copiados = copiar(pasta, sys.argv[2:])
    urls = reescrever(pasta)

    print(f'{MISTERIOS[pasta]} ({pasta})')
    for c in copiados:
        print(f'  copiado  {c.relative_to(RAIZ)}  ({c.stat().st_size // 1024} KB)')
    print(f'  index.html: {len(urls)} imagens no mistério')


if __name__ == '__main__':
    main()
