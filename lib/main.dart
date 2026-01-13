import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ledger/providers/dictionary_provider.dart';
import 'package:ledger/screens/home_screen.dart';
import 'package:ledger/services/storage_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final storageService = StorageService();
  await storageService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DictionaryProvider()),
      ],
      child: MaterialApp(
        title: 'Word Master',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          textTheme: GoogleFonts.poppinsTextTheme(),
          scaffoldBackgroundColor: const Color(0xFFF5F5F9),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
