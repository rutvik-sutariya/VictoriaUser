// upi_payment_screen.dart
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/app_colors.dart';
import '../../utils/text_styles.dart';

class UpiPaymentScreen extends StatefulWidget {
  final String amount;
  final String month;
  final String year;

  const UpiPaymentScreen({
    super.key,
    required this.amount,
    required this.month,
    required this.year,
  });

  @override
  State<UpiPaymentScreen> createState() => _UpiPaymentScreenState();
}

class _UpiPaymentScreenState extends State<UpiPaymentScreen> {
  String upiId = "7859828561-2@axl";
  List<UpiApp> availableUpiApps = [];
  bool isLoading = false;

  // List of popular UPI apps with CORRECT URLs
  final List<UpiApp> allUpiApps = [
    UpiApp(
      name: "PhonePe",
      package: "com.phonepe.app",
      scheme: "phonepe://",
      icon: Icons.phone_android,
    ),
    UpiApp(
      name: "Google Pay",
      package: "com.google.android.apps.nbu.paisa.user",
      scheme: "gpay://",
      icon: Icons.account_balance_wallet,
    ),
    UpiApp(
      name: "Paytm",
      package: "net.one97.paytm",
      scheme: "paytmmp://",
      icon: Icons.payment,
    ),
    UpiApp(
      name: "BHIM UPI",
      package: "in.org.npci.upiapp",
      scheme: "bhim://",
      icon: Icons.mobile_friendly,
    ),
    UpiApp(
      name: "Any UPI App",
      package: "generic.upi",
      scheme: "upi://",
      icon: Icons.apps,
    ),
  ];

  @override
  void initState() {
    super.initState();
    availableUpiApps = allUpiApps;
  }

  /// ✅ Generate UPI payment URL (Standard UPI Format)
  String get upiUrl {
    return "upi://pay?pa=$upiId&pn=Milk%20Vendor&am=${widget.amount}&cu=INR&tn=Payment%20for%20${_getMonthName(widget.month)}%20${widget.year}";
  }

  /// ✅ CORRECT METHOD: Launch UPI app with proper URL
  Future<void> _launchUpiApp(UpiApp upiApp) async {
    try {
      String url = upiUrl;

      // For specific apps, use their custom scheme but same parameters
      if (upiApp.name != "Any UPI App") {
        // Replace upi:// with app specific scheme
        url = url.replaceFirst("upi://", "${upiApp.scheme}pay/");
      }

      print("Trying to launch: $url"); // Debug

      final Uri uri = Uri.parse(url);

      bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (launched) {
        _showPaymentInitiatedDialog(upiApp.name);
      } else {
        // If specific app fails, try generic UPI
        await _launchGenericUpi();
      }
    } catch (e) {
      print("Error: $e");
      // Fallback to generic UPI
      await _launchGenericUpi();
    }
  }

  /// Launch generic UPI as fallback
  Future<void> _launchGenericUpi() async {
    try {
      final Uri uri = Uri.parse(upiUrl);
      bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (launched) {
        _showPaymentInitiatedDialog("UPI App");
      } else {
        _showErrorSnackbar("No UPI app found. Please install PhonePe, Google Pay, etc.");
      }
    } catch (e) {
      _showErrorSnackbar("Please use QR code for payment.");
    }
  }

  /// Alternative: Direct UPI Intent (Most Reliable)
  Future<void> _launchUpiIntent() async {
    try {
      // This is the most reliable UPI URL format
      String url = "upi://pay?pa=$upiId&pn=Milk%20Vendor&am=${widget.amount}&cu=INR";

      final Uri uri = Uri.parse(url);
      bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        _showErrorSnackbar("No UPI app found. Please install a UPI app.");
      }
    } catch (e) {
      _showErrorSnackbar("Payment failed. Please use QR code.");
    }
  }

  /// Show error message
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 4),
      ),
    );
  }

  /// Show success dialog when payment is initiated
  void _showPaymentInitiatedDialog(String appName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Payment Initiated", style: TextStyle(color: AppColors.appPrimaryDarkColor)),
        content: Text("$appName has been opened. Please complete the payment."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK", style: TextStyle(color: AppColors.appPrimaryDarkColor)),
          ),
        ],
      ),
    );
  }

  // ================= UI PART =================

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
            _buildAmountCard(),
            const SizedBox(height: 30),
            _buildQrCodeSection(),
            const SizedBox(height: 30),
            _buildOrDivider(),
            const SizedBox(height: 30),
            _buildUpiAppsSection(),
            const SizedBox(height: 20),
            _buildDirectUpiButton(), // Added direct UPI button
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
            style:
            AppTextStyle.small16.copyWith(color: Colors.white.withOpacity(0.9)),
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
            style:
            AppTextStyle.small14.copyWith(color: Colors.white.withOpacity(0.8)),
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
            style:
            AppTextStyle.small14.copyWith(color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildOrDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey.shade400, thickness: 1)),
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
        Expanded(child: Divider(color: Colors.grey.shade400, thickness: 1)),
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
            style:
            AppTextStyle.small14.copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 20),
          _buildUpiAppsGrid(),
        ],
      ),
    );
  }

  Widget _buildUpiAppsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.9,
      ),
      itemCount: availableUpiApps.length,
      itemBuilder: (context, index) {
        final upiApp = availableUpiApps[index];
        return _buildUpiAppCard(upiApp);
      },
    );
  }

  Widget _buildUpiAppCard(UpiApp upiApp) {
    return GestureDetector(
      onTap: () => _launchUpiApp(upiApp),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.appPrimaryDarkColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                upiApp.icon,
                size: 28,
                color: AppColors.appPrimaryDarkColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              upiApp.name,
              style: AppTextStyle.small12.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade800,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.appPrimaryDarkColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "Pay",
                style: AppTextStyle.small12.copyWith(
                  color: AppColors.appPrimaryDarkColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // NEW: Direct UPI Payment Button (Most Reliable)
  Widget _buildDirectUpiButton() {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _launchUpiIntent,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.appPrimaryDarkColor,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          "Pay with Any UPI App",
          style: AppTextStyle.small16.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  String _getMonthName(String monthNumber) {
    final months = {
      "1": "January",
      "2": "February",
      "3": "March",
      "4": "April",
      "5": "May",
      "6": "June",
      "7": "July",
      "8": "August",
      "9": "September",
      "10": "October",
      "11": "November",
      "12": "December"
    };
    return months[monthNumber] ?? "Month";
  }
}

/// Model for UPI app
class UpiApp {
  final String name;
  final String package;
  final String scheme;
  final IconData icon;

  UpiApp({
    required this.name,
    required this.package,
    required this.scheme,
    required this.icon,
  });
}