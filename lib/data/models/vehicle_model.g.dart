// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleModel _$VehicleModelFromJson(Map<String, dynamic> json) => VehicleModel(
      id: json['id'] as String,
      name: json['name'] as String,
      brand: json['brand'] as String,
      category: $enumDecode(_$VehicleCategoryEnumMap, json['category']),
      fuelType: $enumDecode(_$FuelTypeEnumMap, json['fuelType']),
      transmission:
          $enumDecode(_$TransmissionTypeEnumMap, json['transmission']),
      seats: (json['seats'] as num).toInt(),
      imageUrl: json['imageUrl'] as String,
      pricePerDay: (json['pricePerDay'] as num).toDouble(),
      licensePlate: json['licensePlate'] as String,
      year: (json['year'] as num).toInt(),
      rating: (json['rating'] as num).toDouble(),
      reviewCount: (json['reviewCount'] as num).toInt(),
      isAvailable: json['isAvailable'] as bool,
      description: json['description'] as String,
    );

Map<String, dynamic> _$VehicleModelToJson(VehicleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'brand': instance.brand,
      'category': _$VehicleCategoryEnumMap[instance.category]!,
      'fuelType': _$FuelTypeEnumMap[instance.fuelType]!,
      'transmission': _$TransmissionTypeEnumMap[instance.transmission]!,
      'seats': instance.seats,
      'imageUrl': instance.imageUrl,
      'pricePerDay': instance.pricePerDay,
      'licensePlate': instance.licensePlate,
      'year': instance.year,
      'rating': instance.rating,
      'reviewCount': instance.reviewCount,
      'isAvailable': instance.isAvailable,
      'description': instance.description,
    };

const _$VehicleCategoryEnumMap = {
  VehicleCategory.mobilKeluarga: 'mobilKeluarga',
  VehicleCategory.mobilSport: 'mobilSport',
  VehicleCategory.mobilMewah: 'mobilMewah',
  VehicleCategory.motor: 'motor',
};

const _$FuelTypeEnumMap = {
  FuelType.bensin: 'bensin',
  FuelType.diesel: 'diesel',
  FuelType.hybrid: 'hybrid',
  FuelType.listrik: 'listrik',
};

const _$TransmissionTypeEnumMap = {
  TransmissionType.manual: 'manual',
  TransmissionType.otomatis: 'otomatis',
};
