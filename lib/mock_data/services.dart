import '../models/service.dart';

final List<Service> mockServices = [
  // 1. Worker Needs
  Service(id: 's101', categoryId: 'c1', name: 'Electrician', description: 'Wiring, repairs, installation', price: 300, isAvailable: true),
  Service(id: 's102', categoryId: 'c1', name: 'Plumber', description: 'Pipe leaks, tap fitting, tank cleaning', price: 350, isAvailable: true),
  Service(id: 's103', categoryId: 'c1', name: 'Mason', description: 'Construction, repair, plastering', price: 800, isAvailable: true),
  Service(id: 's104', categoryId: 'c1', name: 'Painter', description: 'Wall painting, whitewash', price: 700, isAvailable: true),
  Service(id: 's105', categoryId: 'c1', name: 'Carpenter', description: 'Furniture repair, wood work', price: 500, isAvailable: true),
  Service(id: 's106', categoryId: 'c1', name: 'Driver', description: 'Car/Taxi driver on-demand', price: 400, isAvailable: true),

  // 2. Home Needs
  Service(id: 's201', categoryId: 'c2', name: 'Fan / Light Repair', description: 'Fixing fans, tubelights, bulbs', price: 150, isAvailable: true),
  Service(id: 's202', categoryId: 'c2', name: 'House Cleaning', description: 'Full house cleaning service', price: 1000, isAvailable: true),
  Service(id: 's203', categoryId: 'c2', name: 'RO Water Service', description: 'Filter change, repair', price: 250, isAvailable: true),
  Service(id: 's204', categoryId: 'c2', name: 'Pest Control', description: 'Termite and insect control', price: 1200, isAvailable: true),
  Service(id: 's205', categoryId: 'c2', name: 'AC Repair', description: 'Service and gas filling', price: 600, isAvailable: true),

  // 3. Daily Help
  Service(id: 's301', categoryId: 'c3', name: 'Water Can Delivery', description: '20L water can delivery', price: 40, isAvailable: true),
  Service(id: 's302', categoryId: 'c3', name: 'Milk Delivery', description: 'Fresh milk supply morning/evening', price: 60, isAvailable: true),
  Service(id: 's303', categoryId: 'c3', name: 'Grocery Pickup', description: 'Buy and deliver groceries', price: 100, isAvailable: true),
  Service(id: 's304', categoryId: 'c3', name: 'Elder Assistance', description: 'Helping elders with daily tasks', price: 200, isAvailable: true),
  Service(id: 's305', categoryId: 'c3', name: 'Cooking Help', description: 'Cooking for functions or daily', price: 400, isAvailable: true),

  // 4. Agriculture Needs
  Service(id: 's401', categoryId: 'c4', name: 'Tractor Booking', description: 'Ploughing, transport', price: 1500, isAvailable: true),
  Service(id: 's402', categoryId: 'c4', name: 'Farm Labour', description: 'Daily wage workers for farm', price: 600, isAvailable: true),
  Service(id: 's403', categoryId: 'c4', name: 'Spraying Service', description: 'Pesticide/Fertilizer spraying', price: 500, isAvailable: true),
  Service(id: 's404', categoryId: 'c4', name: 'Borewell / Motor', description: 'Repair motor, borewell issues', price: 800, isAvailable: true),
  Service(id: 's405', categoryId: 'c4', name: 'Harvest Helpers', description: 'Labour for harvesting', price: 700, isAvailable: true),

  // 5. Part-time / On-spot Work
  Service(id: 's501', categoryId: 'c5', name: '1-Day Farm Labour', description: 'Urgent farm help', price: 600, isAvailable: true),
  Service(id: 's502', categoryId: 'c5', name: 'Event Helpers', description: 'Help in marriages/functions', price: 500, isAvailable: true),
  Service(id: 's503', categoryId: 'c5', name: 'Loading / Unloading', description: 'Heavy lifting work', price: 400, isAvailable: true),
  Service(id: 's504', categoryId: 'c5', name: 'Shop Helper', description: 'Temporary shop assistance', price: 300, isAvailable: true),
  Service(id: 's505', categoryId: 'c5', name: 'Festival Workers', description: 'Special work during festivals', price: 600, isAvailable: true),
];
