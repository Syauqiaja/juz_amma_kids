enum AuthType{
  BOY("boys"),
  GIRL("girls"),
  GUARDIAN("guardians");

  const AuthType(this.name);
  final String name;

  static AuthType fromString(String value){
    switch(value){
      case "boy":
      case "guest_boys":
      case "boys":
        return AuthType.BOY;
      case "girl":
      case "guest_girls":
      case "girls":
        return AuthType.GIRL;
      case "guardian":
      case "guardians":
        return AuthType.GUARDIAN;
      default:
        throw Exception("Auth type from string: no auth type with $value value");
    }
  }
}