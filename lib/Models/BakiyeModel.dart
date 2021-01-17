class BakiyeModel{

  String _bakiye_id;
  double _bakiye;

  //get metotları
  String get bakiye_id => _bakiye_id;
  double get bakiye => _bakiye;

  //constructor
  BakiyeModel(String id,double bakiye){
    this._bakiye_id=id;
    this._bakiye=bakiye;
  }

  //set metodu
  void set bakiye(double newbakiye){
    this._bakiye=newbakiye;
  }

  //değişkenleri map formatına çevirir
  Map<String,dynamic> toMap(){
    var map=Map<String,dynamic>();
    if(bakiye_id!=null){
      map['bakiye_id']=_bakiye_id;
    }
    map['bakiye']=_bakiye;
    return map;
  }

  //map formatından değişkenleri atama yapar
  BakiyeModel.fromMapObject(Map<String,dynamic> map){
    this._bakiye_id=map['bakiye_id'];
    this._bakiye=double.parse(map['bakiye']);
  }

  //json formatından map formatına çevirir
  factory BakiyeModel.fromJson(Map<String,dynamic> json){
      return BakiyeModel(json['Bakiye_id'] as String,double.parse(json['Bakiye'] as String));
  }
}