import 'package:flutter/material.dart';
import 'package:zoltrakk/pages/forgotpassword.dart';
import 'package:zoltrakk/pages/homepage.dart';
import 'package:zoltrakk/pages/signup.dart';
import 'package:zoltrakk/resources/auth_method.dart';
import 'package:zoltrakk/utils/utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isloading = false;


  @override
  void dispose(){
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async{
    setState(() {
      _isloading=true;
    });
    String res = await AuthMethods().loginUser(email: _emailController.text, password: _passwordController.text);
    if(res=='success'){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
      //
    }else{
      showSnackBar(context, res);
    }
    setState(() {
      _isloading = false;
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 250,
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: Colors.pink,
                borderRadius: BorderRadius.only(
                  //  bottomLeft: Radius.circular(200),
                   bottomRight: Radius.circular(200)
                )
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20, top: 150),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Welcome Back!', style: TextStyle(fontSize: 32, ),),
                    Text('Login', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),)
                    
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            
            ),
            Padding(padding: 
            const EdgeInsets.only(left: 20, right: 20),
            child: Text('Email', style: TextStyle(fontSize: 18, fontWeight:FontWeight.bold),),
            
            ),
            const SizedBox(height: 10,),
            Padding(padding: const EdgeInsets.only(left: 20, right: 20),
            child: TextField(
              controller: _emailController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person_2_outlined),
                hintText: 'Enter Your Email'
              ),
            ),
            ),
            const SizedBox(height: 40,),
            Padding(padding: const EdgeInsets.only(left: 20, right: 40),
            child: Text('Password', style: TextStyle(fontSize:18, fontWeight: FontWeight.bold ),),
            ),
            const SizedBox(height: 10,),
            Padding(padding: 
            const EdgeInsets.only(left: 20, right: 20),
            child: TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.password_outlined),
                hintText: 'Enter Your Password',
                
              ),
            ),
            ),
            const SizedBox(height: 25,),
            Padding(padding: const EdgeInsets.only(left: 265, right: 20),
            child: GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgotPassword()));
              },
              child: Text('Forgot Password?', style: TextStyle(
                color: Colors.pinkAccent, fontSize: 15, fontWeight: FontWeight.bold
              ),),
            ),
            ),
            const SizedBox(height: 35,),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: InkWell(
                onTap: loginUser,
                child: Container(
                  height: 60,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 204, 27, 86),
                    borderRadius: BorderRadius.circular(45),
                  ),
                  child:_isloading? const Center(child: CircularProgressIndicator(color: Colors.white,),): Center(
                    child: Text('Login', style: TextStyle(color: Colors.white, fontSize: 19),),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 20,),
            Padding(padding: 
            const EdgeInsets.only(left: 20, right: 20),
            child: GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUp()));
              },
              child: Center(child: Text('Don\'t have an account? Sign Up', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),))),
            )
          ],
        ),
      ),
    );
  }
}