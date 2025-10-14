// upi_payment_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/app_colors.dart';
import '../../utils/text_styles.dart';

class UpiPaymentScreen extends StatefulWidget {
  final String amount;
  final String month;
  final String year;

  const UpiPaymentScreen({
    Key? key,
    required this.amount,
    required this.month,
    required this.year,
  }) : super(key: key);

  @override
  State<UpiPaymentScreen> createState() => _UpiPaymentScreenState();
}

class _UpiPaymentScreenState extends State<UpiPaymentScreen> {
  String upiId = "your-merchant@upi"; // Replace with your actual UPI ID
  List<UpiApp> availableUpiApps = [];
  bool isLoading = true;

  // List of popular UPI apps with their package names and UPI schemes
  final List<UpiApp> allUpiApps = [
    UpiApp(
      name: "PhonePe",
      package: "com.phonepe.app",
      scheme: "phonepe://",
      icon: Icons.phone_android,
      upiPrefix: "phonepe",
    ),
    UpiApp(
      name: "Google Pay",
      package: "com.google.android.apps.nbu.paisa.user",
      scheme: "tez://",
      icon: Icons.account_balance_wallet,
      upiPrefix: "gpay",
    ),
    UpiApp(
      name: "Paytm",
      package: "net.one97.paytm",
      scheme: "paytmmp://",
      icon: Icons.payment,
      upiPrefix: "paytm",
    ),
    UpiApp(
      name: "BHIM UPI",
      package: "in.org.npci.upiapp",
      scheme: "bhim://",
      icon: Icons.mobile_friendly,
      upiPrefix: "bhim",
    ),
    UpiApp(
      name: "Amazon Pay",
      package: "in.amazon.mShop.android.shopping",
      scheme: "amazon://",
      icon: Icons.shopping_bag,
      upiPrefix: "amazon",
    ),
    UpiApp(
      name: "Any UPI App",
      package: "generic.upi",
      scheme: "upi://",
      icon: Icons.payment,
      upiPrefix: "upi",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _checkAvailableUpiApps();
  }

  // Generate UPI URL for direct payment
  String get upiUrl {
    return "upi://pay?pa=$upiId&pn=Milk%20Vendor&am=${widget.amount}&cu=INR&tn=Payment%20for%20${_getMonthName(widget.month)}%20${widget.year}";
  }

  // Check which UPI apps are installed on the device
  Future<void> _checkAvailableUpiApps() async {
    List<UpiApp> availableApps = [];

    for (var app in allUpiApps) {
      try {
        // Try to launch the app scheme to check if it's available
        String testUrl = "${app.scheme}test";
        bool canLaunchApp = await canLaunch(testUrl);

        if (canLaunchApp || app.name == "Any UPI App") {
          availableApps.add(app);
        }
      } catch (e) {
        print("Error checking app ${app.name}: $e");
      }
    }

    // Always add generic UPI option
    if (!availableApps.any((app) => app.name == "Any UPI App")) {
      availableApps.add(
        UpiApp(
          name: "Any UPI App",
          package: "generic.upi",
          scheme: "upi://",
          icon: Icons.payment,
          upiPrefix: "upi",
        ),
      );
    }

    setState(() {
      availableUpiApps = availableApps;
      isLoading = false;
    });
  }

  // Launch specific UPI app with payment details
  Future<void> _launchUpiApp(UpiApp app) async {
    try {
      String launchUrl = "upi://pay?pa=$upiId&pn=Milk%20Vendor&am=${widget.amount}&cu=INR&tn=Payment%20for%20${_getMonthName(widget.month)}%20${widget.year}";

      print("Launching URL: $launchUrl");

      if (await canLaunch(launchUrl)) {
        await launch(launchUrl);
      } else {
        _showErrorDialog();
      }
    } catch (e) {
      print("Error launching app: $e");
      _showErrorDialog();
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Payment Error"),
        content: Text("Unable to open UPI app. Please make sure you have a UPI app installed."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBgColor,
      appBar: AppBar(
        title: Text(
          "UPI Payment",
          style: AppTextStyle.medium18.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.appPrimaryDarkColor,
          ),
        ),
        backgroundColor: AppColors.appWhiteColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.appPrimaryDarkColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Amount Display
            _buildAmountCard(),
            const SizedBox(height: 30),

            // QR Code Section
            _buildQrCodeSection(),
            const SizedBox(height: 30),

            // OR Divider
            _buildOrDivider(),
            const SizedBox(height: 30),

            // UPI Apps List
            _buildUpiAppsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.appPrimaryDarkColor.withOpacity(0.9),
            AppColors.appPrimaryDarkColor,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.appPrimaryDarkColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "Payable Amount",
            style: AppTextStyle.small16.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "₹ ${widget.amount}",
            style: AppTextStyle.extraLarge32.copyWith(
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "For ${_getMonthName(widget.month)} ${widget.year}",
            style: AppTextStyle.small14.copyWith(
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrCodeSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.appWhiteColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "Scan QR Code to Pay",
            style: AppTextStyle.medium18.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.appPrimaryDarkColor,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: QrImageView(
              data: upiUrl,
              version: QrVersions.auto,
              size: 200,
              backgroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Scan this QR code with any UPI app",
            style: AppTextStyle.small14.copyWith(
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildOrDivider() {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: Colors.grey.shade400,
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "OR",
            style: AppTextStyle.small14.copyWith(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: Colors.grey.shade400,
            thickness: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildUpiAppsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.appWhiteColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Pay with UPI App",
            style: AppTextStyle.medium18.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.appPrimaryDarkColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Tap on your preferred UPI app to pay instantly",
            style: AppTextStyle.small14.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 20),

          if (isLoading)
            _buildLoadingIndicator()
          else
            _buildUpiAppsList(),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.appPrimaryDarkColor),
          ),
          const SizedBox(height: 16),
          Text(
            "Loading payment options...",
            style: AppTextStyle.small14.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpiAppsList() {
    return Column(
      children: availableUpiApps.map((app) => _buildUpiAppTile(app)).toList(),
    );
  }

  Widget _buildUpiAppTile(UpiApp app) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.appBgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.appPrimaryDarkColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(app.icon, color: AppColors.appPrimaryDarkColor, size: 24),
        ),
        title: Text(
          app.name,
          style: AppTextStyle.small16.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          "Pay ₹${widget.amount}",
          style: AppTextStyle.small14.copyWith(
            color: Colors.green.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Colors.green.shade700],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            "PAY",
            style: AppTextStyle.small12.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        onTap: () => _launchUpiApp(app),
      ),
    );
  }

  String _getMonthName(String monthNumber) {
    final months = {
      "1": "January", "2": "February", "3": "March", "4": "April",
      "5": "May", "6": "June", "7": "July", "8": "August",
      "9": "September", "10": "October", "11": "November", "12": "December"
    };
    return months[monthNumber] ?? "Month";
  }
}

class UpiApp {
  final String name;
  final String package;
  final String scheme;
  final IconData icon;
  final String upiPrefix;

  UpiApp({
    required this.name,
    required this.package,
    required this.scheme,
    required this.icon,
    required this.upiPrefix,
  });
}