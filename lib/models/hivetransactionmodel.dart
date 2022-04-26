import 'package:hive/hive.dart';

part 'hivetransactionmodel.g.dart';

@HiveType(typeId: 1)
class HiveTransactions {

  HiveTransactions({required this.amount,required this.description,required this.dateTime});
  @HiveField(0)
  int amount;

  @HiveField(1)
  String description;

  @HiveField(2)
  DateTime dateTime;
}
