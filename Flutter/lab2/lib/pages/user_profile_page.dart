import 'package:flutter/cupertino.dart';
import 'package:lab2/handlers/firebase_auth_handler.dart';
import 'package:lab2/handlers/firebase_app_data_handler.dart';
import 'package:lab2/entities/user_entity.dart';
import 'package:lab2/widgets/custom_menu_bar.dart';
import 'package:lab2/pages/login_page.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _surname = '';
  String _dateOfBirth = '';
  String _address = '';
  String _male = '';
  String _phoneNumber = '';
  String _favCity = '';
  String _favCountry = '';
  int _age = 0;

  void _redirectToLoginPage(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false);
  }

  Widget _buildProfileInfoWidget() {
    return FutureBuilder(
      future: FirebaseAppDataHandler.getUserInfo(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.none ||
            snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading user info, wait.');
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        return _displayUserInfo(context, snapshot.data!);
      },
    );
  }

  Widget _buildTextFormFieldEmail(String email) {
    return TextFormField(
      decoration: const InputDecoration(
        icon: Icon(Icons.email),
        labelText: 'Email',
      ),
      initialValue: email,
      enabled: false,
    );
  }

  Widget _buildTextFormFieldName(String name) {
    return TextFormField(
      decoration: const InputDecoration(
        icon: Icon(Icons.person),
        labelText: 'Name',
      ),
      initialValue: name,
      onSaved: (value) {
        _name = value!;
      },
    );
  }

  Widget _buildTextFormFieldSurname(String surname) {
    return TextFormField(
      decoration: const InputDecoration(
        icon: Icon(Icons.person),
        labelText: 'Surname',
      ),
      initialValue: surname,
      onSaved: (value) {
        _surname = value!;
      },
    );
  }

  Widget _buildTextFormFieldDateOfBirth(String dateOfBirth) {
    return TextFormField(
      decoration: const InputDecoration(
        icon: Icon(Icons.celebration),
        labelText: 'Date of birth',
      ),
      initialValue: dateOfBirth,
      onSaved: (value) {
        _dateOfBirth = value!;
      },
    );
  }

  Widget _buildTextFormFieldAddress(String address) {
    return TextFormField(
      decoration: const InputDecoration(
        icon: Icon(Icons.location_city_sharp),
        labelText: 'Address',
      ),
      initialValue: address,
      onSaved: (value) {
        _address = value!;
      },
    );
  }

  Widget _buildTextFormFieldMale(String male) {
    return TextFormField(
      decoration: const InputDecoration(
        icon: Icon(Icons.male),
        labelText: 'Male',
      ),
      initialValue: male,
      onSaved: (value) {
        _male = value!;
      },
    );
  }

  Widget _buildTextFormFieldAge(String age) {
    return TextFormField(
      decoration: const InputDecoration(
        icon: Icon(Icons.person),
        labelText: 'Age',
      ),
      initialValue: age,
      onSaved: (value) {
        _age = int.parse(value!);
      },
    );
  }

  Widget _buildTextFormPhoneNumber(String phoneNumber) {
    return TextFormField(
      decoration: const InputDecoration(
        icon: Icon(Icons.person),
        labelText: 'Phone Number',
      ),
      initialValue: phoneNumber,
      onSaved: (value) {
        _phoneNumber = value!;
      },
    );
  }

  Widget _buildTextFormFavCity(String favCity) {
    return TextFormField(
      decoration: const InputDecoration(
        icon: Icon(Icons.person),
        labelText: 'Favorite City',
      ),
      initialValue: favCity,
      onSaved: (value) {
        _favCity = value!;
      },
    );
  }

  Widget _buildTextFormFavCountry(String favCountry) {
    return TextFormField(
      decoration: const InputDecoration(
        icon: Icon(Icons.person),
        labelText: 'Favorite Country',
      ),
      initialValue: favCountry,
      onSaved: (value) {
        _favCountry = value!;
      },
    );
  }

  Widget _displayUserInfo(BuildContext context, UserEntity userInfo) {
    if (userInfo.toString().isEmpty) {
      return const Text(
          'The user was not found. An error has occurred. Restart the application.');
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                _buildTextFormFieldEmail(userInfo.email),
                _buildTextFormFieldName(userInfo.name),
                _buildTextFormFieldSurname(userInfo.surname),
                _buildTextFormFieldAge(userInfo.age.toString()),
                _buildTextFormFieldDateOfBirth(userInfo.dateOfBirth),
                _buildTextFormFieldAddress(userInfo.address),
                _buildTextFormFieldMale(userInfo.male),
                _buildTextFormPhoneNumber(userInfo.phoneNumber),
                _buildTextFormFavCity(userInfo.favCity),
                _buildTextFormFavCountry(userInfo.favCountry),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      await FirebaseAppDataHandler.updateUserInfo(
                          _name,
                          _surname,
                          _age,
                          _dateOfBirth,
                          _address,
                          _male,
                          _phoneNumber,
                          _favCity,
                          _favCountry); //
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Changes are saved.')),
                      );
                    }
                  },
                  child: const Text('Save changes'),
                ),
                ElevatedButton(
                  onPressed: () {
                    FirebaseAuthHandler.signOut();
                    _redirectToLoginPage(context);
                  },

                  child: const Text('Quit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomMenuBar(currentIndex: 0),
      body: _buildProfileInfoWidget(),
    );
  }
}
