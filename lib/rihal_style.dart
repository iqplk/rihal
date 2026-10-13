import 'package:flutter/material.dart' hide Text;
import 'localization/rihal_localized_text.dart';

// ============================================================================
// R I H A L  •  D E S I G N  S Y S T E M
// ============================================================================
// الملف المرجعي الوحيد لتصميم واجهات رِحال.
// الأقسام:
// 01  الألوان والخطوط والمقاسات والثيم
// 02  المكونات المشتركة: البطاقات والعناوين
// 03  مكونات إعداد الرحلة
// 04  شريط التنقل السفلي والأزرار الرئيسية
// 05  مكونات الخريطة
// 06  مكونات الاستكشاف
//
// ملاحظة: لا تضعي بيانات المستخدم أو GPS أو عمليات API هنا؛ هذا ملف تصميم فقط.
// ============================================================================

/// هوية رِحال البصرية الموحدة: استخدمي هذه القيم بدل الأرقام المتكررة.
class RihalStyle {
  RihalStyle._();

  // --------------------------------------------------------------------------
  // 01.A  PALETTE | الألوان المعتمدة
  // --------------------------------------------------------------------------
  static const Color background = Color(0xFFE6D5C6);
  static const Color darkGreen = Color(0xFF30452D);
  static const Color deepGreen = Color(0xFF263D30);
  static const Color brown = Color(0xFF745B47);
  static const Color secondaryText = Color(0xFF806E60);
  static const Color borderColor = Color(0xFFD9C6B3);
  static const Color softGreen = Color(0xFFEAF0E7);
  static const Color inactiveGreen = Color(0xFF81927B);
  static const Color navInactive = Color(0xFF5B4C41);
  static const Color popupBackground = Color(0xFFF9F5EF);

  static const Color cardBackground = Color(0xFFF8F3EC);
  static const Color cardBackgroundLight = Color(0xFFFFFBF6);
  static const Color cardBorder = Color(0xFFE5D8CA);
  static const Color onCard = Color(0xFF263D30);
  static const Color onCardMuted = Color(0xFF806E60);

  static const Color museumMarker = Color(0xFF75518A);
  static const Color landmarkMarker = Color(0xFF9A6542);
  static const Color searchHint = Color(0xFF958A80);
  static const Color textMuted = Color(0xFF554A41);
  static const Color cardText = Color(0xFF40362F);

  // --------------------------------------------------------------------------
  // 01.B  LAYOUT
  // --------------------------------------------------------------------------
  static const double pageHorizontalPadding = 18;
  static const double pageTopPadding = 8;
  static const double pageBottomPadding = 16;
  static const EdgeInsets pagePadding = EdgeInsets.fromLTRB(
    18,
    8,
    18,
    16,
  );

  static const double cardRadius = 22;
  static const double fieldRadius = 13;
  static const double buttonRadius = 16;
  static const double navTopRadius = 22;
  static const double primaryButtonHeight = 50;
  static const double exploreCategoryHeight = 72;
  static const double exploreTopButtonSize = 51;
  static const double exploreSearchHeight = 52;
  static const double exploreCategoryWidth = 69;
  static const double mapActionSize = 47;
  static const double sectionIconSize = 21;
  static const double navIconSize = 25;
  static const double navTextSize = 11;

  static const double spaceXs = 4;
  static const double spaceSm = 8;
  static const double spaceMd = 12;
  static const double spaceLg = 18;
  static const double spaceXl = 24;

  // --------------------------------------------------------------------------
  // 01.C  TYPOGRAPHY
  // --------------------------------------------------------------------------
  static const double pageTitleSize = 25;
  static const double pageSubtitleSize = 13;
  static const double sectionTitleSize = 16.5;
  static const double sectionSubtitleSize = 11;
  static const double bodySize = 13;
  static const double captionSize = 11.5;
  static const double primaryButtonTextSize = 17;

  static const TextStyle bodyText = TextStyle(
    color: deepGreen,
    fontSize: bodySize,
    height: 1.5,
  );

  static const TextStyle captionText = TextStyle(
    color: secondaryText,
    fontSize: captionSize,
    height: 1.4,
  );

  static const TextStyle pageTitle = TextStyle(
    color: deepGreen,
    fontSize: pageTitleSize,
    fontWeight: FontWeight.bold,
    height: 1.3,
  );

  static const TextStyle pageSubtitle = TextStyle(
    color: secondaryText,
    fontSize: pageSubtitleSize,
    height: 1.5,
  );

  static const TextStyle sectionTitle = TextStyle(
    color: deepGreen,
    fontSize: sectionTitleSize,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle sectionSubtitle = TextStyle(
    color: secondaryText,
    fontSize: sectionSubtitleSize,
    height: 1.4,
  );

  static const TextStyle cardTitle = TextStyle(
    color: onCard,
    fontSize: sectionTitleSize,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle cardSubtitle = TextStyle(
    color: onCardMuted,
    fontSize: sectionSubtitleSize,
    height: 1.4,
  );

  static const TextStyle cardBody = TextStyle(
    color: onCard,
    fontSize: bodySize,
    height: 1.5,
  );

  static const TextStyle cardCaption = TextStyle(
    color: onCardMuted,
    fontSize: captionSize,
    height: 1.4,
  );

  // --------------------------------------------------------------------------
  // 01.D  DECORATIONS
  // --------------------------------------------------------------------------
  static BoxDecoration cardDecoration({
    double radius = cardRadius,
  }) =>
      BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: cardBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF745B47).withValues(
              alpha: 0.10,
            ),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      );

  static BoxDecoration fieldDecoration({
    double radius = fieldRadius,
  }) =>
      BoxDecoration(
        color: cardBackgroundLight,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: cardBorder,
        ),
      );

  // --------------------------------------------------------------------------
  // 01.E  BUTTONS + THEME
  // --------------------------------------------------------------------------
  static ButtonStyle primaryButtonStyle({
    bool enabled = true,
  }) =>
      ElevatedButton.styleFrom(
        backgroundColor:
            enabled ? darkGreen : inactiveGreen,
        foregroundColor: Colors.white,
        disabledBackgroundColor: inactiveGreen,
        disabledForegroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      );

  // --------------------------------------------------------------------------
  // 01.F  NAVIGATION
  // --------------------------------------------------------------------------
  static BoxDecoration bottomNavDecoration() =>
      BoxDecoration(
        color: cardBackground,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(navTopRadius),
          topRight: Radius.circular(navTopRadius),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.10,
            ),
            blurRadius: 14,
            offset: const Offset(0, -3),
          ),
        ],
      );

  static const EdgeInsets bottomNavPadding =
      EdgeInsets.only(
    top: 8,
    bottom: 7,
  );

  // --------------------------------------------------------------------------
  // 01.G  APP THEME
  // --------------------------------------------------------------------------
  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: darkGreen,
          primary: darkGreen,
          surface: background,
        ),
        elevatedButtonTheme:
            ElevatedButtonThemeData(
          style: primaryButtonStyle(),
        ),
      );
}

// ============================================================================
// 02 | SHARED COMPONENTS
// ============================================================================

class RihalCard extends StatelessWidget {
  const RihalCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(15),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: padding,
        decoration: RihalStyle.cardDecoration(),
        child: child,
      );
}

class RihalSectionHeading extends StatelessWidget {
  const RihalSectionHeading({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 39,
            height: 39,
            decoration: const BoxDecoration(
              color:
                  RihalStyle.cardBackgroundLight,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: RihalStyle.darkGreen,
              size: RihalStyle.sectionIconSize,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: RihalStyle.cardTitle,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: RihalStyle.cardSubtitle,
                ),
              ],
            ),
          ),
        ],
      );
}

// ============================================================================
// 03 | TRIP SETUP
// ============================================================================

class RihalLanguageOption {
  const RihalLanguageOption(
    this.code,
    this.name,
    this.flag,
  );

  final String code;
  final String name;
  final String flag;
}

class RihalLanguageSelector extends StatelessWidget {
  const RihalLanguageSelector({
    super.key,
    required this.currentCode,
    required this.languages,
    required this.onChanged,
  });

  final String currentCode;
  final List<RihalLanguageOption> languages;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final current = languages.firstWhere(
      (item) => item.code == currentCode,
    );

    return Align(
      alignment:
          AlignmentDirectional.centerStart,
      child: PopupMenuButton<String>(
        tooltip: RihalTranslations.tr(
          context,
          'اللغة',
        ),
        initialValue: currentCode,
        color: RihalStyle.popupBackground,
        elevation: 8,
        offset: const Offset(0, 8),
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(18),
        ),
        onSelected: onChanged,
        itemBuilder: (context) =>
            languages.map((language) {
          final selected =
              language.code == currentCode;

          return PopupMenuItem<String>(
            value: language.code,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  language.flag,
                  style: const TextStyle(
                    fontSize: 19,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  language.name,
                  style: TextStyle(
                    color:
                        RihalStyle.deepGreen,
                    fontSize: 13,
                    fontWeight: selected
                        ? FontWeight.bold
                        : FontWeight.w500,
                  ),
                ),
                if (selected) ...[
                  const SizedBox(width: 12),
                  const Icon(
                    Icons.check_circle_rounded,
                    color:
                        RihalStyle.darkGreen,
                    size: 17,
                  ),
                ],
              ],
            ),
          );
        }).toList(),
        child: Padding(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 7,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.language_rounded,
                size: 20,
                color:
                    RihalStyle.deepGreen,
              ),
              const SizedBox(width: 7),
              Text(
                current.name,
                style: const TextStyle(
                  color:
                      RihalStyle.deepGreen,
                  fontSize: 13,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
              const SizedBox(width: 3),
              const Icon(
                Icons
                    .keyboard_arrow_down_rounded,
                color: RihalStyle.brown,
                size: 19,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RihalHeroHeader extends StatelessWidget {
  const RihalHeroHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) =>
      Column(
        children: [
          Image.asset(
            'assets/images/1.png',
            width: 116,
            height: 78,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 3),
          Text(
            title,
            textAlign: TextAlign.center,
            style: RihalStyle.pageTitle,
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: RihalStyle.pageSubtitle,
          ),
        ],
      );
}

class RihalDateField extends StatelessWidget {
  const RihalDateField({
    super.key,
    required this.title,
    required this.date,
    required this.onTap,
  });

  final String title;
  final String date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) =>
      Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsetsDirectional
                    .only(
              start: 3,
            ),
            child: Text(
              title,
              style: const TextStyle(
                color:
                    RihalStyle.onCardMuted,
                fontSize: 12,
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Material(
            color: Colors.transparent,
            borderRadius:
                BorderRadius.circular(13),
            child: InkWell(
              onTap: onTap,
              borderRadius:
                  BorderRadius.circular(13),
              child: Container(
                height: 49,
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 9,
                ),
                decoration:
                    RihalStyle.fieldDecoration(),
                child: Row(
                  children: [
                    const Icon(
                      Icons
                          .calendar_today_outlined,
                      color:
                          RihalStyle.brown,
                      size: 17,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        date,
                        maxLines: 1,
                        overflow:
                            TextOverflow
                                .ellipsis,
                        style:
                            const TextStyle(
                          color: RihalStyle
                              .onCard,
                          fontSize: 11.5,
                          fontWeight:
                              FontWeight
                                  .w600,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons
                          .keyboard_arrow_down_rounded,
                      color:
                          RihalStyle.brown,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
}

class RihalDaysBadge extends StatelessWidget {
  const RihalDaysBadge({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) =>
      Container(
        width: double.infinity,
        padding:
            const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 9,
        ),
        decoration: BoxDecoration(
          color:
              RihalStyle.cardBackgroundLight,
          borderRadius:
              BorderRadius.circular(13),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.event_available_outlined,
              color: RihalStyle.darkGreen,
              size: 19,
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  color:
                      RihalStyle.deepGreen,
                  fontSize: 12.5,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
}

class RihalAccommodationField
    extends StatelessWidget {
  const RihalAccommodationField({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) =>
      Material(
        color: Colors.transparent,
        borderRadius:
            BorderRadius.circular(15),
        child: InkWell(
          onTap: onTap,
          borderRadius:
              BorderRadius.circular(15),
          child: Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            decoration:
                RihalStyle.fieldDecoration(
              radius: 15,
            ),
            child: Row(
              children: [
                Container(
                  width: 43,
                  height: 43,
                  decoration: BoxDecoration(
                    color: RihalStyle
                        .cardBackgroundLight,
                    borderRadius:
                        BorderRadius.circular(
                      12,
                    ),
                  ),
                  child: const Icon(
                    Icons.map_outlined,
                    color:
                        RihalStyle.darkGreen,
                    size: 23,
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        overflow:
                            TextOverflow
                                .ellipsis,
                        style:
                            const TextStyle(
                          color: RihalStyle
                              .onCard,
                          fontSize: 13.5,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        subtitle,
                        style:
                            const TextStyle(
                          color: RihalStyle
                              .onCardMuted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons
                      .arrow_forward_ios_rounded,
                  color: RihalStyle.brown,
                  size: 14,
                ),
              ],
            ),
          ),
        ),
      );
}

class RihalInterestChip
    extends StatelessWidget {
  const RihalInterestChip({
    super.key,
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) =>
      Material(
        color: selected
            ? RihalStyle.darkGreen
            : RihalStyle
                .cardBackgroundLight,
        borderRadius:
            BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius:
              BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(
              milliseconds: 170,
            ),
            padding:
                const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(20),
              border: Border.all(
                color: selected
                    ? RihalStyle.darkGreen
                    : RihalStyle.cardBorder,
                width: selected ? 1.4 : 1,
              ),
            ),
            child: Row(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: selected
                      ? Colors.white
                      : RihalStyle.darkGreen,
                ),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: TextStyle(
                    color: selected
                        ? Colors.white
                        : RihalStyle
                            .deepGreen,
                    fontSize: 11.5,
                    fontWeight: selected
                        ? FontWeight.bold
                        : FontWeight.w500,
                  ),
                ),
                if (selected) ...[
                  const SizedBox(width: 5),
                  const Icon(
                    Icons
                        .check_circle_rounded,
                    color: Colors.white,
                    size: 15,
                  ),
                ],
              ],
            ),
          ),
        ),
      );
}

// ============================================================================
// 04 | BOTTOM NAVIGATION + PRIMARY ACTION
// ============================================================================

class RihalBottomArea extends StatelessWidget {
  const RihalBottomArea({
    super.key,
    required this.buttonLabel,
    required this.isReady,
    required this.onButtonPressed,
    required this.myTripsLabel,
    required this.homeLabel,
    required this.exploreLabel,
    required this.onMyTrips,
    required this.onHome,
    required this.onExplore,
    this.onProfile,
    this.profileLabel = 'الحساب',
  });

  final String buttonLabel;
  final bool isReady;
  final VoidCallback onButtonPressed;
  final String myTripsLabel;
  final String homeLabel;
  final String exploreLabel;
  final VoidCallback onMyTrips;
  final VoidCallback onHome;
  final VoidCallback onExplore;
  final VoidCallback? onProfile;
  final String profileLabel;

  @override
  Widget build(BuildContext context) =>
      Container(
        decoration: BoxDecoration(
          color: RihalStyle.background,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: 0.045,
              ),
              blurRadius: 12,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:
                    const EdgeInsets.fromLTRB(
                  18,
                  9,
                  18,
                  8,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed:
                        onButtonPressed,
                    style: RihalStyle
                        .primaryButtonStyle(
                      enabled: isReady,
                    ),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .center,
                      children: [
                        Text(
                          buttonLabel,
                          style:
                              const TextStyle(
                            fontSize: 17,
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(
                          Icons
                              .arrow_back_rounded,
                          size: 22,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              RihalBottomNavigation(
                myTripsLabel: myTripsLabel,
                homeLabel: homeLabel,
                exploreLabel: exploreLabel,
                onMyTrips: onMyTrips,
                onHome: onHome,
                onExplore: onExplore,
                onProfile: onProfile,
                profileLabel: profileLabel,
              ),
            ],
          ),
        ),
      );
}

class RihalBottomNavigation
    extends StatelessWidget {
  const RihalBottomNavigation({
    super.key,
    required this.onMyTrips,
    required this.onHome,
    required this.onExplore,
    this.onProfile,
    this.myTripsLabel = 'رحلاتي',
    this.homeLabel = 'الرئيسية',
    this.exploreLabel = 'استكشاف لحظي',
    this.profileLabel = 'الحساب',
    this.selectedIndex = 1,
  });

  final VoidCallback onMyTrips;
  final VoidCallback onHome;
  final VoidCallback onExplore;
  final VoidCallback? onProfile;

  final String myTripsLabel;
  final String homeLabel;
  final String exploreLabel;
  final String profileLabel;

  final int selectedIndex;

  @override
  Widget build(BuildContext context) =>
      Container(
        padding:
            RihalStyle.bottomNavPadding,
        decoration:
            RihalStyle.bottomNavDecoration(),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              RihalNavItem(
                icon: Icons
                    .calendar_month_outlined,
                label: RihalTranslations.tr(
                  context,
                  myTripsLabel,
                ),
                selected:
                    selectedIndex == 0,
                onTap: onMyTrips,
              ),
              RihalNavItem(
                icon: Icons.home_rounded,
                label: RihalTranslations.tr(
                  context,
                  homeLabel,
                ),
                selected:
                    selectedIndex == 1,
                onTap: onHome,
              ),
              RihalNavItem(
                icon:
                    Icons.explore_outlined,
                label: RihalTranslations.tr(
                  context,
                  exploreLabel,
                ),
                selected:
                    selectedIndex == 2,
                onTap: onExplore,
              ),
              RihalNavItem(
                icon: Icons
                    .person_outline_rounded,
                label: RihalTranslations.tr(
                  context,
                  profileLabel,
                ),
                selected:
                    selectedIndex == 3,
                onTap: onProfile ?? () {},
              ),
            ],
          ),
        ),
      );
}

class RihalNavItem extends StatelessWidget {
  const RihalNavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) =>
      Expanded(
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size:
                    RihalStyle.navIconSize,
                color: selected
                    ? RihalStyle.darkGreen
                    : RihalStyle.brown,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                maxLines: 1,
                overflow:
                    TextOverflow.ellipsis,
                textAlign:
                    TextAlign.center,
                style: TextStyle(
                  color: selected
                      ? RihalStyle.darkGreen
                      : RihalStyle.brown,
                  fontSize:
                      RihalStyle.navTextSize,
                  fontWeight: selected
                      ? FontWeight.bold
                      : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
}

// ============================================================================
// 05 | MAP SCREEN
// ============================================================================

class RihalMapButton extends StatelessWidget {
  const RihalMapButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.loading = false,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool loading;
  final String? tooltip;

  @override
  Widget build(BuildContext context) =>
      Tooltip(
        message: tooltip ?? '',
        child: Material(
          color: RihalStyle.cardBackground,
          borderRadius:
              BorderRadius.circular(15),
          child: InkWell(
            onTap: loading ? null : onTap,
            borderRadius:
                BorderRadius.circular(15),
            child: Container(
              width: 47,
              height: 47,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(
                  15,
                ),
                border: Border.all(
                  color:
                      RihalStyle.cardBorder,
                ),
                boxShadow: [
                  BoxShadow(
                    color: RihalStyle.brown
                        .withValues(
                      alpha: 0.07,
                    ),
                    blurRadius: 12,
                    offset:
                        const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: loading
                    ? const SizedBox(
                        width: 21,
                        height: 21,
                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2.2,
                          color: RihalStyle
                              .darkGreen,
                        ),
                      )
                    : Icon(
                        icon,
                        color: RihalStyle
                            .darkGreen,
                        size: 23,
                      ),
              ),
            ),
          ),
        ),
      );
}

class RihalMapPin extends StatelessWidget {
  const RihalMapPin({
    super.key,
    required this.scale,
  });

  final Animation<double> scale;

  @override
  Widget build(BuildContext context) =>
      ScaleTransition(
        scale: scale,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: RihalStyle.darkGreen
                    .withValues(
                  alpha: 0.12,
                ),
                shape: BoxShape.circle,
              ),
            ),
            const Icon(
              Icons.location_on_rounded,
              color: RihalStyle.darkGreen,
              size: 49,
            ),
            const Positioned(
              top: 10,
              child: Icon(
                Icons.circle,
                color:
                    RihalStyle.softGreen,
                size: 11,
              ),
            ),
          ],
        ),
      );
}

class RihalMapHeader extends StatelessWidget {
  const RihalMapHeader({
    super.key,
    required this.onBack,
    required this.title,
    required this.subtitle,
  });

  final VoidCallback onBack;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) =>
      Padding(
        padding:
            const EdgeInsets.fromLTRB(
          18,
          10,
          18,
          12,
        ),
        child: Row(
          children: [
            Material(
              color:
                  RihalStyle.cardBackground,
              borderRadius:
                  BorderRadius.circular(14),
              child: InkWell(
                onTap: onBack,
                borderRadius:
                    BorderRadius.circular(
                  14,
                ),
                child: Container(
                  width: 43,
                  height: 43,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(
                      14,
                    ),
                    border: Border.all(
                      color: RihalStyle
                          .cardBorder,
                    ),
                  ),
                  child: const Icon(
                    Icons
                        .arrow_forward_ios_rounded,
                    color:
                        RihalStyle.darkGreen,
                    size: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style:
                        const TextStyle(
                      color: RihalStyle
                          .deepGreen,
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style:
                        const TextStyle(
                      color: RihalStyle
                          .onCardMuted,
                      fontSize: 11.5,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 41,
              height: 41,
              decoration:
                  const BoxDecoration(
                color:
                    RihalStyle.softGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.location_on_rounded,
                color:
                    RihalStyle.darkGreen,
                size: 22,
              ),
            ),
          ],
        ),
      );
}

class RihalMapHint extends StatelessWidget {
  const RihalMapHint({
    super.key,
    required this.hasSelectedLocation,
  });

  final bool hasSelectedLocation;

  @override
  Widget build(BuildContext context) =>
      IgnorePointer(
        child: Container(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 13,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color:
                RihalStyle.cardBackground,
            borderRadius:
                BorderRadius.circular(15),
            border: Border.all(
              color: RihalStyle.cardBorder,
            ),
            boxShadow: [
              BoxShadow(
                color: RihalStyle.brown
                    .withValues(
                  alpha: 0.08,
                ),
                blurRadius: 14,
                offset:
                    const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                hasSelectedLocation
                    ? Icons
                        .check_circle_outline_rounded
                    : Icons
                        .touch_app_outlined,
                color:
                    RihalStyle.darkGreen,
                size: 18,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  hasSelectedLocation
                      ? 'يمكنك تغيير الموقع بالضغط على الخريطة'
                      : 'اضغط على الخريطة لتحديد موقع إقامتك',
                  maxLines: 2,
                  style:
                      const TextStyle(
                    color:
                        RihalStyle.onCard,
                    fontSize: 12,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

class RihalMapBottomBar
    extends StatelessWidget {
  const RihalMapBottomBar({
    super.key,
    required this.selectedPlaceName,
    required this.isLoadingAddress,
    required this.hasSelectedLocation,
    required this.onConfirm,
  });

  final String selectedPlaceName;
  final bool isLoadingAddress;
  final bool hasSelectedLocation;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) =>
      Container(
        width: double.infinity,
        padding:
            const EdgeInsets.fromLTRB(
          18,
          12,
          18,
          10,
        ),
        decoration: BoxDecoration(
          color: RihalStyle.background,
          boxShadow: [
            BoxShadow(
              color: RihalStyle.brown
                  .withValues(
                alpha: 0.07,
              ),
              blurRadius: 14,
              offset:
                  const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RihalCard(
              child: Row(
                children: [
                  Container(
                    width: 43,
                    height: 43,
                    decoration:
                        BoxDecoration(
                      color: RihalStyle
                          .cardBackgroundLight,
                      borderRadius:
                          BorderRadius
                              .circular(
                        12,
                      ),
                    ),
                    child: const Icon(
                      Icons.place_outlined,
                      color: RihalStyle
                          .darkGreen,
                      size: 23,
                    ),
                  ),
                  const SizedBox(
                    width: 11,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        Text(
                          RihalTranslations
                              .tr(
                            context,
                            'الموقع المختار',
                          ),
                          style: RihalStyle
                              .cardTitle,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          selectedPlaceName,
                          maxLines: 2,
                          overflow:
                              TextOverflow
                                  .ellipsis,
                          style:
                              const TextStyle(
                            color: RihalStyle
                                .secondaryText,
                            fontSize: 11.5,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isLoadingAddress)
                    const Padding(
                      padding:
                          EdgeInsetsDirectional
                              .only(
                        start: 8,
                      ),
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2,
                          color: RihalStyle
                              .darkGreen,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 11),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed:
                    hasSelectedLocation
                        ? onConfirm
                        : null,
                style: RihalStyle
                    .primaryButtonStyle(
                  enabled:
                      hasSelectedLocation,
                ),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        RihalTranslations
                            .tr(
                          context,
                          'تأكيد موقع الإقامة',
                        ),
                        maxLines: 1,
                        overflow:
                            TextOverflow
                                .ellipsis,
                        textAlign:
                            TextAlign.center,
                        style:
                            const TextStyle(
                          fontSize: 17,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    const Icon(
                      Icons.check_rounded,
                      size: 22,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}

// ============================================================================
// 06 | EXPLORE SCREEN
// ============================================================================

class RihalExploreCircleButton
    extends StatelessWidget {
  const RihalExploreCircleButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: RihalStyle.cardBackground,
      shape: const CircleBorder(),
      elevation: 3,
      shadowColor: Colors.black.withValues(
        alpha: 0.12,
      ),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width:
              RihalStyle.exploreTopButtonSize,
          height:
              RihalStyle.exploreTopButtonSize,
          child: Icon(
            icon,
            color: RihalStyle.darkGreen,
            size: 27,
          ),
        ),
      ),
    );
  }
}

class RihalExploreSearchField
    extends StatelessWidget {
  const RihalExploreSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height:
          RihalStyle.exploreSearchHeight,
      decoration: BoxDecoration(
        color: RihalStyle.cardBackground,
        borderRadius:
            BorderRadius.circular(27),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.12,
            ),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textAlign: TextAlign.start,
        style: const TextStyle(
          color: RihalStyle.deepGreen,
          fontSize: RihalStyle.bodySize,
        ),
        decoration: InputDecoration(
          hintText: RihalTranslations.tr(
            context,
            'ابحث عن معلم، مطعم، مقهى...',
          ),
          hintStyle: const TextStyle(
            color:
                RihalStyle.secondaryText,
            fontSize: 13,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: RihalStyle.brown,
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(
            vertical: 16,
          ),
        ),
      ),
    );
  }
}

class RihalExploreMainFilter
    extends StatelessWidget {
  const RihalExploreMainFilter({
    super.key,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 180,
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected
                ? RihalStyle.darkGreen
                : Colors.transparent,
            borderRadius:
                BorderRadius.circular(21),
          ),
          child: Text(
            RihalTranslations.tr(
              context,
              title,
            ),
            style: TextStyle(
              color: selected
                  ? Colors.white
                  : RihalStyle.onCard,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class RihalExploreCategoryButton
    extends StatelessWidget {
  const RihalExploreCategoryButton({
    super.key,
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 180,
        ),
        width:
            RihalStyle.exploreCategoryWidth,
        margin:
            const EdgeInsets.only(left: 8),
        decoration: BoxDecoration(
          color: selected
              ? RihalStyle.darkGreen
              : RihalStyle.cardBackground,
          borderRadius:
              BorderRadius.circular(17),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: 0.09,
              ),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 23,
              color: selected
                  ? Colors.white
                  : RihalStyle.darkGreen,
            ),
            const SizedBox(height: 4),
            Text(
              RihalTranslations.tr(
                context,
                title,
              ),
              style: TextStyle(
                color: selected
                    ? Colors.white
                    : RihalStyle.onCard,
                fontSize: 10.5,
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RihalExploreMapActionButton
    extends StatelessWidget {
  const RihalExploreMapActionButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.loading = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: RihalStyle.cardBackground,
      elevation: 2,
      shadowColor:
          RihalStyle.brown.withValues(
        alpha: 0.12,
      ),
      borderRadius:
          BorderRadius.circular(14),
      child: InkWell(
        onTap: loading ? null : onTap,
        borderRadius:
            BorderRadius.circular(14),
        child: SizedBox(
          width: 46,
          height: 46,
          child: Center(
            child: loading
                ? const SizedBox(
                    width: 21,
                    height: 21,
                    child:
                        CircularProgressIndicator(
                      strokeWidth: 2.2,
                      color: RihalStyle
                          .darkGreen,
                    ),
                  )
                : Icon(
                    icon,
                    color:
                        RihalStyle.darkGreen,
                    size: 24,
                  ),
          ),
        ),
      ),
    );
  }
}

class RihalExploreCurrentLocationMarker
    extends StatelessWidget {
  const RihalExploreCurrentLocationMarker({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color:
            RihalStyle.darkGreen.withValues(
          alpha: 0.14,
        ),
      ),
      child: Center(
        child: Container(
          width: 19,
          height: 19,
          decoration: BoxDecoration(
            color: RihalStyle.darkGreen,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 3,
            ),
          ),
        ),
      ),
    );
  }
}

class RihalExploreBottomNavigation
    extends StatelessWidget {
  const RihalExploreBottomNavigation({
    super.key,
    required this.onMyTrips,
    required this.onHome,
    required this.onInstantExplore,
    this.onProfile,
  });

  final VoidCallback onMyTrips;
  final VoidCallback onHome;
  final VoidCallback onInstantExplore;
  final VoidCallback? onProfile;

  @override
  Widget build(BuildContext context) =>
      RihalBottomNavigation(
        onMyTrips: onMyTrips,
        onHome: onHome,
        onExplore: onInstantExplore,
        onProfile: onProfile,
        selectedIndex: 1,
      );
}

// ============================================================================
// 06.B | EXPLORE SHARED CARDS
// ============================================================================

class RihalExploreFilterBar
    extends StatelessWidget {
  const RihalExploreFilterBar({
    super.key,
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) =>
      Container(
        height: 47,
        padding: const EdgeInsets.all(4),
        decoration:
            RihalStyle.cardDecoration(
          radius: 25,
        ),
        child: Row(
          children: children,
        ),
      );
}

class RihalExplorePlaceMarker
    extends StatelessWidget {
  const RihalExplorePlaceMarker({
    super.key,
    required this.name,
    required this.icon,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String name;
  final IconData icon;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) =>
      GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              constraints:
                  const BoxConstraints(
                maxWidth: 145,
              ),
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 9,
                vertical: 6,
              ),
              decoration:
                  RihalStyle.cardDecoration(
                radius: 20,
              ).copyWith(
                color: RihalStyle
                    .cardBackground,
                border: selected
                    ? Border.all(
                        color: RihalStyle
                            .darkGreen,
                        width: 2,
                      )
                    : Border.all(
                        color: RihalStyle
                            .cardBorder,
                      ),
              ),
              child: Row(
                mainAxisSize:
                    MainAxisSize.min,
                children: [
                  Container(
                    width: 31,
                    height: 31,
                    decoration:
                        BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      selected
                          ? Icons
                              .check_rounded
                          : icon,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Flexible(
                    child: Text(
                      RihalTranslations.tr(
                        context,
                        name,
                      ),
                      maxLines: 1,
                      overflow:
                          TextOverflow
                              .ellipsis,
                      style:
                          const TextStyle(
                        color:
                            RihalStyle.onCard,
                        fontSize:
                            RihalStyle
                                .bodySize,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.location_on_rounded,
              color: color,
              size: 27,
            ),
          ],
        ),
      );
}

class RihalExplorePlanCard
    extends StatelessWidget {
  const RihalExplorePlanCard({
    super.key,
    required this.icons,
    required this.onTap,
  });

  final List<IconData> icons;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) =>
      Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius:
              BorderRadius.circular(
            RihalStyle.cardRadius,
          ),
          child: RihalCard(
            child: SizedBox(
              height: 64,
              child: Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: Stack(
                      children: [
                        for (var i = 0;
                            i < icons.length &&
                                i < 3;
                            i++)
                          Positioned(
                            right:
                                i * 27.0,
                            top: 8,
                            child:
                                Container(
                              width: 45,
                              height: 45,
                              decoration:
                                  BoxDecoration(
                                color: RihalStyle
                                    .darkGreen,
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  13,
                                ),
                                border:
                                    Border.all(
                                  color:
                                      RihalStyle
                                          .background,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                icons[i],
                                color:
                                    Colors.white,
                                size: 22,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .center,
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        Text(
                          'خطتي (${icons.length})',
                          style:
                              RihalStyle
                                  .cardTitle,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          icons.length == 1
                              ? 'مكان مختار'
                              : 'أماكن مختارة',
                          style:
                              RihalStyle
                                  .cardCaption,
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons
                        .arrow_back_ios_new_rounded,
                    color:
                        RihalStyle.softGreen,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

class RihalExploreMapOptionsSheet
    extends StatelessWidget {
  const RihalExploreMapOptionsSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) =>
      Directionality(
        textDirection:
            RihalTranslations.direction(
          context,
        ),
        child: Container(
          margin: const EdgeInsets.all(14),
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: RihalStyle.background,
            borderRadius:
                BorderRadius.circular(28),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                Container(
                  width: 45,
                  height: 4,
                  decoration: BoxDecoration(
                    color: RihalStyle
                        .borderColor,
                    borderRadius:
                        BorderRadius.circular(
                      10,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'عرض الخريطة',
                  style:
                      RihalStyle.sectionTitle,
                ),
                const SizedBox(height: 15),
                const Text(
                  'سنضيف أنماط عرض إضافية للخريطة لاحقاً',
                  textAlign:
                      TextAlign.center,
                  style: RihalStyle.bodyText,
                ),
              ],
            ),
          ),
        ),
      );
}