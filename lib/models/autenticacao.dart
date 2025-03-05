class Autenticacao {
  static const urlBase = "http://192.168.2.12:8083/rest/"; // http://177.174.11.226:8080 // 192.168.2.12:8083 81
  static const usuario = "jesse";
  static const senha = "Oft3870515"; //"Oft3870515"; // @Phoft0515
  static const pathCustomers = "app/customers/";
  static const pathCustomersAuth = "auth/";
  static const pathContacts = "app/contact/";
  static const pathToken = 'api/oauth2/v1/token?grant_type=password&password=$senha&username=$usuario';
  static const urlLogin = '$urlBase$pathToken';
  static const urlSeller = '$urlBase$pathCustomers$pathCustomersAuth';
  static const urlCustomers = '$urlBase$pathCustomers';
  static const urlContacts = '$urlBase$pathContacts';
}
