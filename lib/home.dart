import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app_search/globals.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter/services.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'controller.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<dynamic> _dadosGet = [];
  final controller = Controller();

  String result = "";

  TextEditingController _textControllerProdut = TextEditingController();

  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();

      result = _textControllerProdut.text = qrResult;

      setState(() {
        result = qrResult;
      });
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          result = "A permissão da câmera foi negada!";
        });
      } else {
        setState(() {
          result = "Erro desconhecido: $ex";
        });
      }
    } on FormatException {
      setState(() {
        result = "Usuário cancelou!";
      });
    } catch (ex) {
      setState(() {
        result = "Erro desconhecido: $ex";
      });
    }
    returnSearch();
  }

  returnSearch() async {
    result = _textControllerProdut.text.toString();

    getCodebar(result);
    //_textControllerProdut.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search codebar'),
        backgroundColor: colorGreenDark,
        actions: <Widget>[
          IconButton(
            icon: Icon(MdiIcons.barcodeScan, color: Colors.white),
            onPressed: _scanQR,
          ),
          Padding(padding: EdgeInsets.only(right: 5)),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          /*Observer(builder: (_){
            return Text(
              '${controller.counter}',
              style: Theme.of(context).textTheme.display1,
            );
          }),*/
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              controller: _textControllerProdut,
              autofocus: false,
              cursorColor: Colors.black87,
              style: TextStyle(color: Colors.black87),
              decoration: InputDecoration(
                hintText: 'Código de barras',
                /*suffixIcon: IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Colors.black87,
                    ),
                    onPressed: returnSearch
                ),*/
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black87)),
                disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black87)),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black87)),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(bottom: 10)),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: Column(
              children: returnCards(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          getCodebar('');
        },
        tooltip: 'Consulta',
        child: IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: returnSearch
        ),
      ),
    );
  }

  returnCards(){
    List<Widget> list = [];

    for(int i = 0; i < _dadosGet.length; i++){
      if(_dadosGet[i]['id'] != '') {
        list.add(
            Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    //title: Text('${_dadosGet[i]['descricao']}'),
                    title: Text('${_dadosGet[i]['id']} - ${_dadosGet[i]['descricao']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Cod.: ${_dadosGet[i]['codbar']}'),
                        Text('R\$: ${_dadosGet[i]['valor']}'),
                      ],
                    ),
                  ),
                ],
              ),
            )
        );
      } else {
        list.add(Container());
      }
    }

    return list;
  }

  Future getCodebar(codbar) async {
    final response = await http.get('$url_api?codbar=$codbar');
    print('$url_api?codbar=$codbar');

    if (response.statusCode == 200) {
      if (response.body != "null") {
        _dadosGet = json.decode(response.body);

        setState(() {});

        return _dadosGet;
      } else {
        return null;
      }
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }
}
