
class KartModel{

  String _kart_id;
  String _kart_sahip;
  String _kart_bakiye_id;
  String _kart_tarife_id;

  //constructor
  KartModel(String kart_id,String kart_sahip,String kart_bakiye_id,String kart_tarife_id){
      this._kart_id=kart_id;
      this._kart_sahip=kart_sahip;
      this._kart_bakiye_id=kart_bakiye_id;
      this._kart_tarife_id=kart_tarife_id;
  }

  //get metotları
  String get kart_id => _kart_id;
  String get kart_sahip => _kart_sahip;
  String get kart_bakiye_id=> _kart_bakiye_id;
  String get kart_tarife_id=> _kart_tarife_id;

  //set metotları
  void set kart_sahip(String sahip){
    this._kart_sahip=sahip;
  }

  //değişkenleri mapa çevirme
  Map<String,dynamic> toMap(){
    var map=Map<String,dynamic>();
    if(kart_id!=null){
      map['kart_id']=_kart_id;
    }
    map['kart_sahip']=_kart_sahip;
    map['kart_bakiye_id']=_kart_bakiye_id;
    map['_kart_tarife_id']=_kart_tarife_id;
    return map;
  }

  //mapı değişkenlere atama
  KartModel.fromMapObject(Map<String,dynamic> map){
      this._kart_id=map['kart_id'];
      this._kart_sahip=map['kart_sahip'];
      this._kart_bakiye_id=map['_kart_bakiye_id'];
      this._kart_tarife_id=map['_kart_tarife_id'];
  }

  //json formatından map formatına çevirir
  factory KartModel.fromJson(Map<String,dynamic> json){
    return KartModel(json['Kart_id'] as String,json['Kart_kullanici'] as String,
        json['Kart_bakiye_id']as String,json['Kart_tarife_id']as String);
  }
}