import 'package:blog_app/res/getx_loclization/languages.dart';
import 'package:blog_app/res/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';




void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
      url: 'https://itbjlrsdiyaluvzcyewg.supabase.co',
      anonKey: 'sb_publishable_j8qHhq5sAka18Usf4cqX3A_UypLqsaN');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blog App',
      translations: Languages(),
      locale: const Locale('en' ,'US'),
      fallbackLocale: const Locale('en' ,'US'),
      theme: ThemeData(
        // primarySwatch: Colors.blue,
        // useMaterial3: true,
        colorSchemeSeed: Colors.teal,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        // inputDecorationTheme: InputDecorationTheme(
        //   border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        //   filled: true,
        //   fillColor: Colors.grey[100],
        // ),
      ),
      getPages: AppRoutes.appRoutes(),
    );
  }
}
final supabase = Supabase.instance.client;
