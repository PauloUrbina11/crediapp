import '../../domain/entities/saved_credit.dart';
import '../../domain/repositories/credit_history_repository.dart';

class InMemoryCreditHistoryRepository implements CreditHistoryRepository {
  final List<SavedCredit> _items = [];

  @override
  Future<void> save(SavedCredit savedCredit) async {
    _items.insert(0, savedCredit);
  }

  @override
  Future<List<SavedCredit>> getAll() async => List.unmodifiable(_items);
}
