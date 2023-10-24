import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../constants/app_colors.dart';
import '../../constants/gradeinet_background.dart';
import '../../constants/text_style.dart';
import '../../controllers/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: GradientBackground(
        child: Center(
          child: LoginForm(),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final AuthController _authController = Get.find<AuthController>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = true;
  bool _passwordVisibile = false;
  Color borderColor = Colors.black;
  bool hasError = false;
  String errorText = 'Invalid User ID or Password';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Image.asset('assets/images/logo.png', width: 55.w),
            const SizedBox(height: 20),
            const Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Divider(
                      color: AppColors.primary,
                      thickness: 1.0,
                    ),
                  ),
                ),
                Text(
                  'Employee Login Panel',
                  style: TextStyle(
                      fontSize: 18,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Divider(
                      color: AppColors.primary,
                      thickness: 1.0,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 40,
              child: TextField(
                controller: _emailController,
                style: const TextStyle(color: AppColors.secondary),
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.person,
                    color: AppColors.primary,
                  ),
                  hintText: 'Username or Email',
                  hintStyle: TextStyle(color: AppColors.primaryHintColor),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: borderColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: borderColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.transparent,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 40,
              child: TextField(
                controller: _passwordController,
                obscureText: !_passwordVisibile,
                style: const TextStyle(color: AppColors.secondary),
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.lock,
                    color: AppColors.primary,
                  ),
                  hintText: 'Password',
                  hintStyle: TextStyle(color: AppColors.primaryHintColor),
                  suffixIcon: InkWell(
                    onTap: () {
                      _passwordVisibile = !_passwordVisibile;
                      setState(() {});
                    },
                    child: Icon(
                      _passwordVisibile
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppColors.primary,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: borderColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: borderColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.transparent,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Visibility(
              visible: hasError,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 60),
                decoration: BoxDecoration(
                  color: AppColors.primaryHintColor,
                  border: Border.all(color: AppColors.primary),
                ),
                child: Text(
                  errorText,
                  style: CustomTextStyles.bodyTextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 30,
              width: 120,
              child: ElevatedButton(
                onPressed: () async {
                  String email = _emailController.text.trim();
                  String password = _passwordController.text;

                  // Email format validation using regex
                  bool isEmailValid = RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                  ).hasMatch(email);

                  bool isPasswordValid = password.length >= 6;

                  if (email.isEmpty ||
                      password.isEmpty ||
                      isEmailValid ||
                      !isPasswordValid) {
                     errorText = 'Invalid User ID or Password';

                    hasError = true;
                  } else {
                    var body = {
                      'login_id': email,
                      'password': password,
                    };
                    errorText = await _authController.userLogin(body);
                    if (errorText.isNotEmpty) {
                      hasError = true;
                    }
                    // Go.to(() => const BottomBar());
                  }
                  setState(() {});
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                child:
                    const Text('LOGIN', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                setState(() {
                  _rememberMe = !_rememberMe;
                  _authController.savId.value = _rememberMe;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 14.0,
                    height: 14.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      border: Border.all(
                        color: _rememberMe ? AppColors.primary : Colors.white,
                        width: 2.0,
                      ),
                      color: _rememberMe ? AppColors.primary : Colors.white,
                    ),
                    child: _rememberMe
                        ? const Icon(
                            Icons.check,
                            size: 10.0,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  const SizedBox(width: 3.0),
                  Text(
                    'Remember me',
                    style: CustomTextStyles.bodyTextStyle(
                        color: AppColors.primary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Divider(
              color: AppColors.secondary,
              thickness: 1,
            ),
            Text(
              'Please contact Admin if forget password',
              style: CustomTextStyles.bodyTextStyle(
                color: AppColors.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
