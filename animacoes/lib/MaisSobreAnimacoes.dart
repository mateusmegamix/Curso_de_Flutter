import 'package:flutter/material.dart';

class MaisSobreAnimacoes extends StatefulWidget {
  @override
  _MaisSobreAnimacoesState createState() => _MaisSobreAnimacoesState();
}

class _MaisSobreAnimacoesState extends State<MaisSobreAnimacoes> with SingleTickerProviderStateMixin{

  AnimationController _animationController;
  Animation _animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _animationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this
    );
    _animation = Tween<double>(
      begin: 0,
      end: 6.28
    ).animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {

    _animationController.forward();

    return Container(
      padding: EdgeInsets.all(20),
      color: Colors.white,
      child: AnimatedBuilder(
          animation: _animation,
          child: Image.asset("imagens/logo.png"),
          builder: (context, widget){


              return Transform.scale(
              scale: _animation.value, //Para isso deve alterar o begin para 0 e end para 1
              child: widget,
            );



            /*
            return Transform.rotate(
              angle: _animation.value,
              child: widget,
            );
             */
          },
      ),
    );
  }
}
