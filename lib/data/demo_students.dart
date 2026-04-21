import '../models/student.dart';

// Local demo accounts for presentation/testing.
// No backend, database, or authentication service is used.
final List<Student> demoStudents = [
  Student(
    fullName: 'MOHAMMED ZOALKEFL MOHAMMED HUSSEN',
    matric: 'AI240276',
    email: 'ai240276@uthm.edu.my',
    password: '1234',
    profileImagePath: null,
  ),
  Student(
    fullName: 'OMER JAMAL OMER ELJACK',
    matric: 'BI230046',
    email: 'bi230046@uthm.edu.my',
    password: '1234',
    profileImagePath: null,
  ),
  Student(
    fullName: 'AMRO EZELDIN MOHAMED SAEED',
    matric: 'AI240275',
    email: 'ai240275@uthm.edu.my',
    password: '1234',
    profileImagePath: null,
  ),
  Student(
    fullName: 'MOHANAD HAFIZ BAKHIT MOHAMED',
    matric: 'BI230087',
    email: 'bi230087@uthm.edu.my',
    password: '1234',
    profileImagePath: null,
  ),
  Student(
    fullName: 'ELSAMANI AHMED MOHAMMEDELNOUR ELKHALIFA',
    matric: 'AI240267',
    email: 'ai240267@uthm.edu.my',
    password: '1234',
    profileImagePath: null,
  ),
  Student(
    fullName: 'AHMED ATIF ELTAYEB ELBADRI',
    matric: 'BI230029',
    email: 'bi230029@uthm.edu.my',
    password: '1234',
    profileImagePath: null,
  ),
  Student(
    fullName: 'OSMAN MOHAMED OSMAN HASSAN',
    matric: 'AI240270',
    email: 'ai240270@uthm.edu.my',
    password: '1234',
    profileImagePath: null,
  ),
];

Student? findDemoStudentByCredentials({
  required String email,
  required String password,
}) {
  final normalizedEmail = email.trim().toLowerCase();

  for (final student in demoStudents) {
    if (student.email == normalizedEmail && student.password == password) {
      return student;
    }
  }

  return null;
}
