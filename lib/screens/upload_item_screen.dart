import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/item.dart';
import '../services/item_service.dart';
import 'dart:convert';

class UploadItemScreen extends StatefulWidget {
  const UploadItemScreen({Key? key}) : super(key: key);

  @override
  State<UploadItemScreen> createState() => _UploadItemScreenState();
}

class _UploadItemScreenState extends State<UploadItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _itemService = ItemService();

  // Form controllers
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _reporterController = TextEditingController();
  final _contactController = TextEditingController();

  int _categoryId = 1; // Default category
  DateTime _dateFound = DateTime.now();
  bool _isLoading = false;
  String? _errorMessage;
  Item? _createdItem;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _reporterController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateFound,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _dateFound) {
      setState(() {
        _dateFound = picked;
      });
    }
  }

  Future<void> _submitItem() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _createdItem = null;
    });

    try {
      // Format date for backend
      final formattedDate = "${_dateFound.toIso8601String()}";

      final newItem = Item(
        itemName: _nameController.text,
        description: _descriptionController.text,
        categoryId: _categoryId,
        locationFound: _locationController.text,
        dateTimeFound: formattedDate,
        reportedBy: _reporterController.text,
        contactInfo: _contactController.text,
        // Don't specify imageIdsList at all
      );

      final jsonBody = jsonEncode(newItem.toJson());
      print("Sending JSON: $jsonBody");

      final createdItem = await _itemService.createItem(newItem);

      setState(() {
        _isLoading = false;
        if (createdItem != null) {
          _createdItem = createdItem;
          _formKey.currentState!.reset();
          // Rest of your code...
        } else {
          _errorMessage = 'Failed to create item. Please try again.';
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'An error occurred: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Found Item'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(10),
                  color: Colors.red.shade100,
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              if (_createdItem != null) ...[
                Container(
                  padding: const EdgeInsets.all(10),
                  color: Colors.green.shade100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Item successfully reported!',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Item ID: ${_createdItem!.itemId}'),
                      Text('Item Name: ${_createdItem!.itemName}'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Item Name*',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the item name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description*',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<int>(
                value: _categoryId,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 1, child: Text('Electronics')),
                  DropdownMenuItem(value: 2, child: Text('Clothing')),
                  DropdownMenuItem(value: 3, child: Text('Accessories')),
                  DropdownMenuItem(value: 4, child: Text('Documents')),
                  DropdownMenuItem(value: 5, child: Text('Other')),
                ],
                onChanged: (value) {
                  setState(() {
                    _categoryId = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location Found*',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter where the item was found';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Date Picker
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date Found',
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    DateFormat('yyyy-MM-dd').format(_dateFound),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _reporterController,
                decoration: const InputDecoration(
                  labelText: 'Your Name*',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _contactController,
                decoration: const InputDecoration(
                  labelText: 'Contact Information*',
                  border: OutlineInputBorder(),
                  hintText: 'Email or phone number',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your contact information';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _isLoading ? null : _submitItem,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('SUBMIT FOUND ITEM'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}