import 'package:colfunding/utils/Session.dart';
import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final page;
  Session session;
  Sidebar({this.page}) {
    session = new Session();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Drawer(
      child: ListView(
        children: options(context, this.page),
      ),
    ));
  }

  List<Widget> options(BuildContext context, int page) {
    switch (page) {
      case 1:
        return <Widget>[
          ListTile(
            title: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Center(
                child: Text(
                  'Opciones',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20.0,
                      color: Colors.green[800]),
                ),
              ),
            ),
            subtitle: FlatButton(
              child: Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 30),
                          child: Icon(Icons.person),
                        ),
                        Text('Iniciar Sesión'),
                      ],
                    ),
                  ],
                ),
              ),
              onPressed: () => Navigator.pushReplacementNamed(context, 'Login'),
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.only(),
            child: FlatButton(
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 30),
                          child: Icon(Icons.person_add),
                        ),
                        Text('Registrate'),
                      ],
                    ),
                  ],
                ),
              ),
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, 'Signin'),
            ),
          ),
        ];
      default:
        return <Widget>[
          UserAccountsDrawerHeader(
            currentAccountPicture: Container(
              padding: EdgeInsets.all(1.0),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage('https://www.reasonwhy.es/sites/default/files/greta_thunberg_persona_del_ano_revista_time.jpg'),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.green,
              image: DecorationImage(
                image: NetworkImage('https://s3-eu-west-1.amazonaws.com/rankia/images/valoraciones/0017/1527/Crowdlending.jpg?1413877346'),
                fit: BoxFit.fill
              ),
            ),
            
            accountName: Text('User Name', style: TextStyle(color: Colors.white),),
            accountEmail: Text('Example@gmail.com', style: TextStyle(color: Colors.white),)
          ),
          Padding(
            padding: const EdgeInsets.only(),
            child: FlatButton(
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 30),
                          child: Icon(Icons.home, color: Colors.black),
                        ),
                        Text('Inicio')
                      ],
                    ),
                  ],
                ),
              ),
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, 'SideBarLayout'),
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.only(),
            child: FlatButton(
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 30),
                          child: Icon(Icons.person, color: Colors.green),
                        ),
                        Text('Editar Perfil'),
                      ],
                    ),
                  ],
                ),
              ),
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, 'UpdateUser'),
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.only(),
            child: FlatButton(
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 30),
                          child: Icon(Icons.vpn_key, color: Colors.blue),
                        ),
                        Text('Cambiar Contraseña'),
                      ],
                    ),
                  ],
                ),
              ),
              onPressed: () =>
                Navigator.pushReplacementNamed(context, 'ChangePassword'),
            ),
          ),
          
          Divider(),
          Padding(
            padding: const EdgeInsets.only(),
            child: FlatButton(
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 30),
                          child: Icon(Icons.monetization_on, color: Colors.yellow[300]),
                        ),
                        Text('Mis Inversiones'),
                      ],
                    ),
                  ],
                ),
              ),
              onPressed: () =>
                Navigator.pushReplacementNamed(context, 'MyInvestments'),
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.only(),
            child: FlatButton(
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 30),
                          child: Icon(Icons.archive, color: Colors.amber),
                        ),
                        Text('Mis Proyectos'),
                      ],
                    ),
                  ],
                ),
              ),
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, 'MyProjects'),
            ),
          ),
          Divider(),

             Padding(
            padding: const EdgeInsets.only(),
            child: FlatButton(
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 30),
                          child: Icon(Icons.timeline, color: Colors.deepPurpleAccent,),
                        ),
                        Text('Mi Actividad'),
                      ],
                    ),
                  ],
                ),
              ),
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, 'SupportedProjects'),
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.only(),
            child: FlatButton(
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 30),
                          child: Icon(Icons.arrow_back, color: Colors.red),
                        ),
                        Text('Cerrar sesion'),
                      ],
                    ),
                  ],
                ),
              ),
              onPressed: () => session.close(context),
            ),
          ),
        ];
    }
  }
}
