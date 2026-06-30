# Meu Rosário — App Nativo (Expo + WebView)

Projeto Expo que empacota o `index.html` existente em um app nativo para Google Play e Apple App Store.

## Pré-requisitos

- Node.js 18+
- Conta em [expo.dev](https://expo.dev) (gratuita)
- Google Play Console ($25 taxa única) — para Android
- Apple Developer Program ($99/ano) — para iOS

## Como buildar (na nuvem, sem Mac)

```bash
# 1. Instalar dependências
cd app
npm install

# 2. Instalar o CLI do EAS globalmente
npm install -g eas-cli

# 3. Fazer login na conta Expo
eas login

# 4. Configurar o projeto (só na primeira vez)
eas build:configure

# 5. Build para Android — gera .aab para o Google Play
eas build --platform android --profile production

# 6. Build para iOS — gera .ipa para a App Store (sem precisar de Mac!)
eas build --platform ios --profile production
```

Os builds rodam na nuvem. Quando terminar, o EAS envia o link para download.

## Como submeter às lojas

```bash
# Submeter para o Google Play
eas submit --platform android

# Submeter para a Apple App Store
eas submit --platform ios
```

## Desenvolvimento local

```bash
npm install
npx expo start
```

Abre o Expo Go no celular e escaneia o QR code para ver o app.
