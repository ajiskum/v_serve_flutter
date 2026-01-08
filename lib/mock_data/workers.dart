import '../models/worker.dart';

final List<Worker> mockWorkers = [
  Worker(
    id: 'w1',
    name: 'Muthu',
    phone: '9988776655',
    villageId: 'v1',
    skills: ['Plumbing', 'Electrical'],
    rating: 4.5,
    completedJobs: 15,
  ),
  Worker(
    id: 'w2',
    name: 'Karthik',
    phone: '9988776654',
    villageId: 'v2',
    skills: ['Carpenter'],
    rating: 4.8,
    completedJobs: 30,
  ),
  Worker(
    id: 'w3',
    name: 'Lakshmi',
    phone: '9988776653',
    villageId: 'v3',
    skills: ['Gardening', 'Cleaning'],
    rating: 4.2,
    completedJobs: 10,
  ),
];
