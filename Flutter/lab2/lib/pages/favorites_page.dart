import 'package:lab2/entities/city_entity.dart';
import 'package:lab2/handlers/firebase_app_data_handler.dart';
import 'package:lab2/widgets/custom_menu_bar.dart';
import 'package:flutter/material.dart';
import 'city_page.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  Widget _buildFavoritesListWidget() {
    return FutureBuilder(
      future: FirebaseAppDataHandler.getFavorites(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const Text('Loading data, wait.');
          default:
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return _displayFavoritesList(context, snapshot);
            }
        }
      },
    );
  }

  Widget _displayFavoritesList(BuildContext context, AsyncSnapshot snapshot) {
    List<CityEntity> values = snapshot.data;
    if (values.isEmpty) {
      return const Text('No data. Add something.');
    }
    return ListView.builder(
      itemCount: values.length,
      padding: EdgeInsets.zero,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: <Widget>[
            Container(
              alignment: const AlignmentDirectional(0, 0),
              color: Theme.of(context).colorScheme.primaryContainer,
              child: ListTile(
                title: Text(
                  values[index].name ?? 'No Data',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_right,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  size: 20,
                ),
                onTap: () async {
                  String? refresh = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CityPage(cityEntity: values[index])));
                  setState(() {});
                },
                contentPadding:
                const EdgeInsetsDirectional.fromSTEB(5, 20, 5, 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomMenuBar(currentIndex: 0),
      body: _buildFavoritesListWidget(),
    );
  }
}
