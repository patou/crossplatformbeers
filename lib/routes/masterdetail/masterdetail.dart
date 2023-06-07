import 'package:crossplatformbeers/models/beer.dart';
import 'package:crossplatformbeers/repositories/beer_repository.dart';
import 'package:crossplatformbeers/routes/detail/detail_route.dart';
import 'package:crossplatformbeers/routes/master/master_route.dart';
import 'package:flutter/material.dart';
import 'package:split_view/split_view.dart';

import 'home.dart';

class MasterDetail extends StatefulWidget {
  static const routeName = '/';

  final BeersRepository beersRepository;

  const MasterDetail({super.key, required this.beersRepository});

  @override
  MasterDetailState createState() => MasterDetailState();
}

class MasterDetailState extends State<MasterDetail> {
  Beer? selectedBeer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SplitView(
      controller: SplitViewController(
        weights: [0.3, 0.7],
        limits: [
          WeightLimit(min: 0.2, max: 0.4),
          WeightLimit(min: 0.6, max: 0.8)
        ],
      ),
      viewMode: SplitViewMode.Horizontal,
      gripColor: theme.primaryColor,
      gripSize: 8,
      gripColorActive: theme.secondaryHeaderColor,
      children: [
        MasterRoute(
          beersRepository: widget.beersRepository,
          onTapped: (selectedBeer) {
            setState(() {
              this.selectedBeer = selectedBeer;
            });
          },
        ),
        selectedBeer != null ? DetailRoute(beer: selectedBeer!) : const Home(),
      ],
    );
  }
}
