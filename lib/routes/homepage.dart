import 'package:crossplatformbeers/repositories/beer_repository.dart';
import 'package:crossplatformbeers/routes/master/master_route.dart';
import 'package:crossplatformbeers/routes/masterdetail/masterdetail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatelessWidget {
  final repository = BeersRepository(
    client: http.Client(),
  );

  HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 768) {
          return MasterDetail(beersRepository: repository);
        } else {
          return MasterRoute(beersRepository: repository);
        }
      },
    );
  }
}
