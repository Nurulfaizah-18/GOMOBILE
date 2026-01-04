class AppConstants {
  // API Base URL
  static const String baseUrl = 'https://api.rental-kendaraan.com/api/v1/';

  // API Endpoints
  static const String vehiclesEndpoint = 'vehicles';
  static const String categoriesEndpoint = 'categories';
  static const String ordersEndpoint = 'orders';
  static const String paymentsEndpoint = 'payments';

  // Local Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String cartKey = 'cart_items';
  static const String favoritesKey = 'favorites';

  // Duration
  static const Duration apiTimeout = Duration(seconds: 30);

  // Pagination
  static const int pageSize = 10;

  // Vehicle Categories
  static const List<String> vehicleCategories = [
    'Semua',
    'Mobil Keluarga',
    'Mobil Sport',
    'Mobil Mewah',
    'Motor',
  ];

  // Default Values
  static const double defaultMinPrice = 0.0;
  static const double defaultMaxPrice = 10000000.0;
  static const int defaultMaxRentalDays = 365;
}
