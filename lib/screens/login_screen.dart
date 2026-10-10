import 'package:flutter/material.dart';
import 'signup_screen.dart';
import 'trip_setup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController =
      TextEditingController();

  final TextEditingController _passwordController =
      TextEditingController();

  bool _obscurePassword = true;

  String selectedLanguage = 'العربية';

  final Color darkGreen = const Color(0xFF30452D);
  final Color brown = const Color(0xFF6B4423);

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            // خلفية رِحال
            Image.asset(
              'assets/images/2.jpg',
              fit: BoxFit.cover,
            ),

            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 15),

                    // ==========================
                    // اختيار اللغة
                    // ==========================

                    Align(
                      alignment: Alignment.centerRight,
                      child: PopupMenuButton<String>(
                        onSelected: (value) {
                          setState(() {
                            selectedLanguage = value;
                          });
                        },
                        color: const Color(0xFFF9F1E5),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        itemBuilder: (context) => const [
                          PopupMenuItem(
                            value: 'العربية',
                            child: Text('🇸🇦  العربية'),
                          ),
                          PopupMenuItem(
                            value: 'English',
                            child: Text('🇬🇧  English'),
                          ),
                          PopupMenuItem(
                            value: 'Urdu',
                            child: Text('🇵🇰  Urdu'),
                          ),
                          PopupMenuItem(
                            value: 'Türkçe',
                            child: Text('🇹🇷  Türkçe'),
                          ),
                        ],
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(
                              alpha: 0.50,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: brown.withValues(
                                alpha: 0.10,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.language_rounded,
                                size: 16,
                                color: brown,
                              ),

                              const SizedBox(width: 5),

                              Text(
                                selectedLanguage,
                                style: TextStyle(
                                  color: darkGreen,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(width: 2),

                              Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 16,
                                color: brown,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // ==========================
                    // لوقو رِحال
                    // ==========================

                    Image.asset(
                      'assets/images/1.png',
                      width: 250,
                      fit: BoxFit.contain,
                    ),

                    const SizedBox(height: 55),

                    // ==========================
                    // اسم المستخدم
                    // ==========================

                    _buildTextField(
                      controller: _usernameController,
                      hint: 'اسم المستخدم',
                      icon: Icons.person_outline_rounded,
                    ),

                    const SizedBox(height: 18),

                    // ==========================
                    // كلمة المرور
                    // ==========================

                    _buildTextField(
                      controller: _passwordController,
                      hint: 'كلمة المرور',
                      icon: Icons.lock_outline_rounded,
                      isPassword: true,
                    ),

                    const SizedBox(height: 24),

                    // ==========================
                    // تسجيل الدخول
                    // ==========================

                    SizedBox(
                      width: double.infinity,
                      height: 62,
                      child: ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: darkGreen,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                        ),
                        child: const Text(
                          'تسجيل الدخول',
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    // ==========================
                    // نسيت كلمة المرور
                    // ==========================

                    TextButton(
                      onPressed: () {
                        // نربطها لاحقاً باستعادة كلمة المرور
                      },
                      child: Text(
                        'نسيت كلمة المرور؟',
                        style: TextStyle(
                          color: brown,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // ==========================
                    // إنشاء حساب
                    // ==========================

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'ليس لديك حساب؟ ',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF4B3A2B),
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const SignupScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'إنشاء حساب',
                            style: TextStyle(
                              fontSize: 16,
                              color: darkGreen,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 35),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================
  // تصميم حقول الإدخال
  // ==========================

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: brown.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText:
            isPassword ? _obscurePassword : false,
        textAlign: TextAlign.right,
        style: const TextStyle(
          fontSize: 17,
          color: Color(0xFF3C342C),
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: Color(0xFF8B8178),
            fontSize: 17,
          ),
          prefixIcon: Icon(
            icon,
            color: brown,
            size: 28,
          ),
          suffixIcon: isPassword
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _obscurePassword =
                          !_obscurePassword;
                    });
                  },
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: brown,
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 23,
          ),
        ),
      ),
    );
  }

  // ==========================
  // تسجيل الدخول
  // ==========================

  void _login() {
    final username =
        _usernameController.text.trim();

    final password =
        _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'الرجاء إدخال اسم المستخدم وكلمة المرور',
            textAlign: TextAlign.center,
          ),
        ),
      );

      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const TripSetupScreen(),
      ),
    );
  }
}