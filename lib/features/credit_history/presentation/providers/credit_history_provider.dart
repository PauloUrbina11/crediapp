import 'package:flutter/foundation.dart';

import '../../domain/entities/saved_credit.dart';
import '../../domain/repositories/credit_history_repository.dart';

class CreditHistoryProvider extends ChangeNotifier {
  CreditHistoryProvider(this._repository) {
    _load();
  }

  final CreditHistoryRepository _repository;
  List<SavedCredit> _items = [];
  int _nextId = 1;

  List<SavedCredit> get items => _items;

  Future<void> _load() async {
    _items = await _repository.getAll();
    notifyListeners();
  }

  Future<void> save({
    required String creditTypeLabel,
    required double loanAmount,
    required int numberOfMonths,
  }) async {
    final savedCredit = SavedCredit(
      id: (_nextId++).toString(),
      creditTypeLabel: creditTypeLabel,
      loanAmount: loanAmount,
      numberOfMonths: numberOfMonths,
      createdAt: DateTime.now(),
    );
    await _repository.save(savedCredit);
    _items = await _repository.getAll();
    notifyListeners();
  }
}
