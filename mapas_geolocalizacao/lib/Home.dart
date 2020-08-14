import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _posicaoCamera = CameraPosition(
      target: LatLng(-23.565160, -46.651797),
      zoom: 19
  );

  Set<Marker> _marcadores = {};
  Set<Polygon> _polygons  = {};
  Set<Polyline> _polylines  = {};

  _onMapCreated( GoogleMapController googleMapController ){
    _controller.complete( googleMapController );
  }

  _movimentarCamera() async {

    GoogleMapController googleMapController = await _controller.future;
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        _posicaoCamera
      )
    );

  }

  _carregarMarcadores(){

    /*
    Set<Marker> marcadoresLocal = {};

    Marker marcadorShopping = Marker(
        markerId: MarkerId("marcador-shopping"),
        position: LatLng(-23.563370, -46.652923),
      infoWindow: InfoWindow(
        title: "Shopping Cidade São Paulo"
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueMagenta
      ),
      onTap: (){
        print("Shopping clicado!!");
      }
      //rotation: 45
    );

    Marker marcadorCartorio = Marker(
        markerId: MarkerId("marcador-cartorio"),
        position: LatLng(-23.562868, -46.655874),
      infoWindow: InfoWindow(
          title: "12 Cartório de notas"
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueBlue
      ),
        onTap: (){
          print("Cartório clicado!!");
        }
    );

    marcadoresLocal.add( marcadorShopping );
    marcadoresLocal.add( marcadorCartorio );

    setState(() {
      _marcadores = marcadoresLocal;
    });
    */
    /*
    Set<Polygon> listaPolygons = {};
    Polygon polygon1 = Polygon(
        polygonId: PolygonId("polygon1"),
      fillColor: Colors.green,
      strokeColor: Colors.red,
      strokeWidth: 20,
      points: [
        LatLng(-23.561816, -46.652044),
        LatLng(-23.563625, -46.653642),
        LatLng(-23.564786, -46.652226),
        LatLng(-23.563085, -46.650531),
      ],
      consumeTapEvents: true,
      onTap: (){
        print("clicado na área");
      },
      zIndex: 1
    );

    Polygon polygon2 = Polygon(
        polygonId: PolygonId("polygon2"),
        fillColor: Colors.purple,
        strokeColor: Colors.orange,
        strokeWidth: 20,
        points: [
          LatLng(-23.561629, -46.653031),
          LatLng(-23.565189, -46.651872),
          LatLng(-23.562032, -46.650831),
        ],
        consumeTapEvents: true,
        onTap: (){
          print("clicado na área");
        },
      zIndex: 0
    );

    listaPolygons.add( polygon1 );
    listaPolygons.add( polygon2 );

    setState(() {
      _polygons = listaPolygons;
    });
    */

    Set<Polyline> listaPolylines = {};
    Polyline polyline = Polyline(
        polylineId: PolylineId("polyline"),
        color: Colors.red,
        width: 40,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        jointType: JointType.round,
        points: [
          LatLng(-23.563645, -46.653642),
          LatLng(-23.565160, -46.651797),
          LatLng(-23.563232, -46.648020),
        ],
        consumeTapEvents: true,
        onTap: (){
          print("clicado na área");
        }
    );

    listaPolylines.add( polyline );
    setState(() {
      _polylines = listaPolylines;
    });

  }

  _recuperarLocalizacaoAtual() async {

    Position position = await Geolocator().getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    );

    setState(() {
      _posicaoCamera = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 17
      );
      _movimentarCamera();
    });

    //-23.565327, -46.650585

    //print("localizacao atual: " + position.toString() );

  }

  _adicionarListenerLocalizacao(){

    var geolocator = Geolocator();
    var locationOptions = LocationOptions(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10
    );
    geolocator.getPositionStream( locationOptions )
        .listen((Position position){

        print("localizacao atual: " + position.toString() );

        Marker marcadorUsuario = Marker(
            markerId: MarkerId("marcador-usuario"),
            position: LatLng(position.latitude, position.longitude),
            infoWindow: InfoWindow(
                title: "Meu local"
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueMagenta
            ),
            onTap: (){
              print("Meu local clicado!!");
            }
          //rotation: 45
        );

        setState(() {
          //-23.566989, -46.649598
          //-23.568395, -46.648353
          //_marcadores.add( marcadorUsuario );
          _posicaoCamera = CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 17
          );
          _movimentarCamera();

        });

    });

  }

  _recuperarLocalParaLatLong() async{

    List<Placemark> listaEnderecos = await Geolocator()
        .placemarkFromCoordinates(-23.565564, -46.652753);

    print("total: " + listaEnderecos.length.toString());

    if(listaEnderecos != null && listaEnderecos.length > 0){
      Placemark endereco = listaEnderecos[0];

      String resultado;

      resultado = "\n administrativeArea " + endereco.administrativeArea;
      resultado += "\n subAdministrativeArea " + endereco.subAdministrativeArea;
      resultado += "\n locality " + endereco.locality;
      resultado += "\n subLocality " + endereco.subLocality;
      resultado += "\n thoroughfare " + endereco.thoroughfare;
      resultado += "\n subThoroughfare " + endereco.subThoroughfare;
      resultado += "\n postalCode " + endereco.postalCode;
      resultado += "\n country " + endereco.country;
      resultado += "\n isoCountryCode " + endereco.isoCountryCode;
      resultado += "\n position " + endereco.position.toString();

      print("resultado: " + endereco.toString());
    }
  }

  _recuperarLocalParaEndereco() async{

    List<Placemark> listaEnderecos = await Geolocator()
        .placemarkFromAddress("Av. Paulista, 1372");

    print("total: " + listaEnderecos.length.toString());

    if(listaEnderecos != null && listaEnderecos.length > 0){
      Placemark endereco = listaEnderecos[0];

      String resultado;

      resultado = "\n administrativeArea " + endereco.administrativeArea;
      resultado += "\n subAdministrativeArea " + endereco.subAdministrativeArea;
      resultado += "\n locality " + endereco.locality;
      resultado += "\n subLocality " + endereco.subLocality;
      resultado += "\n thoroughfare " + endereco.thoroughfare;
      resultado += "\n subThoroughfare " + endereco.subThoroughfare;
      resultado += "\n postalCode " + endereco.postalCode;
      resultado += "\n country " + endereco.country;
      resultado += "\n isoCountryCode " + endereco.isoCountryCode;
      resultado += "\n position " + endereco.position.toString();

      print("resultado: " + endereco.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    //_carregarMarcadores();
    //_recuperarLocalizacaoAtual();
    //_adicionarListenerLocalizacao();
    //_recuperarLocalParaEndereco();
    _recuperarLocalParaLatLong();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mapas e geolocalização"),),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.done),
          onPressed: _movimentarCamera
      ),
      body: Container(
        child: GoogleMap(
            mapType: MapType.normal,
            //mapType: MapType.hybrid,
            //mapType: MapType.none,
            //mapType: MapType.satellite,
            //mapType: MapType.terrain,
            //-23.562436, -46.655005
            initialCameraPosition: _posicaoCamera,
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            markers: _marcadores,
            //polygons: _polygons,
            //polylines: _polylines,
        ),
      ),
    );
  }
}
