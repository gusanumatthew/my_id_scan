// business_card_model.dart (or wherever BusinessCardData is defined)

class BusinessCardData {
  final String? firstName;
  final String? lastName;
  final String? company;
  final String? title;
  final List<String> phoneNumbers;
  final List<String> emails;
  final List<String> websites;
  final String? address;
  final String? matricNumber;
  final String? session;
  final String? level;
  final String? faculty;
  final String? department;
  final String rawText;

  BusinessCardData({
    this.firstName,
    this.lastName,
    this.company,
    this.title,
    this.phoneNumbers = const [],
    this.emails = const [],
    this.websites = const [],
    this.address,
    this.matricNumber,
    this.session,
    this.level,
    this.faculty,
    this.department,
    required this.rawText,
  });

  factory BusinessCardData.fromText(String text) {
    print('Raw OCR Text: $text'); // Debug print

    if (text.trim().isEmpty) {
      return BusinessCardData(rawText: text);
    }

    final lines = text
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    // Use existing generic methods for contact info
    final phoneNumbers = _extractPhoneNumbers(text);
    final emails = _extractEmails(text);
    final websites = _extractWebsites(text);

    String? firstName;
    String? lastName;
    String? company;
    String? title;
    String? address;
    String? matricNumber;
    String? session;
    String? level;
    String? faculty;
    String? department;

    // Stage 1 & 2: Prioritized Extraction for ID Card fields
    final extractedData = _extractIDCardFields(lines, text);

    matricNumber = extractedData['matricNumber'];
    session = extractedData['session'];
    level = extractedData['level'];
    faculty = extractedData['faculty'];
    department = extractedData['department'];

    // Name is split into surname and other names on the card
    lastName = extractedData['lastName'];
    firstName = extractedData['firstName'];

    // Company/Institution/Address
    company = extractedData['company'];
    address = extractedData['address'];

    // Fallback/Cleanup for names that might not have been labeled well
    if (firstName == null && lastName == null) {
      final heuristicData = _extractHeuristicData(lines);
      firstName = heuristicData['firstName'];
      lastName = heuristicData['lastName'];
    }

    // Post-processing validation and cleanup
    firstName = _cleanAndValidateName(firstName);
    lastName = _cleanAndValidateName(lastName);
    company = _cleanAndValidateCompany(company);
    title = _cleanAndValidateTitle(title);

    return BusinessCardData(
      firstName: firstName,
      lastName: lastName,
      company: company,
      title: title,
      phoneNumbers: phoneNumbers,
      emails: emails,
      websites: websites,
      address: address,
      matricNumber: matricNumber,
      session: session,
      level: level,
      faculty: faculty,
      department: department,
      rawText: text,
    );
  }

  // ----------------------------------------------------------------------
  // NEW/MODIFIED EXTRACTION LOGIC
  // ----------------------------------------------------------------------

  // Combined Stage 1 & 2 for ID card specific fields
  static Map<String, String?> _extractIDCardFields(
      List<String> lines, String fullText) {
    String? firstName;
    String? lastName;
    String? company;
    String? address;
    String? matricNumber;
    String? session;
    String? level;
    String? faculty;
    String? department;

    // Search for the institution on the first lines
    final institutionMatch =
        RegExp(r'(THE\s+)?POLYTECHNIC,\s+IBADAN', caseSensitive: false)
            .firstMatch(fullText);
    if (institutionMatch != null) {
      company = institutionMatch.group(0)?.toUpperCase();
    }

    // Fallback company if not found above
    if (company == null) {
      final lineOne = lines.isNotEmpty ? lines[0] : '';
      if (_isInstitutionName(lineOne)) {
        company = lineOne;
      }
    }

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      final lowerLine = line.toLowerCase();

      // 1. Session (Pattern matching: YYYY - YYYY or YYYY-YYYY)
      if (session == null) {
        final sessionMatch =
            RegExp(r'(20\d{2}\s*[\-\/]\s*20\d{2})').firstMatch(line);
        if (sessionMatch != null) {
          session = sessionMatch.group(1);
        }
      }

      // 2. Matric Number (Labeled or Pattern 8+ digits)
      if (matricNumber == null) {
        if (_matchesFieldLabel(
            lowerLine, ['matric no', 'matric number', 'id number'])) {
          matricNumber = _extractFieldValue(line, lines, i);
        }
        // Fallback pattern for 8-15 digit number
        final matricPatternMatch = RegExp(r'\b(\d{8,15})\b').firstMatch(line);
        if (matricNumber == null &&
            matricPatternMatch != null &&
            matricPatternMatch.group(1) != '2024') {
          // Avoid picking up years
          matricNumber = matricPatternMatch.group(1);
        }
      }

      // 3. Names
      if (_matchesFieldLabel(lowerLine, ['surname', 'last name']) &&
          lastName == null) {
        lastName = _extractFieldValue(line, lines, i);
      } else if (_matchesFieldLabel(
              lowerLine, ['other names', 'first name', 'given name']) &&
          firstName == null) {
        firstName = _extractFieldValue(line, lines, i);
      }

      // 4. Faculty
      if (_matchesFieldLabel(lowerLine, ['faculty', 'facutty']) &&
          faculty == null) {
        faculty = _extractFieldValue(line, lines, i);
      }

      // 5. Department
      if (_matchesFieldLabel(lowerLine, ['department', 'dept']) &&
          department == null) {
        department = _extractFieldValue(line, lines, i);
      }

      // 6. Level (HNDII, NDII)
      if (level == null) {
        if (_matchesFieldLabel(lowerLine, ['level', 'class'])) {
          level = _extractFieldValue(line, lines, i);
        }
        // Fallback pattern
        final levelMatch =
            RegExp(r'\b(HNDII|NDII|HND I|ND I)\b', caseSensitive: false)
                .firstMatch(line);
        if (level == null && levelMatch != null) {
          level = levelMatch.group(1)?.toUpperCase();
        }
      }

      // 7. Address (P.M.B 22, U. I POST OFFICE...)
      if (_matchesFieldLabel(lowerLine, ['p.m.b', 'post office', 'ibadan']) &&
          address == null) {
        address = _extractFieldValue(line, lines, i);
      }
    }

    return {
      'firstName': firstName,
      'lastName': lastName,
      'company': company,
      'address': address,
      'matricNumber': matricNumber,
      'session': session,
      'level': level,
      'faculty': faculty,
      'department': department,
    };
  }

  // Helper method for field label matching
  static bool _matchesFieldLabel(String line, List<String> labels) {
    return labels.any((label) =>
        line.contains(label) ||
        line.startsWith('$label:') ||
        line.startsWith('$label ') ||
        line.endsWith(':'));
  }

  // Improved method to extract the value
  static String? _extractFieldValue(
      String line, List<String> lines, int currentIndex) {
    // 1. Extract from same line after colon (e.g., 'Matric No: 2018705010070')
    final colonIndex = line.indexOf(':');
    if (colonIndex != -1 && colonIndex < line.length - 1) {
      final value = line.substring(colonIndex + 1).trim();
      if (_isValidFieldValue(value)) {
        return value;
      }
    }

    // 2. Extract from same line after field label (no colon)
    final lowerLine = line.toLowerCase();
    final fieldLabels = [
      'surname',
      'other names',
      'faculty',
      'department',
      'level',
      'matric no',
      'session',
    ];

    for (final label in fieldLabels) {
      final labelIndex = lowerLine.indexOf(label);
      if (labelIndex != -1) {
        final afterLabel = line.substring(labelIndex + label.length).trim();
        final cleanValue =
            afterLabel.replaceFirst(RegExp(r'^[:\s\.]+'), '').trim();
        if (_isValidFieldValue(cleanValue)) {
          return cleanValue;
        }
      }
    }

    // 3. Extract from the next line if the current line is mostly a label
    if (currentIndex + 1 < lines.length &&
        (line.endsWith(':') || line.length < 15)) {
      final nextLine = lines[currentIndex + 1].trim();
      if (_isValidFieldValue(nextLine) &&
          !_isFieldLabel(nextLine) &&
          nextLine.length < 50) {
        return nextLine;
      }
    }

    return null;
  }

  // ** (Keep other helper methods like _extractPhoneNumbers, _extractEmails,
  //     _isValidFieldValue, _cleanAndValidateName, _extractHeuristicData, etc., as they are
  //     or replace them with your original implementation.) **

  static bool _isValidFieldValue(String value) {
    return value.isNotEmpty &&
        value.length > 1 &&
        !_isFieldLabel(value) &&
        value != ':' &&
        !RegExp(r'^[:;,.\-/\s]+$').hasMatch(value) &&
        value.toLowerCase() != 'student'; // Filter out the 'STUDENT' label
  }

  // (Include all other static methods like _extractPhoneNumbers, _extractEmails,
  //  _extractWebsites, _extractHeuristicData, _cleanAndValidateName, etc.)

  // Placeholder methods to satisfy the class definition (replace with your originals)
  static Map<String, String?> _extractHeuristicData(List<String> lines) {
    return {};
  }

  static List<String> _extractPhoneNumbers(String text) {
    return [];
  }

  static List<String> _extractEmails(String text) {
    return [];
  }

  static List<String> _extractWebsites(String text) {
    return [];
  }

  static String? _cleanAndValidateName(String? name) {
    return name;
  }

  static String? _cleanAndValidateCompany(String? company) {
    return company;
  }

  static String? _cleanAndValidateTitle(String? title) {
    return title;
  }

  static bool _isFieldLabel(String text) {
    return false;
  }

  static bool _isInstitutionName(String text) {
    return text.toLowerCase().contains('polytechnic') ||
        text.toLowerCase().contains('ibadan');
  }
}
