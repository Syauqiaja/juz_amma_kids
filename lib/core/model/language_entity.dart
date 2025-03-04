class LanguageEntity {
  final String name;
  final String code;

  const LanguageEntity({required this.name, required this.code});
}

abstract class Languages{
  static const LanguageEntity arabic =  LanguageEntity(name: 'Arabic', code: 'ar');
  static const LanguageEntity english = LanguageEntity(name: 'English', code: 'en');
  static const LanguageEntity indonesia =  LanguageEntity(name: 'Indonesia', code: 'id');
  

  static List<LanguageEntity> allLanguages = [
    arabic,
    english,
    indonesia
  ];
}
