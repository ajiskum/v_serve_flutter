import '../models/user.dart';

List<User> mockUsers = [
  User(
    id: 'u1',
    name: 'Ravi Kumar',
    phone: '9876543210',
    villageId: 'v1',
    email: 'ravi@example.com',
  ),
  User(
    id: 'u2',
    name: 'Priya A',
    phone: '9876543211',
    villageId: 'v2',
  ),
  User(
    id: 'u3',
    name: 'Senthil',
    phone: '9876543212',
    villageId: 'v3',
  ),
];

void addUser(User user) {
  mockUsers.add(user);
}
