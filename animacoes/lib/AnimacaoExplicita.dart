import 'package:flutter/material.dart';

class AnimacaoExplicita extends StatefulWidget {
  @override
  _AnimacaoExplicitaState createState() => _AnimacaoExplicitaState();
}

class _AnimacaoExplicitaState extends State<AnimacaoExplicita> with SingleTickerProviderStateMixin{
  
  AnimationController _animationController;
  AnimationStatus _animationStatus;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 5),
      vsync: this
    )..repeat()..addStatusListener((status){
      _animationStatus;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(children: <Widget>[
        Container(
          width: 300,
          height: 400,
          child: RotationTransition(
            alignment: Alignment.center,
            child: Image.asset("imagens/logo.png"),
            turns: _animationController,
          ),
        ),
        RaisedButton(
          child: Text("Pressione"),
          onPressed: (){
            if(_animationStatus == AnimationStatus.dismissed){
              _animationController.repeat();
              //_animationController.forward();
            }else{
              _animationController.reverse();
            }
            /*
            if(_animationController.isAnimating){
              _animationController.stop();
            }else{
              _animationController.repeat();
            }
             */
          },
        )
      ],),
    );
  }
}
