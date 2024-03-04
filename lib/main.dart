import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:onemorecoin/model/GroupModel.dart';
import 'package:onemorecoin/model/StorageStage.dart';
import 'package:onemorecoin/model/WalletModel.dart';

import 'package:onemorecoin/navigations/NavigationBottom_2.dart';
import 'package:onemorecoin/pages/Budget/editbudget/ListTransactionInBudget.dart';
import 'package:onemorecoin/pages/Budget/editbudget/DetailBudget.dart';
import 'package:onemorecoin/pages/HomeScreen.dart';
import 'package:onemorecoin/pages/LoginScreen.dart';
import 'package:onemorecoin/pages/RootScreen.dart';

import 'package:onemorecoin/pages/Transaction/addtransaction/AddNotePage.dart';
import 'package:onemorecoin/pages/Transaction/edittransaction/DetailTransaction.dart';
import 'package:provider/provider.dart';
import 'model/BudgetModel.dart';
import 'model/TransactionModel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      appId: '1:46715462293:ios:a99ed4c6f8cbcd2ddff19c',
      messagingSenderId: '46715462293',
      projectId: 'auth-e8933',
      apiKey: 'AIzaSyDTFlpkK4TQ2CWEgguj2VgOHTmqiSRZdgA',
    ),
  );
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
      useDefaultLoading: false,
      overlayWidgetBuilder: (_) { //ignored progress for the moment
        return Center(
          child: SpinKitCubeGrid(
            color: Colors.yellow,
            size: 50.0,
          ),
        );
      },
      overlayColor: Colors.grey.withOpacity(0.8),
      child: MultiProvider(
          providers: [
            Provider(create: (context) => TransactionModelProxy()),
            Provider(create: (context) => BudgetModelProxy()),
            //   Provider(create: (context) => WalletModelProxy()),
            //   Provider(create: (context) => GroupModelProxy()),
            //
            // ChangeNotifierProxyProvider4<TransactionModelProxy, BudgetModelProxy, WalletModelProxy, GroupModelProxy,  StorageStage>(
            //   create: (context) => StorageStage(),
            //   update: (context, transactionModel, budgetModel, walletModel, groupModel, storageStage) {
            //     storageStage!.transactionModelProxy = transactionModel;
            //     storageStage.budgetModelProxy = budgetModel;
            //     storageStage.walletModelProxy = walletModel;
            //     storageStage.groupModelProxy = groupModel;
            //     storageStage.init();
            //     return storageStage;
            //   },
            // ),

            // ChangeNotifierProxyProvider2<TransactionModelProxy, BudgetModelProxy, StorageStage>(
            //   create: (context) => StorageStage(),
            //   update: (context, transactionModel, budgetModelProxy , storageStage) {
            //     storageStage!.transactionModelProxy = transactionModel;
            //     storageStage.budgetModelProxy = budgetModelProxy;
            //     storageStage.init();
            //     return storageStage;
            //   },
            // ),
            ChangeNotifierProvider(create: (context) => TransactionModelProxy()),
            ChangeNotifierProvider(create: (context) => BudgetModelProxy()),
            ChangeNotifierProvider(create: (context) => WalletModelProxy()),
            ChangeNotifierProvider(create: (context) => GroupModelProxy()),
            ChangeNotifierProvider(create: (context) => StorageStageProxy()),
            // ChangeNotifierProvider(create: (context) => StorageStage(
            //   Provider.of<TransactionModelProxy>(context, listen: false),
            //   Provider.of<BudgetModelProxy>(context, listen: false),
            // )),

          ],
          child: MaterialApp(
            title: 'Flutter Demo',
            initialRoute: '/',
            onGenerateRoute: (RouteSettings settings) {
              switch (settings.name) {
                case RootScreen.routeName:
                  return MaterialWithModalsPageRoute(
                    builder: (context) => const RootScreen(),
                    settings: settings,
                  );
                case LoginScreen.routeName:
                  return MaterialWithModalsPageRoute(
                    builder: (context) => const LoginScreen(),
                    settings: settings,
                  );
                case '/home':
                  return MaterialWithModalsPageRoute(
                    builder: (context) => const NavigationBottom2(),
                    settings: settings,
                  );
                case '/HomeScreen':
                  return MaterialWithModalsPageRoute(
                    builder: (context) => const HomeScreen(
                      title: "HomeScreen",
                    ),
                    settings: settings,
                  );
                case '/DetailTransaction':
                  final args = settings.arguments as TransactionModel;
                  return MaterialWithModalsPageRoute(
                    builder: (context) =>  DetailTransaction(
                        transactionModel: args
                    ),
                    settings: settings,
                  );
                case '/DetailBudget':
                  final args = settings.arguments as BudgetModel;
                  return MaterialWithModalsPageRoute(
                    builder: (context) => DetailBudget(
                      budgetModel: args,
                    ),
                    settings: settings,
                  );
                case '/ListTransactionInBudget':
                  final args = settings.arguments as BudgetModel;
                  return MaterialWithModalsPageRoute(
                    builder: (context) => ListTransactionInBudget(
                      budgetModel: args,
                    ),
                    settings: settings,
                  );

              }
              return MaterialPageRoute(
                builder: (context) => Scaffold(
                  body: Center(
                    child: Text('No path for ${settings.name}'),
                  ),
                ),
                settings: settings,
              );
            },

            navigatorObservers: [ClearFocusOnPush()],
            theme: ThemeData(
              colorScheme: const ColorScheme.light(
                primary: Colors.yellow,
                secondary: Colors.black,
                surface: Colors.white,
                brightness: Brightness.light,
              ),
              // ColorScheme.fromSeed(
              //   primary: Colors.yellow,
              //   secondary: Colors.black,
              //   surface: Colors.white,
              //   seedColor: Colors.purple,
              //   brightness: Brightness.light,
              // ),

              bottomAppBarTheme: const BottomAppBarTheme(
                color: Colors.yellow,
                elevation: 0.0,
                shape: CircularNotchedRectangle(),
              ),
              appBarTheme: const AppBarTheme(
                elevation: 0.0,
                surfaceTintColor: Colors.transparent,
              ),
              textTheme: const TextTheme().apply(
                bodyColor: Colors.black,
                displayColor: Colors.black,
              ),
              buttonTheme: const ButtonThemeData(
                buttonColor: Colors.green,
                textTheme: ButtonTextTheme.primary,
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                ),
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                ),
              ),
              useMaterial3: true,
            ),

            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('vi', 'VN'),
              Locale('en', 'US'),
            ],
            locale: const Locale('vi', 'VN'),
            // home: const LoginScreen(),
          )
      )
    );
  }

  void _showDetailsOnNestedNavigator(
      BuildContext context, AddNotePage notePage, Function(BuildContext)? onPressed) {
    final nav = Navigator(
      observers: [HeroController()],
      onGenerateRoute: (settings) => CupertinoPageRoute(
        builder: ((context) {
          return notePage;
        }),
      ),
    );
    showCupertinoModalBottomSheet(
      context: context,
      builder: (context) => nav,
    );
  }
}

class ClearFocusOnPush extends NavigatorObserver{
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}


