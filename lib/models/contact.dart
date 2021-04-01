class Contact {
 static const tblContact = 'contacts';
 static const colId   = 'id';
 static const colName = 'name';
 static const colEmail = 'mail';
 static const colPassword = 'password';
  String email;
  int id;
  String name;
  String password;
  String contact;

  // Constructeur
Contact({this.id, this.email, this.name, this.password});

 Contact.fromMap(Map<String, dynamic> map) {
   id = map[colId];
   name = map[colName];
   password = map[colPassword];
   email =map[colEmail];
 }

 Map<String, dynamic> toMap() {
   var map = <String, dynamic>{colName: name, colEmail: email};
   if (id != null) {
     map[colId] = id;
   }
   return map;
 }

}