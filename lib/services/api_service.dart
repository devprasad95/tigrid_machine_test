import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/random_data.dart';

class ApiService extends ChangeNotifier {
  List<RandomData> _randomDatas = [];
  bool _isLoading = false;
  late BuildContext _context;

  List<RandomData> get randomDatas => _randomDatas;
  bool get isLoading => _isLoading;

  void init(BuildContext context) {
    _context = context;
  }

  Future<void> fetchDatas() async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await http
          .get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
      if (response.statusCode == 200) {
        List<dynamic> datas = jsonDecode(response.body);
        List<RandomData> newDatas =
            datas.map((item) => RandomData.fromJson(item)).toList();

        _randomDatas = newDatas;
      } else {
        print('failed at 1');
        _showErrorSnackbar();
      }
    } catch (e) {
      print('failed: $e');
      _showErrorSnackbar();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _showErrorSnackbar() {
    ScaffoldMessenger.of(_context).showSnackBar(
      const SnackBar(
        content: Text('Failed to fetch data. Please try again later.'),
      ),
    );
  }
}