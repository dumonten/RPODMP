import 'package:lab2/entities/city_entity.dart';
import 'package:lab2/handlers/firebase_app_data_handler.dart';
import 'package:flutter/material.dart';
import 'package:lab2/widgets/images_holder.dart';

class CityPage extends StatefulWidget {
  final CityEntity cityEntity;

  const CityPage({super.key, required this.cityEntity});

  @override
  State<CityPage> createState() => _CityPageState();
}

class _CityPageState extends State<CityPage> {
  bool _isAdding = false;
  bool _isInFavorites = false;

  @override
  void initState() {
    super.initState();
    _updateInFavoritesState();
  }

  Widget _buildCityWidget(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.max, children: [
      Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
        padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
        decoration: BoxDecoration(
          color:
              Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
              child: Text(
                widget.cityEntity.name,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontSize: 15,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
              child: Text(
                'Country: ${widget.cityEntity.country}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
              child: Text(
                'Year of foundation: ${widget.cityEntity.yearOfFoundation}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
              child: Text(
                'Description: ${widget.cityEntity.description}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ],
        ),
      ),
      ImagesHolder(images: widget.cityEntity.imageUrls),
      GestureDetector(
        onTap: () {
          _addToFavorites();
          _updateInFavoritesState();
        },
        child: Container(
          margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: _isAdding
                  ? CircularProgressIndicator(
                color: Theme.of(context).colorScheme.onPrimary,
              )
                  : Text(
                _isInFavorites
                    ? 'Remove from favorites'
                    : 'Add to favorites',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Navigator.of(context).pop(),
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          widget.cityEntity.name,
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        centerTitle: true,
      ),
      body: _buildCityWidget(context),
    );
  }

  void _addToFavorites() async {
    setState(() {
      _isAdding = true;
    });

    if (_isInFavorites) {
      await FirebaseAppDataHandler.removeFromFavorites(widget.cityEntity);
    } else {
      await FirebaseAppDataHandler.addToFavorites(widget.cityEntity);
    }

    _updateInFavoritesState();

    setState(() {
      _isAdding = false;
    });
  }

  void _updateInFavoritesState() async {
    bool isInFavorites =
        await FirebaseAppDataHandler.checkIfInFavorites(widget.cityEntity);
    setState(() {
      _isInFavorites = isInFavorites;
    });
  }
}
