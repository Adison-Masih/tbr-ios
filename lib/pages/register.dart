import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_beauty_rox/utils/constants.dart';
import 'package:the_beauty_rox/utils/routes.dart';
import 'package:velocity_x/velocity_x.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String name = "";
  bool changeButton = false;
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController refController = TextEditingController();

  registerUser(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      final String httpName = nameController.text.toString();
      final String email = emailController.text.toString();
      final String mobile = mobileController.text.toString();
      final String password = passwordController.text.toString();
      // ignore: prefer_if_null_operators
      final String ref = refController.text.toString() == null
          ? 'none'
          : refController.text.toString();

      var res = await callApi(
        url: getApiUrl(
          method: "register",
        ),
        method: HttpMethods.POST,
        postParams: {
          'name': httpName,
          'email': email,
          'mobile': mobile,
          'password': password,
          'ref': ref,
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
        await Navigator.pushReplacementNamed(context, Routes.homeRoute);
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
                  ? Text(
                      "Welcome $name",
                      style: const TextStyle(
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
                      controller: nameController,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: context.theme.accentColor,
                        ),
                        floatingLabelStyle: TextStyle(
                          color: context.theme.accentColor,
                        ),
                        hintText: "Enter Your Name",
                        labelText: "Your Name",
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Name cannot be empty!";
                        }

                        return null;
                      },
                      onChanged: (value) {
                        name = value;
                        setState(() {});
                      },
                    ),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: context.theme.accentColor,
                        ),
                        floatingLabelStyle: TextStyle(
                          color: context.theme.accentColor,
                        ),
                        hintText: "Enter Your Email",
                        labelText: "Your Email",
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Email cannot be empty!";
                        }

                        return null;
                      },
                    ),
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
                      controller: refController,
                      keyboardType: const TextInputType.numberWithOptions(),
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: context.theme.accentColor,
                        ),
                        floatingLabelStyle: TextStyle(
                          color: context.theme.accentColor,
                        ),
                        hintText: "Enter Reference Id (Leave Blank If None)",
                        labelText: "Reference ID",
                      ),
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
                                  "Register",
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
                      child: const Text("Don't Have An Account? Click Here"),
                      onTap: () {
                        Navigator.of(context).pushNamed(Routes.loginRoute);
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
