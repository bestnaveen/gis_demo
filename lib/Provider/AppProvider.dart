import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import 'SettingProvider.dart';

class AppProvider extends StatelessWidget{
  const AppProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (_) => SettingScreenProvider(),
      ),
    ],
      child: const MyApp(),);
  }

}