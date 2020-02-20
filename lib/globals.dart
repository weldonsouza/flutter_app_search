library my_prj.globals;

import 'dart:convert';
import 'package:date_format/date_format.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

String app = 'GRUPO DE PROFISSIONAIS';
String versaoApp = '';
String idNomeCPF = '';
String idNomeCursos = '';
String idProduto = '';
String idCategoria = '';
String codProdutPoints = '';
String codPoints = '';
String codPointsFilial = '';
String descricaoCategoria = '';
String addCategory;

Widget route;

bool isLoggedIn = false;
String name = '';
String dataFiltro = "";
String idTipoOperacao = '';
String idDataOperacao = '';
String titleQuestion = '';
String descriptionQuestion = '';

bool returnUser = true;
String idUser;

List<dynamic> returnCategoryName = [];


//Cor azul
var colorBlueLight = Color(0xff83c3f7);
var colorBlueDark = Color(0xff467eac);
//Cor vermelho
var colorRedLight = Color(0xFFE57373);
var colorRedDark = Color(0xFFef5350);
//Cor verde
var colorGreenLight = Color(0xff80CBC4);
var colorGreenDark = Color(0xFF4EC5AC);


//const String url_produts = "http://192.168.0.13:9191/rest/";
//const String url_produts = "http://172.40.1.7:9191/rest/";
//const String url_api = "http://190.15.121.162:9061/rest/";
const String url_api = "http://192.168.0.13:9194/rest/";
//const String url_api = "http://172.40.1.7:9194/rest/";
//const String url_api = "http://192.168.0.13:9194/rest/";
//const String url_api_externa = "http://190.15.121.162:9061/rest/";

DateTime selectedIni, selectedFin;

var f = NumberFormat('#,###.00', 'pt_BR');
var formatFraction = NumberFormat('#,###', 'pt_BR');
var formatacaoCategoria = NumberFormat("#,##0.00", "pt_BR");

// Valor de exibição data atual
String dataIni = DateFormat('dd/MM/yyyy').format(DateTime.now());
String dataFim = DateFormat('dd/MM/yyyy').format(DateTime.now());

// Data utilizada na pesquisa
String dataInicial = DateFormat('yyyyMMdd').format(selectedIni).toString();
String dataFinal = DateFormat('yyyyMMdd').format(selectedFin).toString();

DateTime todayDate;

convertDateFromString(String data){
  todayDate = DateTime.parse(data);
  return formatDate(todayDate, [dd, '/', mm, '/', yyyy]);
}

Color color;

colorBackground() {
    return color = Colors.blue[300];
}

mediaQuery(BuildContext context, double value, {String direction}) {
  MediaQueryData mediaQuery = MediaQuery.of(context);
  direction = direction ?? 'H';
  Size size = mediaQuery.size;
  if (direction.toUpperCase() == 'H') {
    return size.width * value;
  } else {
    return size.height * value;
  }
}

convertFilial(returnFiliais){
  switch (returnFiliais) {
    case '0103':
      returnFiliais = 'ARAPIRACA';
      break;
    case '0104':
      returnFiliais = 'JOAO PESSOA';
      break;
    case '0106':
      returnFiliais = 'CAMPINA GRANDE';
      break;
    case '0107':
      returnFiliais = 'NATAL';
      break;
    case '0108':
      returnFiliais = 'CABEDELO';
      break;
    case '0109':
      returnFiliais = 'FORTALEZA';
      break;
    case '0110':
      returnFiliais = 'JUAZEIRO';
      break;
    case '0201':
      returnFiliais = 'DONA VALMIRA';
      break;
    default:
      returnFiliais = 'MACEIO';
  }

  return returnFiliais;
}

iconContainer(i, {color, size, sizeH, id_categoria}) {
  if (i == '1' || id_categoria == '3') {
    return SvgPicture.asset(
      'assets/icon/arquiteto.svg',
      width: size,
      color: color,
    );
    //return Icon(Icons.business, color: color, size: size);
  } else if (i == '2' || id_categoria == '4') {
    return SvgPicture.asset(
      'assets/icon/pintor.svg',
      width: size,
      color: color,
    );
    //return Icon(Icons.format_paint, color: color, size: size);
  } else if (i == '3' || id_categoria == '5') {
    return SvgPicture.asset(
      'assets/icon/marceneiro.svg',
      width: size,
      color: color,
    );
    //return Icon(Icons.home, color: color, size: size);
  } else if (i == '4' || id_categoria == '6') {
    return SvgPicture.asset(
      'assets/icon/gesso.svg',
      width: size,
      color: color,
    );
    //return Icon(Icons.home, color: color, size: size);
  } else if (i == '5' || id_categoria == '7') {
    return SvgPicture.asset(
      'assets/icon/encanador.svg',
      width: size,
      color: color,
    );
    //return Icon(Icons.build, color: color, size: size);
  } else if (i == '6' || id_categoria == '8') {
    return SvgPicture.asset(
      'assets/icon/designer.svg',
      width: size,
      color: color,
    );
    return Icon(Icons.format_paint, color: color, size: size);
  } else if (i == '7' || id_categoria == '9') {
    return SvgPicture.asset(
      'assets/icon/eletricista.svg',
      width: size,
      color: color,
    );
    //return Icon(Icons.home, color: color, size: size);
  } else if (i == '8' || id_categoria == '10') {
    return SvgPicture.asset(
      'assets/icon/engenheiro.svg',
      width: size,
      color: color,
    );
    //return Icon(Icons.business, color: color, size: size);
  } else {
    /*return SvgPicture.asset(
      'assets/icon/novoprof.svg',
      width: size,
      color: color,
    );*/
    return Icon(Icons.person_pin, color: color, size: size);
  }
}

var returnChave;

// Concatenação da chave vinda da API com o nome do App, usada para validadar todos os acessos das APIs
securetChave(token) {
  var firstChunk = utf8.encode(app);

  var output = new AccumulatorSink<Digest>();
  var input = md5.startChunkedConversion(output);
  input.add(firstChunk);
  input.close();
  var digest = output.events.single;

  returnChave = '$token-$digest';
  print(returnChave);
}

// Caso o token estaja invalido ou experido.
returnCheckToken(context, token) {
  if (token != 'VALIDO!') {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: <Widget>[
              Image.asset('assets/alert.png', width: mediaQuery(context, 0.06),
              ),
              Padding(padding: EdgeInsets.only(left: 10)),
              Text('Informativo'),
            ],
          ),
          actions: <Widget>[
            FlatButton(
                child: Text(
                  "OK",
                  style: TextStyle(color: colorBackground()),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ],
          content: SingleChildScrollView(
            child: Text('Seu token de acesso esta $token\nSerá necessário realizar o login novamente, feche o aplicativo e o execute novamente!'),
          ),
        );
      },
    );
  }
}
