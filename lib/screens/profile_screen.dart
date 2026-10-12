import 'package:flutter/material.dart' hide Text;
import '../localization/rihal_localized_text.dart';

import '../rihal_style.dart';
import 'instant_explore_screen.dart';
import 'explore_screen.dart';
import 'my_trips_screen.dart';
import 'profile_settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
          title: const Text(
            'الحساب',
            style: TextStyle(
              color: RihalStyle.deepGreen,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SafeArea(
          child: ListView(
            padding: RihalStyle.pagePadding,
            physics: const BouncingScrollPhysics(),
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
                    const SizedBox(height: 12),
                    const Text(
                      'تيم رحال',
                      style: TextStyle(
                        color: RihalStyle.deepGreen,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'rihal@example.com',
                      style: RihalStyle.cardCaption,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: RihalStyle.spaceLg),

              RihalCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _ProfileItem(
                      icon: Icons.person_outline_rounded,
                      title: 'تعديل الملف الشخصي',
                      subtitle: 'الاسم والبريد الإلكتروني وبيانات الحساب',
                      onTap: () => _open(
                        context,
                        const ProfileSettingsScreen(),
                      ),
                    ),
                    const _ProfileDivider(),
                    _ProfileItem(
                      icon: Icons.notifications_none_rounded,
                      title: 'الإشعارات',
                      subtitle: 'التحكم بتنبيهات الرحلات والاقتراحات',
                      onTap: () => _open(
                        context,
                        const NotificationsSettingsScreen(),
                      ),
                    ),
                    const _ProfileDivider(),
                    _ProfileItem(
                      icon: Icons.language_rounded,
                      title: 'اللغة',
                      subtitle: RihalTranslations.currentLanguageLabel(context),
                      onTap: () => _open(
                        context,
                        const LanguageSettingsScreen(),
                      ),
                    ),
                    const _ProfileDivider(),
                    _ProfileItem(
                      icon: Icons.lock_outline_rounded,
                      title: 'الخصوصية والأمان',
                      subtitle: 'كلمة المرور وخصوصية الحساب',
                      onTap: () => _open(
                        context,
                        const PrivacySettingsScreen(),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: RihalStyle.spaceLg),

              RihalCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _ProfileItem(
                      icon: Icons.help_outline_rounded,
                      title: 'المساعدة والدعم',
                      subtitle: 'الأسئلة الشائعة والتواصل معنا',
                      onTap: () => _open(
                        context,
                        const HelpSupportScreen(),
                      ),
                    ),
                    const _ProfileDivider(),
                    _ProfileItem(
                      icon: Icons.info_outline_rounded,
                      title: 'عن رِحال',
                      subtitle: 'معلومات التطبيق والإصدار',
                      onTap: () => _open(
                        context,
                        const AboutRihalScreen(),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 90),
            ],
          ),
        ),
        bottomNavigationBar: RihalBottomNavigation(
          selectedIndex: 3,

          onMyTrips: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const MyTripsScreen(),
              ),
            );
          },

          onHome: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ExploreScreen(),
              ),
            );
          },

          onExplore: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const InstantExploreScreen(),
              ),
            );
          },

          onProfile: () {},
        ),
      ),
    );
  }

  static void _open(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }
}

class _ProfileItem extends StatelessWidget {
  const _ProfileItem({
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 14,
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: RihalStyle.cardBackgroundLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: RihalStyle.darkGreen,
                  size: 21,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: RihalStyle.deepGreen,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: RihalStyle.secondaryText,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: RihalStyle.brown,
                size: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileDivider extends StatelessWidget {
  const _ProfileDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      indent: 68,
      endIndent: 15,
      color: RihalStyle.cardBorder,
    );
  }
}
