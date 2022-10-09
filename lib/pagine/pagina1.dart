import 'package:flutter/material.dart';
import 'package:provasheet/certificatopagina.dart';
import 'package:provasheet/modulocertificato.dart';

class Pagina1 extends StatelessWidget{

  @override

  Widget build (BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('Prepara certificato'),
    ),
    body: ModuloCertificato(),
  );




}