import { useCallback, useEffect, useState } from 'react';
import { StyleSheet, View } from 'react-native';
import { WebView } from 'react-native-webview';
import { Asset } from 'expo-asset';
import * as FileSystem from 'expo-file-system';
import * as Haptics from 'expo-haptics';
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

  // Vibração nativa acionada pelo WebView (funciona no iOS e no Android).
  const onMessage = useCallback((event) => {
    let data;
    try {
      data = JSON.parse(event.nativeEvent.data);
    } catch (e) {
      return;
    }
    if (!data || data.type !== 'haptic') return;

    if (data.kind === 'mystery') {
      // Mudança de mistério: feedback mais forte/notável.
      Haptics.notificationAsync(Haptics.NotificationFeedbackType.Success).catch(() => {});
    } else if (data.kind === 'tick') {
      // Toque leve durante o arrasto.
      Haptics.selectionAsync().catch(() => {});
    } else {
      // Troca de conta comum: toque curto.
      Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light).catch(() => {});
    }
  }, []);

  return (
    <View style={styles.container}>
      <StatusBar style="dark" backgroundColor="#EFECE6" translucent={false} />
      {uri && (
        <WebView
          source={{ uri }}
          style={styles.webview}
          onMessage={onMessage}
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
