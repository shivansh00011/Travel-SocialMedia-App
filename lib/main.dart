import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zoltrakk/firebase_options.dart';
import 'package:zoltrakk/pages/homepage.dart';
import 'package:zoltrakk/pages/intropage.dart';
import 'package:zoltrakk/providers/userprovider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp ({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider(),),
      ],
    child:  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(), builder:(context, snapshot){
        if(snapshot.connectionState== ConnectionState.active){
          if(snapshot.hasData){
            return HomePage();
          }else if(snapshot.hasError){
            return Center(child: Text('${snapshot.error}'),);
          }
        }
        if(snapshot.connectionState==ConnectionState.waiting){
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return const IntroPage();
      })));
    

  }
}