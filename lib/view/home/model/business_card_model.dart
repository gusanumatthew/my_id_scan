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

    if (lines.isNotEmpty) {
      final firstLine = lines[0].trim();
      if (!_containsSpecialPattern(firstLine)) {
        final nameParts = firstLine.split(' ');
        if (nameParts.length >= 2) {
          firstName = nameParts[0];
          lastName = nameParts.sublist(1).join(' ');
        } else if (nameParts.length == 1) {
          firstName = nameParts[0];
        }
      }
    }

    for (int i = 1; i < lines.length; i++) {
      final line = lines[i].trim();
      if (!_containsSpecialPattern(line) &&
          !phoneNumbers.any((phone) => line.contains(phone)) &&
          !emails.any((email) => line.contains(email)) &&
          !websites.any((website) => line.contains(website))) {
        if (company == null) {
          company = line;
        } else {
          title ??= line;
        }
      }
    }

    final addressLines = lines
        .where((line) =>
            _mightBeAddress(line) &&
            !phoneNumbers.any((phone) => line.contains(phone)) &&
            !emails.any((email) => line.contains(email)) &&
            !websites.any((website) => line.contains(website)))
        .toList();

    if (addressLines.isNotEmpty) {
      address = addressLines.join(', ');
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

  static List<String> _extractPhoneNumbers(String text) {
    final phoneRegex = RegExp(r'[\+]?[1-9]?[\d\s\-\(\)\.]{7,15}');
    final matches = phoneRegex.allMatches(text);
    return matches
        .map((match) => match.group(0)!)
        .where((phone) =>
            phone.replaceAll(RegExp(r'[\s\-\(\)\.+]'), '').length >= 7)
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
    final websiteRegex = RegExp(
        r'(?:www\.)?[a-zA-Z0-9][a-zA-Z0-9-]{1,61}[a-zA-Z0-9]\.[a-zA-Z]{2,}');
    final matches = websiteRegex.allMatches(text);
    return matches.map((match) => match.group(0)!).toSet().toList();
  }

  static bool _containsSpecialPattern(String text) {
    return text.contains('@') ||
        text.contains('www.') ||
        text.contains('.com') ||
        text.contains('.org') ||
        text.contains('.net') ||
        RegExp(r'\d{3}').hasMatch(text);
  }

  static bool _mightBeAddress(String text) {
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
      'boulevard'
    ];
    final lowerText = text.toLowerCase();
    return addressKeywords.any((keyword) => lowerText.contains(keyword)) ||
        RegExp(r'\d+.*[a-zA-Z]').hasMatch(text);
  }
}
