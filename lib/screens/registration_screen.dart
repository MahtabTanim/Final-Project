import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/screens/homescreen.dart';
import 'package:final_project/services/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegistrationScren extends StatefulWidget {
  const RegistrationScren({Key? key}) : super(key: key);

  @override
  _RegistrationScrenState createState() => _RegistrationScrenState();
}

class _RegistrationScrenState extends State<RegistrationScren> {
  final _auth = FirebaseAuth.instance;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  void signUp(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {
                postDetailsToFireStore(),
              })
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }

  //Post Details
  postDetailsToFireStore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.firstName = firstNameController.text;
    userModel.secondName = lastNameController.text;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());

    Fluttertoast.showToast(msg: "Successfully Registered");
    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    // firstnamefield
    final firstNameField = TextFormField(
      autofocus: false,
      validator: (value) {
        value = value.toString();
        if (value.isEmpty) {
          return "must have a first name ";
        }
        if (value.length < 3) {
          return "length must be greater than 3";
        }
        return null;
      },
      controller: firstNameController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      onSaved: (value) {
        firstNameController.value = value! as TextEditingValue;
      },
      decoration: InputDecoration(
        hintText: "First Name",
        prefixIcon: Icon(
          Icons.person,
          color: Colors.grey.shade600,
        ),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
    //lastnamefield
    final lastNameField = TextFormField(
      validator: (value) {
        value = value.toString();
        if (value.isEmpty) {
          return "must have a last name ";
        }
        if (value.length < 3) {
          return "length must be greater than 3";
        }
        return null;
      },
      autofocus: false,
      controller: lastNameController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      onSaved: (value) {
        lastNameController.value = value! as TextEditingValue;
      },
      decoration: InputDecoration(
        hintText: "Last Name",
        prefixIcon: Icon(
          Icons.person,
          color: Colors.grey.shade600,
        ),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
    // emailfield
    final emailField = TextFormField(
      validator: (value) {
        value = value.toString();
        if (value.isEmpty) {
          return "u must enter an email";
        }
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please Enter a valid email");
        }
        return null;
      },
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onSaved: (value) {
        emailController.value = value! as TextEditingValue;
      },
      decoration: InputDecoration(
        hintText: "Email",
        prefixIcon: Icon(
          Icons.mail,
          color: Colors.grey.shade600,
        ),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
    //passwordfield
    final passwordField = TextFormField(
      validator: (value) {
        RegExp regex = RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Password is required for login");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Password(Min. 6 Character)");
        }
      },
      autofocus: false,
      controller: passwordController,
      obscureText: true,
      textInputAction: TextInputAction.next,
      onSaved: (value) {
        emailController.value = value as TextEditingValue;
      },
      decoration: InputDecoration(
        hintText: "Password",
        prefixIcon: Icon(
          Icons.vpn_key,
          color: Colors.grey.shade600,
        ),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
    // confirmpassfield
    final confirmPasswordField = TextFormField(
      validator: (value) {
        RegExp regex = RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Password is required for login");
        }
        if (!regex.hasMatch(value) ||
            confirmPasswordController.text != passwordController.text) {
          return ("Enter Valid Password");
        }
      },
      autofocus: false,
      controller: confirmPasswordController,
      obscureText: true,
      onSaved: (value) {
        confirmPasswordController.value = value as TextEditingValue;
      },
      decoration: InputDecoration(
        hintText: "Confirm Password",
        prefixIcon: Icon(
          Icons.vpn_key,
          color: Colors.grey.shade600,
        ),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
    //Registration Button
    final registrationButton = Material(
      borderRadius: BorderRadius.circular(10),
      color: Colors.redAccent,
      elevation: 5,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          signUp(emailController.text, passwordController.text);
        },
        child: const Text(
          "Sign Up",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.redAccent,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formkey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 200,
                        child: Image.asset(
                          'assets/logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 45),
                      firstNameField,
                      const SizedBox(height: 20),
                      lastNameField,
                      const SizedBox(height: 20),
                      emailField,
                      const SizedBox(height: 20),
                      passwordField,
                      const SizedBox(height: 20),
                      confirmPasswordField,
                      const SizedBox(height: 40),
                      registrationButton
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
