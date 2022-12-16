import 'package:audioplayers/audioplayers.dart';
import 'package:cube_snake/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> with WidgetsBindingObserver {
  AudioPlayer player = AudioPlayer();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      player.stop();
    } else if (state == AppLifecycleState.resumed) {
      player.play(AssetSource('audio/myAudio.mp3'));
    } else {
      print(state.toString());
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void initState() {
    player.setPlayerMode(PlayerMode.lowLatency);
    player.play(AssetSource('audio/myAudio.mp3'));
    player.setReleaseMode(ReleaseMode.loop);
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigoAccent,
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 100.0,
            ),
            const Text(
              'Cube',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30.0,
                //fontWeight: FontWeight.bold,
              ),
            ),
            Stack(
              alignment: AlignmentDirectional.topCenter,
              children: const [
                Text(
                  'Snake',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 105.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Snake',
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 100.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 100.0,
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GamePage()),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'Play',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 50.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    Icons.play_circle_outline_outlined,
                    color: Colors.white,
                    size: 50.0,
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'Exit',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    Icons.exit_to_app_rounded,
                    color: Colors.white70,
                    size: 30.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
