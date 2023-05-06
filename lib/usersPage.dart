import 'package:flutter/material.dart';
import 'package:riverpod_example/model/user.dart';
import 'package:riverpod_example/db/database.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();

  late Future<List<User>> _usersList;
  late String _userName;
  bool isUpdate = false;
  int? userIdForUpdate;

  @override
  void initState() {
    super.initState();
    updateUserList();
  }

  updateUserList() {
    setState(() {
      _usersList = DBProvider.db.getusers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SQLite CRUD Demo'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: <Widget>[
          Form(
            key: _formStateKey,
            autovalidateMode: AutovalidateMode.always,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null) {
                        return 'Please Enter User Name';
                      }
                      if (value.trim() == "")
                        return "Only Space is Not Valid!!!";
                      return null;
                    },
                    onSaved: (value) {
                      _userName = value!;
                    },
                    controller: _userNameController,
                    decoration: InputDecoration(
                      focusedBorder: new UnderlineInputBorder(
                        borderSide: new BorderSide(
                            color: Colors.greenAccent,
                            width: 2,
                            style: BorderStyle.solid),
                      ),
                      labelText: "user Name",
                      icon: Icon(
                        Icons.people,
                        color: Colors.black,
                      ),
                      fillColor: Colors.white,
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  textStyle: TextStyle(color: Colors.white),
                ),
                child: Text(
                  (isUpdate ? 'UPDATE' : 'ADD'),
                ),
                onPressed: () {}/*{
                  if (isUpdate) {
                    if (_formStateKey.currentState!.validate()) {
                      _formStateKey.currentState!.save();
                      DBProvider.db
                          .updateuser(
                          User(userNameForUpdate!, _userName))
                          .then((data) {
                        setState(() {
                          isUpdate = false;
                        });
                      });
                    }
                  } else {
                    if (_formStateKey.currentState!.validate()) {
                      _formStateKey.currentState!.save();
                      DBProvider.db.insertuser(User(null, _userName));
                    }
                  }
                  _userNameController.text = '';
                  updateUserList();
                }*/,
              ),
              Padding(
                padding: EdgeInsets.all(10),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  textStyle: TextStyle(color: Colors.white),
                ),
                child: Text(
                  (isUpdate ? 'CANCEL UPDATE' : 'CLEAR'),
                ),
                onPressed: () {
                  _userNameController.text = '';
                  setState(() {
                    isUpdate = false;
                    userIdForUpdate = null; // null;
                  });
                },
              ),
            ],
          ),
          const Divider(
            height: 5.0,
          ),
          Expanded(
            child: FutureBuilder(
              future: _usersList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return generateList(snapshot.data as List<User>);
                }
                if (snapshot.data == null || (snapshot.data as List<User>).length == 0) {
                  return Text('No Data Found');
                }
                return CircularProgressIndicator();
              },
            ),
          ),
        ],
      ),
    );
  }

  SingleChildScrollView generateList(List<User> users) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text('NAME'),
            ),
            DataColumn(
              label: Text('DELETE'),
            ),
          ],
          rows: users
              .map(
                (user) => DataRow(cells: [
              DataCell(Text(user.name), onTap: () {
                setState(() {
                  isUpdate = true;
                  userIdForUpdate = user.age;
                });
                _userNameController.text = user.name;
              }),
              DataCell(
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    DBProvider.db.deleteuser(user.age);
                    updateUserList();
                  },
                ),
              ),
            ]),
          )
              .toList(),
        ),
      ),
    );
  }
}