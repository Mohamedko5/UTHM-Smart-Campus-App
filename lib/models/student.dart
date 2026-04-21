class Student {
  const Student({
    required this.fullName,
    required this.matric,
    required this.email,
    required this.password,
    this.profileImagePath,
  });

  final String fullName;
  final String matric;
  final String email;
  final String password;

  // Later you can point this to an asset, for example:
  // assets/images/students/ai240276.png
  final String? profileImagePath;
}
