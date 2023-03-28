import 'dart:math';

// generate a Random name String ("FirstName LastName")
String generateRandomString(int fNameLength, int lNameLength) {
  var random = Random();
  const charset = 'abcdefghijklmnopqrstuvwxyz';
  String fName = List.generate(fNameLength, (_) => charset[random.nextInt(charset.length)]).join();
  String lName = List.generate(lNameLength, (_) => charset[random.nextInt(charset.length)]).join();
  fName = fName.replaceFirst(fName[0], fName[0].toUpperCase());
  lName = lName.replaceFirst(lName[0], lName[0].toUpperCase());
  //print('$fName $lName');
  return '$fName $lName';
}

