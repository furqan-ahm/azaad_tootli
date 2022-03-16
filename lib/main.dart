import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:volume_control/volume_control.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'AzaadTootli'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final AudioPlayer _player=AudioPlayer();
  Stream<double>? volumeLevel;

  double volume=1;
  double speed=1;

  @override
  void initState() {
    VolumeControl.volume.then((value) => volume=value);
    volumeLevel=VolumeStream();

    _player.setAsset('assets/fx.mp3');
    _player.setVolume(2.5);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      stream: volumeLevel!,
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(widget.title,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w800),),
          ),
          backgroundColor: Colors.green,
          body: Center(
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Icon(Icons.volume_up,color: Colors.white,),
                        Expanded(
                          child: RotatedBox(
                            quarterTurns: 3,
                            child: Slider(
                              min: 0,
                              max: 1,
                              divisions: 15,
                              activeColor: Colors.white,
                              inactiveColor: Colors.greenAccent,
                              value: volume,
                              onChanged: (value) {
                                setState(() {
                                  VolumeControl.setVolume(value);
                                  volume=value;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.blue,
                        border: Border.all(color: Colors.white,width: 5)
                      ),
                      child: FloatingActionButton.large(
                        backgroundColor: Colors.green.withBlue(30),
                        child: Image.asset('assets/star.png',fit: BoxFit.cover,),
                          onPressed: (){
                            _player.setAsset('assets/fx.mp3').then((value) => _player.play());
                        }
                        ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Icon(Icons.speed,color: Colors.white,),
                        Expanded(
                          child: RotatedBox(
                            quarterTurns: 3,
                            child: Slider(
                              min: 0,
                              max: 2.5,
                              activeColor: Colors.white,
                              inactiveColor: Colors.greenAccent,
                              value: speed,
                              onChanged: (value) {
                                setState(() {
                                  speed=value;
                                  _player.setSpeed(value);
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Text('Made by BakarWorks',style: TextStyle(color: Colors.white),),
                      SizedBox(height: 20,)
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }
    );
  }

  Stream<double> VolumeStream()async* {
    while (true) {
      volume = await VolumeControl.volume;
      yield volume;
    }
  }
}
