import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static Future getAllPosts() async {
    final productsURl = Uri.parse('https://fakestoreapi.com/products');
    final result = await http.get(productsURl);
    final List t = json.decode(result.body) as List;
    return t;
  }

  static Future getSingleProduct(int id) async {
    final productUrl = Uri.parse('https://fakestoreapi.com/products/$id');
    final result = await http.get(productUrl);
    final t = json.decode(result.body) as Map;
    return t;
  }

  static Future getCategories() async {
    final categoryUrl =
        Uri.parse('https://fakestoreapi.com/products/categories');
    final result = await http.get(categoryUrl);

    final List t = json.decode(result.body) as List;
    return t;
  }

  static Future<List> getSingleCategoryProducts(
      // ignore: non_constant_identifier_names
      {required String Category}) async {
    final _url =
        Uri.parse('https://fakestoreapi.com/products/category/$Category');

    final result = await http.get(_url);
    final List t = json.decode(result.body) as List;

    return t;
  }

  static Future getCart({required int id}) async {
    final _url = Uri.parse('https://fakestoreapi.com/carts/$id');

    final result = await http.get(_url);

    return json.decode(result.body);
  }
}
