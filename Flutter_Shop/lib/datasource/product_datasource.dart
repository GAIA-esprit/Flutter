
import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/model/Product.dart';



class ProductDTS extends DataTableSource {
  final List<Product> products;
  final BuildContext context ;

  ProductDTS({
    required this.products,
    required this.context,
  });

  @override
  DataRow getRow(int index) {
    final product = products[index];

    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(product.name)),
        DataCell(Text(product.price.toString())),
        DataCell(Text(product.description)),
        DataCell(Text(product.category)),
        DataCell(Text(product.image)),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.edit_outlined),
                onPressed: () {
                  showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (_) => ChambreModal(
                      chambre: chambre,
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  color: Colors.red.withOpacity(0.8),
                ),
                onPressed: () {
                  final dialog = AlertDialog(
                    title: Text('Do you want to delete this room?'),
                    content: Text('Delete ${chambre.roomName} permanently?'),
                    actions: [
                      TextButton(
                        child: Text('No'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text('Yes, delete'),
                        onPressed: () {
                          Provider.of<ChambreProvider>(context, listen: false)
                              .deleteChambre(chambre.id);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );

                  showDialog(context: context, builder: (_) => dialog);
                },
              )
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => chambres.length;

  @override
  int get selectedRowCount => 0;
}
