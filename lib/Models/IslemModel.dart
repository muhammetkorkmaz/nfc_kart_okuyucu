import 'package:intl/intl.dart';

class IslemModel{
  String _islem_id;
  String _islem_kart_id;
  String _islem_tip;
  double _islem_para;
  DateTime _islem_zaman;
  //constructor
  IslemModel(String islem_id,String kart_id,String islem_tip,double islem_para,DateTime islem_zaman){
    this._islem_id=islem_id;
    this._islem_kart_id=kart_id;
    this._islem_tip=islem_tip;
    this._islem_para=islem_para;
    this._islem_zaman=islem_zaman;
  }
  //get metotları
  String get islem_id => _islem_id;
  String get islem_kart_id => _islem_kart_id;
  String get islem_tip => _islem_tip;
  double get islem_para => _islem_para;
  DateTime get islem_zaman => _islem_zaman;
  //işlem zamanı istediğimiz date formatına çevirir
  String get_islem_zaman(){
    //return new DateFormat("dd-MM-yyy").format(islem_zaman);
    return new DateFormat.yMd().add_Hm().format(islem_zaman);
  }
  //set metotları
  void set islem_kart_id(String kart_id){
    this._islem_kart_id=kart_id;
  }
  void set islem_tip(String tip){
    this._islem_tip=tip;
  }
  void set islem_para(double para){
    this._islem_para=para;
  }
  void set islem_zaman(DateTime zaman){
    this._islem_zaman=zaman;
  }
  //json formatından map formatına çevirir
  factory IslemModel.fromJson(Map<String,dynamic> json){
    return IslemModel(json['Islem_id'] as String,json['Islem_kart_id'] as String,json['Islem_tip'] as String,
        double.parse(json['Islem_para'] as String),DateTime.parse(json['Islem_zaman'] as String));
  }
}