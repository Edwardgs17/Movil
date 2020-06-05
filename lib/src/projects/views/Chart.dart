import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colfunding/src/projects/models/month_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  final int idProject;

  HomePage({this.idProject});

  @override
  _HomePageState createState() => _HomePageState(idProject: this.idProject);
}

class _HomePageState extends State<HomePage> {
  PageController _controller;

  int currentPage ;
  Stream<QuerySnapshot> _query;
  int idProject;

  _HomePageState({this.idProject});

  @override
  void initState() {
    super.initState();

    DateTime now = DateTime.now();
    String m = DateFormat('M').format(now);
    int month = int.parse(m);
    currentPage = month - 1;
    print(currentPage);
    _query = Firestore.instance
        .collection('expenses')
        .where("month", isEqualTo: currentPage + 1)
        .where("idProject", isEqualTo: idProject)
        .snapshots();

    _controller = PageController(
      initialPage: currentPage,
      viewportFraction: 0.4,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Estadistica",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w300,
          ),
          overflow: TextOverflow.fade,
        ),
        backgroundColor: Colors.green,
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Container(
      child: Column(
        children: <Widget>[
          _selector(),
          StreamBuilder<QuerySnapshot>(
            stream: _query,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> data) {
              if (data.hasData) {
                return MonthWidget(
                  documents: data.data.documents,
                );
              }

              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _pageItem(String name, int position) {
    var _alignment;
    final selected = TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      color: Colors.blueGrey,
    );
    final unselected = TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.normal,
      color: Colors.blueGrey.withOpacity(0.4),
    );

    if (position == currentPage) {
      _alignment = Alignment.center;
    } else if (position > currentPage) {
      _alignment = Alignment.centerRight;
    } else {
      _alignment = Alignment.centerLeft;
    }

    return Align(
      alignment: _alignment,
      child: Text(
        name,
        style: position == currentPage ? selected : unselected,
      ),
    );
  }

  Widget _selector() {
    return SizedBox.fromSize(
      size: Size.fromHeight(70.0),
      child: PageView(
        onPageChanged: (newPage) {
          setState(() {
            currentPage = newPage;
            _query = Firestore.instance
                .collection('expenses')
                .where("month", isEqualTo: currentPage + 1)
                .where("idProject", isEqualTo: idProject)
                .snapshots();
          });
        },
        controller: _controller,
        children: <Widget>[
          _pageItem("Enero", 0),
          _pageItem("Febrero", 1),
          _pageItem("Marzo", 2),
          _pageItem("Abril", 3),
          _pageItem("Mayo", 4),
          _pageItem("Junio", 5),
          _pageItem("Julio", 6),
          _pageItem("Agosto", 7),
          _pageItem("Septiembre", 8),
          _pageItem("Octubre", 9),
          _pageItem("Noviembre", 10),
          _pageItem("Diciembre", 11),
        ],
      ),
    );
  }
}
