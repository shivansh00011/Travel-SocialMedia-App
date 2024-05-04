
import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:zoltrakk/models/user.dart';
import 'package:zoltrakk/providers/userprovider.dart';
import 'package:zoltrakk/resources/auth_method.dart';
import 'package:zoltrakk/resources/firestore_methods.dart';

import 'package:zoltrakk/utils/utils.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  bool _isLoading = false;
  void initState(){
    super.initState();
    addData();
  }
  addData() async{
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
  }
  String coordinates="No Location found";
  String position = "";
  String address='No Address found';
  bool scanning=false;


 
  

  checkPermission()async{

    bool serviceEnabled;
    LocationPermission permission;
    
    serviceEnabled=await Geolocator.isLocationServiceEnabled();

    print(serviceEnabled);

    if (!serviceEnabled){
      await Geolocator.openLocationSettings();
      return ;
    }


    permission=await Geolocator.checkPermission();

    print(permission);

    if (permission==LocationPermission.denied){

      permission=await Geolocator.requestPermission();

      if (permission==LocationPermission.denied){
        Fluttertoast.showToast(msg: 'Request Denied !');
        return ;
      }

    } 
    
    if(permission==LocationPermission.deniedForever){
      Fluttertoast.showToast(msg: 'Denied Forever !');
      return ;
    }

    getLocation();

  }

  getLocation()async{
    
    setState(() {scanning=true;});

   try{

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      
    coordinates='Latitude : ${position.latitude} \nLongitude : ${position.longitude}';

    List<Placemark> result  = await placemarkFromCoordinates(position.latitude, position.longitude);

    if (result.isNotEmpty){
      address='${result[0].name}, ${result[0].locality} ${result[0].administrativeArea}';
    }


   }catch(e){
    Fluttertoast.showToast(msg:"${e.toString()}");
   }

    setState(() {scanning=false;});
  }
  Uint8List? _file;

  final TextEditingController _descriptionController = TextEditingController();

  void poostImage(
  
    String uid,
    String username,
    double latitude,
    double longitude,
    
  )async{
    setState(() {
      _isLoading=true;
    });
    try {
     
        String res = await FirestoreMethods().uploadPost( _descriptionController.text, username, _file!, uid,latitude, longitude);
     
      if(res=='success'){
        setState(() {
          _isLoading = false;
        });
        showSnackBar(context,'posted');
        clearImage();
      }else{
        _isLoading = false;
        showSnackBar(context, res);
      }
      
    } catch (e) {
      showSnackBar(context, e.toString());
      
    }

  }
  
  _selectImage(BuildContext context) async{
    return showDialog(context: context, builder:(context){
      return SimpleDialog(
        title: const Text('Create a Post'),
        children: [
          SimpleDialogOption(
            padding: const EdgeInsets.all(20),
           child:  const Text('Take a photo'),
           onPressed: () async{
            Navigator.of(context).pop();
            Uint8List file = await pickImage(ImageSource.camera);
            setState(() {
              _file=file;
            });
           },

          ),
          SimpleDialogOption(
            padding: const EdgeInsets.all(20),
           child:  const Text('Choose from gallery'),
           onPressed: () async{
            Navigator.of(context).pop();
            Uint8List file = await pickImage(ImageSource.gallery);
            setState(() {
              _file=file;
            });
           },

          ),
          SimpleDialogOption(
            padding: const EdgeInsets.all(20),
           child:  const Text('Cancel'),
           onPressed: () async{
            Navigator.of(context).pop();
            
           },

          )
        ],
      );
    });
  }
  @override
  void dispose() {
    
    super.dispose();
   
    _descriptionController.dispose();
  }

  void clearImage(){
    setState(() {
      _file = null;
    });
  }
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    

   
    
    return _file ==null ? Center(child: IconButton(onPressed: ()=> _selectImage(context), icon: Icon(Icons.upload,),),) :
    Scaffold(
      appBar: AppBar(
        
        leading: IconButton(onPressed: clearImage, icon: Icon(Icons.arrow_back_ios, color: Colors.black,)),
        title: Text('Post to'),
        actions:<Widget> [
          TextButton(onPressed:()=> poostImage(userProvider.getUser!.uid, userProvider.getUser!.username,double.parse(coordinates.split(": ")[1].split("\n")[0]), double.parse(RegExp(r'[-]?\d+[.]\d+').stringMatch(coordinates.split(": ")[2])!))
          , child: Text('Post', style: TextStyle(color: Colors.blue, fontSize: 14),))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _isLoading ? const LinearProgressIndicator():const Padding(padding: EdgeInsets.only(top: 0)),
              const Divider(),
              Container(
                height: 300,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  image: DecorationImage(image: MemoryImage(_file!), fit: BoxFit.fill)
                ),
                
              ),
              const SizedBox(height: 10,),
              
              const SizedBox(height: 10,),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText: 'Write the Caption....'
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 5,),
              scanning?
          SpinKitThreeBounce(color: Colors.black,size: 20,):
          Text('${coordinates}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),),
          
      
          scanning?
          SpinKitThreeBounce(color: Colors.black,size: 20,):
          // Text('${address}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),),
          const SizedBox(height: 15,),
          
         
          Center(
            child: ElevatedButton.icon(
              onPressed: (){checkPermission();}, 
              icon: Icon(Icons.location_pin,color: Colors.white,), 
              label: Text('Add Your Current Location',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black,),
              ),
          ),

          
              
            ],
          ),
        ),
      ),
      
    );
    
  }
}