import 'dart:convert';
import 'package:flutter_app/Models/BakiyeModel.dart';
import 'package:flutter_app/Models/InformationModel.dart';
import 'package:flutter_app/Models/IslemModel.dart';
import 'package:flutter_app/Models/KartModel.dart';
import 'package:flutter_app/Models/TarifeModel.dart';
import 'package:http/http.dart' as http;

class Services{
  //bağlantı için local ip adresi
  static const ROOT="http://192.168.43.63/dashboard/myfolder/conn.php";
  //statik işlem tipleri
  static const get_all_kart_action='get_all_kart';
  static const get_one_kart_action='get_one_kart';
  static const update_bakiye_action='update_bakiye';
  static const get_tarife_action='get_tarife';
  static const get_bakiye_action='get_bakiye';
  static const get_all_gecisler_action='get_all_gecisler';
  static const get_all_informations_action='get_all_informations';
  static const get_islemler_action='get_islemler';
  static const add_islem_action='add_islem';

  //kullanıcı adlarını,bakiyeleri,tarifeleri joinleyip getiren fonksiyon
  static Future<List<InformationModel>> get_informations() async{
    try{
      var map=Map<String,dynamic>();
      map['action']=get_all_informations_action;
      final response=await http.post(ROOT,body:map);
      //print("get_informations response: ${response.body}");
      if(200==response.statusCode){
        List<InformationModel> list=parseResponseInformations(response.body);
        return list;
      }
      else{
        return List<InformationModel>();
      }
    }
    catch(e){
      return List<InformationModel>();
    }
  }
  //belirli bir kartın bütün işlemlerini getirir
  static Future<List<IslemModel>> get_islemler(String islem_kart_id) async{
    try{
      var map=Map<String,dynamic>();
      map['action']=get_islemler_action;
      map['Islem_kart_id']=islem_kart_id;
      final response=await http.post(ROOT,body: map);
      //print("get_islemler response: ${response.body}");
      if(200==response.statusCode){
        List<IslemModel> islemler=parseResponseIslem(response.body);
        return islemler;
      }
      else{
        return List<IslemModel>();
      }
    }
    catch(e) {
      return List<IslemModel>();
    }
  }
  //belirli bir karta yeni işlem ekler
  static Future<String> add_islem(String islem_kart_id,String islem_tip,double islem_para,DateTime islem_zaman) async{
    try{
      var map=Map<String,dynamic>();
      map['action']=add_islem_action;
      map['Islem_kart_id']=islem_kart_id;
      map['Islem_tip']=islem_tip;
      map['Islem_para']=islem_para.toString();
      map['Islem_zaman']=islem_zaman.toString();
      final response=await http.post(ROOT,body: map);
      //print("add_islem response: ${response.body}");
      if(200==response.statusCode){
        return response.body;
      }
      else{
        return "error";
      }
    }
    catch(e) {
      return "error";
    }
  }
  //databasedeki bütün kartları getirir.
  static Future<List<KartModel>> get_all_karts() async{
    try
    {
      var map=Map<String,dynamic>();
      map['action']=get_all_kart_action;
      final response=await http.post(ROOT,body:map);
      //print("get_karts response: ${response.body}");
      if(200==response.statusCode){
        List<KartModel> list=parseResponseKart(response.body);
        return list;
      }
      else{
        return List<KartModel>();
      }
    }
    catch(e)
    {
      return List<KartModel>();
    }
  }
  //idsi verilen bir kartı getirir.
  static Future<KartModel> get_kart(String kart_id) async{
    try{
      var map=Map<String,dynamic>();
      map['action']=get_one_kart_action;
      map['Kart_id']=kart_id;
      final response=await http.post(ROOT,body: map);
      //print("get_one response: ${response.body}");
      if(200==response.statusCode){
        List<KartModel> kart=parseResponseKart(response.body);
        return kart.first;
      }
      else{
        return KartModel("error","error","error","error");
      }
    }
    catch(e) {
      return KartModel("error","error","error","error");
    }
  }
  //gelen json bilgisini kart modeline çevirir
  static List<KartModel> parseResponseKart(String responseBody){
      final parsed=json.decode(responseBody).cast<Map<String,dynamic>>();
      return parsed.map<KartModel>((json)=>KartModel.fromJson(json)).toList();
  }
  //gelen json bilgisini tarife modeline çevirir
  static List<TarifeModel> parseResponseTarife(String responseBody){
    final parsed=json.decode(responseBody).cast<Map<String,dynamic>>();
    return parsed.map<TarifeModel>((json)=>TarifeModel.fromJson(json)).toList();
  }
  //gelen json bilgisini bakiye modeline çevirir
  static List<BakiyeModel> parseResponseBakiye(String responseBody){
    final parsed=json.decode(responseBody).cast<Map<String,dynamic>>();
    return parsed.map<BakiyeModel>((json)=>BakiyeModel.fromJson(json)).toList();
  }
  //gelen json bilgisini işlem modeline çevirir
  static List<IslemModel> parseResponseIslem(String responseBody){
    final parsed=json.decode(responseBody).cast<Map<String,dynamic>>();
    return parsed.map<IslemModel>((json)=>IslemModel.fromJson(json)).toList();
  }
  //gelen json bilgisini information modeline çevirir
  static List<InformationModel> parseResponseInformations(String responseBody){
  final parsed=json.decode(responseBody).cast<Map<String,dynamic>>();
  return parsed.map<InformationModel>((json)=>InformationModel.fromJson(json)).toList();
  }
  //idsi verilen kartın bakiyesini ve bakiye id getirir.
  static Future<BakiyeModel> get_bakiye(String bakiye_id) async{
    try{
    var map=Map<String,dynamic>();
    map['action']=get_bakiye_action;
    map['Bakiye_id']=bakiye_id;
    final response=await http.post(ROOT,body: map);
    //print("get_bakiye response: ${response.body}");
    if(200==response.statusCode){
      List<BakiyeModel> bakiyeler=parseResponseBakiye(response.body);
      return bakiyeler.first;
    }
    else{
      return BakiyeModel("error",0);
    }
  }
  catch(e){
      return BakiyeModel("error",0);
  }
  }
  //kartın bakiye bilgisini günceller.
  static Future<String> update_Bakiye(String bakiye_id,String bakiye) async{
    try
    {
      var map=Map<String,dynamic>();
      map['action']=update_bakiye_action;
      map['Bakiye_id']=bakiye_id;
      map['Bakiye']=bakiye;
      final response=await http.post(ROOT,body:map);
      //print("update_Bakiye response: ${response.body}");
      if(200==response.statusCode){
        return response.body;
      }
      else{
        return 'error';
      }
    }
    catch(e)
    {
      return 'error';
    }
  }
  //idsi bilinen bir tarifeyi getirir.
  static Future<TarifeModel> get_tarife(String tarife_id) async{
    try{
      var map=Map<String,dynamic>();
      map['action']=get_tarife_action;
      map['Tarife_id']=tarife_id;
      final response=await http.post(ROOT,body: map);
      //print("get_tarife response: ${response.body}");
      if(200==response.statusCode){
        List<TarifeModel> kart=parseResponseTarife(response.body);
        return kart.first;
      }
      else{
        return TarifeModel("error","error",0);
      }
    }
    catch(e){
      return TarifeModel("error","error",0);
    }
  }
}
