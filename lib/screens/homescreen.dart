import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/services/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'all_category_screen.dart';
import '../services/api_service.dart';
import 'cart_screen.dart';
import 'single_product.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static String id = "/HomeScreen";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const CategoryScreen();
              }));
            },
            child: const Text(
              "Categories",
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
      appBar: AppBar(
          title: Text("${loggedInUser.firstName} ${loggedInUser.secondName}"),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CartScreen(id: 6)));
                },
                icon: const Icon(Icons.add_shopping_cart_sharp)),
          ]),
      body: FutureBuilder(
        future: ApiService.getAllPosts(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List l = snapshot.data as List;
            return ListView.builder(
                itemCount: l.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return SingleProduct(l[index]['id'], l[index]['title']);
                      }));
                    },
                    title: Text(l[index]['title']),
                    leading: Image.network(
                      l[index]['image'],
                      height: 50,
                      width: 50,
                      fit: BoxFit.fill,
                    ),
                    trailing: Text(
                      l[index]['price'].toString(),
                      style: const TextStyle(color: Colors.grey),
                    ),
                  );
                });
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
