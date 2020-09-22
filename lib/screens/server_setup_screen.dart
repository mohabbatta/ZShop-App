import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../api/api.dart';
import '../blocs/cart/cart_bloc.dart';
import '../blocs/products/products_bloc.dart';
import '../screens/home_screen.dart';

class ServerSetupScreen extends StatelessWidget {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ZShop')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FormBuilder(
              key: _fbKey,
              child: FormBuilderTextField(
                attribute: "ip",
                decoration: InputDecoration(labelText: "Express API Server IP"),
                autovalidate: true,
                validators: [FormBuilderValidators.IP(version: 4)],
                onChanged: (_) => _fbKey.currentState.saveAndValidate(),
              ),
            ),
            const SizedBox(height: 32),
            RaisedButton(
              onPressed: () {
                Api.serverIP = _fbKey.currentState.value['ip'];
                BlocProvider.of<ProductsCubit>(context).fetchProducts();
                BlocProvider.of<CartCubit>(context).loadCart();
                Navigator.of(context).pushNamed(HomeScreen.route);
              },
              child: Icon(Icons.arrow_forward),
              color: Colors.yellow,
            )
          ],
        ),
      ),
    );
  }
}
