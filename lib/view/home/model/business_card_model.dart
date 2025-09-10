class BusinessCardData {
  final String? firstName;
  final String? lastName;
  final String? company;
  final String? title;
  final List<String> phoneNumbers;
  final List<String> emails;
  final List<String> websites;
  final String? address;
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
    required this.rawText,
  });

  factory BusinessCardData.fromText(String text) {
    final lines =
        text.split('\n').where((line) => line.trim().isNotEmpty).toList();

    final phoneNumbers = _extractPhoneNumbers(text);
    final emails = _extractEmails(text);
    final websites = _extractWebsites(text);

    String? firstName;
    String? lastName;
    String? company;
    String? title;
    String? address;

    // First, try to extract information using field labels (for ID cards)
    final labeledData = _extractLabeledFields(lines);

    if (labeledData['firstName'] != null || labeledData['lastName'] != null) {
      // If we found labeled data, use it
      firstName = labeledData['firstName'];
      lastName = labeledData['lastName'];
      company = labeledData['company'];
      title = labeledData['title'];
      address = labeledData['address'];
    } else {
      // Fall back to heuristic-based extraction (for traditional business cards)
      final potentialLines = <String>[];
      for (final line in lines) {
        final trimmedLine = line.trim();
        if (!_isContactInfo(trimmedLine, phoneNumbers, emails, websites) &&
            !_isAddress(trimmedLine) &&
            !_isFieldLabel(trimmedLine)) {
          potentialLines.add(trimmedLine);
        }
      }

      if (potentialLines.isNotEmpty) {
        final processedLines = _identifyNameAndCompany(potentialLines);
        firstName = processedLines['firstName'];
        lastName = processedLines['lastName'];
        company = processedLines['company'];
        title = processedLines['title'];
      }

      // Extract address using heuristics
      final addressLines = lines
          .where((line) =>
              _isAddress(line.trim()) &&
              !_isContactInfo(line.trim(), phoneNumbers, emails, websites))
          .toList();

      if (addressLines.isNotEmpty) {
        address = addressLines.join(', ');
      }
    }

    return BusinessCardData(
      firstName: firstName,
      lastName: lastName,
      company: company,
      title: title,
      phoneNumbers: phoneNumbers,
      emails: emails,
      websites: websites,
      address: address,
      rawText: text,
    );
  }

  static Map<String, String?> _extractLabeledFields(List<String> lines) {
    String? firstName;
    String? lastName;
    String? company;
    String? title;
    String? address;

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      final lowerLine = line.toLowerCase();

      // Handle different field patterns
      if (_containsFieldLabel(
          lowerLine, ['surname', 'last name', 'family name'])) {
        lastName = _extractFieldValue(line, lines, i);
      } else if (_containsFieldLabel(
          lowerLine, ['other names', 'first name', 'given name', 'names'])) {
        // For "Other Names" field, extract the actual name
        final value = _extractFieldValue(line, lines, i);
        if (value != null && value.toLowerCase() != 'other names') {
          final nameParts = value.split(RegExp(r'\s+'));
          if (nameParts.length >= 2) {
            firstName = nameParts[0];
            lastName ??= nameParts.sublist(1).join(' ');
          } else if (nameParts.length == 1) {
            firstName = nameParts[0];
          }
        }
      } else if (_containsFieldLabel(lowerLine, ['name']) &&
          firstName == null) {
        // Generic name field
        final value = _extractFieldValue(line, lines, i);
        if (value != null && !_isFieldLabel(value)) {
          final nameParts = value.split(RegExp(r'\s+'));
          if (nameParts.length >= 2) {
            firstName = nameParts[0];
            lastName = nameParts.sublist(1).join(' ');
          } else if (nameParts.length == 1) {
            firstName = nameParts[0];
          }
        }
      } else if (_containsFieldLabel(lowerLine, [
        'company',
        'organization',
        'institution',
        'faculty',
        'department'
      ])) {
        company = _extractFieldValue(line, lines, i);
      } else if (_containsFieldLabel(lowerLine,
          ['title', 'position', 'job title', 'level', 'designation'])) {
        title = _extractFieldValue(line, lines, i);
      } else if (_containsFieldLabel(lowerLine, ['address', 'location'])) {
        address = _extractFieldValue(line, lines, i);
      }
    }

    return {
      'firstName': firstName,
      'lastName': lastName,
      'company': company,
      'title': title,
      'address': address,
    };
  }

  static bool _containsFieldLabel(String line, List<String> labels) {
    for (final label in labels) {
      if (line.contains(label)) {
        return true;
      }
    }
    return false;
  }

  static String? _extractFieldValue(
      String line, List<String> lines, int currentIndex) {
    // Try to extract value from the same line first
    final colonIndex = line.indexOf(':');
    if (colonIndex != -1 && colonIndex < line.length - 1) {
      final value = line.substring(colonIndex + 1).trim();
      if (value.isNotEmpty && !_isFieldLabel(value)) {
        return value;
      }
    }

    // Try to extract value from the same line without colon
    final parts = line.split(RegExp(r'\s+'));
    if (parts.length > 1) {
      // Find the label part and take everything after it
      for (int i = 0; i < parts.length - 1; i++) {
        final possibleLabel = parts.sublist(0, i + 1).join(' ').toLowerCase();
        if (_isKnownFieldLabel(possibleLabel)) {
          final value = parts.sublist(i + 1).join(' ');
          if (value.isNotEmpty && !_isFieldLabel(value)) {
            return value;
          }
        }
      }
    }

    // Try to get value from the next line
    if (currentIndex + 1 < lines.length) {
      final nextLine = lines[currentIndex + 1].trim();
      if (nextLine.isNotEmpty && !_isFieldLabel(nextLine)) {
        return nextLine;
      }
    }

    return null;
  }

  static bool _isKnownFieldLabel(String text) {
    final fieldLabels = [
      'name',
      'surname',
      'first name',
      'last name',
      'other names',
      'given name',
      'company',
      'organization',
      'institution',
      'faculty',
      'department',
      'title',
      'position',
      'job title',
      'level',
      'designation',
      'address',
      'location',
      'phone',
      'email',
      'website'
    ];

    return fieldLabels.any((label) => text.toLowerCase().contains(label));
  }

  static bool _isFieldLabel(String text) {
    // Check if this looks like a field label
    final fieldLabels = [
      'name',
      'surname',
      'first name',
      'last name',
      'other names',
      'given name',
      'company',
      'organization',
      'institution',
      'faculty',
      'department',
      'title',
      'position',
      'job title',
      'level',
      'designation',
      'address',
      'location',
      'phone',
      'email',
      'website',
      'matric no',
      'session',
      'student'
    ];

    final lowerText = text.toLowerCase();
    return fieldLabels.any((label) =>
        lowerText == label ||
        lowerText.startsWith('$label:') ||
        lowerText.startsWith('$label ') ||
        lowerText.endsWith(':'));
  }

  static Map<String, String?> _identifyNameAndCompany(List<String> lines) {
    String? firstName;
    String? lastName;
    String? company;
    String? title;

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];

      if (_isLikelyPersonName(line) && firstName == null) {
        final nameParts = line.split(RegExp(r'\s+'));
        if (nameParts.length >= 2) {
          firstName = nameParts[0];
          lastName = nameParts.sublist(1).join(' ');
        } else if (nameParts.length == 1) {
          firstName = nameParts[0];
        }
      } else if (_isLikelyCompanyName(line) && company == null) {
        company = line;
      } else if (_isLikelyJobTitle(line) && title == null) {
        title = line;
      } else if (company == null && !_isLikelyPersonName(line)) {
        // If we haven't found a company yet and this doesn't look like a person name
        company = line;
      }
    }

    // If we still don't have a clear distinction, use position-based logic
    if (firstName == null && company == null && lines.isNotEmpty) {
      final firstLine = lines[0];
      if (_isLikelyPersonName(firstLine)) {
        final nameParts = firstLine.split(RegExp(r'\s+'));
        if (nameParts.length >= 2) {
          firstName = nameParts[0];
          lastName = nameParts.sublist(1).join(' ');
        } else {
          firstName = nameParts[0];
        }

        // Next line might be company
        if (lines.length > 1) {
          company = lines[1];
        }
      } else {
        // First line might be company, look for name in subsequent lines
        company = firstLine;
        for (int i = 1; i < lines.length; i++) {
          if (_isLikelyPersonName(lines[i])) {
            final nameParts = lines[i].split(RegExp(r'\s+'));
            if (nameParts.length >= 2) {
              firstName = nameParts[0];
              lastName = nameParts.sublist(1).join(' ');
            } else {
              firstName = nameParts[0];
            }
            break;
          }
        }
      }
    }

    return {
      'firstName': firstName,
      'lastName': lastName,
      'company': company,
      'title': title,
    };
  }

  static bool _isLikelyPersonName(String text) {
    // Check if it looks like a person's name
    final words = text.split(RegExp(r'\s+'));

    // Names typically have 1-4 words
    if (words.length > 4 || words.isEmpty) return false;

    // Check for common business/company indicators
    final businessIndicators = [
      'inc',
      'ltd',
      'llc',
      'corp',
      'company',
      'co',
      'technologies',
      'tech',
      'solutions',
      'services',
      'group',
      'international',
      'global',
      'systems',
      'consulting',
      'associates',
      'partners',
      'enterprises',
      'industries',
      'limited',
      'corporation',
      'incorporated',
      'organization',
      'agency',
      'institute',
      'foundation',
      'center',
      'centre',
      'university',
      'college',
      'polytechnic',
      'school',
      'faculty',
      'department'
    ];

    final lowerText = text.toLowerCase();
    if (businessIndicators.any((indicator) => lowerText.contains(indicator))) {
      return false;
    }

    // Check if all words start with capital letters (common for names)
    final hasProperCapitalization = words
        .every((word) => word.isNotEmpty && word[0] == word[0].toUpperCase());

    // Check if it contains numbers (names typically don't)
    final containsNumbers = RegExp(r'\d').hasMatch(text);

    // Names are more likely if properly capitalized and no numbers
    return hasProperCapitalization && !containsNumbers && words.length <= 3;
  }

  static bool _isLikelyCompanyName(String text) {
    final businessIndicators = [
      'inc',
      'ltd',
      'llc',
      'corp',
      'company',
      'co',
      'technologies',
      'tech',
      'solutions',
      'services',
      'group',
      'international',
      'global',
      'systems',
      'consulting',
      'associates',
      'partners',
      'enterprises',
      'industries',
      'limited',
      'corporation',
      'incorporated',
      'organization',
      'agency',
      'institute',
      'foundation',
      'center',
      'centre',
      'university',
      'college',
      'polytechnic',
      'school',
      'faculty',
      'department'
    ];

    final lowerText = text.toLowerCase();
    return businessIndicators.any((indicator) => lowerText.contains(indicator));
  }

  static bool _isLikelyJobTitle(String text) {
    final titleIndicators = [
      'manager',
      'director',
      'president',
      'ceo',
      'cto',
      'cfo',
      'vp',
      'vice president',
      'senior',
      'junior',
      'lead',
      'head',
      'chief',
      'officer',
      'executive',
      'coordinator',
      'specialist',
      'analyst',
      'consultant',
      'developer',
      'engineer',
      'designer',
      'architect',
      'administrator',
      'supervisor',
      'associate',
      'assistant',
      'sales',
      'marketing',
      'finance',
      'human resources',
      'hr',
      'operations',
      'student',
      'level',
      'hnd',
      'bsc',
      'msc',
      'phd'
    ];

    final lowerText = text.toLowerCase();
    return titleIndicators.any((indicator) => lowerText.contains(indicator));
  }

  static bool _isContactInfo(String text, List<String> phones,
      List<String> emails, List<String> websites) {
    return phones.any((phone) => text.contains(phone)) ||
        emails.any((email) => text.contains(email)) ||
        websites.any((website) => text.contains(website)) ||
        text.contains('@') ||
        text.contains('www.') ||
        RegExp(r'\+?\d{10,}').hasMatch(text);
  }

  static bool _isAddress(String text) {
    final addressKeywords = [
      'street',
      'st',
      'ave',
      'avenue',
      'road',
      'rd',
      'lane',
      'ln',
      'drive',
      'dr',
      'blvd',
      'boulevard',
      'suite',
      'apt',
      'apartment',
      'floor',
      'building',
      'plaza',
      'square',
      'circle',
      'court',
      'ct',
      'p.m.b',
      'pmb',
      'post office',
      'p.o',
      'state',
      'nigeria'
    ];

    final lowerText = text.toLowerCase();
    return addressKeywords.any((keyword) => lowerText.contains(keyword)) ||
        RegExp(r'\d+.*[a-zA-Z]').hasMatch(text) ||
        RegExp(r'[a-zA-Z]+.*\d{5}').hasMatch(text); // ZIP code pattern
  }

  static List<String> _extractPhoneNumbers(String text) {
    final phoneRegex = RegExp(r'[\+]?[1-9]?[\d\s\-\(\)\.]{7,15}');
    final matches = phoneRegex.allMatches(text);
    return matches
        .map((match) => match.group(0)!)
        .where((phone) {
          final cleanPhone = phone.replaceAll(RegExp(r'[\s\-\(\)\.+]'), '');
          return cleanPhone.length >= 7 && cleanPhone.length <= 15;
        })
        .toSet()
        .toList();
  }

  static List<String> _extractEmails(String text) {
    final emailRegex =
        RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b');
    final matches = emailRegex.allMatches(text);
    return matches.map((match) => match.group(0)!).toSet().toList();
  }

  static List<String> _extractWebsites(String text) {
    // Only match websites, NOT emails
    final websiteRegex = RegExp(
        r'(?:https?:\/\/)?(?:www\.)?[a-zA-Z0-9][a-zA-Z0-9-]{1,61}[a-zA-Z0-9]\.[a-zA-Z]{2,}(?:\/[^\s]*)?');
    final matches = websiteRegex.allMatches(text);

    return matches
        .map((match) => match.group(0)!)
        .where((website) =>
            !website.contains('@')) // Exclude anything with @ symbol
        .map((website) {
          // Keep the website as-is, don't force www.
          return website;
        })
        .toSet()
        .toList();
  }
}
