import 'dart:convert';

class UserModel {

  final double balance;
  final String userModelID;
  final String userModelName;
  
  UserModel({
    this.balance = 0.0,
    required this.userModelID,
    required this.userModelName,
  });

  UserModel copyWith({
    double? balance,
    String? userModelID,
    String? userModelName,
  }) {
    return UserModel(
      balance: balance ?? this.balance,
      userModelID: userModelID ?? this.userModelID,
      userModelName: userModelName ?? this.userModelName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'balance': balance,
      'userModelID': userModelID,
      'userModelName': userModelName,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      balance: map['balance'] as double,    // map['balance']?.toDouble() ?? 0.0,
      userModelID: map['userModelID'] as String,      // map['userModelID'] ?? '',
      userModelName: map['userModelName'] as String,  // map['userModelName'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'UserModel(balance: $balance, userModelID: $userModelID, userModelName: $userModelName)';

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.balance == balance &&
      other.userModelID == userModelID &&
      other.userModelName == userModelName;
  }

  @override
  int get hashCode => balance.hashCode ^ userModelID.hashCode ^ userModelName.hashCode;
}
