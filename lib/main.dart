import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:sigacidades/data/repositories/place_repository_impl.dart';
import 'package:sigacidades/domain/repositories/place_repository.dart';
import 'package:sigacidades/firebase_options.dart';
import 'package:sigacidades/presentation/home/bloc/home_bloc.dart';
import 'package:sigacidades/presentation/home/bloc/home_event.dart';
import 'package:sigacidades/presentation/home/screens/home_page.dart';
import 'package:sigacidades/presentation/distances/screens/distances_page.dart';
import 'package:sigacidades/presentation/main_screen.dart';
import 'package:sigacidades/presentation/maps/screens/maps_page.dart';
import 'package:sigacidades/presentation/about/screens/about_page.dart';
import 'package:sigacidades/presentation/feedback/screens/feedback_page.dart';
import 'package:sigacidades/presentation/maps/bloc/maps_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

// Função principal para rodar o app.
Future main() async {
  // Inicializa os Widgets
  WidgetsFlutterBinding.ensureInitialized();

  // Carrega o arquivo .env
  await dotenv.load(fileName: '.env');

  // Inicializa o backend de cache do FMTC (flutter_map_tile_caching)
  // Inicialização do FMTC apenas em plataformas com suporte FFI
  if (!kIsWeb &&
      (Platform.isAndroid ||
          Platform.isIOS ||
          Platform.isWindows ||
          Platform.isLinux ||
          Platform.isMacOS)) {
    await FMTCObjectBoxBackend().initialise();
    await FMTCStore('mapStore').manage.create();
  }

  // Cria a configuração do Just Audio Background
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  // Inicializa o Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Dá inicio ao app depois dos carregamentos iniciais
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Inicializa o PlaceRepositoryImpl.
    final placeRepository = PlaceRepositoryImpl();
    return MultiProvider(
      providers: [
        // O PlaceRepository será fornecido para toda a aplicação.
        Provider<PlaceRepository>(
          create: (_) => placeRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          // CategoryBloc para gerenciar o estado da HomePage e categorias.
          BlocProvider<CategoryBloc>(
            create: (context) => CategoryBloc(placeRepository)
              ..add(SelectCategoryEvent(0)), // Evento inicial de categoria.
          ),
          // MapsBloc para gerenciar o estado do MapsPage.
          BlocProvider<MapsBloc>(
            create: (context) => MapsBloc(placeRepository),
          ),
        ],
        // ====================================
        // Configuração do MaterialApp com as rotas do app
        // ====================================
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Sigacidades',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            // Responsividade de tela
            useMaterial3: true,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),

          // Define a rota inicial da aplicação (HomePage).

          // initialRoute: MainScreen.routeName,
          initialRoute: '/', // Define LogoSplashScreen como rota inicial

          // Rotas nomeadas: Aqui é definido todas as rotas do app.
          routes: {
            '/': (context) => const LogoSplashScreen(),
            MainScreen.routeName: (context) => const MainScreen(),
            HomePage.routeName: (context) => const HomePage(),
            DistancesPage.routeName: (context) => const DistancesPage(),
            MapsPage.routeName: (context) => const MapsPage(),
            AboutPage.routeName: (context) => const AboutPage(),
            FeedbackPage.routeName: (context) => const FeedbackPage(),
          },
        ),
      ),
    );
  }
}

// SplashScreen para exibir o logo do BF
class LogoSplashScreen extends StatelessWidget {
  const LogoSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 1500, // Duração de 1 segundo
      splash: 'assets/logo_bf.png', // Logo do BF
      nextScreen: const MainScreen(),
      splashTransition: SplashTransition.sizeTransition,
      splashIconSize: 200,
      backgroundColor: Colors.white,
    );
  }
}
