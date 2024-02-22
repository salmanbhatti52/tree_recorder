class SignUpLogInClass {
  int? users_customer_id;
  String? username,
      verify_code,
      users_customer_name,
      email,
      password,
      date_added,
      status;

  SignUpLogInClass({
    this.username,
    this.users_customer_name,
    this.status,
    this.date_added,
    this.password,
    this.users_customer_id,
    this.email,
    this.verify_code,
  });

  Map<String, dynamic> toMap() {
    return {
      'users_customer_id': users_customer_id,
      'users_customer_name': users_customer_name,
      'username': username,
      'email': email,
      'password': password,
      'verify_code': verify_code,
      'date_added': date_added,
      'status': status,
    };
  }

  factory SignUpLogInClass.fromMap(Map<String, dynamic> map) {
    return SignUpLogInClass(
      users_customer_id: map['users_customer_id'] ?? -1,
      users_customer_name: map['users_customer_name'] ?? -1,
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      verify_code: map['verify_code'] ?? '',
      date_added: map['date_added'] ?? '',
      status: map['status'] ?? '',
    );
  }
}
