import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/components/rounded_Button.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  @override
  void initState(){
    super.initState();
    controller=AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
      // vsync: this,
      //  upperBound: 100.0,
    );
    animation = ColorTween(begin: Colors.amber, end: Colors.deepOrangeAccent).animate(controller);
    //animation = CurvedAnimation(parent: controller, curve: Curves.decelerate);  // upper bound for curves cannot be greater than 1
    controller.forward();
    //controller.reverse(from: 1.0);
    // animation.addStatusListener((status) {
    //   if(status==AnimationStatus.completed){
    //     controller.reverse(from: 1.0);
    //   }else if(status==AnimationStatus.dismissed){
    //     controller.forward();
    //   }
    // });
    controller.addListener(() {
      setState(() {

      });
      // print(controller.value);
      print(animation.value);
    });
  }

  void dispose(){
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  text: ["Flash Chat"],
                  textStyle:
                  TextStyle(fontSize: 45.0, fontWeight: FontWeight.w900),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              title: 'Login',
              onpressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
                //Go to login screen.
              },
              colour: Colors.lightBlueAccent,
            ),
            RoundedButton(
              onpressed: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
              title: "Register",
              colour: Colors.lightBlueAccent,
            )
          ],
        ),
      ),
    );
  }
}

// class RoundedButton extends StatelessWidget {
//   RoundedButton({this.colour, this.title, @required this.onpressed});
//
//   // ignore: empty_constructor_bodies
//   final Color colour;
//   final String title;
//   final Function onpressed;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 16.0),
//       child: Material(
//         elevation: 5.0,
//         color: colour,
//         borderRadius: BorderRadius.circular(30.0),
//         child: MaterialButton(
//           onPressed: onpressed,
//           minWidth: 200.0,
//           height: 42.0,
//           child: Text(
//             title,
//           ),
//         ),
//       ),
//     );
//   }
// }