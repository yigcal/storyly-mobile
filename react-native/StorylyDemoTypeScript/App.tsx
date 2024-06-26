/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * Generated with the TypeScript template
 * https://github.com/react-native-community/react-native-template-typescript
 *
 * @format
 */

import React from 'react';
import {
  SafeAreaView,
  StatusBar,
  useColorScheme,
} from 'react-native';

import {
  Colors,
} from 'react-native/Libraries/NewAppScreen';

import { Storyly } from 'storyly-react-native';

const App = () => {
  const isDarkMode = useColorScheme() === 'dark';

  const backgroundStyle = {
    backgroundColor: isDarkMode ? Colors.darker : Colors.lighter,
  };

  return (
    <SafeAreaView style={backgroundStyle}>
      <StatusBar barStyle={isDarkMode ? 'light-content' : 'dark-content'} />
      <Storyly
        style={{ height: "100%" }}
        ref={ref => { ref?.setExternalData(
          [
            {
              "{Title}": "306",
              "{Price}": "1000",
              "{Image_url}": "https://img.yad2.co.il/Pic/202202/20/1_1/o/y2_1_03059_20220220170310.jpeg",
              "{Button}": "למודעה",
              "{Button_url}": "ylbgocfu",
              "{sg1_image_url}": "https://img.yad2.co.il/Pic/202202/20/1_1/o/y2_1_03059_20220220170310.jpeg",
              "{sg1_price}": "1000",
              "{sg1_title}": "306",
              "{sg1_subtitle}": "2000",
              "{sg1_button}": "ylbgocfu",
              "{sg1_button_url}": "ylbgocfu",
            }
          ]
        );}}
        storylyId="eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2NfaWQiOjQ4MTgsImFwcF9pZCI6OTk4OCwiaW5zX2lkIjoxMDUxNX0.L__nUAJ1Q8wt6KApQ_KtiqEPxvftoro_RDyRSHJmCl4"
        onLoad={event => { console.log(event); }}
        onFail={event => { console.log("[Storyly] onFail"); }}
        onPress={event => { console.log("[Storyly] onPress"); }}
        onEvent={event => { console.log("[Storyly] onEvent"); }}
        onStoryOpen={() => { console.log("[Storyly] onStoryOpen"); }}
        onStoryClose={() => { console.log("[Storyly] onStoryClose"); }}
        onUserInteracted={event => { console.log("[Storyly] onUserInteracted"); }}
      />
    </SafeAreaView>
  );
};

export default App;
