

import 'package:flutter/material.dart';

class FiltroPage extends StatefulWidget{
  static const ROUTE_NAME = '/filtro';

  @override
  _FiltroPageState createState() => _FiltroPageState();
}

class _FiltroPageState extends State<FiltroPage>{

  bool _alterouValores = false;

  @override
  Widget build(BuildContext context){
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Filtros'),
          ),
          body: Container(),
        ) ,
        onWillPop: _onVoltarClick,
    );
  }

  Future<bool> _onVoltarClick() async{
    Navigator.of(context).pop(_alterouValores);
    return true;
  }
}