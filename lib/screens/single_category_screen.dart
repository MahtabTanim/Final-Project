import 'package:flutter/material.dart';
import 'single_product.dart';
import '../services/api_service.dart';

// ignore: must_be_immutable
class SingleCategoryScreen extends StatelessWidget {
  String title;

  SingleCategoryScreen(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title.toString()),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: ApiService.getSingleCategoryProducts(Category: title),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List l = snapshot.data as List;
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
                    title: Text(l[index]['title'].toString().toUpperCase()),
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
                },
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ));
  }
}
