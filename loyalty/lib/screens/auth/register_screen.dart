import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradient_elevated_button/gradient_elevated_button.dart';
import 'package:loyalty/controllers/auth_controller.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

enum AuthMode {
  login,
  register
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    
    path.lineTo(0, size.height * 0.4);
    
    path.cubicTo(
      size.width * 0.1, size.height * 0.5,
      size.width * 0.3, size.height * 0.7,
      size.width * 0.5, size.height * 0.75,
    );
    
    path.cubicTo(
      size.width * 0.7, size.height * 0.8,
      size.width * 0.9, size.height * 0.6,
      size.width, size.height * 0.5,
    );
    
    path.lineTo(size.width, 0);
    path.close();
    
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey     = GlobalKey<FormState>();
  AuthMode _authMode = Get.arguments['authMode']?? AuthMode.login;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController    = TextEditingController();
  

  final AuthController _authController = Get.find();

  @override
  void initState() {
    super.initState();
    _authController.initialize();
  }

  @override
  Widget build(BuildContext context) {
    bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            top: isKeyboardVisible? -50 : 0,
            left: 0,
            right: isKeyboardVisible? -300 : 0,
            child: topWave()
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            bottom: isKeyboardVisible? -50 : 0,
            left: isKeyboardVisible? -100 : 0,
            right: 0,
            child: bottomWave()
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Hero(
                    tag: 'logo',
                    child: Image.asset('assets/logo.png', width: 100,),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 40
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: _authMode == AuthMode.login? Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 24, 31, 34)
                        ),
                      ) : Text(
                        "Register",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 24, 31, 34)
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(18, 27, 27, 27),
                              blurRadius: 22,
                              spreadRadius: 6
                            )
                          ],
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(100),
                            bottomRight: Radius.circular(100)
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(100),
                            bottomRight: Radius.circular(100)
                          ),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            width: MediaQuery.of(context).size.width*0.95,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 248, 255, 248),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(100),
                                bottomRight: Radius.circular(100)
                              ),
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 20
                                    ),
                                    child: TextFormField(
                                      controller: _usernameController,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        label: Text("Username"),
                                        icon: Icon(LucideIcons.user),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Username can\'t be empty!';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width*0.7,
                                    child: Divider(),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: 10,
                                      right: 10,
                                      left: 20,
                                      bottom: _authMode == AuthMode.login? 10 : 0,
                                    ),
                                    child: TextFormField(
                                      controller: _passwordController,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        label: Text("Password"),
                                        icon: Icon(LucideIcons.lock)
                                      ),
                                      obscureText: true,
                                      validator: (value) {
                                        if (_authMode == AuthMode.login) {
                                          if (value == null || value.trim() == '') {
                                            return "Password can't be empty!";
                                          }
                                        } else {
                                          if (value == null || value.trim().length < 8) {
                                            return "Password can't be less than 8 characters!";
                                          }
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    child: _authMode == AuthMode.login 
                                      ? SizedBox.shrink()
                                      : SizedBox(
                                      width: MediaQuery.of(context).size.width*0.5,
                                      child: Divider(),
                                    ),
                                  ),
                                  AnimatedSize(
                                    duration: const Duration(milliseconds: 300),
                                    child: _authMode == AuthMode.login 
                                      ? SizedBox.shrink()
                                      : Padding(
                                          padding: EdgeInsets.only(
                                            left: 20,
                                            bottom: _authMode == AuthMode.login? 0 : 10,
                                          ),
                                          child: TextFormField(
                                            controller: _emailController,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              label: Text("Email"),
                                              icon: Icon(LucideIcons.atSign)
                                            ),
                                            validator: (value) {
                                              if (value != null && !value.contains('@') || value != null && value.length < 5) {
                                                return "Please enter a valid email!";
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                  ),
                                ],
                              )
                            ),
                          ),
                        ),
                      ),
                      
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      child: _authMode == AuthMode.login? Obx(() => GradientElevatedButton.icon(
                          label: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 20
                            ),
                            child: _authController.processing.value? CircularProgressIndicator() : Text(
                              'Login',
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          icon: Icon(
                            LucideIcons.logIn,
                            color: Colors.white,
                          ),
                          onPressed: _authController.processing.value? null : () {
                            if (_formKey.currentState!.validate()) {
                              _authController.login(username: _usernameController.text, password: _passwordController.text).then((res) {
                                if (res.success) {
                                  if(mounted) {
                                    showTopSnackBar(
                                        Overlay.of(context),
                                        CustomSnackBar.success(
                                          message: res.message,
                                        ),
                                    );
                                  }
                                  Get.toNamed('/dashboard');
                                } else {
                                  if(mounted) {
                                    showTopSnackBar(
                                        Overlay.of(context),
                                        CustomSnackBar.error(
                                          message: res.message,
                                        ),
                                    );
                                  }
                                }
                              }).catchError((err) {
                                print(err);
                                if(mounted) {
                                  showTopSnackBar(
                                      Overlay.of(context),
                                      CustomSnackBar.error(
                                        message: "Unknown error happened!",
                                      ),
                                  );
                                }
                              });
                            }
                          },
                          style: GradientElevatedButton.styleFrom(
                            backgroundGradient: const LinearGradient(
                              colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(12)
                            ),
                          ),
                        )) : Hero(
                        tag: 'reg-btn',
                        child: Obx(() => GradientElevatedButton.icon(
                            label: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 20
                              ),
                              child: _authController.processing.value? CircularProgressIndicator() : Text(
                                'Register',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            icon: Icon(
                              LucideIcons.userRoundPlus,
                              color: Colors.white,
                            ),
                            onPressed: _authController.processing.value? null : () {
                              if (_formKey.currentState!.validate()) {
                                _authController.register(username: _usernameController.text, email: _emailController.text, password: _passwordController.text).then((res) {
                                  if (res.success) {
                                    if(mounted) {
                                      showTopSnackBar(
                                          Overlay.of(context),
                                          CustomSnackBar.success(
                                            message: res.message,
                                          ),
                                      );
                                    }
                                    setState(() {
                                      _authMode = AuthMode.login;
                                    });
                                  } else {
                                    if(mounted) {
                                      showTopSnackBar(
                                          Overlay.of(context),
                                          CustomSnackBar.error(
                                            message: res.message,
                                          ),
                                      );
                                    }
                                  }
                                }).catchError((err) {
                                  print(err);
                                  if(mounted) {
                                    showTopSnackBar(
                                        Overlay.of(context),
                                        CustomSnackBar.error(
                                          message: "Unknown error happened!",
                                        ),
                                    );
                                  }
                                });
                              }
                            },
                            style: GradientElevatedButton.styleFrom(
                              backgroundGradient: const LinearGradient(
                                colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(12)
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: isKeyboardVisible? const SizedBox.shrink() : Padding(
                      padding: const EdgeInsets.only(
                        top: 20
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _authMode == AuthMode.login 
                              ? "Don't have an account?"
                              : "Already have an account?",
                            style: TextStyle(
                              color: const Color.fromARGB(167, 41, 104, 10),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              setState(() {
                                _authMode = _authMode == AuthMode.login ? AuthMode.register : AuthMode.login;
                              });
                            },
                            icon: Icon(_authMode == AuthMode.login 
                              ? LucideIcons.userRoundPlus 
                              : LucideIcons.logIn),
                            label: Text(_authMode == AuthMode.login ? "Register" : "Login"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget topWave({double height = 150}) {
    return ClipPath(
      clipper: WaveClipper(),
      child: Container(
        height: height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green, Colors.lightGreen],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }

  Widget bottomWave({double height = 120}) {
    return Transform.flip(
      flipY: true,
      child: ClipPath(
        clipper: WaveClipper(),
        child: Container(
          height: height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightGreen, Colors.green],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
    );
  }
}