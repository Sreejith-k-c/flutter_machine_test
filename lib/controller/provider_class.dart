import 'package:flutter/material.dart';
import 'package:flutter_machine_test/model/model.dart';

class GiftCardProvider extends ChangeNotifier {
  GiftCard? _giftCard;
  double _amount = 50.0;
  int _quantity = 1;
  String? _errorMessage;

  GiftCard? get giftCard => _giftCard;
  double get amount => _amount;
  int get quantity => _quantity;
  String? get errorMessage => _errorMessage;

  double get discountPercent => _giftCard?.discounts.first.percent ?? 0;
  
  double get discountAmount => _amount * (discountPercent / 100);
  
  double get youPay => (_amount - discountAmount) * _quantity;
  
  double get savings => discountAmount * _quantity;
  
  bool get isAmountValid {
    if (_giftCard == null) return false;
    return _amount >= _giftCard!.minAmount && _amount <= _giftCard!.maxAmount;
  }
  
  bool get isPayButtonEnabled {
    if (_giftCard == null) return false;
    return !_giftCard!.disablePurchase && isAmountValid;
  }

  bool get disablePurchase => _giftCard?.disablePurchase ?? false;

  // Methods
  Future<void> loadGiftCard() async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    
    final mockJson = {
      "id": "zepo-100",
      "title": "Zepo Instant Voucher",
      "minAmount": 50,
      "maxAmount": 10000,
      "disablePurchase": false,
      "discounts": [
        {
          "method": "UPT",
          "percent": 4
        }
      ],
      "redeemSteps": [
        {
          "method": "Zepo Platform",
          "step1": "login to Zepo profile / Settings",
          "step2": "click on My Profile & Gift Card",
          "step3": "Go to Zepo Cash & Gift Card",
          "step4": "Click on Add Card option"
        }
      ]
    };
    
    _giftCard = GiftCard.fromJson(mockJson);
    _amount = _giftCard!.minAmount; // Set initial amount to min
    notifyListeners();
  }

  void updateAmount(double newAmount) {
    _amount = newAmount;
    _validateAmount();
    notifyListeners();
  }

  void updateQuantity(int newQuantity) {
    _quantity = newQuantity;
    notifyListeners();
  }

  void _validateAmount() {
    if (_giftCard == null) return;
    
    if (_amount < _giftCard!.minAmount) {
      _errorMessage = 'Amount must be at least ${_giftCard!.minAmount}';
    } else if (_amount > _giftCard!.maxAmount) {
      _errorMessage = 'Amount cannot exceed ${_giftCard!.maxAmount}';
    } else {
      _errorMessage = null;
    }
  }

  void incrementQuantity() {
    _quantity++;
    notifyListeners();
  }

  void decrementQuantity() {
    if (_quantity > 1) {
      _quantity--;
      notifyListeners();
    }
  }
}