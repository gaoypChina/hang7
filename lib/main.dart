import 'package:device_preview_screenshot/device_preview_screenshot.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hang7/pages/game_board.dart';
import 'package:hang7/pages/options.dart';
import 'package:hang7/providers/controller.dart';
import 'package:hang7/providers/settings_provider.dart';
import 'package:hang7/pages/splash.dart';
import 'package:hang7/pages/welcome_page.dart';
import 'package:hang7/providers/unique_word.dart';
import 'package:hang7/utils/purchase_api.dart';
import 'package:hang7/widgets/material_color.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

List<String> testDeviceIDs = [
  "8E3C44E0453B296DEDFBA106CDBB59CC", // Samsung S5
  "ea230aa9edfec099faea521e541b8502", //my phone
  "4520409bc3ffb536b6e203bf9d0b0007", //old SE
  "8f4cb8307ba6019ca82bccc419afe5d0", // my iPad
  "GADSimulatorID",
];

bool useTestAds = false;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await PurchaseApi.init();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool removeAds = prefs.getBool('removeAds') ?? false;
  if (removeAds) {
    await MobileAds.instance.initialize().then((InitializationStatus status) {
      debugPrint('Initialization done: ${status.adapterStatuses}');
    });
    final RequestConfiguration requestConfiguration = RequestConfiguration(
        maxAdContentRating: MaxAdContentRating.g,
        tagForChildDirectedTreatment: TagForChildDirectedTreatment.yes,
        testDeviceIds: testDeviceIDs);
    MobileAds.instance.updateRequestConfiguration(requestConfiguration);
  }
  if (kReleaseMode) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }
  final double screenWidth =
      MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width;

  if (screenWidth <= 600) {
    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }
  runApp(DevicePreview(
    enabled: false,
    builder: ((context) => const Hang7()),
    tools: const [
      ...DevicePreview.defaultTools,
      DevicePreviewScreenshot(),
    ],
  ));
}

class Hang7 extends StatelessWidget {
  const Hang7({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Controller()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(
          create: (_) => UniqueWord(),
        ),
      ],
      child: MaterialApp(
        useInheritedMediaQuery: true,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        title: 'Hang 7',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: createMaterialColor(const Color(0xff28375A)),
          fontFamily: "Boogaloo",
        ),
        routes: {
          "/": (context) => const SplashScreen(),
          "/gameBoard": (context) => const GameBoard(),
          "/options": (context) => const Options(),
          "/welcome": (context) => const WelcomePage()
        },
      ),
    );
  }
}
