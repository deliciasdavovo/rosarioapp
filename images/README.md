# Imagens dos mistérios

As imagens do app são servidas pelo jsDelivr, a partir deste repositório:

```
https://cdn.jsdelivr.net/gh/deliciasdavovo/rosarioapp@main/images/<pasta>/<arquivo>.jpg
```

Hospedar aqui, em vez de depender do Cloudinary ou do Unsplash, mantém o app
com uma dependência externa a menos e as imagens versionadas junto do código.

## Trazer para cá o que ainda está no Cloudinary

As 58 imagens que seguem no Cloudinary têm a migração pronta em
`scripts/migrar-imagens.sh`: ele baixa cada uma para a pasta certa e reescreve
as URLs no `index.html`.

```sh
./scripts/migrar-imagens.sh --dry-run   # confere o que seria baixado
./scripts/migrar-imagens.sh             # baixa e reescreve o index.html
git add images index.html && git commit && git push
```

O destino de cada imagem está em `scripts/imagens-cloudinary.tsv`. As URLs do
jsDelivr só respondem depois que o commit chega ao `main`.

## Como adicionar fotos novas de um mistério

1. Coloque os arquivos em `images/<pasta>/`, usando a pasta da tabela abaixo.
2. Mantenha o nome original da foto (`IMG_8607.jpg`) — é o que identifica a
   ordem em que foram tiradas.
3. Em `index.html`, troque as URLs do `imageUrls` daquele mistério pelas URLs
   do jsDelivr correspondentes.

## Situação atual

### Já hospedados aqui

| Mistério | Pasta | Fotos |
| --- | --- | --- |
| A Anunciação do Anjo a Maria | `anunciacao` | 7 |
| O Nascimento de Jesus | `nascimento` | 24 |
| A Apresentação no Templo | `apresentacao-templo` | 5 |
| A Agonia no Horto | `agonia-horto` | 3 |
| A Flagelação | `flagelacao` | 2 |
| A Coroação de Espinhos | `coroacao-espinhos` | 1 |
| A Crucificação e Morte | `crucificacao-morte` | 4 |

### Ainda no Cloudinary — 58 imagens

Todas cobertas pelo script acima. A pasta indicada é criada por ele.

| Mistério | Pasta | Fotos próprias | Arte da web |
| --- | --- | --- | --- |
| A Visitação de Maria a Isabel | `visitacao` | 10 | — |
| O Encontro de Jesus no Templo | `encontro-templo` | 3 | — |
| O Batismo no Jordão | `batismo-jordao` | 15 | — |
| A Auto-revelação nas Bodas de Caná | `bodas-cana` | 10 | — |
| Jesus Carrega a Cruz | `carrega-cruz` | 2 | — |
| A Ascensão | `ascensao` | 2 | — |
| A Vinda do Espírito Santo | `espirito-santo` | 2 | 2 |
| O Anúncio do Reino de Deus | `anuncio-reino` | — | 1 |
| A Transfiguração | `transfiguracao` | — | 3 |
| A Instituição da Eucaristia | `instituicao-eucaristia` | — | 4 |
| A Ressurreição | `ressurreicao` | — | 1 |
| A Assunção de Maria | `assuncao` | — | 2 |
| A Coroação de Maria | `coroacao-maria` | — | 1 |

As 44 fotos próprias mantêm o nome original (`IMG_8437.jpg`). As 14 da coluna
"arte da web" são imagens baixadas da internet, sem foto própria por trás:
recebem nome pela pasta (`assuncao-01.jpg`) e continuam sendo as candidatas a
substituição por fotos suas — trazê-las para o repositório tira a dependência
do Cloudinary, mas não resolve a origem delas.

### Pendentes — cards das orações

Os 11 cards da aba de orações (Creio, Pai Nosso, Ave Maria, Salve Rainha,
Glória, Ó Meu Jesus, Oferecimento, Agradecimento, Espírito Santo, São José,
São Miguel) usam paisagens genéricas do Unsplash, definidas em `ACERVO_ITEMS`
no `index.html`. Ainda não têm pasta aqui.
