import 'package:flutter/material.dart';
import 'package:flutter_sqflite/utils/database_helper.dart';

import 'models/contact.dart';
const darkBlueColor = Color(0xff486579);

void main() => runApp(MaterialApp(
  home: HomePage(),
));

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // les variables
  Contact _contact= Contact();
  List<Contact> _contacts = [];
  DatabaseHelper _dbHelper;
  final _formKey = GlobalKey<FormState>();
  final _ctrlName = TextEditingController();
  final _ctrlEmail = TextEditingController();

   @override
  void initState() {
    // TODO: implement initState
      super.initState();
      setState(() {
        _dbHelper = DatabaseHelper.instance;
        _refreshContactList();
      });
  }
  _refreshContactList() async {
    List<Contact> x = await _dbHelper.fetchContacts();
    setState(() {
      _contacts = x;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: (AppBar(
       backgroundColor: darkBlueColor,
        title: Text('sqflite CRUD',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
        elevation: 10
      )),
      body:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             _form(),
             _list(),
          ],
        ),
      ),
    ));
  }

  _form() => Container(
    color: Colors.white,
    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
    child: Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _ctrlName,
            decoration: InputDecoration(labelText: 'name'),
            validator: (val) =>
            (val.length == 0 ? 'ce champs est requis' : null),
             onSaved: (val)=> setState(() =>_contact.name = val),
              ),
          TextFormField(
            controller: _ctrlEmail,
            decoration: InputDecoration(labelText: 'email'),
            validator: (val) =>
            val.length < 10 ? 'au moins 10 characters required' : null,
            onSaved: (val)=> setState(() =>_contact.email = val),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: RaisedButton(
              onPressed: () {_onSubmit();},
              child: Text('Submit'),
              color: darkBlueColor,
              textColor: Colors.white,
            ),
          ),
        ],
      ),
    ),
  );

  _list() =>Expanded(
    child: Card(
      margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
      child: Scrollbar(
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemBuilder: (context, index) {
            return Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(
                    Icons.account_circle,
                    color: darkBlueColor,
                    size: 40.0,
                  ),
                  trailing: IconButton(
                      icon: Icon(Icons.delete_sweep, color: darkBlueColor),
                      onPressed: () async {
                        await _dbHelper.deleteContact(_contacts[index].id);
                        _resetForm();
                        _refreshContactList();
                      }),
                  title: Text(
                    _contacts[index].name.toUpperCase(),
                    style: TextStyle(
                        color: darkBlueColor, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(_contacts[index].email),
                  onTap: () {
                    setState(() {
                      _contact = _contacts[index];
                      _ctrlName.text =_contacts[index].name;
                      _ctrlEmail.text =_contacts[index].email;

                    });
                  },

                ),
                Divider(
                  height: 5.0,
                ),
              ],
            );
          },
          itemCount: _contacts.length,
        ),
      ),
    ),
  );

  _onSubmit() async {
    var form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      if(_contact.id == null){
        await _dbHelper.insertContact(_contact);
      }
      else{
        await _dbHelper.updateContact(_contact);
        _refreshContactList();
        _resetForm();
      }


    }
  }
  _resetForm(){
    setState(() {
      _formKey.currentState.reset();
      _ctrlName.clear();
      _ctrlEmail.clear();
      _contact.id = null;
    });
  }
}
