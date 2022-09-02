import 'package:flutter/material.dart';
import 'package:mantime/controllers/auth_controller.dart';
import 'package:mantime/models/auth_model.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:mantime/widgets/text_input.dart';
import 'package:get/get.dart';

class RegistrationPage extends StatefulWidget {
  static const registrationPage = 'RegistrationPage';
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  String? _email;
  String? _password;
  String? _passwordConfirmed;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordconfController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  void _register() async {
    if (_key.currentState!.validate()) {
      AuthModel user = AuthModel(email: _email, password: _password);
      await AuthController.signUpWithEmailAndPassword(user);
      setState(() {});
      _btnController.reset();
    } else {
      _btnController.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: !Get.isDarkMode ? ThemeData().backgroundColor : null,
          gradient: Get.isDarkMode
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                      Color.fromARGB(255, 67, 70, 76),
                      Color.fromARGB(255, 34, 36, 39)
                    ])
              : null),
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leading: Padding(
              padding: const EdgeInsets.only(left: 8, top: 5),
              child: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                  )),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: _key,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Hero(
                        tag: 'image',
                        child: Image.asset('images/register.png', height: 295)),
                    Row(children: const [
                      Padding(
                        padding: EdgeInsets.only(left: 30, bottom: 10),
                        child: Text(
                          'Register',
                          style: TextStyle(
                              fontFamily: 'AlbertSans',
                              fontSize: 30,
                              fontWeight: FontWeight.w700),
                        ),
                      )
                    ]),
                    TextInput(
                      icon: Icon(
                        Icons.alternate_email,
                        color: context.theme.primaryColor,
                      ),
                      hint: 'Enter your email address',
                      controller: emailController,
                      passwordField: false,
                      validator: validateEmail,
                      onChanged: (value) {
                        _email = value;
                      },
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    TextInput(
                      icon: Icon(
                        Icons.lock,
                        color: context.theme.primaryColor,
                      ),
                      hint: 'Enter your password',
                      controller: passwordController,
                      passwordField: true,
                      validator: validatePassword,
                      onChanged: (value) {
                        _password = value;
                      },
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    TextInput(
                      icon: Icon(
                        Icons.lock,
                        color: context.theme.primaryColor,
                      ),
                      hint: 'Confirm your password',
                      passwordField: true,
                      controller: passwordconfController,
                      validator: (String? confPass) {
                        RegExp passValid = RegExp(
                            r'^(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                        if (confPass == null || confPass.isEmpty) {
                          return 'Password is required.';
                        } else if (!passValid.hasMatch(confPass)) {
                          return 'require Number & Special char, at least 8 characters';
                        } else if (confPass != _password) {
                          return 'password incorrect';
                        } else if (_password != _passwordConfirmed) {
                          return 'password incorrect';
                        }

                        return null;
                      },
                      onChanged: (value) {
                        _passwordConfirmed = value;
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    RoundedLoadingButton(
                      color: const Color.fromARGB(255, 80, 67, 225),
                      controller: _btnController,
                      onPressed: _register,
                      child: const Text('Register',
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'AlbertSans')),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String? validateEmail(String? emailText) {
  if (emailText == null || emailText.isEmpty) {
    return 'Email Address is required.';
  }
  String pattern = r'\w+@\w+\.\w+';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(emailText)) {
    return 'Invalid email address format.';
  }
  return null;
}

String? validatePassword(String? passwordText) {
  RegExp passValid =
      RegExp(r'^(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  if (passwordText == null || passwordText.isEmpty) {
    return 'Password is required.';
  } else if (!passValid.hasMatch(passwordText)) {
    return 'require Number & Special char, at least 8 characters';
  }

  return null;
}
