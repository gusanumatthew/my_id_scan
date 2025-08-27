import 'package:intl/intl.dart';

extension CharacterValidation on String {
  bool containsUpper() {
    for (var i = 0; i < length; i++) {
      final code = codeUnitAt(i);
      if (code >= 65 && code <= 90) return true;
    }
    return false;
  }

  bool containsLower() {
    for (var i = 0; i < length; i++) {
      final code = codeUnitAt(i);
      if (code >= 97 && code <= 122) return true;
    }
    return false;
  }

  bool containsSpecialChar() {
    for (var i = 0; i < length; i++) {
      final char = this[i];
      if (r'#?!@$%^&*-_.,/[]{}|;:+='.contains(char)) return true;
    }
    return false;
  }

  bool containsUsernameSpecial() {
    for (var i = 0; i < length; i++) {
      final char = this[i];
      // ignore: prefer_single_quotes
      if (r"#?!@$%^&*,/[]{}|;:+=".contains(char)) return true;
    }
    return false;
  }

  bool containsNumber() {
    for (var i = 0; i < length; i++) {
      final code = codeUnitAt(i);
      if (code >= 48 && code <= 57) return true;
    }
    return false;
  }

  String reArrangeDOB(String pattern, [String newPattern = '-']) {
    return split(pattern).reversed.join(newPattern);
  }

  String get capitalizeFirst {
    return isNotEmpty ? this[0].toUpperCase() + substring(1) : this;
  }

  String get capiTalizeFirstLast {
    return this[0].toUpperCase() + substring(1);
  }

  String get capitalizeFullname {
    if (isEmpty) return this;

    final words = split(' ');
    for (var i = 0; i < words.length; i++) {
      if (words[i].isNotEmpty) {
        words[i] = words[i][0].toUpperCase() + words[i].substring(1);
      }
    }

    return words.join(' ');
  }

  String get firstName {
    return split(' ').first;
  }

  String get obscuredMail {
    var newString = '';
    final List<String> emailList = split("");
    for (var i = 0; i < emailList.length; i++) {
      if (i != 0 && emailList[i] != '@' && i < indexOf('.')) {
        emailList[i] = '*';
        newString = emailList.join();
      }
    }
    return newString;
  }

  String get initials {
    final name = split(' ');

    if (name.isEmpty || name[0].isEmpty) return '';

    if (name.length > 1) {
      final firstInitial = name[0].isNotEmpty ? name[0][0] : '';
      final secondInitial = name[1].isNotEmpty ? name[1][0] : '';
      return '$firstInitial$secondInitial'.toUpperCase();
    }

    // If the name has only one word and is long enough, return the second letter
    return name[0].length > 1 ? name[0][1].toUpperCase() : '';
  }

  String removeCommas() {
    if (contains(',')) {
      return replaceAll(',', '');
    } else {
      return this;
    }
  }

  String get first10Characters {
    if (length <= 10) {
      return this;
    }
    return '${substring(0, 10)}...';
  }

  DateTime? toDateTime() {
    try {
      return DateFormat("dd/MM/yyyy").parse(this);
    } catch (e) {
      return null;
    }
  }

  String removePlus() {
    return startsWith('+') ? substring(1) : this;
  }

  String get toSentenceCase {
    if (isEmpty) return this;

    String withSpaces = replaceAll('_', ' ');

    String lowercase = withSpaces.toLowerCase();

    return '${lowercase[0].toUpperCase()}${lowercase.substring(1)}';
  }
}
