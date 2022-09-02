import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mantime/controllers/auth_controller.dart';
import 'package:mantime/database/database_helper.dart';
import 'package:mantime/pages/add_task_page.dart';
import 'package:mantime/services/theme_services.dart';
import 'package:mantime/theme/theme.dart';
import 'firebase_options.dart';
import 'pages/login_page.dart';
import 'pages/registration_page.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await DataBaseHelper.initializeDatabase();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ManTime',
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeService().theme,
      home: AuthController.loginState(),
      routes: {
        HomePage.homePage: (context) => const HomePage(),
        LoginPage.loginPage: (context) => const LoginPage(),
        RegistrationPage.registrationPage: (context) =>
            const RegistrationPage(),
        AddTaskPage.addTaskPage: (context) => const AddTaskPage()
      },
    );
  }
}
