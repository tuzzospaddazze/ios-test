import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'certificatopagina.dart';
import 'downloadservice.dart';

class ModuloCertificato extends StatefulWidget{

  @override
  State<StatefulWidget> createState() =>ModuloCertificatoStato();
}
class ModuloCertificatoStato extends State<ModuloCertificato>{


  final String url = 'https://docs.google.com/spreadsheets/d/1CAdI5EvbXaXIX71rIijuxNKXQqnMcbfuiuBtbGp1O0Y/export?format=pdf&fitw=true&size=a4';
  Future<void> _downloadFile() async {
    DownloadService downloadService =
    kIsWeb ? WebDownloadService() : MobileDownloadService();
    await downloadService.download(url: url);
  }
  final formKey = GlobalKey<FormState>();
  DateTime datascelta = DateTime.now();
  late TextEditingController nomeecognome;
  late TextEditingController codicefiscale;
  late TextEditingController citta;
  late TextEditingController provincia;

  int indicecorso = 0;
  final List<String> tipocorso = [
    'BLS-D/PBLS-D',
    'ADDETTO AL PRIMO SOCCORSO AZIENDALE',
    'PHTC Esecutore'
  ];
  final List<String> dettaglicorso1 = [
    'Corso di Formazione Rianimazione Cardiopolmonare di Base',
    '',
    'Corso di PREHOSPITAL TRAUMA CARE'
  ];
  final List<String> dettaglicorso2 = [
    'per Adulto, Bambino e Lattante e Defibrillazione Precoce AED',
    'ai sensi dell’art 37 comma 9 del D.Lgs. 81/08 e s.m.i. D.M. 388/03 e s.m.i., Gruppo B Medio Rischio',
    'Tecniche per la gestione, la valutazione e il trattamento del politraumatizzato'
  ];
  final List<String> dettaglicorso3 = [
    'ai sensi di: Legge 120 del 03/04/2001, DM 18/03/2011',
    '',
    ''
  ];
  final List<String> titolocorso = [
    'OPERATORE BLS-D/PBLS-D',
    'ADDETTO AL PRIMO SOCCORSO AZIENDALE',
    'ESECUTORE PHTC'
  ];
  final List<String> immaginecorso = [
    '=image("https://drive.google.com/uc?export=download&id=1lsXrhDTQZ3aD7z3x2jQM98GSF3NKM2ac")',
    '=image("https://drive.google.com/uc?export=download&id=1lsXrhDTQZ3aD7z3x2jQM98GSF3NKM2ac")',
    '=image("https://drive.google.com/uc?export=download&id=1lsXrhDTQZ3aD7z3x2jQM98GSF3NKM2ac")'
  ];
  @override
  void initState() {
    super.initState();
    inizializzaCampi();
  }
  void inizializzaCampi(){
    nomeecognome = TextEditingController();
    codicefiscale = TextEditingController();
    citta = TextEditingController();
    provincia = TextEditingController();
  }
  @override

  Widget build(BuildContext context) =>
      Form( key: formKey,
        child: Column(
          children: [
          tipoCertificatoCampo(),
          spazio(),
          riga(nomecognomeCampo()),
          spazio(),
          riga(codicefiscaleCampo()),
          spazio(),
          riga(luogo()),
          spazio(),
          riga(spaziodata()),
          spazio(),
          bottoneConferma(),
      ],
    ),
  );

  Widget tipoCertificatoCampo() => Row(
    children: [Expanded(child: Text('Corso: ',textAlign: TextAlign.right,),),

  Expanded( child:TextButton(style: ButtonStyle(alignment: Alignment.centerLeft), onPressed: () {setState(() {
    if (indicecorso <= tipocorso.length-2){
      indicecorso++;
    } else {indicecorso = 0;}
  });},
    child: Text(tipocorso[indicecorso])
  ))]);

  Widget nomecognomeCampo() => TextFormField(
    controller: nomeecognome,
    decoration: InputDecoration(
      labelText: 'Nome e cognome',
      border: OutlineInputBorder(),
      ),
      validator: (value) => value != null && value.isEmpty ? 'Inserire nome e cognome' : null,
    );

  Widget codicefiscaleCampo() => TextFormField(
    inputFormatters: [LengthLimitingTextInputFormatter(16)],
    controller: codicefiscale,
    decoration: InputDecoration(
      labelText: 'Codice fiscale',
      border: OutlineInputBorder(),
    ),
    validator: (value) => value != null && value.isEmpty ? 'Inserire codice fiscale' : null,
  );

  Widget luogo() => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Expanded(flex: 5, child:TextFormField(
        controller: citta,
        decoration: InputDecoration(
          labelText: 'Città',
          border: OutlineInputBorder(),
        ),
        validator: (value) => value != null && value.isEmpty ? 'Inserire una città' : null,
      ),),
      spazioorizzontale(),
      Expanded(
          child:TextFormField(

        inputFormatters: [LengthLimitingTextInputFormatter(2)],
        controller: provincia,
        decoration: InputDecoration(
          labelText: 'Provincia',
          border: OutlineInputBorder(),
        ),
        validator: (value) => value != null && value.isEmpty ? 'Inserire una provincia' : null,
      )),
    ],
  );
  Widget spazio() => Container(height: 20);
  Widget spazioorizzontale() => Container(width: 20);
  Widget spaziodata() => Row(
    children: [Expanded(child: Text('Data di conseguimento: ',textAlign: TextAlign.right,),),

      Expanded( child:
  TextButton(
    style: ButtonStyle(alignment: Alignment.centerLeft),
  onPressed: () async {
  DateTime? dataselezione = await scegliData();
  if (dataselezione == null) {return;};
  setState(() => datascelta = dataselezione);
},
child: Text(textAlign: TextAlign.left, datascelta.day.toString()+'/'+datascelta.month.toString()+'/'+datascelta.year.toString())),
  )

    ]);


  Future scegliData() => showDatePicker(initialEntryMode: DatePickerEntryMode.calendar, context: context, initialDate: DateTime.now(), firstDate: DateTime.utc(2000), lastDate: DateTime.utc(2050));

  Widget riga(Widget contenuto)  => Row(
            children: [
            spazioorizzontale(),
            Expanded(child: contenuto),
            spazioorizzontale()]);

  Widget bottoneConferma() => ElevatedButton(
    onPressed: () async {
      final form = formKey.currentState!;
      final valido = form.validate();
      String cittadefinitiva = citta.text.toUpperCase();
      String datadefinitiva = datascelta.day.toString()+'/'+datascelta.month.toString()+'/'+datascelta.year.toString();
      String svoltosi = 'svoltosi il '+datadefinitiva+' a '+cittadefinitiva+' ('+provincia.text.toUpperCase()+')';
      String datainbasso = 'lì '+datadefinitiva;
      final List<String> dati = [
        tipocorso[indicecorso],
        nomeecognome.text.toUpperCase(),
        codicefiscale.text.toUpperCase(),
        svoltosi,
        cittadefinitiva,
        datainbasso,
        dettaglicorso1[indicecorso],
        dettaglicorso2[indicecorso],
        dettaglicorso3[indicecorso],
        immaginecorso[indicecorso],
        titolocorso[indicecorso]
      ];
      if (valido) {
      _downloadFile();
      await SpreadsheetApi.inserisci(dati);
      }
    },
    child: Text('Crea certificato'),
  );

}