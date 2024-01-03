import 'package:flutter/material.dart';
import 'package:quiz_backoffice/api/productapi.dart';
import 'package:quiz_backoffice/model/Product.dart';
import 'package:quiz_backoffice/routing/routes.dart';

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late List<Product> productList = [];

  @override
  void initState() {
    super.initState();
    fetchProductData();
  }

  Future<void> fetchProductData() async {
    try {
      final productService = produitService();
      final fetchedProductList = await productService.fetchProducts();

      setState(() {
        productList = fetchedProductList;
      });
    } catch (error) {
      // Handle error appropriately, e.g., show an error message
      print('Error fetching product data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (productList == null) {
      // Show loading indicator or some other placeholder while data is being fetched
      return CircularProgressIndicator();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Product List',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Card(
              elevation: 5,
              child: _buildProductList(),
            ),
          ],
        ),
      ),
       floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              //_showAddProdcutModal(context);
            },
            child: Icon(Icons.add),
          ),
          SizedBox(width: 16),
          FloatingActionButton(
            onPressed: () {
              _navigateToOrdersPage(context);
            },
            child: Icon(Icons.shopping_cart),
          ),
          ],
      ),
    );
  }

  void _navigateToOrdersPage(BuildContext context) {
  Navigator.of(context).pushNamed(orderssPageRoute);
}
  Widget _buildProductList() {
    return Table(
      border: TableBorder.all(),
      columnWidths: {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1),
        4: FlexColumnWidth(2),
        5: FlexColumnWidth(1),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey[200]),
          children: [
            _buildTableHeaderItem('Name'),
            _buildTableHeaderItem('Category'),
            _buildTableHeaderItem('Description'),
            _buildTableHeaderItem('Price'),
             _buildTableHeaderItem('Image'),

            SizedBox(), // Adjust as needed
          ],
        ),
        for (final product in productList)
          TableRow(
            children: [
              _buildTableCell(product.name),
              _buildTableCell(product.category),
              _buildTableCell(product.description),
               Image.network(
                product.image,
                height: 50,
                errorBuilder: (BuildContext context, Object error,
                    StackTrace? stackTrace) {
                  // Image failed to load, show person icon
                  return Icon(Icons.person, color: Colors.blue);
                },
              ),
              _buildTableCell(product.price.toString()),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () async {
                      await _showEditProductModal(context, product);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                     //_deleteProduct(product);
                    },
                  ),
                ],
              ),
            ],
          ),
      ],
    );
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
Future<void> _showEditProductModal(
      BuildContext context, Product product) async {
    TextEditingController nameController =
        TextEditingController(text: product.name);
    TextEditingController categoryController =
        TextEditingController(text: product.category);
    TextEditingController descriptionController =
        TextEditingController(text: product.description);
    TextEditingController priceController =
        TextEditingController(text: product.price.toString());

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Product'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextFormField(
                  controller: categoryController,
                  decoration: InputDecoration(labelText: 'Category'),
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                TextFormField(
                  controller: priceController,
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
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
                // Update the product
                Product updatedProduct = Product(
                  id: product.id,
                  name: nameController.text,
                  category: categoryController.text,
                  description: descriptionController.text,
                  price: double.parse(priceController.text),
                  image: product.image, // Pass the existing image value
                );

                try {
                  await produitService().updateProduct(
                    product.id,
                    updatedProduct,
                  );
                  // Refresh the product list after updating
                  fetchProductData();
                  Navigator.pop(context);
                } catch (error) {
                  // Handle error, e.g., show an error message
                  print('Error updating product: $error');
                }
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  }

  




