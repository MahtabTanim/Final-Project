import 'package:flutter/material.dart';
import 'single_product.dart';
import '../services/api_service.dart';

// ignore: must_be_immutable
class CartScreen extends StatelessWidget {
  int id;

  CartScreen({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shopping cart"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: ApiService.getCart(id: 1),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List ls = (snapshot.data as Map)['products'] as List;
            return ListView.builder(
              itemCount: ls.length,
              itemBuilder: (context, index) {
                return FutureBuilder(
                  future: ApiService.getSingleProduct(ls[index]['productId']),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      Map item = snapshot.data as Map;
                      return ListTile(
                        leading: Image.network(
                          item['image'].toString(),
                          height: 50,
                          width: 50,
                        ),
                        title: Text(item['title'].toString()),
                        trailing: Text(
                          item['price'].toString(),
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey.withOpacity(0.7)),
                        ),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return SingleProduct(item['id'], item['title']);
                          }));
                        },
                      );
                    }
                    return const Center(
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  },
                );
              },
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
