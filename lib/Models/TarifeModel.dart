class TarifeModel{

  String _tarife_id;
  String _tarife_adi;
  double _tarife_ucret;

  //constructor
  TarifeModel(String tarife_id,String tarife_adi,double tarife_ucret){
    this._tarife_id=tarife_id;
    this._tarife_adi=tarife_adi;
    this._tarife_ucret=tarife_ucret;
  }

  //get metotları
  String get tarife_id =>_tarife_id;
  String get tarife_adi =>_tarife_adi;
  double get tarife_ucret =>_tarife_ucret;

  //set metotları
  void set tarife_adi(String tarife_adi){
    this._tarife_adi=tarife_adi;
  }

  void set tarife_ucret(double tarife_ucret){
    this._tarife_ucret=tarife_ucret;
  }

  //değişkenleri mapa çevirme
  Map<String,dynamic> toMap(){
    var map=Map<String,dynamic>();
    if(tarife_id!=null){
      map['Tarife_id']=_tarife_id;
    }
    map['Tarife_adi']=_tarife_adi;
    map['Tarife_ucret']=_tarife_ucret;
    return map;
  }

  //mapı değişkenlere atama
  TarifeModel.fromMapObject(Map<String,dynamic> map){
    this._tarife_id=map['Tarife_id'];
    this._tarife_adi=map['Tarife_adi'];
    this._tarife_ucret=double.parse(map['Tarife_ucret']);
  }

  //json formatından map formatına çevirir
  factory TarifeModel.fromJson(Map<String,dynamic> json){
    return TarifeModel(json['Tarife_id'] as String,json['Tarife_adi'] as String,double.parse(json['Tarife_ucret'] as String));
  }
}