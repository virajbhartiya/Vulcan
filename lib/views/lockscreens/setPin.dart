import 'package:chatapp/helper/googlesheet.dart';
import 'package:chatapp/helper/sharedPrefFuncitons.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SetPin extends StatefulWidget {
  const SetPin({Key key}) : super(key: key);

  @override
  _SetPinState createState() => _SetPinState();
}

class _SetPinState extends State<SetPin> {
  bool visible = false;
  TextEditingController pinController = new TextEditingController();
  TextEditingController reEnterController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  googleSheets(String pin) async {
    String index =
        await SharedPrefFunctions.getGoogleSheetIndexSharedPreference();
    FormConstructor formConstructor =
        FormConstructor(pin: pin, toDo: "lock", index: index);
    FormController formController = FormController("lock");
    formController.submit(formConstructor);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Pin.",
            style: GoogleFonts.workSans(fontSize: 50),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Container(
                      height: MediaQuery.of(context).size.height - 120,
                      child: Column(
                        children: [
                          Spacer(),
                          Text("Enter a 4 digit Pin",
                              style: GoogleFonts.workSans(fontSize: 20)),
                          Spacer(flex: 2),
                          TextFormField(
                            validator: (value) {
                              return value.length == 4
                                  ? null
                                  : "Plese enter a 4 digit pin";
                            },
                            controller: pinController,
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            cursorColor: Colors.green[50],
                            decoration: InputDecoration(
                              counterText: "",
                              fillColor: Theme.of(context).backgroundColor,
                              filled: true,
                              enabledBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(100),
                                ),
                                borderSide: BorderSide(
                                  color: Color(0xff06d6a7),
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                    !visible
                                        ? FeatherIcons.eye
                                        : FeatherIcons.eyeOff,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                                color: Theme.of(context).colorScheme.primary,
                                onPressed: () {
                                  setState(() {
                                    visible = !visible;
                                    Future.delayed(
                                        const Duration(milliseconds: 1500), () {
                                      setState(() {
                                        visible = false;
                                      });
                                    });
                                  });
                                },
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(100),
                                ),
                                borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ),
                              border: InputBorder.none,
                              hintText: "Pin",
                              hintStyle: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              contentPadding: const EdgeInsets.only(
                                left: 18,
                                right: 20,
                                top: 14,
                                bottom: 14,
                              ),
                            ),
                            textCapitalization: TextCapitalization.none,
                            obscureText: !visible,
                            maxLength: 4,
                            keyboardType: TextInputType.phone,
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            validator: (value) {
                              String val = value.length == 4
                                  ? value == pinController.text
                                      ? null
                                      : "Pin dosen't match"
                                  : "Please enter a 4 digit Pin";
                              return val;
                            },
                            controller: reEnterController,
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            cursorColor: Colors.green[50],
                            decoration: InputDecoration(
                              counterText: "",
                              fillColor: Theme.of(context).backgroundColor,
                              filled: true,
                              enabledBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(100),
                                ),
                                borderSide: BorderSide(
                                  color: Color(0xff06d6a7),
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                    !visible
                                        ? FeatherIcons.eye
                                        : FeatherIcons.eyeOff,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                                color: Theme.of(context).colorScheme.primary,
                                onPressed: () {
                                  setState(() {
                                    visible = !visible;
                                    Future.delayed(
                                        const Duration(milliseconds: 1500), () {
                                      setState(() {
                                        visible = false;
                                      });
                                    });
                                  });
                                },
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(100),
                                ),
                                borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ),
                              border: InputBorder.none,
                              hintText: "Re-Enter Pin",
                              hintStyle: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              contentPadding: const EdgeInsets.only(
                                left: 18,
                                right: 20,
                                top: 14,
                                bottom: 14,
                              ),
                            ),
                            textCapitalization: TextCapitalization.none,
                            obscureText: !visible,
                            maxLength: 4,
                            keyboardType: TextInputType.phone,
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () async {
                              if (_formKey.currentState.validate()) {
                                String newPin = pinController.text;
                                await SharedPrefFunctions.savePin(newPin);
                                await SharedPrefFunctions
                                    .savePinEnabledSharedPreference(true);
                                googleSheets(newPin).then((_) {
                                  Navigator.of(context).pop();
                                });
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  gradient: LinearGradient(
                                    colors: [
                                      Theme.of(context).colorScheme.primary,
                                      Theme.of(context).colorScheme.primary
                                    ],
                                  )),
                              width: MediaQuery.of(context).size.width,
                              child: Text(
                                "Set Pin",
                                style: GoogleFonts.workSans(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 20),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Spacer(flex: 2),
                        ],
                      ),
                    ),
                  )
                ]),
          ),
        ));
  }
}
