class Config {
  // static String baseUrl = 'https://f736448013bf.ngrok-free.app';
  static String baseUrl = 'https://victoriafarm.onrender.com';

  static String uploadImage = '/api/upload-image';

  static String login = '/api/users/login-user';
  static String getUser = '/api/users/get-user/';
  static String milkHistory = '/api/milk/milk-history';
  static String cancelOrder = '/api/milk/cancel-order';
  static String extraOrder = '/api/users/';
  static String paymentSummery = '/api/milk/payment-summery';
  static String employee = '/api/employee/get-employee';
  static String pendingMonth = '/api/get-pending-month';
  static String cashPayment = '/api/milk/send-cash-payment-request';
  static String upiPayment = '/api/milk/send-online-payment-request';
}
