<?php
#SQL kullanıcı adı, şifresi ve tablo adı
$servername="localhost";
$username="root";
$password="";
$dbname="kart";

$action=$_POST["action"];#Kullanılacak fonksiyonu seçmek için kullanılıyor.

$conn=new mysqli($servername,$username,$password,$dbname);#sql bağlantısı oluşturdu.

#işlemler tablosuna yeni bir işlem ekliyor.
if($action=="add_islem"){
    $Islem_kart_id=$_POST["Islem_kart_id"];
    $Islem_tip=$_POST["Islem_tip"];
    $Islem_para=$_POST["Islem_para"];
    $Islem_zaman=$_POST["Islem_zaman"];
    $sql="INSERT INTO islemler ( Islem_kart_id, Islem_tip, Islem_para, Islem_zaman) 
    VALUES ('$Islem_kart_id', '$Islem_tip', '$Islem_para', '$Islem_zaman')";
    $result=$conn->query($sql);
    echo "success";
    $conn->close();
    return;
}

#Kartlar tablosundaki bütün kartları getiriyor.
if($action=="get_all_kart"){
    $db_data=array();
    $sql="SELECT * FROM kartlar";
    $result=$conn->query($sql);
    if($result->num_rows>0){
        while($row=$result->fetch_assoc()){
            $db_data[]=$row;
        }
        echo json_encode($db_data);
    }
    else{
        echo "error";
    }
    $conn->close();
    return;
}

#kartlardan kullanıcı adını, bakiyelerden bakiyeyi,tarifelerden tarife adını join
if($action=="get_all_informations"){
    $db_data=array();
    $sql="SELECT kartlar.Kart_kullanici,bakiyeler.Bakiye,tarifeler.Tarife_adi FROM `kartlar`
    INNER JOIN bakiyeler ON kartlar.Kart_bakiye_id=bakiyeler.Bakiye_id 
    INNER JOIN tarifeler ON kartlar.Kart_tarife_id=tarifeler.Tarife_id";
    $result=$conn->query($sql);
    if($result->num_rows>0){
        while($row=$result->fetch_assoc()){
            $db_data[]=$row;
        }
        echo json_encode($db_data);
    }
    else{
        echo "error";
    }
    $conn->close();
    return;
}

#işlemler tablosundaki bütün işlemleri getiriyor
if($action=="get_islemler"){
    $db_data=array();
    $Islem_kart_id=$_POST["Islem_kart_id"];
    $sql="SELECT * FROM `islemler` WHERE Islem_kart_id='$Islem_kart_id'";
    $result=$conn->query($sql);
    if($result->num_rows>0){
        while($row=$result->fetch_assoc()){
            $db_data[]=$row;
        }
        echo json_encode($db_data);
    }
    else{
        echo "error";
    }
    $conn->close();
    return;
}

#idsi verilen kartı getiriyor.
if($action=="get_one_kart"){
    $db_data=array();
    $Kart_id=$_POST["Kart_id"];
    $sql="SELECT * FROM kartlar WHERE Kart_id='$Kart_id'";
    $result=$conn->query($sql);
    if($result->num_rows>0){
        while($row=$result->fetch_assoc()){
            $db_data[]=$row;
        }
        echo json_encode($db_data);
    }
    else{
        echo "error";
    }
    $conn->close();
    return;
}

#bakiye idsi verilen bakiyeyi getiriyor.
if($action=="get_bakiye"){
    $db_data=array();
    $Bakiye_id=$_POST["Bakiye_id"];
    $sql="SELECT * FROM bakiyeler WHERE Bakiye_id=$Bakiye_id";
    $result=$conn->query($sql);
    if($result->num_rows>0){
        while($row=$result->fetch_assoc()){
            $db_data[]=$row;
        }
        echo json_encode($db_data);
    }
    else{
        echo "error";
    }
    $conn->close();
    return;
}

#bakiye idsi ve bakiye bilgisi verilerek bakiye güncelleniyor.
if($action=="update_bakiye"){
    $Bakiye_id=$_POST["Bakiye_id"];
    $Bakiye=$_POST["Bakiye"];

    $sql="UPDATE bakiyeler SET Bakiye=$Bakiye WHERE Bakiye_id=$Bakiye_id";
    if($conn->query($sql)==TRUE){
        echo "success";
    }
    else{
        echo "error";
    }
    $conn->close();
    return;
}

#tarife id verilen tarifeyi getiriyor.
if($action=="get_tarife"){
    $db_data=array();
    $Tarife_id=$_POST["Tarife_id"];

    $sql="SELECT * FROM tarifeler WHERE Tarife_id=$Tarife_id";
    $result=$conn->query($sql);
    if($result->num_rows>0){
        while($row=$result->fetch_assoc()){
            $db_data[]=$row;
        }
        echo json_encode($db_data);
    }
    else{
        echo "error";
    }
    $conn->close();
    return;
}

?>