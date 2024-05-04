import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoltrakk/pages/loginpage.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // height: double.maxFinite,
        width: double.maxFinite,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/back.jpg'), fit: BoxFit.cover),
        ),

        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 580),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ZOLTRAKK', style: TextStyle(
                fontSize: 35, fontWeight: FontWeight.bold
              ),),
              const SizedBox(height: 10,),
              Text('Share Your Journey, Inspire the World!', style: TextStyle(
                fontSize: 23, color: const Color.fromARGB(255, 207, 204, 204)
              ),),
              const SizedBox(
                height: 50,
              ),
              GestureDetector(
                onTap: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));

                },
                child: Container(
                  height: 60,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 240, 139, 173),
                    borderRadius: BorderRadius.circular(17)
                  ),
                  child: Center(
                    child: Text('Get Started', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}