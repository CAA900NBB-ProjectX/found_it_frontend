import 'package:flutter/material.dart';
import '../models/item.dart';
import '../services/item_service.dart';
import 'package:intl/intl.dart';

class ViewItemScreen extends StatefulWidget {
  const ViewItemScreen({Key? key}) : super(key: key);

  @override
  State<ViewItemScreen> createState() => _ViewItemScreenState();
}

class _ViewItemScreenState extends State<ViewItemScreen> {
  final _itemService = ItemService();
  final _itemIdController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  Item? _item;

  @override
  void dispose() {
    _itemIdController.dispose();
    super.dispose();
  }

  Future<void> _fetchItem() async {
    final itemIdText = _itemIdController.text.trim();
    if (itemIdText.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter an item ID';
      });
      return;
    }

    final itemId = int.tryParse(itemIdText);
    if (itemId == null) {
      setState(() {
        _errorMessage = 'Please enter a valid item ID';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _item = null;
    });

    try {
      final item = await _itemService.getItemById(itemId);

      setState(() {
        _isLoading = false;
        _item = item;
        if (item == null) {
          _errorMessage = 'Item not found with ID: $itemId';
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error fetching item: $e';
      });
    }
  }

  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      return DateFormat('yyyy-MM-dd HH:mm').format(date);
    } catch (e) {
      return isoDate; // Return original if parsing fails
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Found Item'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _itemIdController,
                    decoration: const InputDecoration(
                      labelText: 'Enter Item ID',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _isLoading ? null : _fetchItem,
                  child: _isLoading
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Text('View Item'),
                ),
              ],
            ),

            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(10),
                color: Colors.red.shade100,
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ],

            if (_item != null) ...[
              const SizedBox(height: 24),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _item!.itemName,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      const Divider(),
                      _buildItemDetail('ID', '${_item!.itemId}'),
                      _buildItemDetail('Description', _item!.description),
                      _buildItemDetail('Category', 'Category ID: ${_item!.categoryId}'),
                      _buildItemDetail('Location Found', _item!.locationFound),
                      _buildItemDetail('Date Found', _formatDate(_item!.dateTimeFound)),
                      _buildItemDetail('Reported By', _item!.reportedBy),
                      _buildItemDetail('Contact', _item!.contactInfo),
                      _buildItemDetail('Status', _item!.status),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildItemDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}