import 'package:flutter/material.dart';
import 'package:quiz_backoffice/api/orderapi.dart';
import 'package:quiz_backoffice/helpers/reponsiveness.dart';
import 'package:quiz_backoffice/model/order.dart';
import 'package:quiz_backoffice/pages/overview/widgets/bar_chart.dart';
import 'package:quiz_backoffice/pages/overview/widgets/revenue_info.dart';
import 'package:quiz_backoffice/pages/overview/widgets/revenue_section_large.dart';
import 'package:quiz_backoffice/pages/overview/widgets/revenue_section_small.dart';
import 'package:quiz_backoffice/routing/routes.dart';
import 'package:charts_flutter_new/flutter.dart' as charts;
import 'package:quiz_backoffice/constants/style.dart';
import 'package:quiz_backoffice/widgets/custom_text.dart';




class OrdersScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrdersScreen> {
  late List<Order> orderList = [];
    double totalAmountToday = 0.0;

  @override
  void initState() {
    super.initState();
    fetchOrderData();
  }

  Future<void> _showEditOrderModal(
      BuildContext context, Order order) async {
    TextEditingController locationController =
        TextEditingController(text: order.location);
    TextEditingController dateController =
        TextEditingController(text: order.date);
    TextEditingController totalAmountController =
        TextEditingController(text: order.totalAmount.toString());
    TextEditingController isPaidController =
        TextEditingController(text: order.isPaid);

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
                  controller: dateController,
                  decoration: InputDecoration(labelText: 'Date'),
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
                    updatedOrder as Order,
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

  @override
  Widget build(BuildContext context) {
    if (orderList == null) {
      // Show loading indicator or some other placeholder while data is being fetched
      return CircularProgressIndicator();
    }

    // Display the number of completed quizzes (length of orderList)
  int numberOfCompletedQuizzes = orderList.length;

    

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
            Text(
              'Order List',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            // Display the number of completed quizzes
          Text(
            'Orders Completed: $numberOfCompletedQuizzes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
            Card(
              elevation: 5,
              child: SizedBox(
                height: 400, // Adjust the height as needed
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      // Build the Order List
                      _buildOrderList(),
                      SizedBox(height: 16),
                      // Include the RevenueSectionSmall widget here
              if (!ResponsiveWidget.isSmallScreen(context))  RevenueSectionLarge() else  RevenueSectionSmall(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              _showAddOrderModal(context);
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

List<Order> filterOrdersByDate(List<Order> orders, String targetDate) {
  return orders.where((order) {
    // Extract the date part from the order's date string
    String orderDate = order.date.split(',')[0].trim();
    // Compare only the date part
    return orderDate == targetDate;
  }).toList();
}

void _handleNewOrder(Order newOrder) {
    // Update the state to trigger a rebuild
    setState(() {
      orderList.add(newOrder);
    });
  }
void _navigateToProductsPage(BuildContext context) {
  Navigator.of(context).pushNamed(productsPageRoute);
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
  

  Widget _buildOrderList() {
    // Filter orders for today's date
String today = "1/3/2024, 8:39:11 AM" ;
 List<Order> todayOrders = filterOrdersByDate(orderList, today);

  // Calculate the sum of total amount for today's orders
  double totalAmountToday = todayOrders.fold(
      0, (previousValue, order) => previousValue + order.totalAmount);
    return Table(
      border: TableBorder.all(),
      columnWidths: {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey[200]),
          children: [
            _buildTableHeaderItem('Location'),
            _buildTableHeaderItem('Date'),
            _buildTableHeaderItem('Total Amount'),
            _buildTableHeaderItem('isPaid'),
            
            SizedBox(), // Adjust as needed
          ],
        ),
        for (final order in orderList)
          TableRow(
            children: [
              _buildTableCell(order.location),
              _buildTableCell(order.date),
              _buildTableCell(order.totalAmount.toString()),
              _buildTableCell(order.isPaid),
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


 class RevenueSectionLarge extends StatelessWidget {
  const RevenueSectionLarge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
              offset: const Offset(0, 6),
              color: lightGrey.withOpacity(.1),
              blurRadius: 12)
        ],
        border: Border.all(color: lightGrey, width: .5),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const CustomText(
                  text: "Quiz Chart",
                  size: 20,
                  weight: FontWeight.bold,
                  color: lightGrey,
                ),
                SizedBox(
                  width: 600,
                  height: 200,
                  child: SimpleBarChart.withSampleData(),
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: 120,
            color: lightGrey,
          ),
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    // Update the number of completed quizzes dynamically
                    RevenueInfo(
                      title: "Orders made",
                      amount: "220",
                    ),
                    RevenueInfo(
                      title: "Order Not delivered",
                      amount: "14", // Static value, update if needed
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    RevenueInfo(
                      title: "Orders above 500TND ",
                      amount: "10", // Static value, update if needed
                    ),
                    RevenueInfo(
                      title: "Quiz below 500",
                      amount: "210", // Static value, update if needed
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
 }