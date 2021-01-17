class InformationModel{
  String _inf_kullanici;
  double _inf_bakiye;
  String _inf_tarife;

  //constructor
  InformationModel(String kullanici,double bakiye,String tarife){
    this._inf_kullanici=kullanici;
    this._inf_bakiye=bakiye;
    this._inf_tarife=tarife;
  }

  //get metotları
  String get inf_kullanici => _inf_kullanici;
  double get inf_bakiye => _inf_bakiye;
  String get inf_tarife => _inf_tarife;

  //set metotları
  void set inf_kullanici(String kullanici){
    this._inf_kullanici=kullanici;
  }

  void set inf_tarife(String tarife){
    this._inf_tarife=tarife;
  }

  void set inf_bakiye(double bakiye){
    this._inf_bakiye=bakiye;
  }

  //json formatından map formatına çevirir
  factory InformationModel.fromJson(Map<String,dynamic> json){
    return InformationModel(json['Kart_kullanici'] as String,double.parse(json['Bakiye'] as String),json['Tarife_adi'] as String);
  }

}