import 'dart:core';

class Contact{

  int _id;
  String _name;
  String _phone;
  String _email;
  String _image;
  int _category;

  Contact(this._name, this._phone, this._category, [this._email, this._image]);

  Contact.withId(this._id, this._name, this._phone, this._category, [this._email, this._image]);

  int get id => _id;
  String get name => _name;
  String get phone => _phone;
  String get email => _email;
  String get image => _image;
  int get category => _category;

  set name(String newName){
    if (newName.length <= 255) {
      this._name = newName;
    }
  }

  set phone(String newPhone){
    if (newPhone.length <= 255) {
      if(newPhone.substring(0,3) == '+91'){
        this._phone = newPhone;
      }
      else{
      this._phone = "+91"+newPhone;
      }
    }
  }

  set email(String newEmail){
    if (newEmail.length <= 255) {
      this._email = newEmail;
    }
  }
  set image(String newImage){
    if (newImage.length <= 255) {
      this._image = newImage;
    }
  }

  set category(int newCategory){
    if (newCategory >= 1 && newCategory <= 3) {
      this._category = newCategory;
    }
  }

  //convert contact object to map object
  Map<String, dynamic> toMap(){

    var map = Map<String, dynamic>();
    if ( id != null) {
        map['id'] = _id;
      }

    map['name'] = _name;
    map['phone'] = _phone;
    map['email'] = _email;
    map['image'] = _image;
    map['category'] = _category;
    
    return map;
    
  }

  //extract contact object from map object
  Contact.fromMapObject(Map<String, dynamic> map){

    this._id = map['id'];
    this._name = map['name'];
    this._phone = map['phone'];
    this._email = map['email'];
    this._category = map['category'];
    this._image = map['image'];

  } 

   @override
  String toString() {
    return 'Contact(id: $id, name: $name, email: $email, phone: $phone, category: $category)';
  }
}