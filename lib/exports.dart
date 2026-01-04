// ignore_for_file: depend_on_referenced_packages

// Re-export riverpod
export 'package:flutter_riverpod/flutter_riverpod.dart';

// Core exports
export 'core/theme/app_colors.dart';
export 'core/theme/app_theme.dart';
export 'core/constants/app_constants.dart';
export 'core/utils/date_formatter.dart';

// Domain exports
export 'domain/entities/vehicle_entity.dart';
export 'domain/entities/rental_order_entity.dart';
export 'domain/entities/cart_item_entity.dart';
export 'domain/repositories/vehicle_repository.dart';
export 'domain/repositories/order_repository.dart';
export 'domain/usecases/vehicle_usecases.dart';
export 'domain/usecases/order_usecases.dart';

// Data exports
export 'data/datasources/remote/vehicle_remote_datasource.dart';
export 'data/datasources/local/vehicle_local_datasource.dart';
export 'data/models/vehicle_model.dart';
export 'data/repositories/vehicle_repository_impl.dart';
export 'data/repositories/order_repository_impl.dart';

// Presentation exports
export 'presentation/pages/main_page.dart';
export 'presentation/pages/vehicle_detail_page.dart';
export 'presentation/pages/search_page.dart';
export 'presentation/pages/cart_page.dart';
export 'presentation/pages/profile_page.dart';
export 'presentation/pages/landing_page.dart';
export 'presentation/pages/splash_page.dart';
export 'presentation/pages/user_dashboard_page.dart';
export 'presentation/providers/vehicle_provider.dart';
export 'presentation/providers/cart_provider.dart';
export 'presentation/providers/date_range_provider.dart';
export 'presentation/widgets/index.dart';
