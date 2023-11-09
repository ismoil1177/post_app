class Language {
  String language;
  String text;

  Language({
    required this.language,
    required this.text,
  });

  factory Language.fromJson(Map<String, Object?> json) {
    return Language(
      language: json["language"] as String,
      text: json["text"] as String,
    );
  }
}
