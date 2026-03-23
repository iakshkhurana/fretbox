import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class KitchenScreen extends StatefulWidget {
  final String userName;

  const KitchenScreen({super.key, required this.userName});

  @override
  State<KitchenScreen> createState() => _KitchenScreenState();
}

class _KitchenScreenState extends State<KitchenScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _getCurrentMeal() {
    final hour = TimeOfDay.now().hour;
    if (hour >= 7 && hour < 9) return 'Breakfast';
    if (hour >= 12 && hour < 14) return 'Lunch';
    if (hour >= 19 && hour < 21) return 'Dinner';
    // Outside meal hours — closest upcoming
    if (hour < 7) return 'Breakfast';
    if (hour < 12) return 'Lunch';
    if (hour < 19) return 'Dinner';
    return 'Breakfast';
  }

  void _openQrScanner() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _QrScannerPage(
          onScanned: (String code) {
            Navigator.pop(context); // close scanner
            _showScannedResultDialog(code);
          },
        ),
      ),
    );
  }

  void _showScannedResultDialog(String scannedData) {
    final meal = _getCurrentMeal();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Avatar with green border
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF4CAF50), width: 3),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4CAF50).withOpacity(0.25),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const CircleAvatar(
                radius: 46,
                backgroundImage: NetworkImage(
                  'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Name
            Text(
              widget.userName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Meal For
            RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 15, color: Colors.black87),
                children: [
                  const TextSpan(text: 'Meal For: '),
                  TextSpan(text: meal, style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 6),
            // Outlet
            RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 15, color: Colors.black87),
                children: [
                  TextSpan(text: 'Outlet : '),
                  TextSpan(text: 'Agira Hall (hostel A)', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Success message
            const Text(
              'Success!! You can Avail Meal now!!',
              style: TextStyle(
                color: Color(0xFF4CAF50),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Color(0xFF1E88E5), fontSize: 16)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E88E5),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Kitchen', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.receipt_long_outlined, color: Colors.white), onPressed: () {}),
          IconButton(icon: const Icon(Icons.qr_code_scanner, color: Colors.white), onPressed: _openQrScanner),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'Active/Upcoming'),
            Tab(text: 'Cancelled/Expired'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildActiveTab(),
          _buildEmptyTab('No cancelled or expired subscriptions'),
        ],
      ),
    );
  }

  Widget _buildActiveTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: _buildSubscriptionCard(),
    );
  }

  Widget _buildEmptyTab(String message) {
    return Center(
      child: Text(message, style: const TextStyle(color: Colors.grey, fontSize: 14)),
    );
  }

  Widget _buildSubscriptionCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Sodexo 25 26',
                style: TextStyle(
                  color: Color(0xFF1E88E5),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  const Text('Active', style: TextStyle(color: Colors.grey, fontSize: 13)),
                  const SizedBox(width: 6),
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(color: Color(0xFF4CAF50), shape: BoxShape.circle),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Subscription details
          _infoRow('Subscription from', null, richText: 'Subscription from ', boldParts: ['03 January', '31 May'], fullText: 'Subscription from 03 January to 31 May'),
          const SizedBox(height: 6),
          _labelValueRow('Subscription ID:', '24521', valueColor: const Color(0xFF1E88E5)),
          const SizedBox(height: 6),
          _labelValueRow('Session:', 'EVEN SEM 2025-26', valueColor: Colors.grey),
          const SizedBox(height: 6),
          _labelValueRow('Package:', 'All Programs & Years', valueColor: Colors.grey),
          const SizedBox(height: 6),
          _labelValueRow('Food Allergies:', 'N/A', valueColor: Colors.grey),
          const SizedBox(height: 6),
          _labelValueRow('Default Outlet :', 'Agira Hall (hostel A)', valueColor: Colors.grey),
          const SizedBox(height: 6),
          _labelValueRow('Amount :', '₹25500.00', valueColor: Colors.black87),
          const SizedBox(height: 6),
          _labelValueRow('Billing Status :', 'PAID (Bill ID:24884)', valueColor: Colors.grey),
          const SizedBox(height: 6),
          _labelValueRow('Last Scanned :', '23 Jan | 07:49 PM', valueColor: Colors.black87),
          const SizedBox(height: 16),
          // Bottom icons and scan button
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(color: Color(0xFF1E88E5), shape: BoxShape.circle),
                child: const Icon(Icons.info_outline, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 8),
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF1E88E5)),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.receipt_long_outlined, color: Color(0xFF1E88E5), size: 18),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton.icon(
              onPressed: _openQrScanner,
              icon: const Icon(Icons.qr_code_scanner, size: 18),
              label: const Text('Scan Qr', style: TextStyle(fontWeight: FontWeight.w600)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E88E5),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String? value, {String? richText, List<String>? boldParts, String? fullText}) {
    if (fullText != null && boldParts != null) {
      return RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black87, fontSize: 14),
          children: [
            const TextSpan(text: 'Subscription from '),
            const TextSpan(text: '03 January', style: TextStyle(fontWeight: FontWeight.bold)),
            const TextSpan(text: ' to '),
            const TextSpan(text: '31 May', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      );
    }
    return Text('$label ${value ?? ''}', style: const TextStyle(fontSize: 14, color: Colors.black87));
  }

  Widget _labelValueRow(String label, String value, {Color valueColor = Colors.black87}) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 14, color: Colors.black87),
        children: [
          TextSpan(text: label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const TextSpan(text: ' '),
          TextSpan(text: value, style: TextStyle(color: valueColor, fontWeight: FontWeight.normal)),
        ],
      ),
    );
  }
}

class _QrScannerPage extends StatefulWidget {
  final void Function(String code) onScanned;

  const _QrScannerPage({required this.onScanned});

  @override
  State<_QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<_QrScannerPage> {
  final MobileScannerController _controller = MobileScannerController();
  bool _hasScanned = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Scan QR Code'),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () => _controller.toggleTorch(),
          ),
          IconButton(
            icon: const Icon(Icons.cameraswitch),
            onPressed: () => _controller.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: (BarcodeCapture capture) {
              if (_hasScanned) return;
              final barcode = capture.barcodes.firstOrNull;
              if (barcode != null && barcode.rawValue != null) {
                _hasScanned = true;
                widget.onScanned(barcode.rawValue!);
              }
            },
          ),
          // Scan overlay
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          // Cancel button
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text('Cancel', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
