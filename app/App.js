import { useEffect, useState } from 'react';
import { StyleSheet, View } from 'react-native';
import { WebView } from 'react-native-webview';
import { Asset } from 'expo-asset';
import * as FileSystem from 'expo-file-system';
import { StatusBar } from 'expo-status-bar';

const HTML_DEST = FileSystem.documentDirectory + 'meurosario/index.html';

export default function App() {
  const [uri, setUri] = useState(null);

  useEffect(() => {
    async function prepare() {
      // Garante que a pasta existe
      await FileSystem.makeDirectoryAsync(
        FileSystem.documentDirectory + 'meurosario/',
        { intermediates: true }
      );

      // Carrega o asset empacotado e copia para um local acessível via file://
      const [asset] = await Asset.loadAsync(require('../index.html'));
      await FileSystem.copyAsync({ from: asset.localUri, to: HTML_DEST });

      setUri(HTML_DEST);
    }
    prepare();
  }, []);

  return (
    <View style={styles.container}>
      <StatusBar style="dark" backgroundColor="#EFECE6" translucent={false} />
      {uri && (
        <WebView
          source={{ uri }}
          style={styles.webview}
          allowFileAccessFromFileURLs={true}
          allowUniversalAccessFromFileURLs={true}
          originWhitelist={['*']}
          javaScriptEnabled={true}
          domStorageEnabled={true}
          mediaPlaybackRequiresUserAction={false}
          mixedContentMode="always"
          // Preserva localStorage entre sessões
          sharedCookiesEnabled={true}
        />
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#EFECE6' },
  webview: { flex: 1 },
});
