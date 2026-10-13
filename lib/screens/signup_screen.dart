import 'package:flutter/material.dart' hide Text;
import '../localization/rihal_localized_text.dart';

import '../rihal_style.dart';
import '../localization/locale_controller.dart';
import '../localization/rihal_language_menu.dart';

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
      textDirection: RihalTranslations.direction(context),
      child: Scaffold(
        backgroundColor: RihalStyle.background,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/2.jpg',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: RihalStyle.background,
              ),
            ),

            Container(
              color: RihalStyle.background.withValues(alpha: 0.90),
            ),

            SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  RihalStyle.pageHorizontalPadding,
                  12,
                  RihalStyle.pageHorizontalPadding,
                  24,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: RihalLanguageSelector(
                      currentCode: LocaleScope.of(context).locale.languageCode,
                      languages: const [
                        RihalLanguageOption('ar', 'العربية', '🇸🇦'),
                        RihalLanguageOption('en', 'English', '🇺🇸'),
                        RihalLanguageOption('tr', 'Türkçe', '🇹🇷'),
                        RihalLanguageOption('ur', 'Urdu', '🇵🇰'),
                      ],
                      onChanged: (code) =>
                          LocaleScope.of(context).setLocale(Locale(code)),
                    ),
                          ),
                        ),
                        IconButton(
                          tooltip: RihalTranslations.tr(context, 'رجوع'),
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: RihalStyle.darkGreen,
                            size: 20,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Image.asset(
                      'assets/images/1.png',
                      width: 145,
                      height: 95,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.explore_rounded,
                        color: RihalStyle.darkGreen,
                        size: 62,
                      ),
                    ),

                    const SizedBox(height: 4),

                    const Text(
                      'ابدئي رحلتك مع رِحال',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: RihalStyle.deepGreen,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      'أنشئي حسابك وابدئي تخطيط رحلاتك بسهولة',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: RihalStyle.secondaryText,
                        fontSize: 13.5,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 22),

                    RihalCard(
                      padding: const EdgeInsets.fromLTRB(
                        18,
                        22,
                        18,
                        20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'إنشاء حساب',
                            style: TextStyle(
                              color: RihalStyle.deepGreen,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 5),

                          const Text(
                            'أدخلي بياناتك لإنشاء حساب جديد',
                            style: TextStyle(
                              color: RihalStyle.secondaryText,
                              fontSize: 12,
                            ),
                          ),

                          const SizedBox(height: 19),

                          _fieldLabel('اسم المستخدم'),

                          const SizedBox(height: 7),

                          _buildTextField(
                            controller: _usernameController,
                            hint: 'أدخلي اسم المستخدم',
                            icon: Icons.person_outline_rounded,
                            textInputAction: TextInputAction.next,
                          ),

                          const SizedBox(height: 14),

                          _fieldLabel('البريد الإلكتروني'),

                          const SizedBox(height: 7),

                          _buildTextField(
                            controller: _emailController,
                            hint: 'example@email.com',
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                          ),

                          const SizedBox(height: 14),

                          _fieldLabel('كلمة المرور'),

                          const SizedBox(height: 7),

                          _buildTextField(
                            controller: _passwordController,
                            hint: 'أدخلي كلمة المرور',
                            icon: Icons.lock_outline_rounded,
                            isPassword: true,
                            textInputAction: TextInputAction.next,
                          ),

                          const SizedBox(height: 14),

                          _fieldLabel('تأكيد كلمة المرور'),

                          const SizedBox(height: 7),

                          _buildTextField(
                            controller: _confirmPasswordController,
                            hint: 'أعيدي إدخال كلمة المرور',
                            icon: Icons.lock_reset_rounded,
                            isConfirmPassword: true,
                            textInputAction: TextInputAction.done,
                          ),

                          const SizedBox(height: 20),

                          SizedBox(
                            width: double.infinity,
                            height: RihalStyle.primaryButtonHeight,
                            child: ElevatedButton.icon(
                              onPressed: _createAccount,
                              style: RihalStyle.primaryButtonStyle(),
                              icon: const Icon(
                                Icons.person_add_alt_1_rounded,
                                size: 20,
                              ),
                              label: const Text(
                                'إنشاء حساب',
                                style: TextStyle(
                                  fontSize:
                                      RihalStyle.primaryButtonTextSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 13,
                      ),
                      decoration: BoxDecoration(
                        color: RihalStyle.cardBackground,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: RihalStyle.cardBorder,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'لديك حساب بالفعل؟',
                            style: TextStyle(
                              color: RihalStyle.secondaryText,
                              fontSize: 13,
                            ),
                          ),

                          const SizedBox(width: 5),

                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              foregroundColor:
                                  RihalStyle.darkGreen,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 4,
                              ),
                            ),
                            child: const Text(
                              'تسجيل الدخول',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'بإنشاء الحساب فإنك توافقين على سياسة الخصوصية وشروط الاستخدام',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: RihalStyle.secondaryText,
                        fontSize: 10.5,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _languageSelector() => const RihalLanguageMenu();

  Widget _fieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: RihalStyle.deepGreen,
        fontSize: 12.5,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool isConfirmPassword = false,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.next,
  }) {
    final bool obscure = isPassword
        ? _obscurePassword
        : isConfirmPassword
            ? _obscureConfirmPassword
            : false;

    return Container(
      height: 54,
      decoration: RihalStyle.fieldDecoration(
        radius: RihalStyle.fieldRadius,
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        onSubmitted: textInputAction == TextInputAction.done
            ? (_) => _createAccount()
            : null,
        textAlign: TextAlign.start,
        style: const TextStyle(
          color: RihalStyle.deepGreen,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: RihalTranslations.tr(context, hint),
          hintStyle: const TextStyle(
            color: RihalStyle.searchHint,
            fontSize: 13,
          ),
          prefixIcon: Icon(
            icon,
            color: RihalStyle.brown,
            size: 21,
          ),
          suffixIcon: (isPassword || isConfirmPassword)
              ? IconButton(
                  tooltip: obscure
                      ? 'إظهار كلمة المرور'
                      : 'إخفاء كلمة المرور',
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
                    color: RihalStyle.brown,
                    size: 21,
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  void _createAccount() {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword =
        _confirmPasswordController.text;

    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showMessage('الرجاء تعبئة جميع الحقول');
      return;
    }

    if (!email.contains('@') ||
        !email.contains('.')) {
      _showMessage('أدخلي بريدًا إلكترونيًا صحيحًا');
      return;
    }

    if (password.length < 6) {
      _showMessage(
        'يجب أن تكون كلمة المرور 6 أحرف على الأقل',
      );
      return;
    }

    if (password != confirmPassword) {
      _showMessage('كلمتا المرور غير متطابقتين');
      return;
    }

    _showMessage('تم إنشاء الحساب بنجاح');

    Future.delayed(
      const Duration(milliseconds: 700),
      () {
        if (!mounted) return;
        Navigator.pop(context);
      },
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: RihalStyle.darkGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

