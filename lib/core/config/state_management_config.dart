/// Fix untuk Riverpod version mismatch
///
/// Jika mengalami error dengan Riverpod, gunakan ini untuk perbaikan:

// Tambahkan ke pubspec.yaml:
/*
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  flutter_riverpod: ^2.4.0
  riverpod: ^2.4.0
  
  # Navigation & UI
  google_nav_bar: ^5.0.5
  flutter_svg: ^2.0.5
  
  # Date & Time
  intl: ^0.19.0
  
  # Model
  json_annotation: ^4.8.0
  equatable: ^2.0.5
  dartz: ^0.10.1
  
  # HTTP
  dio: ^5.3.0
  
  # Local Storage
  shared_preferences: ^2.2.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.6
  json_serializable: ^6.7.0
*/

// Jika ingin menggunakan Provider bukan Riverpod, ganti dependencies:
/*
dependencies:
  provider: ^6.0.0
  google_nav_bar: ^5.0.5
  intl: ^0.19.0
  json_annotation: ^4.8.0
  equatable: ^2.0.5
  dartz: ^0.10.1
  dio: ^5.3.0
  shared_preferences: ^2.2.0
*/

// Kemudian update provider files:
// lib/presentation/providers/vehicle_provider.dart akan menggunakan Provider bukan Riverpod

/// Provider Implementation (Alternative to Riverpod)
/*

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Vehicle Provider
class VehicleProvider extends ChangeNotifier {
  List<VehicleEntity> _vehicles = [];
  bool _isLoading = false;
  String? _error;
  
  List<VehicleEntity> get vehicles => _vehicles;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  final GetAllVehiclesUsecase _getAllVehiclesUsecase;
  
  VehicleProvider({required GetAllVehiclesUsecase getAllVehiclesUsecase})
    : _getAllVehiclesUsecase = getAllVehiclesUsecase;
  
  Future<void> fetchVehicles() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    final result = await _getAllVehiclesUsecase();
    
    result.fold(
      (exception) {
        _error = exception.toString();
        _isLoading = false;
        notifyListeners();
      },
      (vehicles) {
        _vehicles = vehicles;
        _isLoading = false;
        notifyListeners();
      },
    );
  }
}

// Usage dalam MultiProvider di main.dart:
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => VehicleProvider(
            getAllVehiclesUsecase: GetAllVehiclesUsecase(...),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => DateRangeProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

// Usage dalam Widget:
class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<VehicleProvider>(
      builder: (context, vehicleProvider, _) {
        if (vehicleProvider.isLoading) {
          return LoadingWidget();
        }
        
        if (vehicleProvider.error != null) {
          return ErrorWidget(message: vehicleProvider.error!);
        }
        
        return GridView.builder(
          itemCount: vehicleProvider.vehicles.length,
          itemBuilder: (context, index) {
            return VehicleCard(vehicle: vehicleProvider.vehicles[index]);
          },
        );
      },
    );
  }
}

*/

/// BLOC Implementation (Alternative to Provider/Riverpod)
/*

// Tambahkan ke pubspec.yaml:
dependencies:
  flutter_bloc: ^8.1.3
  bloc: ^8.1.1

// lib/presentation/bloc/vehicle/vehicle_event.dart
abstract class VehicleEvent extends Equatable {
  const VehicleEvent();
  
  @override
  List<Object?> get props => [];
}

class GetAllVehiclesEvent extends VehicleEvent {
  const GetAllVehiclesEvent();
}

class GetVehicleByIdEvent extends VehicleEvent {
  final String vehicleId;
  const GetVehicleByIdEvent(this.vehicleId);
  
  @override
  List<Object?> get props => [vehicleId];
}

// lib/presentation/bloc/vehicle/vehicle_state.dart
abstract class VehicleState extends Equatable {
  const VehicleState();
  
  @override
  List<Object?> get props => [];
}

class VehicleInitial extends VehicleState {
  const VehicleInitial();
}

class VehicleLoading extends VehicleState {
  const VehicleLoading();
}

class VehicleLoaded extends VehicleState {
  final List<VehicleEntity> vehicles;
  const VehicleLoaded(this.vehicles);
  
  @override
  List<Object?> get props => [vehicles];
}

class VehicleError extends VehicleState {
  final String message;
  const VehicleError(this.message);
  
  @override
  List<Object?> get props => [message];
}

// lib/presentation/bloc/vehicle/vehicle_bloc.dart
class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  final GetAllVehiclesUsecase getAllVehiclesUsecase;
  
  VehicleBloc({required this.getAllVehiclesUsecase}) 
    : super(const VehicleInitial()) {
    on<GetAllVehiclesEvent>(_onGetAllVehicles);
  }
  
  Future<void> _onGetAllVehicles(
    GetAllVehiclesEvent event,
    Emitter<VehicleState> emit,
  ) async {
    emit(const VehicleLoading());
    
    final result = await getAllVehiclesUsecase();
    
    result.fold(
      (exception) => emit(VehicleError(exception.toString())),
      (vehicles) => emit(VehicleLoaded(vehicles)),
    );
  }
}

// Usage dalam Widget:
class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VehicleBloc, VehicleState>(
      builder: (context, state) {
        if (state is VehicleLoading) {
          return LoadingWidget();
        }
        
        if (state is VehicleError) {
          return ErrorWidget(message: state.message);
        }
        
        if (state is VehicleLoaded) {
          return GridView.builder(
            itemCount: state.vehicles.length,
            itemBuilder: (context, index) {
              return VehicleCard(vehicle: state.vehicles[index]);
            },
          );
        }
        
        return SizedBox.shrink();
      },
    );
  }
}

// Setup di main.dart dengan MultiBlocProvider
void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => VehicleBloc(
            getAllVehiclesUsecase: GetAllVehiclesUsecase(...),
          )..add(const GetAllVehiclesEvent()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

*/

/// State Management Comparison
/*

┌────────────────┬──────────────────┬────────────────┬──────────────┐
│    Feature     │    Provider      │     Riverpod   │     BLOC     │
├────────────────┼──────────────────┼────────────────┼──────────────┤
│ Learning Curve │ Easy             │ Medium         │ Hard         │
│ Complexity     │ Simple           │ Medium         │ Complex      │
│ Performance    │ Good             │ Very Good      │ Good         │
│ Testability    │ Good             │ Excellent      │ Excellent    │
│ Features       │ Limited          │ Advanced       │ Advanced     │
│ Documentation  │ Good             │ Excellent      │ Excellent    │
│ Community      │ Large            │ Growing        │ Very Large   │
│ Bundle Size    │ Small            │ Medium         │ Medium       │
└────────────────┴──────────────────┴────────────────┴──────────────┘

RECOMMENDATION:
- Untuk aplikasi sederhana: Provider
- Untuk aplikasi medium: Riverpod
- Untuk aplikasi kompleks: BLOC

*/

void setupAndRunApp() {
  // Setup untuk production
  // 1. Configure error handling
  // 2. Setup logging
  // 3. Initialize Firebase
  // 4. Setup notifications
  // 5. Load cached data
  print('Ready to run app');
}
