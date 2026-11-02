abstract final class AppIdentity {
  static const String appName = 'Arrow Out';
  static const String developer = 'ARU Soft';
  static const String packageId = 'com.arusoft.arrowout';
  static const String privacyUrl = 'https://arusoft.vercel.app/privacy/arrow-out';
}

abstract final class AppRoutes {
  static const String settings = '/settings';
  static const String howTo = '/how-to';
  static const String play = '/play';
}

abstract final class PrefsKeys {
  static const String language = 'language';
  static const String sound = 'sound';
  static const String haptics = 'haptics';
  static const String reduceMotion = 'reduce_motion';
  static const String onboardingDone = 'onboarding_done';
  static const String progressNext = 'progress_next';
  static const String progressDone = 'progress_done';
}
