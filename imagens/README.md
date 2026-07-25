# Imagens do app (hospedadas no próprio repositório / GitHub Pages)

Antes as imagens eram carregadas do Cloudinary. Como o Cloudinary foi bloqueado,
o app agora carrega as imagens **desta pasta**, servidas pelo mesmo GitHub Pages
que hospeda o `index.html`. No código, cada imagem é referenciada por um caminho
relativo, por exemplo:

```
imagens/IMG_8424_rq0ya1.jpg
```

## O que você precisa fazer

1. Coloque **todos** os arquivos listados em `ARQUIVOS-NECESSARIOS.txt` dentro
   desta pasta `imagens/`, com **exatamente o mesmo nome** (respeitando
   maiúsculas/minúsculas e acentos).
2. Faça commit e push. O GitHub Pages passa a servir as imagens automaticamente.

## De onde tirar os arquivos

Os nomes correspondem ao "public_id" do Cloudinary. Se você ainda tem acesso à
sua conta Cloudinary (Media Library no navegador), pode baixar cada imagem — o
nome do arquivo baixado já costuma bater com o esperado. Se não tiver mais
acesso, use os arquivos originais das fotos/imagens que você havia enviado.

## Observações

- **Não é preciso** manter o sufixo aleatório fora do padrão: o nome do arquivo
  deve ser idêntico ao listado (ex.: `IMG_8424_rq0ya1.jpg`, e não `IMG_8424.jpg`).
- Arquivos com acento no nome (ex.: `Ressurreição_de_Jesus_aj7qtm.jpg`) devem ser
  salvos com o acento — o navegador resolve o caminho corretamente.
- Se alguma imagem faltar, o app não quebra: ele mostra um placeholder discreto
  (o ícone do app) no lugar, graças ao tratamento de erro já existente.
- Limites do GitHub Pages: repositório recomendado até ~1 GB e cada arquivo até
  100 MB. As imagens deste app estão bem abaixo disso.
