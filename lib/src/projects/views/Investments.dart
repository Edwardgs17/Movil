import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:colfunding/utils/Session.dart';
import 'package:colfunding/src/projects/controllers/InvestmentsController.dart';

class Investments extends StatefulWidget {
  final List<dynamic> investmentsDetailData;
  final List<dynamic> rewardsData;

  Investments({this.investmentsDetailData, this.rewardsData});

  @override
  _InvestmentsState createState() => _InvestmentsState(
      investmentsDetailData: this.investmentsDetailData,
      rewardsData: this.rewardsData);
}

class _InvestmentsState extends State<Investments> {
  List<dynamic> investmentsDetail = new List();
  List<dynamic> investmentsDetailData;
  List<dynamic> rewardsData;

  InvestmentsController investmentsController;

  Session session;
  Map reward;

  bool neverInv;
  String pesos = "\$";

  _InvestmentsState({this.investmentsDetailData, this.rewardsData}) {
    this.session = new Session();
    this.investmentsController = InvestmentsController();

    // neverInv = !(investdata.length < 0);
  }
  Future getInvestmentsByProject() async {
    print('ALLx==>$investmentsDetailData');

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getInvestmentsByProject();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.green,
          title: Text('Inversores', 
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w300,
            )
          ),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.attach_money), onPressed: null)
          ],
        ),
        body: ListView.builder(
          itemCount:
              investmentsDetailData == null ? 0 : investmentsDetailData.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              color: Colors.green[100],
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: <Widget>[
                    ExpansionTile(
                      title: null,
                      leading: Container(
                        width: 300.0,
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.attach_money,
                              color: Colors.green,
                              size: 35.0,
                            ),
                            SizedBox(width: 5),
                            CircleAvatar(
                              backgroundImage:
                                  AssetImage("assets/anonymus.jpg"),
                            ),
                            SizedBox(width: 15),
                            Flexible(
                              child: Text(
                                "${investmentsDetailData[index]["nameUser"]}",
                                style: TextStyle(
                                    fontSize: 16.0, fontWeight: FontWeight.w500),
                              ),
                            )
                          ],
                        ),
                      ),      
                    
                    children: <Widget>[
                    Card(
                      color: Colors.green[50],
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          width: 300.0,
                          height: 60.0,
                          child: Center(
                            child: SingleChildScrollView(
                              child: Column(children: <Widget>[
                                Row(
                                  children: <Widget>[
                                  Text(
                                    "$pesos ${investmentsDetailData[index]["rewards"]["price"]}",
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.green),
                                  ),
                                  SizedBox(
                                    width: 20.0,
                                  ),
                                  Text(
                                    "${investmentsDetailData[index]["created_at"].split('T')[0]}",
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.blue),
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(
                                    "${investmentsDetailData[index]["created_at"].split('T')[1].split('.')[0]}",
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.blue),
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 23.0,
                                  ),
                                ]),
                              ]),
                            ),
                          ),
                          color: Colors.green[50],
                        ),
                      ),
                    ),
                  ]),
                 ]),
              ),
            );
          },
        )
      ),
    );
  }
}
