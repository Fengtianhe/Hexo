---
title: ReactNative-组件react-native-camera
date: 2019-09-09 11:28:27
tags:
   - ReactNative
   - node_modules
categories: fe
---
### ReactNative版本 < 0.60.0
#### 1.1、安装  `react-native-camera@2.9.0` 版本
将 `missingDimensionStrategy 'react-native-camera', 'general'` 加入到 android/app/build.gradle 中
```
android {
    ...
    defaultConfig {
        ...
        missingDimensionStrategy 'react-native-camera', 'mlkit'
    }
    ...
}
```

#### 1.2、修改 `android/build.gradle` 中的 classpath
```
buildscript {
    ext {
        buildToolsVersion = "28.0.3"
        minSdkVersion = 16
        compileSdkVersion = 28
        targetSdkVersion = 28
        supportLibVersion = "28.0.0"
    }
    repositories {
        google()
        jcenter()
    }
    dependencies {
        // 注意这里的版本
        classpath('com.android.tools.build:gradle:3.3.0')

        // NOTE: Do not place your application dependencies here; they belong
        // in the individual module build.gradle files
    }
}

allprojects {
    repositories {
        mavenLocal()
        google()
        jcenter()
        maven {
            // All of React Native (JS, Obj-C sources, Android binaries) is installed from npm
            url "$rootDir/../node_modules/react-native/android"
        }
    }
}

```
#### 1.3、修改 android/gradle/wrapper/gradle-wrapper.properties 中的 gradle version
```
distributionUrl=https\://services.gradle.org/distributions/gradle-4.10.1-all.zip
```

#### 1.4、修改打包配置 `app/build.gradle`
```
android {
    ...
    packagingOptions {
        exclude 'META-INF/proguard/androidx-annotations.pro'
    }
}
```
---
### 使用react-native-camera扫码
```
import React from 'react'
import {RNCamera} from "react-native-camera";
import {Animated, Easing, Modal, Platform, StyleSheet, Text, Vibration, View} from 'react-native'
import PropType from 'prop-types'

var Sound = require('react-native-sound');
Sound.setCategory('Playback');

class Scanner extends React.Component {
  static propTypes = {
    visible: PropType.bool.isRequired,
    onClose: PropType.func.isRequired,
    onScanSuccess: PropType.func
  }

  constructor (props) {
    super(props);
    this.state = {
      moveAnim: new Animated.Value(0),
      code: ''
    };
  }

  componentDidMount () {
    this.startAnimation();
  }

  startAnimation = () => {
    this.state.moveAnim.setValue(0);
    Animated.timing(
      this.state.moveAnim,
      {
        toValue: -200,
        duration: 5000,
        easing: Easing.linear
      }
    ).start(() => this.startAnimation());
  };

  //  识别二维码
  onBarCodeRead = (result) => {
    const {data} = result;
    if (data && !this.state.code) {
      this.setState({code: data})

      // 扫码提示音
      var whoosh = new Sound('scanner.mp3', Sound.MAIN_BUNDLE, (error) => {
        if (error) {
          console.log('failed to load the sound', error);
          return;
        }
        // loaded successfully
        console.log('duration in seconds: ' + whoosh.getDuration() + 'number of channels: ' + whoosh.getNumberOfChannels());

        // Play the sound with an onEnd callback
        whoosh.play((success) => {
          if (success) {
            whoosh.pause()
            console.log('scan qr result => ', data)
            this.props.onScanSuccess && this.props.onScanSuccess(data)
          } else {
            console.log('playback failed due to audio decoding errors');
          }
        });
      });

      whoosh.setNumberOfLoops(1);
      whoosh.release();

      //手机振动
      if (Platform.OS === 'ios') {
        Vibration.vibrate(100, false)
      } else {
        Vibration.vibrate([0, 100], false)
      }
    }
  };

  render () {
    return (
      <Modal
        visible={this.props.visible}
        onRequestClose={this.props.onClose}
      >
        <View style={styles.container}>
          <RNCamera
            ref={ref => {
              this.camera = ref;
            }}
            style={styles.preview}
            type={RNCamera.Constants.Type.back}
            flashMode={RNCamera.Constants.FlashMode.on}
            onBarCodeRead={this.onBarCodeRead}
          >
            <View style={styles.rectangleContainer}>
              <View style={styles.rectangle}/>
              <Animated.View style={[
                styles.border,
                {transform: [{translateY: this.state.moveAnim}]}]}/>
              <Text style={styles.rectangleText}>将二维码/条码放入框内，即可自动扫描</Text>
            </View>
          </RNCamera>
        </View>
      </Modal>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    flexDirection: 'row',
    width: '100%',
    height: '100%'
  },
  preview: {
    flex: 1,
    justifyContent: 'flex-end',
    alignItems: 'center'
  },
  rectangleContainer: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: 'transparent'
  },
  rectangle: {
    height: 200,
    width: 200,
    borderWidth: 1,
    borderColor: '#00FF00',
    backgroundColor: 'transparent'
  },
  rectangleText: {
    flex: 0,
    color: '#fff',
    marginTop: 10
  },
  border: {
    flex: 0,
    width: 200,
    height: 2,
    backgroundColor: '#00FF00',
  }
});

export default Scanner
```