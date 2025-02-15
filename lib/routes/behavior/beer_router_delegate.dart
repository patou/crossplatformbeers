import 'package:crossplatformbeers/models/beer.dart';
import 'package:crossplatformbeers/repositories/beer_repository.dart';
import 'package:crossplatformbeers/routes/masterdetail/masterdetail.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../detail/detail_route.dart';
import '../master/master_route.dart';
import '../unknown/unknown_route.dart';
import 'beer_route_path.dart';
import 'beer_router_animation.dart';

class BeerRouterDelegate extends RouterDelegate<BeerRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<BeerRoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  TransitionDelegate<dynamic> transitionDelegate = (kIsWeb
      ? NoAnimationTransitionDelegate()
      : const DefaultTransitionDelegate<dynamic>()) as TransitionDelegate;

  Beer? _selectedBeer;
  bool show404 = false;

  BeerRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  @override
  BeerRoutePath get currentConfiguration {
    if (show404) {
      return BeerRoutePath.unknown();
    }
    return _selectedBeer == null
        ? BeerRoutePath.home()
        : BeerRoutePath.details(_selectedBeer!.id);
  }

  void _handleBeerTapped(Beer beer) {
    _selectedBeer = beer;
    notifyListeners();
  }

  MaterialPage<dynamic> constraintPages() {
    BeersRepository beersRepository = BeersRepository(
      client: http.Client(),
    );

    if (kIsWeb) {
      return MaterialPage(
          key: const ValueKey(MasterRoute.routeName),
          child: MasterRoute(
              beersRepository: beersRepository, onTapped: _handleBeerTapped));
    }

    return MaterialPage(
        key: const ValueKey(MasterRoute.routeName),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 768) {
              return MasterDetail(beersRepository: beersRepository);
            } else {
              return MasterRoute(
                beersRepository: beersRepository,
                onTapped: _handleBeerTapped,
              );
            }
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      transitionDelegate: transitionDelegate,
      pages: [
        constraintPages(),
        if (show404)
          const MaterialPage(
              key: ValueKey('UnknownPage'), child: UnknownRoute())
        else if (_selectedBeer != null)
          MaterialPage(
              key: const ValueKey(DetailRoute.routeName),
              child: DetailRoute(beer: _selectedBeer!))
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        // Update the list of pages by setting _selectedBeer to null
        _selectedBeer = null;
        show404 = false;
        notifyListeners();

        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(BeerRoutePath configuration) async {
    if (configuration.isUnknown) {
      _selectedBeer = null;
      show404 = true;
      return;
    }
    if (configuration.isDetailsPage) {
      // Trivial check, i know....
      if (configuration.id! < 0 || configuration.id! > 80) {
        show404 = true;
        return;
      }

      var beersRepository = BeersRepository(
        client: http.Client(),
      );
      var beers = await beersRepository.getBeers();
      _selectedBeer = beers.firstWhere((beer) => beer.id == configuration.id);
    } else {
      _selectedBeer = null;
    }

    show404 = false;
  }
}
