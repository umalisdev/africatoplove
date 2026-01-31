import 'package:flutter/material.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_en.dart';

/// Enum pour les langues supportées
enum AppLanguage {
  french('fr', 'Français', '🇫🇷'),
  english('en', 'English', '🇬🇧');

  final String code;
  final String name;
  final String flag;

  const AppLanguage(this.code, this.name, this.flag);
}

/// Gestionnaire de localisation pour SparkMatch
/// Permet de basculer entre français et anglais
class LocalizationManager extends ChangeNotifier {
  AppLanguage _currentLanguage = AppLanguage.french;
  
  AppLanguage get currentLanguage => _currentLanguage;
  String get languageCode => _currentLanguage.code;
  
  /// Obtenir les traductions actuelles
  Map<String, String> get translations {
    switch (_currentLanguage) {
      case AppLanguage.french:
        return AppLocalizationsFr.translations;
      case AppLanguage.english:
        return AppLocalizationsEn.translations;
    }
  }

  /// Changer la langue
  void setLanguage(AppLanguage language) {
    if (_currentLanguage != language) {
      _currentLanguage = language;
      notifyListeners();
    }
  }

  /// Basculer entre français et anglais
  void toggleLanguage() {
    if (_currentLanguage == AppLanguage.french) {
      _currentLanguage = AppLanguage.english;
    } else {
      _currentLanguage = AppLanguage.french;
    }
    notifyListeners();
  }

  /// Obtenir une traduction par clé
  String translate(String key) {
    return translations[key] ?? key;
  }

  /// Raccourci pour obtenir une traduction
  String tr(String key) => translate(key);

  /// Obtenir la locale Flutter correspondante
  Locale get locale => Locale(_currentLanguage.code);

  /// Liste des langues disponibles
  List<AppLanguage> get availableLanguages => AppLanguage.values;
}

/// Extension pour faciliter l'accès aux traductions depuis le contexte
extension LocalizationExtension on BuildContext {
  LocalizationManager get localization {
    // Utiliser Provider ou InheritedWidget pour accéder au manager
    // Pour l'instant, retourner une instance par défaut
    return LocalizationManager();
  }
  
  String tr(String key) => localization.translate(key);
}

/// Widget pour afficher le sélecteur de langue
class LanguageSelector extends StatelessWidget {
  final LocalizationManager localizationManager;
  final bool showFlag;
  final bool showName;

  const LanguageSelector({
    super.key,
    required this.localizationManager,
    this.showFlag = true,
    this.showName = true,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<AppLanguage>(
      initialValue: localizationManager.currentLanguage,
      onSelected: (AppLanguage language) {
        localizationManager.setLanguage(language);
      },
      itemBuilder: (BuildContext context) {
        return localizationManager.availableLanguages.map((AppLanguage language) {
          return PopupMenuItem<AppLanguage>(
            value: language,
            child: Row(
              children: [
                if (showFlag) ...[
                  Text(language.flag, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                ],
                if (showName) Text(language.name),
                if (localizationManager.currentLanguage == language)
                  const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Icon(Icons.check, size: 18, color: Colors.green),
                  ),
              ],
            ),
          );
        }).toList();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showFlag) Text(
              localizationManager.currentLanguage.flag,
              style: const TextStyle(fontSize: 18),
            ),
            if (showFlag && showName) const SizedBox(width: 8),
            if (showName) Text(localizationManager.currentLanguage.name),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_drop_down, size: 20),
          ],
        ),
      ),
    );
  }
}

/// Bouton simple pour basculer la langue
class LanguageToggleButton extends StatelessWidget {
  final LocalizationManager localizationManager;

  const LanguageToggleButton({
    super.key,
    required this.localizationManager,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => localizationManager.toggleLanguage(),
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            localizationManager.currentLanguage.flag,
            style: const TextStyle(fontSize: 20),
          ),
          const Icon(Icons.swap_horiz, size: 16),
        ],
      ),
      tooltip: localizationManager.currentLanguage == AppLanguage.french
          ? 'Switch to English'
          : 'Passer en français',
    );
  }
}
