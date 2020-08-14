import 'package:flutter/material.dart';
import 'package:am4_noticias/model/Noticia.dart';

class ItemNoticia extends StatelessWidget {

  Noticia noticia;
  VoidCallback onTapItem;
  VoidCallback onPressedRemover;

  ItemNoticia({
    @required this.noticia,
    this.onTapItem,
    this.onPressedRemover
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTapItem,
      child: Card(
        child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(children: <Widget>[

              SizedBox(
              width: 120,
              height: 120,
              child: Image.network(
                noticia.fotos[0],
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      noticia.titulo,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],),
              ),
            ),
            if( this.onPressedRemover != null) Expanded(
        flex: 1,
        child: FlatButton(
          color: Colors.white,
          padding: EdgeInsets.all(10),
          onPressed: this.onPressedRemover,
          child: Icon(Icons.delete_forever, color: Colors.red,),
        ),
      )
      //botao remover

      ],),)
    ,
    )
    ,
    );
  }
}