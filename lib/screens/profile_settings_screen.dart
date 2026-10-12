import 'package:flutter/material.dart' hide Text;
import '../localization/rihal_localized_text.dart';

import '../rihal_style.dart';
import '../localization/locale_controller.dart';

// ============================================================================
// PROFILE EDIT
// ============================================================================

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() =>
      _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  final nameController = TextEditingController(text: 'أثير اليعبي');
  final emailController = TextEditingController(text: 'atheer@example.com');
  final phoneController = TextEditingController(text: '+966 5X XXX XXXX');
  final cityController = TextEditingController(text: 'المدينة المنورة');

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _SettingsScaffold(
      title: 'تعديل الملف الشخصي',
      child: ListView(
        padding: RihalStyle.pagePadding,
        children: [
          RihalCard(
            child: Column(
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: RihalStyle.cardBackgroundLight,
                    border: Border.all(
                      color: RihalStyle.cardBorder,
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: RihalStyle.darkGreen,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 10),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.camera_alt_outlined),
                  label: const Text('تغيير الصورة'),
                ),
              ],
            ),
          ),
          const SizedBox(height: RihalStyle.spaceLg),
          RihalCard(
            child: Column(
              children: [
                _field('الاسم', nameController, Icons.person_outline_rounded),
                const SizedBox(height: 12),
                _field('البريد الإلكتروني', emailController, Icons.email_outlined),
                const SizedBox(height: 12),
                _field('رقم الجوال', phoneController, Icons.phone_outlined),
                const SizedBox(height: 12),
                _field('المدينة', cityController, Icons.location_city_outlined),
              ],
            ),
          ),
          const SizedBox(height: RihalStyle.spaceLg),
          SizedBox(
            height: RihalStyle.primaryButtonHeight,
            child: ElevatedButton.icon(
              style: RihalStyle.primaryButtonStyle(),
              onPressed: () {
                FocusScope.of(context).unfocus();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'تم حفظ التغييرات',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.check_rounded),
              label: const Text(
                'حفظ التغييرات',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(
    String title,
    TextEditingController controller,
    IconData icon,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: RihalTranslations.tr(context, title),
        prefixIcon: Icon(icon, color: RihalStyle.darkGreen),
        filled: true,
        fillColor: RihalStyle.cardBackgroundLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: RihalStyle.cardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: RihalStyle.cardBorder),
        ),
      ),
    );
  }
}

// ============================================================================
// NOTIFICATIONS
// ============================================================================

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<NotificationsSettingsScreen> createState() =>
      _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState
    extends State<NotificationsSettingsScreen> {
  bool tripNotifications = true;
  bool recommendations = true;
  bool nearbyPlaces = true;

  @override
  Widget build(BuildContext context) {
    return _SettingsScaffold(
      title: 'الإشعارات',
      child: ListView(
        padding: RihalStyle.pagePadding,
        children: [
          RihalCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _switchTile(
                  Icons.calendar_month_outlined,
                  'تنبيهات الرحلات',
                  'تذكير بخطة الرحلة والمواعيد',
                  tripNotifications,
                  (v) => setState(() => tripNotifications = v),
                ),
                const Divider(height: 1, color: RihalStyle.cardBorder),
                _switchTile(
                  Icons.auto_awesome_outlined,
                  'اقتراحات رِحال',
                  'أماكن وتجارب مقترحة لك',
                  recommendations,
                  (v) => setState(() => recommendations = v),
                ),
                const Divider(height: 1, color: RihalStyle.cardBorder),
                _switchTile(
                  Icons.location_on_outlined,
                  'أماكن قريبة',
                  'اقتراحات حسب موقعك الحالي',
                  nearbyPlaces,
                  (v) => setState(() => nearbyPlaces = v),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _switchTile(
    IconData icon,
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return SwitchListTile(
      secondary: Icon(icon, color: RihalStyle.darkGreen),
      title: Text(title, style: RihalStyle.cardTitle),
      subtitle: Text(subtitle, style: RihalStyle.cardCaption),
      value: value,
      activeTrackColor: RihalStyle.darkGreen,
      onChanged: onChanged,
    );
  }
}

// ============================================================================
// LANGUAGE
// ============================================================================

class LanguageSettingsScreen extends StatefulWidget {
  const LanguageSettingsScreen({super.key});

  @override
  State<LanguageSettingsScreen> createState() =>
      _LanguageSettingsScreenState();
}

class _LanguageSettingsScreenState extends State<LanguageSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = LocaleScope.of(context);
    final selectedLanguage = controller.locale.languageCode;

    Widget option(String code, String title) {
      return RadioListTile<String>(
        value: code,
        groupValue: selectedLanguage,
        activeColor: RihalStyle.darkGreen,
        title: Text(title, style: RihalStyle.cardTitle),
        onChanged: (value) {
          if (value != null) controller.setLocale(Locale(value));
        },
      );
    }

    return _SettingsScaffold(
      title: 'اللغة',
      child: ListView(
        padding: RihalStyle.pagePadding,
        children: [
          RihalCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                option('ar', 'العربية'),
                const Divider(height: 1, color: RihalStyle.cardBorder),
                option('en', 'English'),
                const Divider(height: 1, color: RihalStyle.cardBorder),
                option('ur', 'اردو'),
                const Divider(height: 1, color: RihalStyle.cardBorder),
                option('tr', 'Türkçe'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// PRIVACY
// ============================================================================

class PrivacySettingsScreen extends StatelessWidget {
  const PrivacySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _SettingsScaffold(
      title: 'الخصوصية والأمان',
      child: ListView(
        padding: RihalStyle.pagePadding,
        children: [
          RihalCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _SettingsItem(
                  icon: Icons.lock_reset_rounded,
                  title: 'تغيير كلمة المرور',
                  subtitle: 'تحديث كلمة مرور الحساب',
                  onTap: () => _soon(context, 'تغيير كلمة المرور'),
                ),
                const Divider(height: 1, color: RihalStyle.cardBorder),
                _SettingsItem(
                  icon: Icons.location_on_outlined,
                  title: 'صلاحية الموقع',
                  subtitle: 'التحكم باستخدام موقعك',
                  onTap: () => _soon(context, 'صلاحية الموقع'),
                ),
                const Divider(height: 1, color: RihalStyle.cardBorder),
                _SettingsItem(
                  icon: Icons.delete_outline_rounded,
                  title: 'حذف الحساب',
                  subtitle: 'حذف الحساب والبيانات نهائيًا',
                  onTap: () => _soon(context, 'حذف الحساب'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// HELP
// ============================================================================

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _SettingsScaffold(
      title: 'المساعدة والدعم',
      child: ListView(
        padding: RihalStyle.pagePadding,
        children: [
          RihalCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _SettingsItem(
                  icon: Icons.help_outline_rounded,
                  title: 'الأسئلة الشائعة',
                  subtitle: 'إجابات لأكثر الأسئلة شيوعًا',
                  onTap: () => _soon(context, 'الأسئلة الشائعة'),
                ),
                const Divider(height: 1, color: RihalStyle.cardBorder),
                _SettingsItem(
                  icon: Icons.email_outlined,
                  title: 'تواصل معنا',
                  subtitle: 'إرسال استفسار أو ملاحظة',
                  onTap: () => _soon(context, 'تواصل معنا'),
                ),
                const Divider(height: 1, color: RihalStyle.cardBorder),
                _SettingsItem(
                  icon: Icons.bug_report_outlined,
                  title: 'الإبلاغ عن مشكلة',
                  subtitle: 'ساعدينا في تحسين رِحال',
                  onTap: () => _soon(context, 'الإبلاغ عن مشكلة'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// ABOUT
// ============================================================================

class AboutRihalScreen extends StatelessWidget {
  const AboutRihalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _SettingsScaffold(
      title: 'عن رِحال',
      child: ListView(
        padding: RihalStyle.pagePadding,
        children: [
          RihalCard(
            child: Column(
              children: [
                const Icon(
                  Icons.explore_rounded,
                  size: 62,
                  color: RihalStyle.darkGreen,
                ),
                const SizedBox(height: 12),
                const Text(
                  'رِحال',
                  style: TextStyle(
                    color: RihalStyle.deepGreen,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'مساعدك الذكي لاكتشاف المدينة وبناء رحلة تناسب اهتماماتك.',
                  textAlign: TextAlign.center,
                  style: RihalStyle.cardBody,
                ),
                const SizedBox(height: 16),
                const Text(
                  'الإصدار 1.0.0',
                  style: RihalStyle.cardCaption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// SHARED SETTINGS WIDGETS
// ============================================================================

class _SettingsScaffold extends StatelessWidget {
  const _SettingsScaffold({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: RihalTranslations.direction(context),
      child: Scaffold(
        backgroundColor: RihalStyle.background,
        appBar: AppBar(
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          backgroundColor: RihalStyle.background,
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: RihalStyle.darkGreen,
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: RihalStyle.deepGreen,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SafeArea(child: child),
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  const _SettingsItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: RihalStyle.darkGreen),
      title: Text(title, style: RihalStyle.cardTitle),
      subtitle: Text(subtitle, style: RihalStyle.cardCaption),
      trailing: const Icon(
        Icons.arrow_back_ios_new_rounded,
        size: 15,
        color: RihalStyle.brown,
      ),
      onTap: onTap,
    );
  }
}

void _soon(BuildContext context, String title) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        '$title سيتم ربطها لاحقًا',
        textAlign: TextAlign.center,
      ),
    ),
  );
}
