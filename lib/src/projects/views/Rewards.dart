import 'package:colfunding/src/payments/providers/PaymentsProviders.dart';
import 'package:colfunding/src/projects/controllers/SeeProjectController.dart';
import 'package:colfunding/utils/PhotoView.dart';
import 'package:colfunding/utils/Session.dart';
import 'package:colfunding/utils/Token.dart';
import 'package:colfunding/src/projects/controllers/RewardsController.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:progress_dialog/progress_dialog.dart';

class Rewards extends StatefulWidget {
  final List<dynamic> rewardsDetailData;
  final bool isUser;
  final int idProject;

  Rewards({this.rewardsDetailData, this.isUser, this.idProject});

  @override
  _RewardsState createState() => _RewardsState(
      rewardsDetailData: this.rewardsDetailData, isUser: this.isUser, idProject: this.idProject);
}

class _RewardsState extends State<Rewards> {
  List<dynamic> rewardsDetailData;
  Session session;
  Token token;
  String pesos = "\$";
  final bool isUser;
  bool isActivate;
  PaymentsProviders paymentsProviders;
  RewardsController rewardsController;
  ProgressDialog progressDialog;
  int idProject;
  SeeProjectController seeProjectController;

  _RewardsState({this.rewardsDetailData, this.isUser, this.idProject}) {
    isActivate = false;
    session = Session();
    token = new Token();
    rewardsController    = RewardsController();
    seeProjectController = SeeProjectController();
    paymentsProviders    = PaymentsProviders();
    print('infooo : $rewardsDetailData');
    token.getString('process').then((fl) {
      setState(() {
        isActivate = fl == 'Aprobado';
      });
    });

    token.getNumber('idProject').then((id) {
      idProject = id;
    });
  }

  void progress() {
    progressDialog = new ProgressDialog(context);
    progressDialog.style(
      message: 'Iniciando metodo de pago',
      borderRadius: 15.0,
      backgroundColor: Colors.black,
      progressWidget: CircularProgressIndicator(),
      elevation: 20.0,
      insetAnimCurve: Curves.easeInOut,
      progress: 0.0,
      maxProgress: 100.0,
      progressTextStyle: TextStyle(
          color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.w600),
    );
  }

  Color myColorGrey = Color(0xfff2f5f8),
      myColorBlue = Colors.blue[800],
      lightText = Color(0xff8891a4);

  @override
  void initState() {
    super.initState();
  }

  TextStyle titleTextStyle = TextStyle(
    color: Colors.grey,
    fontSize: 20.0,
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                seeProjectController.getProjectDatails(
                    context, idProject, isUser);
              }),
          centerTitle: true,
          title: Text('Recompensas',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w300,
              )),
          backgroundColor: Colors.green,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: _rewards(),
        ),
        backgroundColor: Colors.white,
        floatingActionButton: isUser
            ? FloatingActionButton.extended(
                onPressed: () {
                  Navigator.pushNamed(context, 'CreateReward');
                },
                label: Text('Crear Recompensa'),
                icon: Icon(Icons.card_giftcard),
                backgroundColor: Colors.green,
              )
            : null,
      ),
    );
  }

  Future getRewards() async {
    await session.renovate();
    List<dynamic> data =
        await rewardsController.getRewardsByIdProjects(this.idProject);
    print('list rewards');

    if (!mounted) return;

    setState(() {
      rewardsDetailData = data;
    });

    return rewardsDetailData;
  }

  Widget _rewards() {
    return RefreshIndicator(
      onRefresh: getRewards,
      child: ListView.builder(
        itemCount: rewardsDetailData == null ? 0 : rewardsDetailData.length,
        itemBuilder: (context, index) =>
            _card(context, rewardsDetailData[index]),
      )
    );
  }

  Widget _card(BuildContext context, dynamic rewards) {

    IconData iconTypeReward;

    switch (rewards["nameTypeRewards"]) {
      case 'Especie':
        iconTypeReward = Icons.layers;
        break;
      case 'Efectivo':
        iconTypeReward = Icons.monetization_on;
        break;
      default:
        iconTypeReward = Icons.loop;
        break;
    }

    return Card(
      elevation: 7.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              _createImage(rewards["imagesReward"]),
              Padding(
                padding: EdgeInsets.only(top: 0.0, left: 16.0, right: 16.0, bottom: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      child: ExpandablePanel(
                        theme: ExpandableThemeData(
                          headerAlignment: ExpandablePanelHeaderAlignment.center
                        ),
                        header: Text(
                          'Descripción',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                            
                        collapsed: Text(
                          "${rewards["description"]}",
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                          ),
                          softWrap: true,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        expanded: Text(
                          "${rewards["description"]}",
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                          ),
                          softWrap: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      iconTypeReward,
                      color: Colors.green,
                    ),
                    SizedBox(
                      width: 6.0,
                    ),
                    Text(
                      '${rewards["nameTypeRewards"]}',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 17,
                      ),
                    ),
                    Spacer(),

                    Text(
                      r'$',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                        fontSize: 20
                      ),
                    ),
                    SizedBox(
                      width: 2.0,
                    ),
                    Text(
                      '${rewards["price"]}',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.only(right: 16.0, bottom: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    RaisedButton(
                      padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 0.0, bottom: 0.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            "CONSEGUIR",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Container(
                            padding: EdgeInsets.all(3.0),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.green,
                              size: 16.0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4.0)
                            ),
                          ),
                        ],
                      ),
                      
                      color: Colors.green,
                      textColor: Colors.white,
                      onPressed: isActivate
                        ? () async {
                          token.setNumber(
                              'priceRewards', rewards['price']);
                          progress();
                          progressDialog.show();
                          Map user = await session.getInformation();
                          print({
                            'idUser': user['id'],
                            'idRewards': rewards['id'],
                            'price': rewards['price'],
                            'name': 'inversion',
                            'total': rewards['price'],
                            'description': rewards['description']
                          });
                          paymentsProviders.pay({
                            'idUser': user['id'],
                            'idRewards': rewards['id'],
                            'price': rewards['price'],
                            'name': 'inversion',
                            'total': rewards['price'],
                            'description': rewards['description']
                          }).then((url) {
                            token.setString('url', url);
                            token.setNumber(
                              'idReward', rewards['id']
                            );
                            Future.delayed(Duration(seconds: 3)).then((value) {
                              progressDialog.hide().whenComplete(() {
                                print(url);
                                Navigator.pushReplacementNamed(
                                    context, 'Payments');
                              });
                            });
                          });
                        }
                      : null
                    ),
                  ],
                ),
              ),
            
          ],
        ),
          // Positioned(
          //   top: 170,
          //   left: 275.0,
          //   child: RaisedButton(
          //     padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 0.0, bottom: 0.0),
          //     child: Row(
          //       mainAxisSize: MainAxisSize.min,
          //       children: <Widget>[
          //         Text(
          //           "CONSEGUIR",
          //           style: TextStyle(
          //             color: Colors.white,
          //             fontSize: 14.0,
          //             fontWeight: FontWeight.bold
          //           ),
          //         ),
          //         SizedBox(
          //           width: 5.0,
          //         ),
          //         Container(
          //           padding: EdgeInsets.all(3.0),
          //           child: Icon(
          //             Icons.arrow_forward_ios,
          //             color: Colors.green,
          //             size: 16.0,
          //           ),
          //           decoration: BoxDecoration(
          //             color: Colors.white,
          //             borderRadius: BorderRadius.circular(4.0)
          //           ),
          //         ),
          //       ],
          //     ),
              
          //     color: Colors.green,
          //     textColor: Colors.white,
          //     onPressed: !isActivate
          //       ? () async {
          //         token.setNumber(
          //             'priceRewards', rewards['price']);
          //         progress();
          //         progressDialog.show();
          //         Map user = await session.getInformation();
          //         print({
          //           'idUser': user['id'],
          //           'idRewards': rewards['id'],
          //           'price': rewards['price'],
          //           'name': 'inversion',
          //           'total': rewards['price'],
          //           'description': rewards['description']
          //         });
          //         paymentsProviders.pay({
          //           'idUser': user['id'],
          //           'idRewards': rewards['id'],
          //           'price': rewards['price'],
          //           'name': 'inversion',
          //           'total': rewards['price'],
          //           'description': rewards['description']
          //         }).then((url) {
          //           token.setString('url', url);
          //           token.setNumber(
          //             'idReward', rewards['id']
          //           );
          //           Future.delayed(Duration(seconds: 3)).then((value) {
          //             progressDialog.hide().whenComplete(() {
          //               print(url);
          //               Navigator.pushReplacementNamed(
          //                   context, 'Payments');
          //             });
          //           });
          //         });
          //       }
          //     : null
          //   ),
            // ButtonTheme(
            //   minWidth: 40,
            //   child: RaisedButton(
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(8.0),
            //     ),
            //     child: Icon(
            //       Icons.add_shopping_cart,
            //       color: Colors.white,
            //       size: 25.0,
            //     ),
            //     color: Colors.purple[400],
            //     textColor: Colors.white,
            //     onPressed: !isActivate
            //       ? () async {
            //         token.setNumber(
            //             'priceRewards', rewards['price']);
            //         progress();
            //         progressDialog.show();
            //         Map user = await session.getInformation();
            //         print({
            //           'idUser': user['id'],
            //           'idRewards': rewards['id'],
            //           'price': rewards['price'],
            //           'name': 'inversion',
            //           'total': rewards['price'],
            //           'description': rewards['description']
            //         });
            //         paymentsProviders.pay({
            //           'idUser': user['id'],
            //           'idRewards': rewards['id'],
            //           'price': rewards['price'],
            //           'name': 'inversion',
            //           'total': rewards['price'],
            //           'description': rewards['description']
            //         }).then((url) {
            //           token.setString('url', url);
            //           token.setNumber(
            //             'idReward', rewards['id']
            //           );
            //           Future.delayed(Duration(seconds: 3)).then((value) {
            //             progressDialog.hide().whenComplete(() {
            //               print(url);
            //               Navigator.pushReplacementNamed(
            //                   context, 'Payments');
            //             });
            //           });
            //         });
            //       }
            //     : null
            //   )

              
        // )
            // ),
          // )
        ],
      ),
    ); 
  }

  Widget _cardTipo1(BuildContext context, dynamic rewards) {
    final card = Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0)),
            child: _createImage(rewards["imagesReward"]),
          ),
          ListTile(
            contentPadding: EdgeInsets.only(top: 10.0),
            title: _titleSection(rewards),
          ),
        ],
      ),
    );
    return Container(
      margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0, bottom: 10.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
          border: Border.all(
            width: 0.1,
            style: BorderStyle.solid,
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black26,
                blurRadius: 5.0,
                spreadRadius: 2.0,
                offset: Offset(2.0, 10.0))
          ]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: card,
      ),
    );
  }

  Widget _titleSection(dynamic rewards) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.description,
                          color: Colors.grey[400],
                        ),
                        SizedBox(
                          width: 6.0,
                        ),
                        Flexible(
                          child: Text(
                            '${rewards["description"]}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.monetization_on,
                          color: Colors.green,
                        ),
                        SizedBox(
                          width: 6.0,
                        ),
                        Flexible(
                          child: Text(
                            '${rewards["price"]}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.payment,
                          color: Colors.green,
                        ),
                        SizedBox(
                          width: 6.0,
                        ),
                        Text(
                          '${rewards["nameTypeRewards"]}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      // ButtonTheme(
                      //     height: 38.0,
                      //     minWidth: 80.0,
                      //     child: RaisedButton(
                      //         shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(8.0),
                      //         ),
                      //         child: Text(
                      //           'Consiguelo',
                      //           style: TextStyle(
                      //               fontSize: 17, fontWeight: FontWeight.bold),
                      //         ),
                      //         color: Colors.green,
                      //         textColor: Colors.white,
                      //         onPressed: !isActivate
                      //             ? () async {
                      //                 token.setNumber(
                      //                     'priceRewards', rewards['price']);
                      //                 progress();
                      //                 progressDialog.show();
                      //                 Map user = await session.getInformation();
                      //                 print({
                      //                   'idUser': user['id'],
                      //                   'idRewards': rewards['id'],
                      //                   'price': rewards['price'],
                      //                   'name': 'inversion',
                      //                   'total': rewards['price'],
                      //                   'description': rewards['description']
                      //                 });
                      //                 paymentsProviders.pay({
                      //                   'idUser': user['id'],
                      //                   'idRewards': rewards['id'],
                      //                   'price': rewards['price'],
                      //                   'name': 'inversion',
                      //                   'total': rewards['price'],
                      //                   'description': rewards['description']
                      //                 }).then((url) {
                      //                   token.setString('url', url);
                      //                   token.setNumber(
                      //                       'idReward', rewards['id']);

                      //                   Future.delayed(Duration(seconds: 3))
                      //                       .then((value) {
                      //                     progressDialog
                      //                         .hide()
                      //                         .whenComplete(() {
                      //                       print(url);
                      //                       Navigator.pushReplacementNamed(
                      //                           context, 'Payments');
                      //                     });
                      //                   });
                      //                 });
                      //               }
                      //             : null))
                    ],
                  )
                ]),
          )
        ],
      ),
    );
  }

  Widget _createImage(images) {
    return Container(
        height: 200,
        child: Swiper(
          itemCount: images == null ? 0 : images.length,
          itemBuilder: (BuildContext context, int index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: GestureDetector(
                onTap: () {
                  final route = MaterialPageRoute(builder: (context) {
                    return PhotoViewPage(images: images, tittle: 'Imagenes recompensa',);
                  });
                  Navigator.push(context, route);
                },
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/loading.gif',
                  image: images[index].toString(),
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
          viewportFraction: 0.5,
          scale: 0.8,
          // pagination: SwiperPagination(
          //   builder:  DotSwiperPaginationBuilder(
          //     color: Colors.grey.shade600,
          //     activeColor: Colors.white,
          //     size: 15.0,
          //     activeSize: 15.0
          //   )
          // ),
          control: SwiperControl(color: Colors.white),
        ));
  }
}
