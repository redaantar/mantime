import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mantime/controllers/auth_controller.dart';
import 'package:mantime/pages/login_page.dart';
import 'package:mantime/theme/theme.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            minRadius: 30,
            maxRadius: 40,
            backgroundImage: AssetImage('images/profile.png'),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            user!.email.toString(),
            style: titleTextStyle,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'Last login: ${user.metadata.lastSignInTime.toString()}',
            style: titleTextStyle,
          ),
          const SizedBox(
            height: 20,
          ),
          MaterialButton(
            onPressed: () {
              AuthController.signOut();
              Get.offAllNamed(LoginPage.loginPage);
            },
            color: primaryColor,
            height: MediaQuery.of(context).size.height * 0.06,
            minWidth: MediaQuery.of(context).size.width * 0.3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Text(
              'Sign out',
              style: titleTextStyle.copyWith(
                  color: Colors.white, fontWeight: FontWeight.normal),
            ),
          )
        ],
      ),
    );
  }
}
