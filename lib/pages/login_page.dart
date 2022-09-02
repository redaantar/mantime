import 'package:flutter/material.dart';
import 'package:mantime/controllers/auth_controller.dart';
import 'package:mantime/models/auth_model.dart';
import 'package:mantime/pages/registration_page.dart';
import 'package:mantime/widgets/text_input.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:mantime/widgets/google_logo.dart';
import 'package:mantime/constants.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  static const loginPage = 'LoginPage';
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? _password;
  String? _email;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final RoundedLoadingButtonController _googleBtnController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  void _loginWithGoogle() async {
    await AuthController.signInWithGoogle();
    _googleBtnController.reset();
  }

  void _doSomething() async {
    if (_key.currentState!.validate()) {
      AuthModel user = AuthModel(email: _email, password: _password);
      AuthController.signInWithEmailAndPassword(user);
      _btnController.reset();
    }
    _btnController.reset();
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
          body: SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: _key,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Hero(
                        tag: 'image',
                        child: Image.asset('images/login.png', height: 295)),
                    Row(children: const [
                      Padding(
                        padding: EdgeInsets.only(left: 30, bottom: 10),
                        child: Text(
                          'Login',
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: TextButton(
                            onPressed: () {},
                            child: const Text('Forgot Password?',
                                style: knormalTextStyle),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    RoundedLoadingButton(
                      color: const Color.fromARGB(255, 80, 67, 225),
                      controller: _btnController,
                      onPressed: _doSomething,
                      child: const Text('Login',
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'AlbertSans')),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Text('OR',
                          style: TextStyle(color: Colors.grey, fontSize: 15)),
                    ),
                    RoundedLoadingButton(
                        color: Colors.white,
                        controller: _googleBtnController,
                        onPressed: _loginWithGoogle,
                        successColor: Colors.green,
                        valueColor: Colors.black,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            GoogleLogo(
                              size: 20,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text('Login with Google',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'AlbertSans')),
                          ],
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('New to Mantime?',
                            style: TextStyle(fontFamily: 'AlbertSans')),
                        TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, RegistrationPage.registrationPage);
                            },
                            child:
                                const Text('Register', style: knormalTextStyle))
                      ],
                    )
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
