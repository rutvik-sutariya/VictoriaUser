class Config {
  static String baseUrl = 'http://147.93.108.251';
  static String uploadImage = '/api/upload-image';
  static String login = '/api/users/login-user';
  static String getUser = '/api/users/get-user/';
  static String milkHistory = '/api/milk/milk-history';
  static String cancelOrder = '/api/milk/cancel-order';
  static String extraOrder = '/api/users/';
  static String lessMilk = '/api/milk/';
  static String paymentSummery = '/api/milk/payment-summery';
  static String employee = '/api/employee/get-employee';
  static String pendingMonth = '/api/get-pending-month';
  static String cashPayment = '/api/milk/send-cash-payment-request';
  static String upiPayment = '/api/milk/send-online-payment-request';
  static String notification = '/api/milk/get-milk-notification?userId=';
  static String milkExportPdf = '/api/milk/milk-history?export=pdf';
  static String monthSummery = '/api/milk/get-pending-month-summery';
  static String contactUs = '/api/contact-us/get-contact';
  static String resetSound = '/api/milk/reset-sound';

}
