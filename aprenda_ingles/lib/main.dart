import 'package:aprenda_ingles/telas/Home.dart';
import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';

void main() => runApp(MaterialApp(
      home: Video(),

      //home: Home(),
      //debugShowCheckedModeBanner: false,
      //theme: ThemeData(
      //  primaryColor: Color(0xff795548),
      //accentColor: Colors.green
      //  scaffoldBackgroundColor: Color(0xfff5e9b9)
      //),
    ));

class Video extends StatefulWidget {
  @override
  _VideoState createState() => _VideoState();
}

class _VideoState extends State<Video> {
  VideoPlayerController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    /*

    _controller = VideoPlayerController.network(
        "https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4"
    )
      ..initialize().then((_) {
        setState(() {
          _controller.play();
        });
      });

     */

    _controller = VideoPlayerController.asset("videos/exemplo.mp4")
      ..setLooping(true)
      ..initialize().then((_) {
        setState(() {});
        //_controller.play();
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _controller.value.initialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : Text("Pressione Play"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow
        ),
          onPressed: (){
            setState(() {
              _controller.value.isPlaying ? _controller.pause() : _controller.play();
            });
          }
      ),
    );
  }
}
