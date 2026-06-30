const { getDefaultConfig } = require('expo/metro-config');

const config = getDefaultConfig(__dirname);

// Permite que arquivos .html sejam empacotados como assets
config.resolver.assetExts.push('html');

module.exports = config;
