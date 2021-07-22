import 'package:crud/pages/update.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Slist extends StatefulWidget {
  @override
  _SlistState createState() => _SlistState();
}

class _SlistState extends State<Slist> {
  final Stream<QuerySnapshot> stuStream =
      FirebaseFirestore.instance.collection('students').snapshots();

  //delete
  CollectionReference stu = FirebaseFirestore.instance.collection('students');
  Future<void> deleteUser(id) {
    //print("User Deleted $id");
    return stu.doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: stuStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print('something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final List storedocs = [];
          snapshot.data.docs.map((DocumentSnapshot document) {
            Map a = document.data() as Map<String, dynamic>;
            storedocs.add(a);
            a['id'] = document.id;
          }).toList();

          return Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Table(
                border: TableBorder.all(),
                columnWidths: const <int, TableColumnWidth>{
                  1: FixedColumnWidth(140)
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(
                    children: [
                      TableCell(
                        child: Container(
                          color: Colors.greenAccent,
                          child: Center(
                              child: Text('Name',
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold))),
                        ),
                      ),
                      TableCell(
                        child: Container(
                          color: Colors.greenAccent,
                          child: Center(
                              child: Text('Email',
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold))),
                        ),
                      ),
                      TableCell(
                        child: Container(
                          color: Colors.greenAccent,
                          child: Center(
                              child: Text('Action',
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold))),
                        ),
                      ),
                    ],
                  ),
                  for (var i = 0; i < storedocs.length; i++) ...[
                    TableRow(children: [
                      TableCell(
                        child: Container(
                          child: Center(
                              child: Text(storedocs[i]['name'],
                                  style: TextStyle(
                                      fontSize: 11.0,
                                      fontWeight: FontWeight.bold))),
                        ),
                      ),
                      TableCell(
                        child: Container(
                          child: Center(
                              child: Text(storedocs[i]['email'],
                                  style: TextStyle(
                                      fontSize: 11.0,
                                      fontWeight: FontWeight.bold))),
                        ),
                      ),
                      TableCell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.orange,
                                ),
                                onPressed: () => {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              Update(id: storedocs[i]['id']),
                                        ),
                                      )
                                    }),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () => {deleteUser(storedocs[i]['id'])},
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ] //loop
                ],
              ),
            ),
          );
        });
  }
}
