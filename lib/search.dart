import 'package:mobx/mobx.dart';
part 'search.g.dart';

class Search = _SearchBarBase with _$Search;

abstract class _SearchBarBase with Store{
  @observable
  String codbar;
  @action
  changeCod(String value) => codbar = value;
}