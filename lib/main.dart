import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override

  Widget build(BuildContext context) {

    return MaterialApp(
      title:"Dinamik Ortalama Hesaplama",
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override

  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String dersAdi;
  int dersKredi = 1;
  double dersHarfDegeri = 4;
  List <Ders> TumDersler;
  static int sayac=0;
  var formKey = GlobalKey<FormState>();
   double ortalama=0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    TumDersler = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dinamik Ortalama Hesaplama",)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (formKey.currentState.validate()) {
            formKey.currentState.save();
          }
        },
        child: Icon(Icons.add),
      ),
      body: uygulamaGovdesi(),
    );
  }

  Widget uygulamaGovdesi() {
    return Container(
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[

            Expanded(
                child: Container(
              padding: EdgeInsets.fromLTRB(10, 30, 30, 0),
              color: Colors.black12,
              child: Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Ders Adı",
                          hintText: "Dersin Adını Giriniz",
                          border: OutlineInputBorder(),
                        ),
                        validator: (girilenDeger) {
                          if (girilenDeger.length > 0) {
                            return null;
                          } else
                            return "Ders Adı Boş Girilemez";
                        },

                        onSaved: (kaydedilecekDeger) {
                          dersAdi = kaydedilecekDeger;
                          setState(() {
                            TumDersler.add(
                                Ders(dersAdi, dersHarfDegeri, dersKredi));
                            ortalama=0;
                            ortalamaHesapla();

                          });
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                            child:  DropdownButton<int>(items: dersKredileriItems(),
                                value: dersKredi,
                                onChanged: (secilenKredi) {
                                  setState(() {
                                    dersKredi = secilenKredi;
                                  });
                                },
                              ),  ),
                              //   padding: EdgeInsets.symmetric(horizontal:30 , vertical:30),
                             // margin: EdgeInsets.only(top:10),
                            DropdownButton<double>(
                              items: dersHarfDegeriItems(),
                              value: dersHarfDegeri,
                              onChanged: (secilenHarf) {
                                setState(() {
                                  dersHarfDegeri = secilenHarf;
                                });
                              },
                            ),
                          ]
                      ),

                    ],
                  )),
            )),
            Container(
                height: 60,
                color: Colors.blueGrey,

                margin: EdgeInsets.symmetric(vertical: 10),
               
                child: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan( text: "ORTALAMA:",style: (TextStyle(fontSize: 24, color: Colors.black))),
                        TextSpan( text: "${ortalama.toStringAsFixed(2)}",style: (TextStyle(fontSize: 24, color: Colors.cyanAccent)))
                      ],
                    ),
                  )
                ),
            ),
            Expanded(child: Container(
                color: Colors.black26,
                child: ListView.builder(itemBuilder: _listeElemanlariniOlustur,
                  itemCount: TumDersler.length,)
            )
            )
          ],
        )
    );
  }

  List<DropdownMenuItem<int>> dersKredileriItems() {
    List<DropdownMenuItem<int>> krediler = [];
    for (int i = 1; i <= 10; i++) {
      krediler.add(DropdownMenuItem<int>(value: i, child: Text("$i Kredi"),));
    }
    return krediler;
  }

  List<DropdownMenuItem<double>> dersHarfDegeriItems() {
    List<DropdownMenuItem<double>> harfler = [];

    harfler.add(DropdownMenuItem(
      child: Text("AA", style: TextStyle(fontSize: 18),), value: 4,));
    harfler.add(DropdownMenuItem(
      child: Text("BA", style: TextStyle(fontSize: 18),), value: 3.5,));
    harfler.add(DropdownMenuItem(
      child: Text("BB", style: TextStyle(fontSize: 18),), value: 3,));
    harfler.add(DropdownMenuItem(
      child: Text("CB", style: TextStyle(fontSize: 18),), value: 2.5,));
    harfler.add(DropdownMenuItem(
      child: Text("CC", style: TextStyle(fontSize: 18),), value: 2,));
    harfler.add(DropdownMenuItem(
      child: Text("DC", style: TextStyle(fontSize: 18),), value: 1.5,));
    harfler.add(DropdownMenuItem(
      child: Text("DD", style: TextStyle(fontSize: 18),), value: 1,));
    harfler.add(DropdownMenuItem(
      child: Text("FF", style: TextStyle(fontSize: 18),), value: 0,));

    return harfler;
  }


  Widget _listeElemanlariniOlustur(BuildContext context, int index) {
   sayac++;
   debugPrint(sayac.toString());
    return Dismissible(key: Key(index.toString()),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction){
      setState(() {
        TumDersler.removeAt(sayac);
        ortalamaHesapla();
      });
    },
    child:  Card(
      child: ListTile(
        title: Text(TumDersler[index].ad),
        subtitle: Text(
            TumDersler[index].kredi.toString() + "kredi Ders Notu Değeri:" +
                TumDersler[index].harfDegeri.toString() ),
      ),
    ),
    );
  }

  void ortalamaHesapla() {
    double toplamNot=0;
    double toplamKredi=0;
     for( var oankiDers in TumDersler){
       var kredi= oankiDers.kredi;
       var harfDegeri= oankiDers.harfDegeri;
       toplamNot= toplamNot+(harfDegeri* kredi);
       toplamKredi+=kredi;

     }
     ortalama=toplamNot/toplamKredi;
  }

}

class Ders{
  String ad;
  double harfDegeri;
  int kredi;
  Ders(this.ad,this.harfDegeri,this.kredi);
}