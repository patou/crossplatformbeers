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

  MasterDetail({@required this.beersRepository})
      : assert(beersRepository != null);

  @override
  _MasterDetailState createState() => _MasterDetailState();
}

class _MasterDetailState extends State<MasterDetail> {
  Beer selectedBeer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SplitView(
      children: [
        MasterRoute(
          beersRepository: widget.beersRepository,
          onTapped: (selectedBeer) {
            setState(() {
              this.selectedBeer = selectedBeer;
            });
          },
        ),
        this.selectedBeer != null ? DetailRoute(beer: selectedBeer) : Home(),
      ],
      /*indicator: SplitIndicator(viewMode: SplitViewMode.Vertical),
      activeIndicator: SplitIndicator(
        viewMode: SplitViewMode.Vertical,
        color: theme.primaryColor,
        isActive: true,
      ),*/
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
    );
  }
}
