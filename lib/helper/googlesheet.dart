import 'package:http/http.dart' as http;
import 'dart:convert';

import 'sharedPrefFuncitons.dart';

class FormConstructor {
  String name, email, lock, toDo, pin, index;
  FormConstructor(
      {this.name, this.email, this.lock, this.toDo, this.pin, this.index});
  getValues() {
    if (toDo == "signUp") return "?name=$name&email=$email&func=signUp";
    if (toDo == "lock") return "?func=lock&rowIndex=$index&lock=$pin";
    if (toDo == "signIn") return "?func=signIn&email=$email";
  }
}

class FormController {
  String toDo;
  FormController(this.toDo);

  void submit(FormConstructor formConstructor) async {
    String url =
        "https://script.google.com/macros/s/AKfycbzZvTPRuOWkTSuMzvsxmC7Uow6mAQKfk3w_p03z/exec";
    try {
      await http.get(url + formConstructor.getValues()).then((response) async {
        var data = json.decode(response.body);
        if (toDo == "signUp") {
          if (data['error'] == "none") {
            await SharedPrefFunctions.saveGoogleSheetIndexSharedPreference(
                data['index'].toString());
          } else {
            throw ('there was a error');
          }
        } else if (toDo == "lock") {
        } else if (toDo == "signIn") {
          await SharedPrefFunctions.saveGoogleSheetIndexSharedPreference(
              data['index'].toString());
          if (data['lock'].toString() != "none") {
            await SharedPrefFunctions.savePin(data['lock'].toString());
            await SharedPrefFunctions.savePinEnabledSharedPreference(true);
          }
        }
      });
    } catch (e) {
      print(e);
    }
  }
}
