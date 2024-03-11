import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inbetrieb/resources/appColors.dart';
import 'package:inbetrieb/screens/SplashScreen.dart';
import 'package:inbetrieb/Services/api_services.dart';

//  Flutter Version :: 3.13.7  //

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  GetIt.instance.registerSingleton<ApiServices>(ApiServices());
  const AudioContext audioContext = AudioContext(
    iOS: AudioContextIOS(
      // defaultToSpeaker: true,
      category: AVAudioSessionCategory.ambient,
      options: [
        AVAudioSessionOptions.defaultToSpeaker,
        AVAudioSessionOptions.mixWithOthers,
      ],
    ),
    android: AudioContextAndroid(
      isSpeakerphoneOn: true,
      stayAwake: true,
      contentType: AndroidContentType.sonification,
      usageType: AndroidUsageType.assistanceSonification,
      audioFocus: AndroidAudioFocus.none,
    ),
  );
  AudioPlayer.global.setAudioContext(audioContext);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Folder Tree Voice Notes Recorder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColor.primaryColor),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
