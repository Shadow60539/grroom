import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:grroom/utils/all_provider.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/auth/pages/change_password_page.dart';
import 'features/auth/pages/forgot_password_page.dart';
import 'features/auth/pages/login_page.dart';
import 'features/auth/pages/signup_page.dart';
import 'features/home/pages/index_page.dart';
import 'features/stylist/widgets/hive/inf.dart';
import 'features/stylist/widgets/hive/location.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(InfluencerCodeAdapter());
  Hive.registerAdapter(LocationAdapter());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => AllProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Grroom',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: <String, WidgetBuilder>{
          "/login": (BuildContext context) => LoginPage(),
          "/signup": (BuildContext context) => SignupPage(),
          "/changePassword": (BuildContext context) => ChangePasswordPage(),
          "/forgotPassword": (BuildContext context) => ForgotPasswordPage()
        },
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String token;
  String role;
  bool screenLoaded = false;
  bool redirect = false;
  @override
  void initState() {
    super.initState();
    final storage = FlutterSecureStorage();
    storage.containsKey(key: "token").then((_contains) {
      if (_contains) {
        storage
            .read(key: "token")
            .then((value) => setState(() => token = value));
        storage.read(key: "role").then((value) => setState(() => role = value));
      } else {
        setState(() => redirect = true);
      }

      setState(() {
        screenLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          body: Container(
            child: Center(
                child: screenLoaded
                    ? redirect
                        ? LoginPage()
                        : FutureBuilder(
                            future: Future.wait([
                              Hive.openBox('influencerBox'),
                              Hive.openBox('locationBox'),
                            ]),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                return IndexPage();
                              } else {
                                return SpinKitPouringHourglass(
                                  color: Colors.black87,
                                  size: 20,
                                );
                              }
                            },
                          )
                    : SpinKitPouringHourglass(
                        color: Colors.black87,
                        size: 20,
                      )
                // child: FutureBuilder(
                //   future: Future.wait([
                //     Hive.openBox('influencerBox'),
                //     Hive.openBox('locationBox'),
                //   ]),
                //   builder: (BuildContext context, AsyncSnapshot snapshot) {
                //     if (snapshot.hasData) {
                //       return StylistPage();
                //     } else {
                //       return CircularProgressIndicator(
                //         valueColor: AlwaysStoppedAnimation(Colors.black87),
                //       );
                //     }
                //   },
                // ),
                ),
          ),
        ),
      ),
    );
    // return GalleryScreen();
  }
}
