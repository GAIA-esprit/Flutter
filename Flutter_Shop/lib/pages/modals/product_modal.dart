import 'dart:ffi';

import 'package:admin_dashboard/models/chambre.dart';
import 'package:admin_dashboard/providers/chambre_provider.dart';
import 'package:admin_dashboard/services/notifications_service.dart';
import 'package:admin_dashboard/ui/buttons/custom_outlined_button.dart';
import 'package:admin_dashboard/ui/inputs/custom_inputs.dart';
import 'package:admin_dashboard/ui/labels/custom_labels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/model/Product.dart';

class ProductModal extends StatefulWidget {
  final Product? product;

  const ProductModal({
    Key? key,
    this.product,
  }) : super(key: key);

  @override
  State<ProductModal> createState() => _ProductModalState();
}

class _ProductModalState extends State<ProductModal> {
  String name = '';
  double price = 0.0 ;
  String category= '';
  String description = '';
  String image = '';
  String? id;

  @override
  void initState() {
    super.initState();

    id = widget.product?.id;
    name = widget.product?.name ?? '';
    price = widget.product?.price ?? 0.0;
    description = widget.product?.description ?? '';
    category = widget.product?.category ?? '';
    image = widget.product?.image ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final productProvider =
        Provider.of<ChambreProvider>(context, listen: false);

    return Container(
      padding: EdgeInsets.all(20),
      height: 500,
      width: 300,
      decoration: _buildBoxDecoration(),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.chambre?.roomName ?? 'New Room',
                style: CustomLabels.h1.copyWith(
                  color: Colors.white,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
          Divider(
            color: Colors.white.withOpacity(0.3),
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            initialValue: widget.chambre?.roomName ?? '',
            onChanged: (value) => roomName = value,
            decoration: CustomInputs.loginInputDecoration(
              hint: 'Room Name',
              label: 'Room Name',
              icon: Icons.hotel,
            ),
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          TextFormField(
            initialValue: widget.chambre?.price.toString() ?? '',
            onChanged: (value) => price = int.tryParse(value) ?? 0,
            decoration: CustomInputs.loginInputDecoration(
              hint: 'Price',
              label: 'Price',
              icon: Icons.money,
            ),
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          TextFormField(
            initialValue: widget.chambre?.nbPlace.toString() ?? '',
            onChanged: (value) => nbPlace = int.tryParse(value) ?? 0,
            decoration: CustomInputs.loginInputDecoration(
              hint: 'Number of Places',
              label: 'Places',
              icon: Icons.hotel,
            ),
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          SwitchListTile(
            title: Text(
              'Is Booked',
              style: TextStyle(color: Colors.white),
            ),
            value: isBooked,
            onChanged: (value) {
              setState(() {
                isBooked = value;
              });
            },
          ),
          SizedBox(
            height: 5,
          ),
          TextFormField(
            initialValue: widget.chambre?.nbChambreType.toString() ?? '',
            onChanged: (value) => nbChambreType = int.tryParse(value) ?? 0,
            decoration: CustomInputs.loginInputDecoration(
              hint: 'Number of Chambre Type',
              label: 'Chambre Type',
              icon: Icons.hotel,
            ),
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.only(top: 30),
            alignment: Alignment.center,
            child: CustomOutlinedButton(
              onPressed: () async {
                try {
                  if (id == null) {
                    // Creating a new room
                    final newChambre = Chambree(
                      roomName: roomName,
                      id: '',
                      price: price,
                      nbPlace: nbPlace,
                      isBooked: isBooked,
                      nbChambreType: nbChambreType,
                    );
                    await chambreProvider.createChambre(newChambre);
                    NotificationsService.showSnackbar(
                        'Room $roomName created!');
                  } else {
                    // Updating an existing room
                    final updatedChambre = widget.chambre!.copyWith(
                      roomName: roomName,
                      price: price,
                      nbPlace: nbPlace,
                      isBooked: isBooked,
                      nbChambreType: nbChambreType,
                    );
                    await chambreProvider.updateChambre(
                      widget.chambre!.id,
                      updatedChambre,
                    );
                    NotificationsService.showSnackbar(
                        'Room $roomName updated!');
                  }

                  Navigator.of(context).pop();
                } catch (e) {
                  Navigator.of(context).pop();
                  NotificationsService.showSnackbarError(
                      'Error creating/updating room');
                }
              },
              text: 'Save',
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        color: Color(0xff0F2041),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
          ),
        ],
      );
}
