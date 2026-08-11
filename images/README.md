# Imagens dos mistérios

As imagens do app são servidas pelo jsDelivr, a partir deste repositório:

```
https://cdn.jsdelivr.net/gh/deliciasdavovo/rosarioapp@main/images/<pasta>/<arquivo>.jpg
```

Hospedar aqui, em vez de depender do Cloudinary ou do Unsplash, mantém o app
com uma dependência externa a menos e as imagens versionadas junto do código.

## Como adicionar as fotos de um mistério

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

### Pendentes — fotos próprias, ainda no Cloudinary

São fotos que já existem; só precisam ser reenviadas para entrar no
repositório. A pasta indicada é a que deve ser criada.

| Mistério | Pasta | Fotos | Arquivos originais |
| --- | --- | --- | --- |
| A Visitação de Maria a Isabel | `visitacao` | 10 | IMG_8437 a IMG_8446 |
| O Encontro de Jesus no Templo | `encontro-templo` | 3 | IMG_8508, 8509, 8512 |
| O Batismo no Jordão | `batismo-jordao` | 15 | IMG_8519 a IMG_8534 |
| A Auto-revelação nas Bodas de Caná | `bodas-cana` | 10 | IMG_8535 a IMG_8546 |
| Jesus Carrega a Cruz | `carrega-cruz` | 2 | IMG_8766, IMG_8767 |
| A Ascensão | `ascensao` | 2 | WhatsApp 03/06, 17:25 |
| A Vinda do Espírito Santo | `espirito-santo` | 2 | WhatsApp 03/06, 17:57 |

### Pendentes — sem foto própria

Estes mistérios ainda usam arte baixada da internet. Não há arquivo original
para reenviar: precisam de fotos novas.

| Mistério | Pasta | Imagens da web hoje |
| --- | --- | --- |
| O Anúncio do Reino de Deus | `anuncio-reino` | 1 |
| A Transfiguração | `transfiguracao` | 3 |
| A Instituição da Eucaristia | `instituicao-eucaristia` | 4 |
| A Vinda do Espírito Santo | `espirito-santo` | 2 (além das 2 próprias) |
| A Ressurreição | `ressurreicao` | 1 |
| A Assunção de Maria | `assuncao` | 2 |
| A Coroação de Maria | `coroacao-maria` | 1 |

### Pendentes — cards das orações

Os 11 cards da aba de orações (Creio, Pai Nosso, Ave Maria, Salve Rainha,
Glória, Ó Meu Jesus, Oferecimento, Agradecimento, Espírito Santo, São José,
São Miguel) usam paisagens genéricas do Unsplash, definidas em `ACERVO_ITEMS`
no `index.html`. Ainda não têm pasta aqui.
