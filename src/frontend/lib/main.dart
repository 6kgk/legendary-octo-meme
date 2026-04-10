import 'package:flutter/material.dart';
import 'services/forum_provider.dart';
import 'services/study_provider.dart';
import 'services/school_provider.dart';
import 'package:provider/provider.dart';
import 'pages/splash_screen.dart';
import 'theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StudyProvider()),
        ChangeNotifierProvider(create: (_) => SchoolProvider()),
        ChangeNotifierProvider(create: (_) => ForumProvider()),
      ],
      child: const YueZhiTongApp(),
    ),
  );
}

class YueZhiTongApp extends StatelessWidget {
  const YueZhiTongApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '粤职通',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
