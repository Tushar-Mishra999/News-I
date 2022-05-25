import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:red_hat_up/routes.dart';
import 'package:red_hat_up/components/rounded_button.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(
              flex: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: size.width * 0.17,
                ),
                Hero(
                  tag: 'newspaper',
                  child: Image.asset(
                    'lib/assets/images/newspaper-1.png',
                    fit: BoxFit.cover,
                    width: size.width * 0.25,
                  ),
                ),
                AnimatedTextKit(
                   totalRepeatCount: 20,
                  animatedTexts: [
                  TyperAnimatedText(' News',
                      textStyle: TextStyle(
                        color: Colors.orange,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                      speed: const Duration(milliseconds: 300)),
                      TyperAnimatedText(' India',
                      textStyle: TextStyle(
                        color: Colors.green,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                      speed: const Duration(milliseconds: 300)),
                ])
              ],
            ),
            SizedBox(
              height: size.height * 0.1,
            ),
            RoundedButton(
                string: "LOGIN",
                size: size,
                func: () {
                  Navigator.pushNamed(context, AppRoutes.loginScreen);
                }),
            RoundedButton(
                string: "SIGN UP",
                size: size,
                func: () {
                  Navigator.pushNamed(context, AppRoutes.registrationScreen);
                }),
            const Spacer(
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }
}
