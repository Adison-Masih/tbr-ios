import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_beauty_rox/utils/constants.dart';
import 'package:the_beauty_rox/utils/routes.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String name = "";
  bool changeButton = false;
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  registerUser(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      final String mobile = mobileController.text.toString();
      final String password = passwordController.text.toString();
      var res = await callApi(
        url: getApiUrl(
          method: "login",
        ),
        method: HttpMethods.POST,
        postParams: {
          'mobile': mobile,
          'password': password,
        },
        // decode: false,
      );

      print(res);

      if (res["status"] == "200") {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('user_id', res["user_id"].toString());
        setState(() {
          changeButton = true;
        });
        await Future.delayed(const Duration(seconds: 1));
        await Navigator.pushNamedAndRemoveUntil(
            context, Routes.homeRoute, (_) => false);
        setState(() {
          changeButton = false;
        });
      } else {
        alertMsg(
          title: "Error",
          text: res["message"],
          context: context,
          callback: () {
            Navigator.of(context).pop();
            setState(() {
              isLoading = false;
            });
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.canvasColor,
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Image.asset(
                "assets/images/hey.png",
                // fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width - 130,
              ),
              const SizedBox(
                height: 20.0,
              ),
              !isLoading
                  ? const Text(
                      "Welcome Back!",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : CircularProgressIndicator(
                      color: context.theme.primaryColor,
                    ),
              const SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 32.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: mobileController,
                      keyboardType: const TextInputType.numberWithOptions(),
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: context.theme.accentColor,
                        ),
                        floatingLabelStyle: TextStyle(
                          color: context.theme.accentColor,
                        ),
                        hintText: "Enter Your Mobile",
                        labelText: "Your Mobile",
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Mobile cannot be empty!";
                        }

                        return null;
                      },
                    ),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: context.theme.accentColor,
                        ),
                        floatingLabelStyle: TextStyle(
                          color: context.theme.accentColor,
                        ),
                        hintText: "Enter password",
                        labelText: "Password",
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Password cannot be empty";
                        } else if (value.length < 6) {
                          return "Password length should be atleast 6";
                        }

                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 40.0,
                    ),
                    Material(
                      // ignore: deprecated_member_use
                      color: context.theme.buttonColor,
                      borderRadius:
                          BorderRadius.circular(changeButton ? 50 : 8),
                      child: InkWell(
                        onTap: () => registerUser(context),
                        child: AnimatedContainer(
                          duration: const Duration(seconds: 1),
                          width: 150,
                          height: 50,
                          alignment: Alignment.center,
                          child: changeButton
                              ? const Icon(
                                  Icons.done,
                                  color: Colors.white,
                                )
                              : const Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      child: const Text("Already Have An Account? Click Here"),
                      onTap: () {
                        Navigator.of(context).pushNamed(Routes.registerRoute);
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
