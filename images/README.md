# Imagens dos mistérios

Esta pasta guarda, **dentro do repositório**, as fotos usadas nos mistérios do
terço. O app (`index.html`) carrega as imagens daqui como fonte principal, o que:

- faz as imagens funcionarem **offline** (o app é um PWA);
- remove a dependência de um serviço externo (Cloudinary), que pode ficar
  indisponível e fazer as imagens sumirem.

Se um arquivo local não existir aqui, o app tenta automaticamente a URL original
do Cloudinary e, por fim, mostra um placeholder — nada quebra.

## Como popular esta pasta

Num computador com internet, na raiz do projeto:

```bash
bash scripts/download-mystery-images.sh
git add images && git commit -m "Adiciona imagens locais dos mistérios"
```

O script lê todas as URLs do Cloudinary em `index.html` e baixa cada imagem para
cá, mantendo o mesmo nome de arquivo (ex.: `IMG_8424_rq0ya1.jpg`).
