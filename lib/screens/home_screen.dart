import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'kitchen_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _name = 'Default User';
  String _rollNo = '202';
  String _roomNumber = 'A-101 - Agira Hall (A) (2S WST AC)';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('profile_name') ?? 'Default User';
      _rollNo = prefs.getString('profile_rollNo') ?? '202';
      _roomNumber = prefs.getString('profile_room') ?? 'A-101 - Agira Hall (A) (2S WST AC)';
    });
  }

  Future<void> _saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_name', _name);
    await prefs.setString('profile_rollNo', _rollNo);
    await prefs.setString('profile_room', _roomNumber);
  }

  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: _name);
    final rollController = TextEditingController(text: _rollNo);
    final roomController = TextEditingController(text: _roomNumber);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Edit Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: rollController,
              decoration: const InputDecoration(
                labelText: 'Roll No',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: roomController,
              decoration: const InputDecoration(
                labelText: 'Room Number',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _name = nameController.text;
                _rollNo = rollController.text;
                _roomNumber = roomController.text;
              });
              _saveProfile();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC62B6D),
              foregroundColor: Colors.white,
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildSearchBar(),
            const SizedBox(height: 16),
            _buildQuickActions(),
            const SizedBox(height: 16),
            _buildEntryExitLog(),
            const SizedBox(height: 16),
            _buildRecentActivities(),
            const SizedBox(height: 16),
            _buildFooter(),
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFFC62B6D),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFB5174F), Color(0xFFD63870)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            children: [
              // Top bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.grid_view, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 10),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('TIET', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          Text('Resident App', style: TextStyle(color: Colors.white70, fontSize: 13)),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _headerIconBtn(Icons.badge_outlined, null),
                      const SizedBox(width: 8),
                      _headerIconBtn(Icons.refresh, null),
                      const SizedBox(width: 8),
                      _headerIconBtn(Icons.logout, _showEditProfileDialog),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Profile row
              Row(
                children: [
                  // Avatar with progress ring
                  CircularPercentIndicator(
                    radius: 40,
                    lineWidth: 4,
                    percent: 0.31,
                    center: CircleAvatar(
                      radius: 34,
                      backgroundColor: Colors.grey.shade300,
                      child: const Icon(Icons.person, size: 38, color: Color(0xFF555555)),
                    ),
                    progressColor: const Color(0xFF4CAF50),
                    backgroundColor: Colors.white24,
                    footer: const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text('31%', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('Roll No - $_rollNo', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                        const SizedBox(height: 2),
                        Text(_roomNumber, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ),
                  // Thapar Institute logo
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/images/img.png',
                      width: 80,
                      height: 80,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerIconBtn(IconData icon, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: const TextField(
          decoration: InputDecoration(
            hintText: 'Search for Leave, Complaints, etc...',
            hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
            suffixIcon: Icon(Icons.search, color: Colors.grey),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _quickAction(Icons.exit_to_app_outlined, 'Vacation', null),
          _quickAction(Icons.room_service_outlined, 'Kitchen', () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => KitchenScreen(userName: _name)));
          }),
          _quickAction(Icons.account_balance_wallet_outlined, 'Ledger', null),
          _quickAction(Icons.grid_view, 'See more', null),
        ],
      ),
    );
  }

  Widget _quickAction(IconData icon, String label, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
            ),
            child: Icon(icon, color: const Color(0xFF3B82F6), size: 26),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildEntryExitLog() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 2))],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE53935),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('Live', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 8),
                    const Text('Entry/Exit Log', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  ],
                ),
                const Text('Your Status', style: TextStyle(color: Color(0xFF3B82F6), fontSize: 13, fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Wed, 11 Mar 2026 | 6:41 PM,', style: TextStyle(color: Colors.grey, fontSize: 12)),
                Row(
                  children: [
                    Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                    const SizedBox(width: 3),
                    Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _logBtn('Exit', isBlack: true),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(child: Text('--', style: TextStyle(color: Colors.grey))),
                  ),
                ),
                const SizedBox(width: 8),
                _logBtn('Entry', isBlack: true),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(child: Text('--', style: TextStyle(color: Colors.grey))),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _logBtn(String label, {bool isBlack = false}) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: isBlack ? Colors.black : const Color(0xFFC62B6D),
        foregroundColor: Colors.white,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        elevation: 0,
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildRecentActivities() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Recent Activities', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          SizedBox(
            height: 180,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _activityCard(
                  type: 'Complain',
                  status: 'Resolved',
                  statusColor: const Color(0xFF4CAF50),
                  title: 'Room needs to be cleaned',
                  header: 'Housekeeping',
                  scope: 'User',
                  date: 'Mar 7, 2026',
                  iconColor: const Color(0xFFC62B6D),
                ),
                const SizedBox(width: 12),
                _activityCard(
                  type: 'Vacation',
                  status: 'Pending',
                  statusColor: const Color(0xFFFF9800),
                  title: 'Going home for weekend',
                  header: 'Personal',
                  scope: 'User',
                  date: 'Mar 5, 2026',
                  iconColor: const Color(0xFF3B82F6),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _activityCard({
    required String type,
    required String status,
    required Color statusColor,
    required String title,
    required String header,
    required String scope,
    required String date,
    required Color iconColor,
  }) {
    return Container(
      width: 270,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(type, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(status, style: TextStyle(color: statusColor, fontSize: 13, fontStyle: FontStyle.italic)),
                ],
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: iconColor, shape: BoxShape.circle),
                child: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 4),
          Text('Header: $header', style: const TextStyle(color: Colors.black54, fontSize: 12)),
          Text.rich(TextSpan(children: [
            const TextSpan(text: 'Scope: ', style: TextStyle(color: Colors.black54, fontSize: 12)),
            TextSpan(text: scope, style: const TextStyle(color: Color(0xFF3B82F6), fontSize: 12)),
          ])),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.calendar_today, size: 12, color: Colors.grey),
                const SizedBox(width: 4),
                Text(date, style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return const Center(
      child: Column(
        children: [
          Text('Powered By: Fretbox', style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, fontSize: 14)),
          SizedBox(height: 4),
          Text('v3.10.10+210', style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      color: Colors.white,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(Icons.home, 'Home', 0),
            _navItem(Icons.warning_amber_rounded, 'Emergency', 1),
            const SizedBox(width: 48),
            _navItem(Icons.notifications_none, 'Notification', 2),
            _navItem(Icons.person_outline, 'Profile', 3),
          ],
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    final color = isSelected ? const Color(0xFFC62B6D) : (index == 1 ? const Color(0xFFFF9800) : Colors.grey);
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          Text(label, style: TextStyle(color: color, fontSize: 10)),
        ],
      ),
    );
  }
}
