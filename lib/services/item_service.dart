import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/item.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ItemService {
  String get baseUrl {
    // For web
    if (kIsWeb) {
      return 'http://localhost:8081';
    }
    // For Android emulator
    else if (!kIsWeb && Platform.isAndroid) {
      return 'http://10.0.2.2:8081';
    }
    // For iOS simulator
    else if (!kIsWeb && Platform.isIOS) {
      return 'http://localhost:8081';
    }
    // Default fallback
    return 'http://localhost:8081';
  }

  // Create a new item
  Future<Item?> createItem(Item item) async {
    try {
      final jsonData = item.toJson();
      final jsonBody = jsonEncode(jsonData);
      print("Sending JSON: $jsonBody");

      final response = await http.post(
        Uri.parse('$baseUrl/item/insertitems'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonBody,
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final responseJson = jsonDecode(response.body);
          final createdItem = Item.fromJson(responseJson);
          return createdItem;
        } catch (e) {
          print('Error parsing response: $e');
          // Return a basic item with the ID from the response if possible
          try {
            final responseJson = jsonDecode(response.body);
            if (responseJson['item_id'] != null) {
              // Create a copy of the original item but with the ID set
              return Item(
                itemId: responseJson['item_id'],
                itemName: item.itemName,
                description: item.description,
                categoryId: item.categoryId,
                locationFound: item.locationFound,
                dateTimeFound: item.dateTimeFound,
                reportedBy: item.reportedBy,
                contactInfo: item.contactInfo,
                status: item.status,
              );
            }
          } catch (_) {
            // Ignore this error and fall back to returning null
          }
          return null;
        }
      } else {
        print('Failed to create item: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error creating item: $e');
      return null;
    }
  }

  // Get item by ID
  Future<Item?> getItemById(int itemId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/item/getitems/$itemId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final responseJson = jsonDecode(response.body);
          final item = Item.fromJson(responseJson);
          return item;
        } catch (e) {
          print('Error parsing response: $e');
          return null;
        }
      } else {
        print('Failed to get item: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error getting item: $e');
      return null;
    }
  }
}