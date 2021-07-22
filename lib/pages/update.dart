import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Update extends StatefulWidget {
  final String id;
  const Update({Key key, this.id}) : super(key: key);
  @override
  _UpdateState createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  final _formkey = GlobalKey<FormState>();

//update
  CollectionReference stu = FirebaseFirestore.instance.collection('students');

  Future<void> update(id, name, email, password) {
    return stu
        .doc(id)
        .update({'name': name, 'email': email, 'password': password});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Students'),
      ),
      body: Form(
          key: _formkey,
          child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: FirebaseFirestore.instance
                .collection('students')
                .doc(widget.id)
                .get(),
            builder: (_, snapshot) {
              if (snapshot.hasError) {
                print('something went wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              var data = snapshot.data.data();
              var name = data['name'];
              var email = data['email'];
              var password = data['password'];

              return Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                child: ListView(
                  children: [
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: TextFormField(
                        initialValue: name,
                        autofocus: false,
                        onChanged: (value) {},
                        decoration: InputDecoration(
                          labelText: 'Name',
                          labelStyle:
                              TextStyle(color: Colors.blueAccent, fontSize: 15),
                          border: OutlineInputBorder(),
                          errorStyle:
                              TextStyle(color: Colors.redAccent, fontSize: 15),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter name';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: TextFormField(
                        autofocus: false,
                        initialValue: email,
                        onChanged: (value) {},
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle:
                              TextStyle(color: Colors.blueAccent, fontSize: 15),
                          border: OutlineInputBorder(),
                          errorStyle:
                              TextStyle(color: Colors.redAccent, fontSize: 15),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter email';
                          } else if (!value.contains('@')) {
                            return 'Please enter valid email';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: TextFormField(
                        autofocus: false,
                        obscureText: true,
                        initialValue: password,
                        onChanged: (value) {},
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle:
                              TextStyle(color: Colors.blueAccent, fontSize: 15),
                          border: OutlineInputBorder(),
                          errorStyle:
                              TextStyle(color: Colors.redAccent, fontSize: 15),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter password';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                if (_formkey.currentState.validate()) {
                                  update(widget.id, name, email, password);
                                  Navigator.pop(context);
                                }
                              },
                              child: Text(
                                'Register',
                                style: TextStyle(fontSize: 18),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          )),
    );
  }
}
