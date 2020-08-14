import 'package:flutter/material.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:youtube/model/Video.dart';
import '../Api.dart';

class Inicio extends StatefulWidget {

  String pesquisa;

  Inicio(this.pesquisa);

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {

  _listarVideos(String pesquisa){

    Api api = Api();
    return api.pesquisar(pesquisa);;

  }

  //Para carregar a tela uma única vez
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("chamado 1 - initState");
  }

  //Carrega as dependências
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print("chamado 2 - didChangeDependencies");
  }

  //para atualização de ciclo de dados ex: mudanças na interface
  @override
  void didUpdateWidget(Inicio oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    print("chamado 2 - didUpdateWidget");
  }

  //dispose para descarte de chamadas que não serão mais utilizadas ex: quando muda de tela
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print("chamado 4 - dispose");
  }

  //Constroi a aplicação
  @override
  Widget build(BuildContext context) {

    print("chamado 3 - build");

    return FutureBuilder<List<Video>>(
      future: _listarVideos(widget.pesquisa),
      builder: (context, snapshot){
        switch(snapshot.connectionState){

          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
            break;
          case ConnectionState.active:
          case ConnectionState.done:
              if(snapshot.hasData){

                return ListView.separated(
                    itemBuilder: (context, index){

                      List<Video> videos = snapshot.data;
                      Video video = videos[index];

                      return GestureDetector(
                        onTap: (){
                          // ignore: missing_return
                          FlutterYoutube.playYoutubeVideoById(
                            apiKey: CHAVE_YOUTUBE_API,
                            videoId: video.id,
                            autoPlay: true,
                            fullScreen: true
                          );
                        },
                         child: Column(
                            children: <Widget>[
                              Container(
                                height: 200,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(video.imagem)
                                    )
                                ),
                              ),
                              ListTile(
                                title: Text(video.titulo),
                                subtitle: Text(video.canal),
                              )
                            ],
                          ),
                      );

                    },
                    separatorBuilder: (context, index) => Divider(
                      height: 2,
                      color: Colors.grey,
                    ),
                    itemCount: snapshot.data.length
                );

              }else{
                return Center(
                  child: Text("Nenhum dado a ser exibido!"),
                );
              }
            break;

        }
      },
    );
  }
}
