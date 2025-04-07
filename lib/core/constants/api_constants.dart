// ignore_for_file: camel_case_types, non_constant_identifier_names

class Api_Constants {
  static String signupurl = "https://api.newhorizonhm.com/api/signup";
  static String verifyemail = "https://api.newhorizonhm.com/api/verifyemail";
  static String loginurl = "https://api.newhorizonhm.com/api/login";
  static String forgetpass = "https://api.newhorizonhm.com/api/forgotpassword";
  static String resetpass = "https://api.newhorizonhm.com/api/resetpassword";
  static String products =
      "https://api.newhorizonhm.com/api/getallproducts/{uid}";
  static String benefitsverification =
      "https://api.newhorizonhm.com/api/getbenefitsverificationdetails/{emailaddress}";
  static String addtocart = "https://api.newhorizonhm.com/api/cart/add";
  static String getmycart =
      'https://api.newhorizonhm.com/api/cart/show/{emailaddress}';
  static String removefromcart = 'https://api.newhorizonhm.com/api/cart/remove';
  static String Createcart = 'https://api.newhorizonhm.com/api/order';
  static String GetOrderDetails =
      'https://api.newhorizonhm.com/api/api/getorderdetailsbyemail/{emailaddress}?emailaddress=';
  static String deleteaccount =
      'https://api.newhorizonhm.com/api/deleteaccount';
  static String orderbyuid =
      'https://api.newhorizonhm.com/api/getorderdetailsbyUID/{uid}';
  static String benefitsverificationdetails =
      'https://api.newhorizonhm.com/api/getbenefitsverificationdetails/{uid}?uid=';
  static String addfavoriteapi =
      'https://api.newhorizonhm.com/api/AddToFavorites';
  static String removefavoriteapi =
      'https://api.newhorizonhm.com/api/RemoveFromFavorites';
  static String registerfirebasecloudtoken =
      'https://api.newhorizonhm.com/api/RegisterToken';
  static String getfavorite =
      'https://api.newhorizonhm.com/api/GetFavoriteProducts/{uid}?uid=';
  static String invoicebyuid =
      'https://api.newhorizonhm.com/api/getinvoicedetailsbyUID/{uid}?uid=';
  static String resetpassword =
      'https://api.newhorizonhm.com/api/resetpassword';
  static String uploadDocument =
      'https://api.newhorizonhm.com/api/UploadDocuments/{uid}?uid=';
  static String retreivedocument =
      'https://api.newhorizonhm.com/api/GetDocuments/{uid}';
  static String verifiedpatients =
      'https://api.newhorizonhm.com/api/GetVerifiedPatients/{uid}';
  static String claimdetails =
      'https://api.newhorizonhm.com/api/getbillingdetailsbyUID/{uid}';
  static String updateclaimdetails =
      'https://api.newhorizonhm.com/api/UpdateClaimsEditableFields';
  static String retrieveclaimuserdocuments =
      'https://api.newhorizonhm.com/api/GetClaimsDocuments/{uid}/{OrderID}';
  static String usernotifications =
      'https://api.newhorizonhm.com/api/getNotificationsByUID/{uid}';
  static String updateusernotification =
      'https://api.newhorizonhm.com/api/NotifiationIsViewed/';
  static String cancelorder = 'https://api.newhorizonhm.com/api/CancelOrder';
  static String getalldoctors =
      "https://api.newhorizonhm.com/api/getalldoctors";
  static String sendmsgdata =
      "https://api.newhorizonhm.com/api/chat/sendmessage";
  static String getAllchat =
      "https://api.newhorizonhm.com/api/chat/getchatmessages/{uid}?uid=";
}
