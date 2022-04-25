import 'package:app/common/destroy_textFocus.dart';
import 'package:app/common/pretty_print.dart';
import 'package:app/common/radius.dart';
import 'package:app/common/spacing.dart';
import 'package:app/const/colors.dart';
import 'package:app/controllers/globalController.dart';
import 'package:app/controllers/userController.dart';
import 'package:app/form/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterAccount extends StatefulWidget {
  const RegisterAccount({Key? key}) : super(key: key);

  @override
  State<RegisterAccount> createState() => _RegisterAccountState();
}

class _RegisterAccountState extends State<RegisterAccount> {
  final _user = Get.put(UserController());
  final _global = Get.put(GlobalController());

  late TextEditingController _emailController;
  late FocusNode _emailFocus;

  late TextEditingController _passwordController;
  late FocusNode _passwordFocus;

  bool _isAgreed = false;
  bool _obscureText = true;

  Future<void> onProceed() async {
    final _email = _emailController.text.trim();
    final _password = _passwordController.text.trim();

    // VALIDATE
    if (_email.isEmpty) {
      return _emailFocus.requestFocus();
    }
    if (_password.isEmpty) {
      return _passwordFocus.requestFocus();
    }

    // REGISTER AND REDIRECT IF SUCCESS
    await _user.register(
      email: _email,
      password: _password,
    );

    prettyPrint("RegisterAccount", _global.registrationProperties);
  }

  void onNavigate() {
    Get.toNamed("/login");
    // RESET
    _user.registerFailed.value = false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailController = TextEditingController();
    _emailFocus = FocusNode();
    _passwordController = TextEditingController();
    _passwordFocus = FocusNode();

    // _emailController.text = "madridano.kolya@gmail.com";
    // _passwordController.text = "password";
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _emailFocus.dispose();
    _passwordController.dispose();
    _passwordFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _title = Text(
      "Water Refilling \nStation Sign Up",
      style: GoogleFonts.chivo(
        fontSize: 35.0,
        fontWeight: FontWeight.bold,
        color: kLight,
      ),
    );
    final _subTitle = Text(
      "Please enter your valid email \nand password.",
      style: GoogleFonts.chivo(
        fontSize: 14.0,
        fontWeight: FontWeight.w300,
        color: kLight,
      ),
    );
    final _loginAccount = Container(
      margin: const EdgeInsets.only(top: 25.0),
      width: double.infinity,
      child: GestureDetector(
        onTap: () => onNavigate(),
        behavior: HitTestBehavior.opaque,
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: 'Already have an account?',
            style: GoogleFonts.roboto(
              color: kLight,
              fontSize: 12.0,
              fontWeight: FontWeight.w300,
            ),
            children: [
              TextSpan(
                text: ' SIGN IN!',
                style: GoogleFonts.roboto(
                  color: kLight,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
        ),
      ),
    );
    final _errorMessage = Container(
      decoration: const BoxDecoration(
        color: Colors.redAccent,
        borderRadius: kDefaultRadius,
      ),
      margin: const EdgeInsets.only(top: 15.0, bottom: 15),
      padding: const EdgeInsets.all(20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            AntDesign.warning,
            color: kLight,
          ),
          const SizedBox(width: 25),
          Expanded(
            child: Text(
              "The email you have entered is \nalready exist, please try a new one.",
              style: GoogleFonts.roboto(
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                color: kLight,
              ),
            ),
          ),
        ],
      ),
    );

    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
          onTap: () => destroyTextFieldFocus(context),
          child: Obx(
            () => Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: kPrimary,
              body: Container(
                margin: kDefaultBodyPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    _title,
                    _subTitle,
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 30.0),
                      child: inputTextField(
                        controller: _emailController,
                        focusNode: _emailFocus,
                        color: kLight,
                        hasError: _user.registerFailed.value,
                        labelText: "Email",
                        textFieldStyle: GoogleFonts.roboto(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: kPrimary,
                        ),
                        hintStyleStyle: GoogleFonts.roboto(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: kPrimary,
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 10.0),
                      child: inputTextField(
                        controller: _passwordController,
                        focusNode: _passwordFocus,
                        obscureText: _obscureText,
                        labelText: "Password",
                        color: kLight,
                        hasError: _user.registerFailed.value,
                        textFieldStyle: GoogleFonts.roboto(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: kPrimary,
                        ),
                        hintStyleStyle: GoogleFonts.roboto(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: kPrimary,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10.0),
                      child: CheckboxListTile(
                        value: _obscureText,
                        onChanged: (v) {
                          setState(() {
                            _obscureText = v as bool;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(
                          "Conceal Password",
                          style: GoogleFonts.roboto(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400,
                            color: kLight,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      child: CheckboxListTile(
                        value: _isAgreed,
                        onChanged: (v) {
                          setState(() {
                            _isAgreed = v as bool;
                          });
                        },
                        title: Text(
                          "I agree to Water Refilling Station Terms of Service and Privacy Policy.",
                          style: GoogleFonts.roboto(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400,
                            color: kLight,
                          ),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                    _user.registerFailed.value
                        ? _errorMessage
                        : const SizedBox(),
                    const Spacer(flex: 2),
                    IgnorePointer(
                      ignoring: _isAgreed ? false : true,
                      child: AnimatedOpacity(
                        opacity: _isAgreed ? 1 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: SizedBox(
                          width: double.infinity,
                          height: 62,
                          child: TextButton(
                            onPressed: () => onProceed(),
                            style: TextButton.styleFrom(
                              //primary: kFadeWhite,
                              backgroundColor: kLight,
                              shape: const RoundedRectangleBorder(
                                borderRadius: kDefaultRadius,
                              ),
                            ),
                            child: Text(
                              "PROCEED",
                              style: GoogleFonts.roboto(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                                color: kPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    _loginAccount,
                    const Spacer(),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
