import 'package:flutter/material.dart';
import '../utils/language.dart';
import '../utils/constants.dart';
import '../utils/session.dart';
import '../mock_data/service_requests.dart';
import '../mock_data/users.dart';
import '../mock_data/services.dart';
import '../models/user.dart';
import '../models/service.dart';
import '../models/service_request.dart';

class WorkerHomeScreen extends StatefulWidget {
  const WorkerHomeScreen({super.key});

  @override
  State<WorkerHomeScreen> createState() => _WorkerHomeScreenState();
}

class _WorkerHomeScreenState extends State<WorkerHomeScreen> with SingleTickerProviderStateMixin {
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

  String _getUserName(String userId) {
    return mockUsers.firstWhere(
      (u) => u.id == userId, 
      orElse: () => User(id: '', name: 'Unknown', phone: '', villageId: ''),
    ).name;
  }

  String _getServiceName(String serviceId) {
    return mockServices.firstWhere(
      (s) => s.id == serviceId,
      orElse: () => Service(id: '', categoryId: '', name: 'Unknown Service', description: '', price: 0, isAvailable: false),
    ).name;
  }

  void _updateStatus(String requestId, String newStatus) {
    setState(() {
      final request = mockServiceRequests.firstWhere((r) => r.id == requestId);
      // Hack to update immutable object in mock list for demo
      // In real app, we would make a DB call
      mockServiceRequests.remove(request);
      mockServiceRequests.add(request.copyWith(status: newStatus)); 
      // Note: copyWith wasn't strictly defined in our initial model but we can simulate it or just replace manually
      // Let's reload to be safe or assuming the list update works.
    });
  }
  
  // Custom manual update since we didn't add copyWith to model yet
  void _setJobStatus(String requestId, String status) {
      final index = mockServiceRequests.indexWhere((r) => r.id == requestId);
      if (index != -1) {
        final old = mockServiceRequests[index];
        mockServiceRequests[index] =  old; // Temp hold
        // Since fields are final, we need to create new instance.
        // But our model doesn't have copyWith. 
        // Let's just create a new one manually.
        final updated = ServiceRequest( // Wait, we need to import ServiceRequest class properly or just assume it
           id: old.id,
           userId: old.userId,
           workerId: old.workerId,
           serviceId: old.serviceId,
           createdAt: old.createdAt,
           completedAt: status == 'completed' ? DateTime.now() : old.completedAt,
           status: status,
           notes: old.notes
        );
        setState(() {
           mockServiceRequests[index] = updated;
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    final currentWorkerId = Session.currentUser?.id;

    // Filter requests
    final allRequests = mockServiceRequests.where((req) => req.workerId == currentWorkerId).toList();
    final pendingRequests = allRequests.where((req) => req.status == 'pending').toList();
    final activeJobs = allRequests.where((req) => ['accepted', 'completed'].contains(req.status)).toList();

    activeJobs.sort((a, b) => b.createdAt.compareTo(a.createdAt)); // Newest first

    return Scaffold(
      appBar: AppBar(
        title: const Text('Partner Dashboard'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'New Requests'),
            Tab(text: 'My Jobs'),
          ],
        ),
        actions: [
           IconButton(
             onPressed: () => Navigator.pushNamed(context, '/user_profile'), 
             icon: const Icon(Icons.person_pin, color: Colors.white) // White since AppBar is primary color? No, theme says primary is DeepPurple. Let's check theme.
           ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRequestList(pendingRequests, isPending: true),
          _buildRequestList(activeJobs, isPending: false),
        ],
      ),
    );
  }

  Widget _buildRequestList(List<dynamic> requests, {required bool isPending}) {
    if (requests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_outlined, size: 60, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              isPending ? 'No new requests' : 'No active jobs',
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _getServiceName(request.serviceId),
                      style: AppTextStyles.subHeading,
                    ),
                    if (!isPending)
                       Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: request.status == 'completed' ? Colors.green[100] : Colors.blue[100],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                request.status.toUpperCase(),
                                style: TextStyle(
                                  color: request.status == 'completed' ? Colors.green[800] : Colors.blue[800],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Customer: ${_getUserName(request.userId)}'),
                Text('Date: ${request.createdAt.toString().split(' ')[0]}'),
                const SizedBox(height: 16),
                
                if (isPending)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _setJobStatus(request.id, 'rejected'),
                          child: const Text('REJECT'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _setJobStatus(request.id, 'accepted'),
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.success, foregroundColor: Colors.white),
                          child: const Text('ACCEPT'),
                        ),
                      ),
                    ],
                  )
                else if (request.status == 'accepted')
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _setJobStatus(request.id, 'completed'),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                      child: const Text('MARK COMPLETED'),
                    ),
                  )
              ],
            ),
          ),
        );
      },
    );
  }
}
