import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _usernameController =
      TextEditingController();

  final TextEditingController _emailController =
      TextEditingController();

  final TextEditingController _passwordController =
      TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // اللغة الافتراضية
  String selectedLanguage = 'العربية';

  final Color darkGreen = const Color(0xFF30452D);
  final Color brown = const Color(0xFF6B4423);

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
            // الخلفية
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

                    const SizedBox(height: 8),

                    // ==========================
                    // اللوقو
                    // ==========================

                    Image.asset(
                      'assets/images/1.png',
                      width: 190,
                      fit: BoxFit.contain,
                    ),

                    const SizedBox(height: 5),

                    Text(
                      'إنشاء حساب',
                      style: TextStyle(
                        color: darkGreen,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      'ابدأ رحلتك معنا',
                      style: TextStyle(
                        color: brown,
                        fontSize: 17,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ==========================
                    // اسم المستخدم
                    // ==========================

                    _buildTextField(
                      controller: _usernameController,
                      hint: 'اسم المستخدم',
                      icon: Icons.person_outline_rounded,
                    ),

                    const SizedBox(height: 15),

                    // ==========================
                    // البريد الإلكتروني
                    // ==========================

                    _buildTextField(
                      controller: _emailController,
                      hint: 'البريد الإلكتروني',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 15),

                    // ==========================
                    // كلمة المرور
                    // ==========================

                    _buildTextField(
                      controller: _passwordController,
                      hint: 'كلمة المرور',
                      icon: Icons.lock_outline_rounded,
                      isPassword: true,
                    ),

                    const SizedBox(height: 15),

                    // ==========================
                    // تأكيد كلمة المرور
                    // ==========================

                    _buildTextField(
                      controller: _confirmPasswordController,
                      hint: 'تأكيد كلمة المرور',
                      icon: Icons.lock_outline_rounded,
                      isConfirmPassword: true,
                    ),

                    const SizedBox(height: 25),

                    // ==========================
                    // إنشاء حساب
                    // ==========================

                    SizedBox(
                      width: double.infinity,
                      height: 62,
                      child: ElevatedButton(
                        onPressed: _createAccount,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: darkGreen,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                        ),
                        child: const Text(
                          'إنشاء حساب',
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    // ==========================
                    // العودة لتسجيل الدخول
                    // ==========================

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'لديك حساب بالفعل؟ ',
                          style: TextStyle(
                            color: Color(0xFF4B3A2B),
                            fontSize: 16,
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'تسجيل الدخول',
                            style: TextStyle(
                              color: darkGreen,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),
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
    bool isConfirmPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    bool obscure = false;

    if (isPassword) {
      obscure = _obscurePassword;
    }

    if (isConfirmPassword) {
      obscure = _obscureConfirmPassword;
    }

    return Container(
      height: 67,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: brown.withValues(alpha: 0.25),
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: Color(0xFF8B8178),
            fontSize: 16,
          ),
          prefixIcon: Icon(
            icon,
            color: brown,
          ),
          suffixIcon: (isPassword || isConfirmPassword)
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      if (isPassword) {
                        _obscurePassword =
                            !_obscurePassword;
                      }

                      if (isConfirmPassword) {
                        _obscureConfirmPassword =
                            !_obscureConfirmPassword;
                      }
                    });
                  },
                  icon: Icon(
                    obscure
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: brown,
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 22,
          ),
        ),
      ),
    );
  }

  // ==========================
  // إنشاء الحساب
  // ==========================

  void _createAccount() {
    final username =
        _usernameController.text.trim();

    final email =
        _emailController.text.trim();

    final password =
        _passwordController.text;

    final confirmPassword =
        _confirmPasswordController.text;

    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showMessage('الرجاء تعبئة جميع الحقول');
      return;
    }

    if (password != confirmPassword) {
      _showMessage('كلمتا المرور غير متطابقتين');
      return;
    }

    // لاحقاً نربطه بقاعدة البيانات
    _showMessage('تم إنشاء الحساب بنجاح');
  }

  // ==========================
  // الرسائل
  // ==========================

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}