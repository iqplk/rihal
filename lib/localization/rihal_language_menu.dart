import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../localization/locale_controller.dart';
import '../rihal_style.dart';

class RihalLanguageMenu extends StatelessWidget {
  const RihalLanguageMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final localeController = LocaleScope.of(context);
    final l10n = AppLocalizations.of(context);
    final currentCode = localeController.locale.languageCode;

    final languages = <_LanguageOption>[
      _LanguageOption('ar', '🇸🇦', l10n.arabic),
      _LanguageOption('en', '🇬🇧', l10n.english),
      _LanguageOption('tr', '🇹🇷', l10n.turkish),
      _LanguageOption('ur', '🇵🇰', l10n.urdu),
    ];

    final current = languages.firstWhere(
      (language) => language.code == currentCode,
    );

    return PopupMenuButton<String>(
      tooltip: l10n.language,
      initialValue: currentCode,
      color: RihalStyle.popupBackground,
      elevation: 8,
      offset: const Offset(0, 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      onSelected: (code) {
        localeController.setLocale(Locale(code));
      },
      itemBuilder: (context) {
        return languages.map((language) {
          final selected = language.code == currentCode;

          return PopupMenuItem<String>(
            value: language.code,
            child: Row(
              children: [
                Text(
                  language.flag,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    language.label,
                    style: TextStyle(
                      color: RihalStyle.deepGreen,
                      fontSize: 13,
                      fontWeight: selected
                          ? FontWeight.bold
                          : FontWeight.w500,
                    ),
                  ),
                ),
                if (selected)
                  const Icon(
                    Icons.check_circle_rounded,
                    color: RihalStyle.darkGreen,
                    size: 18,
                  ),
              ],
            ),
          );
        }).toList();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 9,
        ),
        decoration: BoxDecoration(
          color: RihalStyle.cardBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: RihalStyle.cardBorder,
          ),
          boxShadow: [
            BoxShadow(
              color: RihalStyle.brown.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.language_rounded,
              size: 18,
              color: RihalStyle.darkGreen,
            ),
            const SizedBox(width: 7),
            Text(
              current.label,
              style: const TextStyle(
                color: RihalStyle.deepGreen,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 3),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18,
              color: RihalStyle.brown,
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageOption {
  const _LanguageOption(
    this.code,
    this.flag,
    this.label,
  );

  final String code;
  final String flag;
  final String label;
}
