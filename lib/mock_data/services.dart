import '../models/service.dart';

final List<Service> mockServices = [
  Service(
    id: 's1',
    name: 'Pipe Repair',
    categoryId: 'c1',
    description: 'Fixing leaking pipes and taps',
    price: 150.0,
  ),
  Service(
    id: 's2',
    name: 'Full Wiring',
    categoryId: 'c2',
    description: 'Complete house wiring service',
    price: 2000.0,
  ),
  Service(
    id: 's3',
    name: 'Switch Replacement',
    categoryId: 'c2',
    description: 'Replacing old or broken switches',
    price: 50.0,
  ),
  Service(
    id: 's4',
    name: 'Door Repair',
    categoryId: 'c3',
    description: 'Fixing broken doors and hinges',
    price: 300.0,
  ),
  Service(
    id: 's5',
    name: 'Wall Painting',
    categoryId: 'c4',
    description: 'Interior and exterior wall painting',
    price: 15.0, // per sq ft
  ),
];
