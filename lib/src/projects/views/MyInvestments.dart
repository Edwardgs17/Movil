import 'package:colfunding/src/projects/controllers/MyInvestmentsController.dart';
import 'package:colfunding/utils/Session.dart';
import 'package:colfunding/utils/Sidebar.dart';
import 'package:colfunding/utils/Token.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:colfunding/utils/NavigationBloc.dart';

class MyInvestments extends StatefulWidget with NavigationStates {
  final Map user;
  final String title;

  MyInvestments({this.title, this.user});

  @override
  _MyInvestmentsState createState() =>  _MyInvestmentsState(user: this.user);
}

class _MyInvestmentsState extends State<MyInvestments> {
  List<dynamic> investmentsDetail = new List();
  MyInvestmentsController myInvestmentsController;
  ScrollController scrollController;

  Map user = {};
  Sidebar sidebar;
  int c;
  Token token;
  Session session;

  _MyInvestmentsState({this.user}) {
    print(investmentsDetail);
    session = new Session();
    c = 0;
    token = new Token();
    sidebar = Sidebar(
    page: 2
    );
  }
    Future getMyInvestments() async {
    user = await session.getInformation();
    myInvestmentsController = new MyInvestmentsController();
    await session.renovate();
    investmentsDetail = await myInvestmentsController.getInvestmentsByIdUser(context, user["id"]);
    print( user["id"]);
    print('hola');
    print(investmentsDetail);
    print('paso');

    setState(() {});

    return investmentsDetail;
  }

  @override
  void initState() {
    super.initState();

    scrollController = new ScrollController();
    getMyInvestments();
  }

  Color myColorGrey = Color(0xfff2f5f8),
      myColorBlue = Colors.blue[800],
      lightText = Color(0xff8891a4);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.enhanced_encryption, color: Colors.transparent,), 
            onPressed: null
          ),
          centerTitle: true,
          title: const Text('Mis Inversiones',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w300,
              )),
          backgroundColor: Colors.green,
        ),
        body: _investments(),
        backgroundColor: Colors.grey[200],
      ),
    );
  }

  Widget _investments() {
    return ListView.builder(
      controller: scrollController,
      itemCount: investmentsDetail.length,
      itemBuilder: (context, index) => _card(investmentsDetail[index]),

    );
  }

  Widget _card(dynamic investments) {
  final TextStyle subtitle = TextStyle(fontSize: 12.0, color: Colors.grey);
  final TextStyle label = TextStyle(fontSize: 14.0, color: Colors.grey);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Card(
         child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Text("Tu Inversion!",style: TextStyle(color: Colors.green),),
                    Text('Inversion exitosa!',style: label,),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Fecha Pago', style: label),
                        Text("Hora Pago", style: label)
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('${investments["created_at"].toString().split('T')[0]} ',style: TextStyle(color: Colors.purple)),
                        Text('${investments["created_at"].toString().split('Z')[0].split('T')[1].split('.')[0]}',style: TextStyle(color: Colors.purple))
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Nombre Proyecto", style: label,),
                            Text('${investments["title"]}'),
                          ],
                        ),
                        CircleAvatar(child: Icon(Icons.check_circle, color: Colors.white,), backgroundColor: Colors.green,)
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Compromiso social", style: label,),
                            Text("${investments["targetAudience"]}"),
                          ],
                        ),
                       Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Monto", style: label,),
                            Text("${investments["rewards"]["price"]}",style: TextStyle(color: Colors.green)),
                          ],
                       ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(5.0)
                      ),
                      child: Row(
                        children: <Widget>[
                          CircleAvatar(backgroundColor: Colors.green, child: Icon(Icons.payment, color: Colors.white,),),
                          SizedBox(width: 10.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Pago realizado con"),
                              Text("Paypal", style: subtitle,),
                            ],
                          )

                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
        ),
      ),
    );
  }
}