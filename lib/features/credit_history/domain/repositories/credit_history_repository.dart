import '../entities/saved_credit.dart';

abstract class CreditHistoryRepository {
  Future<void> save(SavedCredit savedCredit);
  Future<List<SavedCredit>> getAll();
}
