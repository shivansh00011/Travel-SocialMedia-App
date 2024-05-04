import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoltrakk/pages/loginpage.dart';
import 'package:zoltrakk/resources/auth_method.dart';
import 'package:zoltrakk/utils/utils.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final TextEditingController _usernameController =new  TextEditingController();
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  bool _isloading = false;
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }

  void signUpUser() async{
    setState(() {
      _isloading = true;
    });
    String res = await AuthMethods().signUpUser(username: _usernameController.text, email: _emailController.text, password: _passwordController.text);
    if (res!='success') 
    {
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
                    Text('Welcome!', style: TextStyle(fontSize: 32, ),),
                    Text('Sign Up', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),)
                    
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            
            ),
            Padding(padding: 
            const EdgeInsets.only(left: 20, right: 20),
            child: Text('Username', style: TextStyle(fontSize: 18, fontWeight:FontWeight.bold),),
            
            ),
            const SizedBox(height: 10,),
            Padding(padding: const EdgeInsets.only(left: 20, right: 20),
            child: TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person_3_outlined),
                hintText: 'Enter Your Username'
              ),
            ),
            ),
            const SizedBox(height: 40,),
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
            
            const SizedBox(height: 35,),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: GestureDetector(
                onTap: signUpUser,
                
    
                child: Container(
                  height: 60,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 204, 27, 86),
                    borderRadius: BorderRadius.circular(45),
                  ),
                  child:_isloading? const Center(child: CircularProgressIndicator(color: Colors.white,),): Center(
                    child: Text('Sign Up', style: TextStyle(color: Colors.white, fontSize: 19),),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 20,),
            Padding(padding: 
            const EdgeInsets.only(left: 20, right: 20),
            child: GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
              },
              child: Center(child: Text('Already have an account? Login', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),))),
            )
          ],
        ),
      ),
    );
  }
}