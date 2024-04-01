import 'package:adi_soft/app/config/app_config.dart';
import 'package:adi_soft/app/config/styles/system_styles.dart';
import 'package:flutter/material.dart';

import 'presentation/ui/pages/my_app_page.dart';
import 'presentation/ui/widgets/base/communication/base_loading_view.dart';

void main() async {
  await _initMyApp();

  SystemStyles.basic().then(
    (_) => runApp(
      const MyAppPage(),
    ),
  );
}

Future _initMyApp() async {
  //ensureInitialized for initialize device orientation
  WidgetsFlutterBinding.ensureInitialized();

  //flavor
  AppConfig(
    flavor: Flavor.production,
  );

  //easy loading
  BaseLoadingView.init();
}
