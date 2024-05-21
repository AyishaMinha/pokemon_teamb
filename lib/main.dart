import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:app/modules/merch/widgets/shirt_provider.dart';
import 'package:app/shared/getit/getit.dart';
import 'package:app/shared/providers/auth_state_provider.dart';
import 'package:app/shared/providers/credit_card_provider.dart';
import 'package:app/shared/providers/credits_provider.dart';
import 'package:app/shared/providers/daily_checkin_provider.dart';
import 'package:app/shared/providers/favourites_provider.dart';
import 'package:app/shared/providers/otp_provider.dart';
import 'package:app/shared/providers/password_obscure_provider.dart';
import 'package:app/shared/providers/signup_provider.dart';
import 'package:app/shared/providers/timer_provider.dart';
import 'package:app/shared/providers/youtube_provider.dart';
import 'package:app/shared/repositories/credit_card_db.dart';
import 'package:app/shared/utils/connectivity_wrapper.dart';
import 'package:app/shared_preferences_provider.dart';
import 'package:app/theme/dark/dark_theme.dart';
import 'package:app/theme/light/light_theme.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:app/shared/routes/router.dart' as router;
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> loadEnv() async {
  await dotenv.load();
}

void main() async {
  // Making the statusbar transparent
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.getInstance().then((instance) async {
    WidgetsFlutterBinding.ensureInitialized();

    final initializer = MyAppInitializer();
    final prefs = await initializer.initialize();
    await CreditCardDatabase.initialize();

    // .env service
    await loadEnv();
    runApp(MyApp(prefs));
  });
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp(this.prefs, {super.key});

  @override
  Widget build(BuildContext context) {
    GetItRegister.register();

    final botToastBuilder = BotToastInit();

    ///
    return ThemeProvider(
      initTheme: prefs.getBool("darkTheme") ?? false ? darkTheme : lightTheme,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AuthProvider()),
          ChangeNotifierProvider(create: (context) => SignupProvider()),
          ChangeNotifierProvider(create: (context) => OtpProvider()),
          ChangeNotifierProvider(create: (context) => TimerProvider()),
          ChangeNotifierProvider(create: (context) => ObscureProvider()),
          ChangeNotifierProvider(
              create: (context) => FavouritesProvider(context)),
          ChangeNotifierProvider(create: (context) => YoutubeProvider()),
          ChangeNotifierProvider(create: (_) => CreditsProvider(context)),
          ChangeNotifierProvider(create: (context) => CheckinProvider(context)),
          ChangeNotifierProvider(create: (context) => CreditCardDatabase()),
          ChangeNotifierProvider(create: (context) => CreditCardProvider()),
          ChangeNotifierProvider(create: (context) => ShirtProvider()),
        ],
        child: ScreenUtilInit(
          minTextAdapt: true,
          useInheritedMediaQuery: true,
          designSize: const Size(414, 896),
          builder: (context, child) => Builder(
            builder: (context) {
              return ConnectivityWrapper(
                child: MaterialApp(
                  title: 'Pokedex By Team B',
                  builder: (context, child) {
                    child = botToastBuilder(context, child);
                    return child;
                  },
                  theme: lightTheme,
                  darkTheme: darkTheme,
                  navigatorObservers: [BotToastNavigatorObserver()],
                  debugShowCheckedModeBanner: false,
                  initialRoute: '/',
                  routes: router.Router.getRoutes(context),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
