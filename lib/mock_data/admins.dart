import '../models/admin.dart';

final List<Admin> mockAdmins = [
  Admin(
    id: 'a1',
    name: 'Super Admin',
    phone: '8888888888',
    role: 'super_admin',
    permissions: ['all'],
  ),
  Admin(
    id: 'a2',
    name: 'Local Admin',
    phone: '8888888887',
    role: 'village_admin',
    permissions: ['manage_users', 'view_reports'],
  ),
];
