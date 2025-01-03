import 'package:flutter/material.dart';
import 'package:travelmate/component/checkinputs.dart';
import 'package:travelmate/component/gsbg.dart';
import 'package:travelmate/db/userdb.dart';
import 'package:travelmate/models/sessions.dart';
import 'package:travelmate/screens/mainscreen.dart';
import 'package:travelmate/screens/registration/signup.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  bool isShowPass = false;

  var emailCtrl = TextEditingController();
  var passCtrl = TextEditingController();

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
                "Sign in",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  color: Color(0XFF4DC3FF),
                ),
              ),
              SizedBox(height: 12),
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
                  color: Color(0XFF464646),
                  fontSize: 14,
                ),
                controller: passCtrl,
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 6,
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      "Forgot password?",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                        color: Color.fromARGB(255, 117, 116, 116),
                      ),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: manageLogIn,
                child: Text(
                  "Sign in",
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
                    "Don't have account?",
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
                          builder: (_) => SignUpPage(),
                        ),
                      );
                    },
                    child: Text(
                      "Sign up",
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

  void manageLogIn() async {
    //
    bool isUserExists = await User.isUserExists(email: emailCtrl.text);

    if (!isUserExists) {
      showMessage("Email does not exists");
      return;
    }

    if (!isValidPassword(passCtrl.text)) {
      showMessage("Password must 8 or more characters");
      return;
    }

    var acc =
        await User.checkAccount(email: emailCtrl.text, pass: passCtrl.text)
            as Map<String, dynamic>;
    if (acc == null) {
      showMessage("Icorrect email or password");
      return;
    }

    setState(() {
      user = acc;
    });

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MainScreen(),
      ),
    );
  }

  void showMessage(String content) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
      ),
    );
  }
}
