import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/user_home_screen.dart';
import 'screens/worker_home_screen.dart';
import 'screens/admin_home_screen.dart';
import 'screens/service_list_screen.dart';
import 'screens/worker_list_screen.dart';
import 'screens/worker_detail_screen.dart';
import 'screens/user_profile_screen.dart';
import 'utils/constants.dart';

void main() {
  runApp(const VServeApp());
}

class VServeApp extends StatelessWidget {
  const VServeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'V SERVE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          secondary: AppColors.secondary,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/user_home': (context) => const UserHomeScreen(),
        '/worker_home': (context) => const WorkerHomeScreen(),
        '/admin_home': (context) => const AdminHomeScreen(),
        '/service_list': (context) => const ServiceListScreen(),
        '/worker_list': (context) => const WorkerListScreen(),
        '/worker_detail': (context) => const WorkerDetailScreen(),
        '/user_profile': (context) => const UserProfileScreen(),
      },
    );
  }
}
