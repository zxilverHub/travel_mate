import 'package:flutter/material.dart';
import 'package:travelmate/component/checkinputs.dart';
import 'package:travelmate/component/gsbg.dart';
import 'package:travelmate/db/userdb.dart';
import 'package:travelmate/models/sessions.dart';
import 'package:travelmate/screens/mainscreen.dart';
import 'package:travelmate/screens/registration/signin.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isShowPass = false;

  bool isAgreed = false;

  var usernameCtrl = TextEditingController();
  var emailCtrl = TextEditingController();
  var passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          gsBg("signbg"),
          formFields(context),
        ],
      ),
    );
  }

  Positioned formFields(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(46, 22, 46, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Sign up",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  color: Color(0XFF4DC3FF),
                ),
              ),
              SizedBox(height: 18),
              TextField(
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0XFF464646),
                ),
                controller: usernameCtrl,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  label: const Text(
                    "Username",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0XFF464646),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 18),
              TextField(
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0XFF464646),
                ),
                controller: emailCtrl,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  label: const Text(
                    "Email Address",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0XFF464646),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 18),
              TextField(
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0XFF464646),
                ),
                controller: passwordCtrl,
                obscureText: !isShowPass,
                decoration: InputDecoration(
                  suffixIcon: TextButton(
                    onPressed: () {
                      setState(() {
                        isShowPass = !isShowPass;
                      });
                    },
                    child: Icon(
                      isShowPass ? Icons.visibility : Icons.visibility_off,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  label: const Text(
                    "Password",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0XFF464646),
                    ),
                  ),
                  contentPadding: EdgeInsets.only(
                    bottom: 10,
                    left: 16,
                    right: 8,
                    top: 0,
                  ), // Adjust vertical padding
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Transform.scale(
                    scale: 0.8,
                    child: Checkbox(
                      value: isAgreed,
                      onChanged: (value) {
                        setState(
                          () {
                            isAgreed = value!;
                          },
                        );
                      },
                    ),
                  ),
                  Text(
                    "I agree to the",
                    style: termsStyle(),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.all(4),
                    ),
                    onPressed: () {},
                    child: Text(
                      "terms and conditions",
                      style: termsStyle(isLink: true),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: manageSignUp,
                child: Text(
                  "Create",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 80,
                  ),
                  backgroundColor: Color(0XFF4DC3FF),
                  foregroundColor: Colors.white,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account?",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 90, 87, 87),
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.only(left: 0),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => Loginpage(),
                        ),
                      );
                    },
                    child: Text(
                      "Sign in",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 35, 71, 192),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const Text(
                "or connect with",
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 139, 134, 134),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        // elevation: 0,
                        padding: EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                      ),
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/images/home/sign/fb.png"),
                          const SizedBox(width: 8),
                          Text(
                            "Facebook",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 90, 87, 87),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        // elevation: 0,
                        padding: EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                      ),
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/images/home/sign/gg.png"),
                          const SizedBox(width: 8),
                          Text(
                            "Google",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 90, 87, 87),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Container bg() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/registration/signbg.jpg"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  TextStyle termsStyle({isLink = false}) {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: const Color.fromARGB(255, 116, 112, 112),
      decoration: isLink ? TextDecoration.underline : TextDecoration.none,
    );
  }

  void manageSignUp() async {
    if (!isValidUsername(usernameCtrl.text)) {
      showMessage("Please enter username");
      return;
    }

    if (!isValidEmail(emailCtrl.text)) {
      showMessage("Please enter a valid email");
      return;
    }

    if (!isValidPassword(passwordCtrl.text)) {
      showMessage("Password must 8 or more characters");
      return;
    }

    bool isUserExists = await User.isUserExists(email: emailCtrl.text);
    if (isUserExists) {
      showMessage("EMAIL IS NOT AVAILABLE");
      return;
    }

    int userid = await User.addNewUser(user: {
      User.username: usernameCtrl.text,
      User.email: emailCtrl.text,
      User.password: passwordCtrl.text,
      User.imgURL: null,
    });

    var userInfo =
        await User.checkAccount(email: emailCtrl.text, pass: passwordCtrl.text)
            as Map<String, dynamic>;

    setState(() {
      thisuserid = userid;
      user = userInfo;
    });

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MainScreen(),
      ),
    );
  }

  void showMessage(String content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
      ),
    );
  }
}
