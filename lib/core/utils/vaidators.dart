



import 'package:myid_scan/core/extensions/string_extensions.dart';

class Validators {
  static final emailPattern = RegExp(
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@"
    '[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}'
    r'[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}'
    r'[a-zA-Z0-9])?)+\s*$',
  );

  static final phonePattern = RegExp("^(\\08|09|07|[7-9])\\d{9}\$");

  static final urlPattern = RegExp(
  r'^(https?://)?(www\.)?'
  r'[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?'
  r'(\.[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*'
  r'(\.[a-zA-Z]{2,})'
  r'(:\d+)?'
  r'(/[^\s]*)?$',
);

static Validator url([String? text, bool requireProtocol = false]) {
  return (String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; 
    }

    String url = value.trim().toLowerCase();
    
    
    if (!requireProtocol && !url.startsWith(RegExp(r'https?://'))) {
      url = 'https://$url';
    }

  
    if (urlPattern.hasMatch(url)) {
      return null;
    }

    return text ?? 'Please enter a valid web link or social media URL';
  };
}

  static Validator notEmpty() {
    return (String? value) {
      return (value?.isEmpty ?? true) ? 'This field can not be empty.' : null;
    };
  }

  static Validator confirmPass(String val1, String val2) {
    return (String? value) {
      if (val1 != val2) {
        return 'Passwords do not match';
      } else {
        return null;
      }
    };
  }

  static Validator pin() {
    return (String? value) {
      return (value!.length < 4) ? 'Invalid Pin' : null;
    };
  }

  static Validator confirmPin(String val1, String val2) {
    return (String? value) {
      if (val1 != val2) {
        return 'Pins do not match';
      } else {
        return null;
      }
    };
  }

  static Validator passcode() {
    return (String? value) {
      return (value!.length < 6) ? 'Invalid Pin' : null;
    };
  }

  static Validator phone([String? text]) {
    return (String? value) {
      if (value == null) {
        return null;
      }
      return !phonePattern.hasMatch(value)
          ? (text ?? 'Invalid phone number')
          : null;
    };
  }

  static Validator withdrawSafe(num safeAmount) {
    return (value) {
      if (value == null) {
        return 'This field can not be empty.';
      }
      if (num.parse(value) > safeAmount) {
        return "You can't withdraw more than your safe lock balance";
      }
      return null;
    };
  }

  static Validator date() {
    return (String? input) {
     
      final numericInput = input!.replaceAll(RegExp(r'\D'), '');

    
      if (numericInput.length != 8) {
        return 'Invalid date';
      }

      final day = int.tryParse(numericInput.substring(0, 2));
      final month = int.tryParse(numericInput.substring(2, 4));
      final year = int.tryParse(numericInput.substring(4, 8));

      if (day == null || month == null || year == null) {
        return 'Invalid date';
      }

      if (day > 29 && month == 2) {
        return 'Invalid february date';
      }

     
      if (day < 1 || day > 31 || month < 1 || month > 12 || year < 1900) {
        return 'Invalid date';
      }

     

      return null;
    };
  }

  static Validator name() {
    return (String? value) {
      if (value!.isEmpty) {
        return 'Field cannot be empty.';
      }
      if (!value.contains(' ')) {
        return 'Seperate names with spaces';
      }
      return null;
    };
  }

  static Validator minLength(int minLength) {
    return (String? value) {
      if ((value?.length ?? 0) < minLength) {
        return 'Must contain a minimum of $minLength characters.';
      }
      return null;
    };
  }

  static bool isValid(String pin, String pin2) =>
      pin.isNotEmpty && pin2.isNotEmpty && pin == pin2;

  static Validator matchPattern(
    Pattern pattern, [
    String? patternName,
    String? text,
  ]) {
    return (String? value) {
      if (value == null || (pattern.allMatches(value).isEmpty)) {
        return text ?? "Please enter a valid ${patternName ?? "value"}.";
      }
      return null;
    };
  }

  static Validator email([String? text]) {
    return matchPattern(emailPattern, 'email', text);
  }

  static Validator password([int minimumLength = 8]) => multiple(
        [
          containsUpper('Password'),
          containsLower('Password'),
          containsNumber('Password'),
          containsSpecialChar('Password'),
          minLength(minimumLength),
        ],
        shouldTrim: false,
      );

  static Validator containsUpper([String? fieldName]) {
    return (String? value) {
      if (value != null && value.containsUpper()) return null;
      return "${fieldName ?? 'Field'} must contain at least one uppercase character.";
    };
  }

  static Validator containsLower([String? fieldName]) {
    return (String? value) {
      if (value != null && value.containsLower()) return null;
      return "${fieldName ?? 'Field'} must contain at least one lowercase character.";
    };
  }

  static Validator containsNumber([String? fieldName]) {
    return (String? value) {
      if (value != null && value.containsNumber()) return null;
      return "${fieldName ?? 'Field'} must contain at least one number.";
    };
  }

  static Validator containsSpecialChar([String? fieldName]) {
    return (String? value) {
      if (value != null && value.containsSpecialChar()) return null;
      return "${fieldName ?? 'Field'} must contain at least one special character.";
    };
  }


  static Validator multiple(
    List<Validator> validators, {
    bool shouldTrim = true,
  }) {
    return (String? value) {
      value = shouldTrim ? value?.trim() : value;
      for (final validator in validators) {
        if (validator(value) != null) {
          return validator(value);
        }
      }
      return null;
    };
  }

  static String getCleanedNumber(String text) {
    final regExp = RegExp('[^0-9]');
    return text.replaceAll(regExp, '');
  }

  static String? Function(String? input) validateCardNum() {
    return (String? input) {
      if (input == null || input.isEmpty) {
        return 'This field is required';
      }
      input = getCleanedNumber(input);
      if (input.length < 8) {
        return 'Card is invalid';
      }
      var sum = 0;
      final length = input.length;
      for (var i = 0; i < length; i++) {
      
        var digit = int.parse(input[length - i - 1]);

        if (i.isOdd) {
          digit *= 2;
        }
        sum += digit > 9 ? (digit - 9) : digit;
      }
      if (sum % 10 == 0) {
        return null;
      }
      return 'Card is invalid';
    };
  }

  static String? Function(String? value) validateCVV() {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return 'This field is required';
      }
      if (value.length < 3 || value.length > 3) {
        return 'CVV is invalid';
      }
      return null;
    };
  }

  static String? Function(String? value) validateDate() {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return 'This field is required';
      }
      int year;
      int month;
      if (value.contains(RegExp('(/)'))) {
        final split = value.split(RegExp('(/)'));

        month = int.parse(split[0]);
        year = int.parse(split[1]);
      } else {
        month = int.parse(value.substring(0, value.length));
        year = -1; 
      }
      if ((month < 1) || (month > 12)) {
      
        return 'Expiry month is invalid';
      }

      if (!hasDateExpired(month, year)) {
        return 'Card has expired';
      }
      return null;
    };
  }

  static int convertYearTo4Digits(int year) {
    if (year < 100 && year >= 0) {
      final now = DateTime.now();
      final currentYear = now.year.toString();
      final prefix = currentYear.substring(0, currentYear.length - 2);
      year = int.parse('$prefix${year.toString().padLeft(2, '0')}');
    }
    return year;
  }

  static bool hasDateExpired(int month, int year) {
    return isNotExpired(year, month);
  }

  static bool isNotExpired(int year, int month) {
 
    return !hasYearPassed(year) && !hasMonthPassed(year, month);
  }

  static List<int> getExpiryDate(String value) {
    final split = value.split(RegExp('(/)'));
    return [int.parse(split[0]), int.parse(split[1])];
  }

  static bool hasMonthPassed(int year, int month) {
    final now = DateTime.now();
    // The month has passed if:
    // 1. The year is in the past. In that case, we just assume that the month
    // has passed
    // 2. Card's month (plus another month) is more than current month.
    return hasYearPassed(year) ||
        convertYearTo4Digits(year) == now.year && (month < now.month + 1);
  }

  static bool hasYearPassed(int year) {
    final fourDigitsYear = convertYearTo4Digits(year);
    final now = DateTime.now();
    // The year has passed if the year we are currently is more than card's
    // year
    return fourDigitsYear < now.year;
  }
}

typedef Validator = String? Function(String? value);
