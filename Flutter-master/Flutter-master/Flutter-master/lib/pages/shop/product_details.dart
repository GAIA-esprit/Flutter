import 'package:flutter/material.dart';
import 'package:quiz_backoffice/api/productapi.dart';
import 'package:quiz_backoffice/model/Product.dart';
import 'package:quiz_backoffice/routing/routes.dart';
import 'package:quiz_backoffice/widgets/custom_text.dart';

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

  void _deleteProduct(Product product) async {
    try {
      final productService = produitService();
      await productService.deleteProduct(product.id);

      setState(() {
        productList.removeWhere((p) => p.id == product.id);
      });

      print('Product deleted successfully');
    } catch (error) {
      print('Error deleting product: $error');
      // Optionally, you can show a user-friendly message or handle the error in another way
    }
  }

  void _handleUpdatedProduct(Product updatedProduct) {
    // Find the index of the updated product in the list
    final index =
        productList.indexWhere((product) => product.id == updatedProduct.id);

    if (index != -1) {
      // If found, update the product in the list
      setState(() {
        productList[index] = updatedProduct;
      });
    }
  }

  Future<void> _showAddProductModal(BuildContext context) async {
    final newProduct = await showDialog<Product>(
      context: context,
      builder: (BuildContext context) {
        return AddProductModal(
          onProductAdded: (newProduct) {
            // Handle the newly added product here
            _handleNewProduct(newProduct);
          },
        );
      },
    );

    // If newProduct is not null, it means a new product was added
    if (newProduct != null) {
      // Handle the new product being added
      // For example, you might want to update the product list
      _handleNewProduct(newProduct);
    }
  }

  void _handleNewProduct(Product newProduct) {
    // Update the state to trigger a rebuild
    setState(() {
      productList.add(newProduct);
    });
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
           CustomText(
              text: 'Product List',
              size: 24,
              weight: FontWeight.bold,
              color: Colors.black12, // Set your desired color
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
             _showAddProductModal(context);
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
        2: FlexColumnWidth(2),
        3: FlexColumnWidth(2),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey[200]),
          children: [
            _buildTableHeaderItem('Name'),
            _buildTableHeaderItem('Category'),
            _buildTableHeaderItem('Description'),
            _buildTableHeaderItem('Image'),
            _buildTableHeaderItem('Price'),
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
                      _deleteProduct(product);
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
}

class EditProductModal extends StatefulWidget {
  final Product initialProduct;
  final Function(Product) onProductUpdated;

  const EditProductModal({
    Key? key,
    required this.initialProduct,
    required this.onProductUpdated,
  }) : super(key: key);

  @override
  _EditProductModalState createState() => _EditProductModalState();
}

class _EditProductModalState extends State<EditProductModal> {
  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late TextEditingController _descriptionController;
  late TextEditingController _imageController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialProduct.name);
    _categoryController =
        TextEditingController(text: widget.initialProduct.category);
    _descriptionController =
        TextEditingController(text: widget.initialProduct.description);
    _imageController = TextEditingController(text: widget.initialProduct.image);
    _priceController =
        TextEditingController(text: widget.initialProduct.price.toString());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Product'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField('Name', _nameController),
            _buildTextField('Category', _categoryController),
            _buildTextField('Description', _descriptionController),
            _buildTextField('Image', _imageController),
            _buildTextField('Price', _priceController),
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
            // Create a new Product object with the updated values
            final updatedProduct = Product(
              id: widget.initialProduct.id,
              name: _nameController.text,
              category: _categoryController.text,
              description: _descriptionController.text,
              image: _imageController.text,
              price: double.parse(_priceController.text),
            );

            // Call the callback function with the updated Product
            widget.onProductUpdated(updatedProduct);

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

class AddProductModal extends StatefulWidget {
  final Function(Product) onProductAdded;

  const AddProductModal({Key? key, required this.onProductAdded})
      : super(key: key);

  @override
  _AddProductModalState createState() => _AddProductModalState();
}

class _AddProductModalState extends State<AddProductModal> {
  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late TextEditingController _descriptionController;
  late TextEditingController _imageController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _categoryController = TextEditingController();
    _descriptionController = TextEditingController();
    _imageController = TextEditingController();
    _priceController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Product'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField('Name', _nameController),
            _buildTextField('Category', _categoryController),
            _buildTextField('Description', _descriptionController),
            _buildTextField('Image', _imageController),
            _buildTextField('Price', _priceController),
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
            // Create a new Product object with the entered values
            final newProduct = Product(
              id: '', // Leave the id empty as it will be assigned by the server
              name: _nameController.text,
              category: _categoryController.text,
              description: _descriptionController.text,
              image: _imageController.text,
              price: double.parse(_priceController.text),
            );

            // Call the callback function with the new Product
            widget.onProductAdded(newProduct);

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
