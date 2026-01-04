import 'package:flutter_riverpod/flutter_riverpod.dart';

class PromoCode {
  final String code;
  final String title;
  final String description;
  final double discountPercent;
  final DateTime expiryDate;
  final bool isUsed;

  const PromoCode({
    required this.code,
    required this.title,
    required this.description,
    required this.discountPercent,
    required this.expiryDate,
    this.isUsed = false,
  });

  PromoCode copyWith({
    String? code,
    String? title,
    String? description,
    double? discountPercent,
    DateTime? expiryDate,
    bool? isUsed,
  }) {
    return PromoCode(
      code: code ?? this.code,
      title: title ?? this.title,
      description: description ?? this.description,
      discountPercent: discountPercent ?? this.discountPercent,
      expiryDate: expiryDate ?? this.expiryDate,
      isUsed: isUsed ?? this.isUsed,
    );
  }
}

class DiscountState {
  final PromoCode? appliedPromo;
  final List<PromoCode> availablePromos;

  const DiscountState({
    this.appliedPromo,
    this.availablePromos = const [],
  });

  DiscountState copyWith({
    PromoCode? appliedPromo,
    List<PromoCode>? availablePromos,
    bool clearAppliedPromo = false,
  }) {
    return DiscountState(
      appliedPromo:
          clearAppliedPromo ? null : (appliedPromo ?? this.appliedPromo),
      availablePromos: availablePromos ?? this.availablePromos,
    );
  }
}

class DiscountNotifier extends StateNotifier<DiscountState> {
  DiscountNotifier()
      : super(DiscountState(
          availablePromos: [
            PromoCode(
              code: 'DISKON20',
              title: 'Diskon 20%',
              description: 'Diskon 20% untuk semua rental kendaraan',
              discountPercent: 20,
              expiryDate: DateTime(2026, 12, 31),
            ),
            PromoCode(
              code: 'NEWYEAR2026',
              title: 'Promo Tahun Baru',
              description: 'Diskon 15% spesial tahun baru 2026',
              discountPercent: 15,
              expiryDate: DateTime(2026, 1, 31),
            ),
            PromoCode(
              code: 'MEMBER10',
              title: 'Diskon Member',
              description: 'Diskon 10% untuk member setia',
              discountPercent: 10,
              expiryDate: DateTime(2026, 6, 30),
            ),
          ],
        ));

  void applyPromo(PromoCode promo) {
    state = state.copyWith(appliedPromo: promo);
  }

  void removePromo() {
    state = state.copyWith(clearAppliedPromo: true);
  }

  bool applyPromoCode(String code) {
    final promo = state.availablePromos.firstWhere(
      (p) => p.code.toUpperCase() == code.toUpperCase() && !p.isUsed,
      orElse: () => PromoCode(
        code: '',
        title: '',
        description: '',
        discountPercent: 0,
        expiryDate: DateTime(2000),
      ),
    );

    if (promo.code.isNotEmpty && promo.expiryDate.isAfter(DateTime.now())) {
      state = state.copyWith(appliedPromo: promo);
      return true;
    }
    return false;
  }

  double calculateDiscount(double totalPrice) {
    if (state.appliedPromo != null) {
      return totalPrice * (state.appliedPromo!.discountPercent / 100);
    }
    return 0;
  }

  double calculateFinalPrice(double totalPrice) {
    return totalPrice - calculateDiscount(totalPrice);
  }
}

final discountProvider =
    StateNotifierProvider<DiscountNotifier, DiscountState>((ref) {
  return DiscountNotifier();
});

// Computed providers
final appliedPromoProvider = Provider<PromoCode?>((ref) {
  return ref.watch(discountProvider).appliedPromo;
});

final availablePromosProvider = Provider<List<PromoCode>>((ref) {
  return ref.watch(discountProvider).availablePromos;
});
