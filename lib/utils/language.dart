class Language {
  static const String en = 'en';
  static const String ta = 'ta';

  static String currentLanguage = en;

  static final Map<String, Map<String, String>> _localizedValues = {
    en: {
      'app_name': 'V SERVE',
      'select_role': 'Select Your Role',
      'user': 'User',
      'worker': 'Worker',
      'admin': 'Admin',
      'welcome': 'Welcome',
      'services': 'Services',
      'categories': 'Categories',
      'villages': 'Villages',
      'login': 'Login',
      'logout': 'Logout',
      'switch_language': 'தமிழ்',
    },
    ta: {
      'app_name': 'V SERVE',
      'select_role': 'உங்கள் பங்கைத் தேர்ந்தெடுக்கவும்',
      'user': 'பயனர்',
      'worker': 'தொழிலாளி',
      'admin': 'நிர்வாகி',
      'welcome': 'வரவேற்கிறோம்',
      'services': 'சேவைகள்',
      'categories': 'வகைகள்',
      'villages': 'கிராமங்கள்',
      'login': 'உள்நுழைய',
      'logout': 'வெளியேறு',
      'switch_language': 'English',
    },
  };

  static String get(String key) {
    return _localizedValues[currentLanguage]?[key] ?? key;
  }

  static void toggleLanguage() {
    currentLanguage = currentLanguage == en ? ta : en;
  }
}
