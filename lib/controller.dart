import 'package:flutter_app_search/search.dart';
import 'package:mobx/mobx.dart';
part 'controller.g.dart';

class Controller  = ControllerBase with _$Controller;

abstract class ControllerBase with Store {
  var search = Search();

  String checkCodBar(){
    if(search.codbar == null || search.codbar.isEmpty){
      return null;
    } else if(search.codbar.length < 13 || search.codbar.length > 13){
      return 'Codigo de barras deve conter 13 numeros.';
    }

    return null;
  }

  dispose(){}
}