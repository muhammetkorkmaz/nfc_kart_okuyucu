
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Models/BakiyeModel.dart';
import 'package:flutter_app/Models/IslemModel.dart';
import 'package:flutter_app/Models/KartModel.dart';
import 'package:flutter_app/Models/TarifeModel.dart';
import 'package:flutter_app/Services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'Services.dart';
import 'package:flutter_app/NFC.dart';
import 'package:barcode_scan/barcode_scan.dart';

class LocalNotifications extends StatefulWidget {
  @override
  _LocalNotificationsState createState() => _LocalNotificationsState();
}
class _LocalNotificationsState extends State<LocalNotifications> {
  //ıos android ayarları oluşturuluyor, bildirim nesne oluşturuluyor
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings;
  IOSInitializationSettings iosInitializationSettings;
  InitializationSettings initializationSettings;
  List<IslemModel> _islemler;
  TextEditingController _bakiyetextEditingController;
  String _kart_id;
  String result;

  @override
  void initState() {
    super.initState();
    initializing();
    _islemler=[];
    _bakiyetextEditingController=TextEditingController();
    _kart_id="";
    result="Deneme";
  }
  //ıos android ayarları
  void initializing() async{
    androidInitializationSettings=AndroidInitializationSettings("icon_flutter");
    iosInitializationSettings=IOSInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initializationSettings= InitializationSettings(androidInitializationSettings,iosInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,onSelectNotification:onSelectNotification);
  }
  //gelen parametreler ile bildirim gönderiyor.
  void _showNotifications(String title,String body) async{
    await notification(title,body);
  }
  //android için bildirim içeriği oluşturuluyor.
  Future<void> notification(String title,String body) async{
    AndroidNotificationDetails androidNotificationDetails= AndroidNotificationDetails(
      "Channel ID",
      "Channel title",
      "Channel body",
      priority: Priority.High,
      importance: Importance.Max,
      ticker: "test"
    );
    //bildirim detaylarını gönderiyoruz
    IOSNotificationDetails iosNotificationDetails=IOSNotificationDetails();
    NotificationDetails notificationDetails=NotificationDetails(androidNotificationDetails,iosNotificationDetails);
    await flutterLocalNotificationsPlugin.show(0, title, body , notificationDetails);
  }
  //bildirime tıklandığında mesaj iletiyor.
  Future onSelectNotification(String payload){
    if(payload!=null){
      print(payload);
    }
  }
  //bildirim için widget oluşturuyor.
  Future onDidReceiveLocalNotification(int id,String title,String body,String payload) async{
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(body),
      actions: <Widget>[
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: (){
            //print("hh");
          },
          child: Text("Okay")),
    ],);
  }

  _get_islemler(String kart_id){
    Services.get_islemler(kart_id).then((islemler){
      setState(() {
        _islemler=islemler;
      });
    });
  }

  _updateBakiye(String kart_id)async{
    KartModel kart=await Services.get_kart(kart_id);
    BakiyeModel bakiyeModel=await Services.get_bakiye(kart.kart_bakiye_id);
    TarifeModel tarifeModel=await Services.get_tarife(kart.kart_tarife_id);
    if(kart.kart_id=="error" || bakiyeModel.bakiye_id=="error" || tarifeModel.tarife_id=="error")
      _showNotifications("HATA", "Kart tanımlanmadı");
    else{
      if(bakiyeModel.bakiye>=tarifeModel.tarife_ucret)
        {
          bakiyeModel.bakiye-=tarifeModel.tarife_ucret;
          Services.update_Bakiye(bakiyeModel.bakiye_id, bakiyeModel.bakiye.toString()).then((result){
            if(result=="success"){
              //_showSnackBar(context, "Bakiye güncellendi");
              String message=kart.kart_sahip+" yeni bakiyeniz:"+bakiyeModel.bakiye.toString()+" TL";
              _showNotifications("İşlem tamamlandı", message);
              Services.add_islem(kart_id, "Gecis", (-1)*tarifeModel.tarife_ucret, DateTime.now());
            }
            else{
              //_showSnackBar(context, "Hata");
              _showNotifications("Hata", "Kartı tekrar okutunuz");
            }
            _bakiyetextEditingController.text=null;
          });
        }
      else{
        String message="Bakiyeniz: "+bakiyeModel.bakiye.toString();
        _showNotifications("Bakiye yetersiz", message);
      }
    }
  }

  _loadmoney(String kart_id,double money) async{
    KartModel kart=await Services.get_kart(kart_id);
    BakiyeModel bakiyeModel=await Services.get_bakiye(kart.kart_bakiye_id);
    if(kart.kart_id=="error" || bakiyeModel.bakiye_id=="error" )
      _showNotifications("HATA", "Kart tanımlanmadı");
    else{
      bakiyeModel.bakiye+=money;
      Services.update_Bakiye(bakiyeModel.bakiye_id, bakiyeModel.bakiye.toString()).then((result){
        if(result=="success"){
          //_showSnackBar(context, "Bakiye güncellendi");
          String message=kart.kart_sahip+" yeni bakiyeniz:"+bakiyeModel.bakiye.toString()+" TL";
          _showNotifications("İşlem tamamlandı", message);
          Services.add_islem(kart_id, "Yukleme", money, DateTime.now());
        }
        else{
          //_showSnackBar(context, "Hata");
          _showNotifications("Hata", "Kartı tekrar okutunuz");
        }
        _bakiyetextEditingController.text=null;
      });
    }
  }

  String _get_kart_id(){
    FlutterNfcReader.onTagDiscovered().listen((onData) {
      if(onData.nfcId!=null){
        //_showNotifications("Kart okundu", "Kartı çekin");
        return onData.nfcId;
      }
      else{
        //_showNotifications("Kart okunmadı", "Kartı tekrar okutun");
        return "error";
      }
    });
}

  Future<double> _get_bakiye(String kart_id) async{
    KartModel kart=await Services.get_kart(kart_id);
    BakiyeModel bakiyeModel=await Services.get_bakiye(kart.kart_bakiye_id);
    if(bakiyeModel.bakiye_id=="error")
      return -1;
    else
      return bakiyeModel.bakiye;
  }

  Future<void> _scanQR() async{
    try{
      var qrResult= await BarcodeScanner.scan();
      double bakiye=await _get_bakiye(qrResult.rawContent);
      if(bakiye==-1){
        _showNotifications("HATA", "Kart bulunamadı");
      }
      else{
        String message="Bakiyeniz: "+bakiye.toString()+ " TL";
        _showNotifications("Kart Okundu", message);
        _kart_id=qrResult.rawContent;
      }
    }
    on PlatformException catch(ex){
      if(ex.code==BarcodeScanner.cameraAccessDenied){
        _showNotifications("HATA", "Kamera iznini açınız");
      }
      else{
        _showNotifications("HATA", "Bilinmeyen hata $ex");
      }
    }
    on FormatException catch(ex){
      _showNotifications("HATA", "Okumadan önce bekleyin");
    }
    catch(ex){
      _showNotifications("HATA", "Bilinmeyen hata $ex");
    }
  }

  SingleChildScrollView _databody(){
    return SingleChildScrollView(

      padding: EdgeInsets.only(top: 20),
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(columns: [
          DataColumn(
            label: Text("İşlem"),
          ),
          DataColumn(
              label: Text("Değişim")
          ),
          DataColumn(
              label: Text("Tarih")
          ),
        ],
            rows: _islemler.map((islem) => DataRow(
          cells: [
            DataCell(Text(islem.islem_tip)),
            DataCell(Text(islem.islem_para.toString())),
            DataCell(Text(islem.get_islem_zaman()))
          ]
        )
        ).toList()
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Kart Okuyucu",
            style: TextStyle(
              fontSize: 30.0,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
          actions: <Widget>[
            new IconButton(icon: new Icon(Icons.nfc),iconSize: 40, onPressed: () async{
              _kart_id=await _get_kart_id();
              if(_kart_id=="error"){
                _showNotifications("HATA", "Kart okunmadı");
              }
              else{
                double bakiye=await _get_bakiye(_kart_id);
                if(bakiye==-1)
                  _showNotifications("Hata", "Bağlantı hatası");
                else{
                  String message="Bakiyeniz: "+bakiye.toString()+" TL";
                  _showNotifications("Kart okundu", message);
                }
              }
            }),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              FlatButton(onPressed: () async{
                  if(_kart_id==""){
                    _showNotifications("HATA", "Kartı okutun");
                  }
                  else{
                    _updateBakiye(_kart_id);
                  }
              }, child: Text("Bakiye Düş",
                style:TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
                color: Colors.blue,
                textColor: Colors.white,
                //splashColor: Colors.purpleAccent,
                highlightColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(color: Colors.black,width: 2.0)
                ),
              ),
              FlatButton(onPressed: (){
                if(_kart_id==""){
                  _showNotifications("HATA", "Kartı okutun");
                }
                else{
                  _get_islemler(_kart_id);
                }
              }, 
                  child: Text("İşlemler",
                    style:TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                color: Colors.blue,
                textColor: Colors.lime[600],
                highlightColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(color: Colors.black,width: 2.0)
                ),
              ),
              FlatButton(onPressed: () async{
                if(_bakiyetextEditingController.text==""){
                  _showNotifications("HATA", "Bakiye giriniz");
                }
                else{
                  try{
                    double.parse(_bakiyetextEditingController.text);
                    _loadmoney(_kart_id, double.parse(_bakiyetextEditingController.text));
                  }
                  catch(e){
                    _showNotifications("HATA", "Bakiye hatalı girildi.");
                  }
                }
              }, child: Text("Bakiye yükle",
                  style:TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
                  color: Colors.blue,
                  textColor: Colors.white,
                  highlightColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(color: Colors.black,width: 2.0)
                ),
              ),
              TextField(
                controller: _bakiyetextEditingController,
                decoration: InputDecoration(
                    hintText: 'Bakiye giriniz',
                    labelText: "Bakiye",
                    labelStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    border: OutlineInputBorder()
                ),
                keyboardType: TextInputType.number,
              ),
              _databody()
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.camera_alt),
          label: Text("QR"),
          onPressed: _scanQR,
        ),
      ),
    );
  }
}
