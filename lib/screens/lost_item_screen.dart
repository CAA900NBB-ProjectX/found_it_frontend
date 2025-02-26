import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'view_item_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

class LostItemScreen extends StatefulWidget {
  const LostItemScreen({Key? key}) : super(key: key);

  @override
  State<LostItemScreen> createState() => _LostItemScreenState();
}

class _LostItemScreenState extends State<LostItemScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Form controllers
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _contactController = TextEditingController();

  int _categoryId = 1; // Default category
  DateTime _dateLost = DateTime.now();
  
  // Image handling
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateLost,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _dateLost) {
      setState(() {
        _dateLost = picked;
      });
    }
  }
  
  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _image = image;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;
    
    // For now, just display a success message
    // In a real app, you would submit to an API
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Lost item report submitted!'),
        backgroundColor: Colors.green,
      ),
    );
    
    // Clear the form
    _formKey.currentState!.reset();
    setState(() {
      _image = null;
      _dateLost = DateTime.now();
      _categoryId = 1;
    });
    
    // Navigate to view lost items
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ViewItemScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Lost Item'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                  labelText: 'Last Seen Location*',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter where the item was last seen';
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
                    labelText: 'Date Lost',
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    DateFormat('yyyy-MM-dd').format(_dateLost),
                  ),
                ),
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
              const SizedBox(height: 16),
              
              // Image picker
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Add Photo of Item'),
                      onPressed: _pickImage,
                    ),
                  ),
                ],
              ),
              
              if (_image != null) ...[
                const SizedBox(height: 16),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: kIsWeb 
                    ? Image.network(_image!.path)
                    : Image.file(File(_image!.path)),
                ),
              ],
              
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('SUBMIT LOST ITEM REPORT'),
              ),
              
              const SizedBox(height: 16),
              
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ViewItemScreen()),
                  );
                },
                child: const Text('VIEW FOUND ITEMS'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}