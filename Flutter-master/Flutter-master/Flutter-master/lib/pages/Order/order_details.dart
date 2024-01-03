import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quiz_backoffice/api/orderapi.dart';
import 'package:quiz_backoffice/model/order.dart';
import 'package:quiz_backoffice/routing/routes.dart';
import 'package:quiz_backoffice/widgets/custom_text.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late List<Order> orderList = [];

  @override
  void initState() {
    super.initState();
    fetchOrderData();
  }

  Future<void> fetchOrderData() async {
    try {
      final orderService = ordereService();
      final fetchedOrderList = await orderService.fetchOrders();

      setState(() {
        orderList = fetchedOrderList;
      });
    } catch (error) {
      // Handle error appropriately, e.g., show an error message
      print('Error fetching order data: $error');
    }
  }

  Future<void> _showEditOrderModal(
      BuildContext context, Order order) async {
    TextEditingController locationController =
        TextEditingController(text: order.location);
    TextEditingController totalAmountController =
        TextEditingController(text: order.totalAmount.toString());
    TextEditingController isPaidController =
        TextEditingController(text: order.isPaid);
    TextEditingController dateController=
        TextEditingController(text: order.date);

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Order'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: locationController,
                  decoration: InputDecoration(labelText: 'Location'),
                ),
                TextFormField(
                  controller: totalAmountController,
                  decoration: InputDecoration(labelText: 'Total Amount'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: isPaidController,
                  decoration: InputDecoration(labelText: 'isPaid'),
                ),
                TextFormField(
                  controller: dateController,
                  decoration: InputDecoration(labelText: 'Date'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Update the order
                Order updatedOrder = Order(
                  id: order.id,
                  location: locationController.text,
                  date: dateController.text,
                  isPaid: isPaidController.text,
                  totalAmount: double.parse(totalAmountController.text),
                );

                try {
                  await ordereService().updateOrder(
                    order.id,
                    updatedOrder,
                  );
                  // Refresh the order list after updating
                  fetchOrderData();
                  Navigator.pop(context);
                } catch (error) {
                  // Handle error, e.g., show an error message
                  print('Error updating order: $error');
                }
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _deleteOrder(Order order) async {
    try {
      final orderService = ordereService();
      await orderService.deleteOrder(order.id);

      setState(() {
        orderList.removeWhere((p) => p.id == order.id);
      });

      print('Order deleted successfully');
    } catch (error) {
      print('Error deleting order: $error');
      // Optionally, you can show a user-friendly message or handle the error in another way
    }
  }

  void _handleUpdatedOrder(Order updatedOrder) {
    // Find the index of the updated order in the list
    final index =
        orderList.indexWhere((order) => order.id == updatedOrder.id);

    if (index != -1) {
      // If found, update the order in the list
      setState(() {
        orderList[index] = updatedOrder;
      });
    }
  }

  Future<void> _showAddOrderModal(BuildContext context) async {
    final newOrder = await showDialog<Order>(
      context: context,
      builder: (BuildContext context) {
        return AddOrderModal(
          onOrderAdded: (newOrder) {
            // Handle the newly added order here
            _handleNewOrder(newOrder);
          },
        );
      },
    );

    // If newOrder is not null, it means a new order was added
    if (newOrder != null) {
      // Handle the new order being added
      // For example, you might want to update the order list
      _handleNewOrder(newOrder);
    }
  }

  void _handleNewOrder(Order newOrder) {
    // Update the state to trigger a rebuild
    setState(() {
      orderList.add(newOrder);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (orderList == null) {
      // Show loading indicator or some other placeholder while data is being fetched
      return CircularProgressIndicator();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Order List'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           CustomText(
              text: 'Order List',
              size: 24,
              weight: FontWeight.bold,
              color: Colors.black12, // Set your desired color
            ),

            SizedBox(height: 16),
            Card(
              elevation: 5,
              child: _buildOrderList(),
            ),
          ],
        ),
      ),
     floatingActionButton: Row(
  mainAxisAlignment: MainAxisAlignment.end,
  children: [
    FloatingActionButton(
      onPressed: () {
        //  _showAddProductModal(context);
      },
      child: Icon(Icons.add),
    ),
    SizedBox(width: 16),
    FloatingActionButton(
      onPressed: () {
        _navigateToProductsPage(context);
      },
      child: Icon(Icons.shopping_cart),
    ),
  ],
),
    );
  }

  Widget _buildOrderList() {
    return Table(
      border: TableBorder.all(),
      columnWidths: {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(2),
        3: FlexColumnWidth(2),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey[200]),
          children: [
            _buildTableHeaderItem('Location'),
            _buildTableHeaderItem('TotalAmount'),
            _buildTableHeaderItem('isPaid'),
            _buildTableHeaderItem('Date'),
            SizedBox(), // Adjust as needed
          ],
        ),
        for (final order in orderList)
          TableRow(
            children: [
              _buildTableCell(order.location),
              _buildTableCell(order.totalAmount.toString()),
              _buildTableCell(order.isPaid),
              _buildTableCell(order.date),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () async {
                      await _showEditOrderModal(context, order);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _deleteOrder(order);
                    },
                  ),
                ],
              ),
            ],
          ),
      ],
    );
  }

   void _navigateToProductsPage(BuildContext context) {
  Navigator.of(context).pushNamed(productsPageRoute);
}

  Widget _buildTableHeaderItem(String title) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTableCell(String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Text(value),
    );
  }
}

class EditOrderModal extends StatefulWidget {
  final Order initialOrder;
  final Function(Order) onOrderUpdated;

  const EditOrderModal({
    Key? key,
    required this.initialOrder,
    required this.onOrderUpdated,
  }) : super(key: key);

  @override
  _EditOrderModalState createState() => _EditOrderModalState();
}

class _EditOrderModalState extends State<EditOrderModal> {
  late TextEditingController _locationController;
  late TextEditingController _totalAmountController;
  late TextEditingController _isPaidController;
  late TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    _locationController = TextEditingController(text: widget.initialOrder.location);
    _totalAmountController =
        TextEditingController(text: widget.initialOrder.totalAmount.toString());
    _isPaidController =
        TextEditingController(text: widget.initialOrder.isPaid);
    _dateController = TextEditingController(text: widget.initialOrder.date);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Order'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField('Location', _locationController),
            _buildTextField('Total Amount', _totalAmountController),
            _buildTextField('isPaid', _isPaidController),
            _buildTextField('Date', _dateController),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // Create a new Order object with the updated values
            final updatedOrder = Order(
              id: widget.initialOrder.id,
              location: _locationController.text,
              totalAmount: double.parse(_totalAmountController.text),
              isPaid: _isPaidController.text,
              date: _dateController.text,
            );

            // Call the callback function with the updated Order
            widget.onOrderUpdated(updatedOrder);

            // Close the modal
            Navigator.of(context).pop();
          },
          child: Text('Save'),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
        ),
      ),
    );
  }
}

class AddOrderModal extends StatefulWidget {
  final Function(Order) onOrderAdded;

  const AddOrderModal({Key? key, required this.onOrderAdded})
      : super(key: key);

  @override
  _AddOrderModalState createState() => _AddOrderModalState();
}

class _AddOrderModalState extends State<AddOrderModal> {
 late TextEditingController _locationController;
  late TextEditingController _totalAmountController;
  late TextEditingController _isPaidController;
  late TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    _locationController = TextEditingController();
    _totalAmountController = TextEditingController();
    _isPaidController = TextEditingController();
    _dateController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Order'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField('Location', _locationController),
            _buildTextField('Total Amount', _totalAmountController),
            _buildTextField('isPaid', _isPaidController),
            _buildTextField('Date', _dateController),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // Create a new Order object with the entered values
            final newOrder = Order(
              id: '', // Leave the id empty as it will be assigned by the server
              location: _locationController.text,
              totalAmount: double.parse(_totalAmountController.text),
              isPaid: _isPaidController.text,
              date: _dateController.text,
            );

            // Call the callback function with the new Order
            widget.onOrderAdded(newOrder);

            // Close the modal
            Navigator.of(context).pop();
          },
          child: Text('Add'),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
        ),
      ),
    );
  }
}
