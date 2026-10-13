import 'package:flutter/material.dart' hide Text;

import '../localization/rihal_localized_text.dart';
import '../localization/locale_controller.dart';
import '../rihal_style.dart';

import 'signup_screen.dart';

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

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          RihalTranslations.direction(context),

      child: Scaffold(
        backgroundColor:
            RihalStyle.background,

        body: Stack(
          fit: StackFit.expand,

          children: [
            Image.asset(
              'assets/images/2.jpg',
              fit: BoxFit.cover,

              errorBuilder:
                  (_, __, ___) =>
                      Container(
                color:
                    RihalStyle.background,
              ),
            ),

            Container(
              color:
                  RihalStyle.background
                      .withValues(
                alpha: 0.90,
              ),
            ),

            SafeArea(
              child: SingleChildScrollView(
                physics:
                    const BouncingScrollPhysics(),

                padding:
                    const EdgeInsets.fromLTRB(
                  RihalStyle
                      .pageHorizontalPadding,
                  12,
                  RihalStyle
                      .pageHorizontalPadding,
                  24,
                ),

                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Align(
                            alignment:
                                AlignmentDirectional
                                    .centerStart,

                            child:
                                RihalLanguageSelector(
                              currentCode:
                                  LocaleScope.of(
                                context,
                              )
                                      .locale
                                      .languageCode,

                              languages: const [
                                RihalLanguageOption(
                                  'ar',
                                  'العربية',
                                  '🇸🇦',
                                ),
                                RihalLanguageOption(
                                  'en',
                                  'English',
                                  '🇬🇧',
                                ),
                                RihalLanguageOption(
                                  'tr',
                                  'Türkçe',
                                  '🇹🇷',
                                ),
                                RihalLanguageOption(
                                  'ur',
                                  'اردو',
                                  '🇵🇰',
                                ),
                              ],

                              onChanged:
                                  (code) {
                                LocaleScope.of(
                                  context,
                                ).setLocale(
                                  Locale(code),
                                );
                              },
                            ),
                          ),
                        ),

                        IconButton(
                          tooltip:
                              RihalTranslations.tr(
                            context,
                            'رجوع',
                          ),

                          onPressed:
                              () =>
                                  Navigator.pop(
                            context,
                          ),

                          icon:
                              const Icon(
                            Icons
                                .arrow_forward_ios_rounded,
                            color:
                                RihalStyle
                                    .darkGreen,
                            size: 20,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    Image.asset(
                      'assets/images/1.png',
                      width: 150,
                      height: 105,
                      fit: BoxFit.contain,

                      errorBuilder:
                          (_, __, ___) =>
                              const Icon(
                        Icons
                            .explore_rounded,
                        color:
                            RihalStyle
                                .darkGreen,
                        size: 66,
                      ),
                    ),

                    const SizedBox(
                      height: 6,
                    ),

                    const Text(
                      'مرحبًا بعودتك',
                      textAlign:
                          TextAlign.center,
                      style: TextStyle(
                        color:
                            RihalStyle
                                .deepGreen,
                        fontSize: 26,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 6,
                    ),

                    const Text(
                      'سجّلي الدخول وكمّلي رحلتك مع رِحال',
                      textAlign:
                          TextAlign.center,
                      style: TextStyle(
                        color:
                            RihalStyle
                                .secondaryText,
                        fontSize: 13.5,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(
                      height: 24,
                    ),

                    RihalCard(
                      padding:
                          const EdgeInsets
                              .fromLTRB(
                        18,
                        22,
                        18,
                        20,
                      ),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [
                          const Text(
                            'تسجيل الدخول',
                            style: TextStyle(
                              color:
                                  RihalStyle
                                      .deepGreen,
                              fontSize: 20,
                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),

                          const SizedBox(
                            height: 5,
                          ),

                          const Text(
                            'أدخلي بيانات حسابك للمتابعة',
                            style: TextStyle(
                              color:
                                  RihalStyle
                                      .secondaryText,
                              fontSize: 12,
                            ),
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          _fieldLabel(
                            'اسم المستخدم',
                          ),

                          const SizedBox(
                            height: 7,
                          ),

                          _buildTextField(
                            controller:
                                _usernameController,

                            hint:
                                'أدخلي اسم المستخدم',

                            icon: Icons
                                .person_outline_rounded,

                            keyboardType:
                                TextInputType
                                    .text,
                          ),

                          const SizedBox(
                            height: 16,
                          ),

                          _fieldLabel(
                            'كلمة المرور',
                          ),

                          const SizedBox(
                            height: 7,
                          ),

                          _buildTextField(
                            controller:
                                _passwordController,

                            hint:
                                'أدخلي كلمة المرور',

                            icon: Icons
                                .lock_outline_rounded,

                            isPassword: true,
                          ),

                          const SizedBox(
                            height: 8,
                          ),

                          Align(
                            alignment:
                                AlignmentDirectional
                                    .centerEnd,

                            child: TextButton(
                              onPressed: () {},

                              style:
                                  TextButton
                                      .styleFrom(
                                foregroundColor:
                                    RihalStyle
                                        .brown,

                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                  horizontal:
                                      3,
                                  vertical:
                                      6,
                                ),
                              ),

                              child:
                                  const Text(
                                'نسيت كلمة المرور؟',
                                style:
                                    TextStyle(
                                  fontSize:
                                      12.5,
                                  fontWeight:
                                      FontWeight
                                          .w600,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 8,
                          ),

                          SizedBox(
                            width:
                                double.infinity,
                            height:
                                RihalStyle
                                    .primaryButtonHeight,

                            child:
                                ElevatedButton
                                    .icon(
                              onPressed:
                                  _login,

                              style:
                                  RihalStyle
                                      .primaryButtonStyle(),

                              icon:
                                  const Icon(
                                Icons
                                    .login_rounded,
                                size: 20,
                              ),

                              label:
                                  const Text(
                                'تسجيل الدخول',
                                style:
                                    TextStyle(
                                  fontSize:
                                      RihalStyle
                                          .primaryButtonTextSize,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 18,
                    ),

                    Container(
                      width:
                          double.infinity,

                      padding:
                          const EdgeInsets
                              .symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),

                      decoration:
                          BoxDecoration(
                        color:
                            RihalStyle
                                .cardBackground,

                        borderRadius:
                            BorderRadius
                                .circular(
                          18,
                        ),

                        border:
                            Border.all(
                          color:
                              RihalStyle
                                  .cardBorder,
                        ),
                      ),

                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .center,

                        children: [
                          const Text(
                            'ليس لديك حساب؟',
                            style:
                                TextStyle(
                              color:
                                  RihalStyle
                                      .secondaryText,
                              fontSize: 13,
                            ),
                          ),

                          const SizedBox(
                            width: 5,
                          ),

                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,

                                MaterialPageRoute(
                                  builder:
                                      (_) =>
                                          const SignupScreen(),
                                ),
                              );
                            },

                            style:
                                TextButton
                                    .styleFrom(
                              foregroundColor:
                                  RihalStyle
                                      .darkGreen,

                              padding:
                                  const EdgeInsets
                                      .symmetric(
                                horizontal: 5,
                                vertical: 4,
                              ),
                            ),

                            child:
                                const Text(
                              'إنشاء حساب',
                              style:
                                  TextStyle(
                                fontSize: 13,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    const Text(
                      'رِحال — رحلتك على طريقتك',
                      textAlign:
                          TextAlign.center,
                      style: TextStyle(
                        color:
                            RihalStyle
                                .secondaryText,
                        fontSize: 11,
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

  Widget _fieldLabel(
    String text,
  ) {
    return Text(
      text,
      style: const TextStyle(
        color:
            RihalStyle.deepGreen,
        fontSize: 12.5,
        fontWeight:
            FontWeight.w700,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController
        controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool isPassword = false,
  }) {
    return Container(
      height: 54,

      decoration:
          RihalStyle.fieldDecoration(
        radius:
            RihalStyle.fieldRadius,
      ),

      child: TextField(
        controller: controller,

        obscureText:
            isPassword &&
                _obscurePassword,

        keyboardType:
            keyboardType,

        textInputAction:
            isPassword
                ? TextInputAction.done
                : TextInputAction.next,

        onSubmitted:
            isPassword
                ? (_) => _login()
                : null,

        textAlign:
            TextAlign.start,

        style: const TextStyle(
          color:
              RihalStyle.deepGreen,
          fontSize: 14,
          fontWeight:
              FontWeight.w500,
        ),

        decoration:
            InputDecoration(
          hintText:
              RihalTranslations.tr(
            context,
            hint,
          ),

          hintStyle:
              const TextStyle(
            color:
                RihalStyle.searchHint,
            fontSize: 13,
          ),

          prefixIcon: Icon(
            icon,
            color:
                RihalStyle.brown,
            size: 21,
          ),

          suffixIcon:
              isPassword
                  ? IconButton(
                      tooltip:
                          RihalTranslations
                              .tr(
                        context,
                        _obscurePassword
                            ? 'إظهار كلمة المرور'
                            : 'إخفاء كلمة المرور',
                      ),

                      onPressed:
                          () {
                        setState(
                          () {
                            _obscurePassword =
                                !_obscurePassword;
                          },
                        );
                      },

                      icon: Icon(
                        _obscurePassword
                            ? Icons
                                .visibility_outlined
                            : Icons
                                .visibility_off_outlined,

                        color:
                            RihalStyle
                                .brown,

                        size: 21,
                      ),
                    )
                  : null,

          border:
              InputBorder.none,

          contentPadding:
              const EdgeInsets
                  .symmetric(
            horizontal: 14,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  void _login() {
    final username =
        _usernameController
            .text
            .trim();

    final password =
        _passwordController
            .text
            .trim();

    if (username.isEmpty ||
        password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(
          backgroundColor:
              RihalStyle.darkGreen,

          behavior:
              SnackBarBehavior
                  .floating,

          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius
                    .circular(
              14,
            ),
          ),

          content: const Text(
            'الرجاء إدخال اسم المستخدم وكلمة المرور',
            textAlign:
                TextAlign.center,
          ),
        ),
      );

      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      SnackBar(
        backgroundColor:
            RihalStyle.darkGreen,

        behavior:
            SnackBarBehavior
                .floating,

        shape:
            RoundedRectangleBorder(
          borderRadius:
              BorderRadius
                  .circular(
            14,
          ),
        ),

        content: const Text(
          'تم تسجيل الدخول بنجاح',
          textAlign:
              TextAlign.center,
        ),
      ),
    );

    Future.delayed(
      const Duration(
        milliseconds: 500,
      ),
      () {
        if (!mounted) return;

        Navigator.pop(
          context,
        );
      },
    );
  }
}