import 'package:lab2/entities/city_entity.dart';
import 'package:lab2/handlers/firebase_app_data_handler.dart';
import 'package:lab2/widgets/custom_menu_bar.dart';
import 'package:flutter/material.dart';
import 'city_page.dart';

class UserMainPage extends StatefulWidget {
  const UserMainPage({super.key});

  @override
  State<UserMainPage> createState() => _UserMainPageState();
}

class _UserMainPageState extends State<UserMainPage> {
  Widget _buildCitiesListWidget() {
    return FutureBuilder(
      future: FirebaseAppDataHandler.getAllCities(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const Text('Loading data, wait.');
          default:
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return _displayCitiesList(context, snapshot);
            }
        }
      },
    );
  }

  Widget _displayCitiesList(BuildContext context, AsyncSnapshot snapshot) {
    List<CityEntity> values = snapshot.data;
    if (values.isEmpty) {
      return const Text('No data. Add something.');
    }
    return ListView.separated(
      itemCount: values.length,
      padding: EdgeInsets.zero,
      itemBuilder: (BuildContext context, int index) {
        return IntrinsicHeight(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            alignment: const AlignmentDirectional(0, 0),
            child: ListTile(
              title: Text(
                values[index].name ?? 'No Data',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              subtitle: Text(
                values[index].country ?? 'No Data',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              trailing: Icon(
                Icons.arrow_right,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                size: 20,
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CityPage(cityEntity: values[index])));
              },
              contentPadding:
              const EdgeInsetsDirectional.fromSTEB(5, 20, 5, 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(height: 10);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomMenuBar(currentIndex: 0),
      body: _buildCitiesListWidget(),
    );
  }
}
