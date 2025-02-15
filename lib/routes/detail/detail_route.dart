import 'package:crossplatformbeers/models/beer.dart';
import 'package:crossplatformbeers/models/favorites.dart';
import 'package:crossplatformbeers/widgets/favorite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

class DetailRoute extends StatelessWidget {
  static const routeName = '/detail';
  final Beer beer;

  const DetailRoute({super.key, required this.beer});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            );
          },
        ),
        title: Text(beer.name),
        actions: [buildFavorite(context)],
      ),
      body: Container(
        color: theme.cardColor,
        child: SizedBox.expand(
          child: SingleChildScrollView(
            child: LayoutBuilder(builder: (context, contrains) {
              return Column(
                children: [
                  buildMainPanel(contrains, theme, context),
                  buildDetailList(context, contrains, theme, beer)
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget buildFavorite(BuildContext context) {
    return Shortcuts(
        shortcuts: {
          LogicalKeySet(LogicalKeyboardKey.keyF): const FavoriteIntent(),
        },
        child: Actions(
            actions: <Type, Action<Intent>>{
              FavoriteIntent: CallbackAction<FavoriteIntent>(
                onInvoke: (FavoriteIntent intent) async {
                  final favoritesModel =
                      Provider.of<FavoritesModel>(context, listen: false);
                  bool isInFavorite =
                      favoritesModel.isInFavorites(beer.id.toString());
                  if (isInFavorite) {
                    favoritesModel.onRemoveToFavorite(beer.id.toString());
                  } else {
                    favoritesModel.onAddToFavorite(beer.id.toString());
                  }
                  return null;
                },
              ),
            },
            child: Focus(
                autofocus: true, child: Favorite(id: beer.id.toString()))));
  }

  Widget buildMainPanel(
      BoxConstraints contrains, ThemeData theme, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: theme.primaryColorLight,
        borderRadius:
            const BorderRadiusDirectional.vertical(bottom: Radius.circular(12)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.4),
            offset: const Offset(0.0, 1.0),
            blurRadius: 6.0,
          )
        ],
      ),
      padding: const EdgeInsets.all(8.0),
      child: Flex(
        direction: contrains.maxWidth > 800 ? Axis.horizontal : Axis.vertical,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
              flex: 1,
              child: InteractiveViewer(
                minScale: 0.1,
                maxScale: 4,
                child: InkWell(
                  onTap: () async {
                    await showDialog(
                        context: context,
                        builder: (context) => ImageDialog(beer.imageURL));
                  },
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Hero(
                      tag: beer.id,
                      child: Image.network(beer.imageURL),
                    ),
                  ),
                ),
              )),
          Flexible(
            flex: 2,
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Text(
                    beer.tagline ?? '',
                    style: theme.textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "ABV",
                              maxLines: 1,
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .headlineSmall,
                            ),
                            Text(
                              beer.abv ?? '',
                              maxLines: 1,
                              style:
                                  Theme.of(context).primaryTextTheme.titleLarge,
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "IBU",
                              maxLines: 1,
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .headlineSmall,
                            ),
                            Text(
                              beer.ibu ?? '',
                              maxLines: 1,
                              style:
                                  Theme.of(context).primaryTextTheme.titleLarge,
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "OG",
                              maxLines: 1,
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .headlineSmall,
                            ),
                            Text(
                              beer.targetOg ?? '',
                              maxLines: 1,
                              style:
                                  Theme.of(context).primaryTextTheme.titleLarge,
                              softWrap: false,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDetailList(BuildContext context, BoxConstraints contrains,
      ThemeData theme, Beer beer) {
    int even = 0;
    final foodColumn = Column(
        children: beer.foodPairing
                ?.map((food) => buildSimpleText(context, food, even++ % 2 == 0))
                .toList(growable: false) ??
            []);

    bool isLarge = contrains.maxWidth > 650;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      child: AnimationLimiter(
        child: Column(
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 375),
            childAnimationBuilder: (widget) => SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: widget,
              ),
            ),
            children: <Widget>[
              // Basics
              buildHeader(context, "Description"),
              buildSimpleText(context, beer.description ?? '', false),
              Flex(
                  direction: isLarge ? Axis.horizontal : Axis.vertical,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: isLarge
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: 300,
                      child: Column(
                        children: [
                          buildHeader(context, "Basics"),
                          buildValue(context, "VOLUME", beer.volume, true),
                          buildValue(
                              context, "BOIL VOLUME", beer.boilVolume, false),
                          buildValue(context, "ABV", beer.abv, true),
                          buildValue(
                              context, "Target FG", beer.targetFg, false),
                          buildValue(context, "Target OG", beer.targetOg, true),
                          buildValue(context, "EBC", beer.ebc, false),
                          buildValue(context, "SRM", beer.srm, true),
                          buildValue(context, "PH", beer.ph, false),
                          buildValue(context, "ATTENUATION LEVEL",
                              beer.attenuationLevel, true),
                        ],
                      ),
                    ),

                    // Food pairing

                    SizedBox(
                      width: 300,
                      child: Column(
                        children: [
                          buildHeader(context, "Food pairing"),
                          foodColumn,
                        ],
                      ),
                    ),
                  ]),

              // Brewer's tips
              buildHeader(context, "BREWER'S TIPS"),
              buildSimpleText(context, beer.brewersTips, false),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context, String title) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).primaryTextTheme.headlineSmall,
      ),
    );
  }

  Widget buildSimpleText(BuildContext context, String? message, bool even) {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: even
            ? Theme.of(context).primaryColorLight
            : Theme.of(context).colorScheme.background,
      ),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Text(
        message ?? '',
        style: Theme.of(context).primaryTextTheme.bodyMedium,
      ),
    );
  }

  Widget buildValue(
      BuildContext context, String title, String? message, bool even) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: even
            ? Theme.of(context).primaryColorLight
            : Theme.of(context).colorScheme.background,
      ),
      child: Row(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: Theme.of(context).primaryTextTheme.titleMedium,
            ),
          ),
          Flexible(
            child: Container(
              alignment: Alignment.centerRight,
              child: Text(
                message ?? '',
                style: Theme.of(context).primaryTextTheme.bodyMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ImageDialog extends StatelessWidget {
  final String imageURL;

  const ImageDialog(this.imageURL, {super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: InteractiveViewer(
          minScale: 0.1, maxScale: 4, child: Image.network(imageURL)),
    );
  }
}

class FavoriteIntent extends Intent {
  const FavoriteIntent();
}
