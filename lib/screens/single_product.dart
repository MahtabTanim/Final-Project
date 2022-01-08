import 'package:flutter/material.dart';
import '../services/api_service.dart';

// ignore: must_be_immutable
class SingleProduct extends StatelessWidget {
  final int _id;
  final String _title;
  const SingleProduct(this._id, this._title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title.toString()),
        backgroundColor: Colors.redAccent,
      ),
      body: FutureBuilder(
        future: ApiService.getSingleProduct(_id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map m = snapshot.data as Map;
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: Image.network(
                      m['image'],
                      fit: BoxFit.fill,
                    ),
                  ),
                  Center(
                    child: Text(
                      m['price'].toString(),
                      style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(m['title'].toString(), style: TitleStyle()),
                  Chip(
                    label: Text(
                      m['category'].toString(),
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    backgroundColor: Colors.lightBlue[200],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    m['description'].toString(),
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
          color: Colors.amber,
        ),
        onPressed: () {
          SnackBar snackBar = SnackBar(
            content: Text(
              "item $_title added to the cart",
              textAlign: TextAlign.center,
            ),
            padding: const EdgeInsets.only(top: 10, bottom: 10),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
      ),
    );
  }

  // ignore: non_constant_identifier_names
  TextStyle TitleStyle() {
    return const TextStyle(
        color: Colors.black54,
        fontSize: 21,
        overflow: TextOverflow.ellipsis,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(blurRadius: 1, color: Colors.red, offset: Offset(-1, -1))
        ]);
  }
}
