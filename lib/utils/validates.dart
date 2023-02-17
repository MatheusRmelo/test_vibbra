class Validates {
  static bool validCNPJ(String cnpj) {
    cnpj = cnpj.replaceAll(RegExp(r'[^0-9]'), '');
    cnpj = cnpj.replaceAll(RegExp(r'/[^\d]+/g'), '');

    if (cnpj == '') return false;

    if (cnpj.length != 14) {
      return false;
    }

    if (cnpj == "00000000000000" ||
        cnpj == "11111111111111" ||
        cnpj == "22222222222222" ||
        cnpj == "33333333333333" ||
        cnpj == "44444444444444" ||
        cnpj == "55555555555555" ||
        cnpj == "66666666666666" ||
        cnpj == "77777777777777" ||
        cnpj == "88888888888888" ||
        cnpj == "99999999999999") {
      return false;
    }

    int size = cnpj.length - 2;
    String numbers = cnpj.substring(0, size);
    String digits = cnpj.substring(size);
    int sum = 0;
    int pos = size - 7;
    for (int i = size; i >= 1; i--) {
      sum += int.parse(numbers[size - i]) * pos--;
      if (pos < 2) pos = 9;
    }
    int result = sum % 11 < 2 ? 0 : 11 - sum % 11;
    if (result != int.parse(digits[0])) return false;

    size = size + 1;
    numbers = cnpj.substring(0, size);
    sum = 0;
    pos = size - 7;
    for (int i = size; i >= 1; i--) {
      sum += int.parse(numbers[size - i]) * pos--;
      if (pos < 2) pos = 9;
    }
    result = sum % 11 < 2 ? 0 : 11 - sum % 11;
    if (result != int.parse(digits[1])) return false;

    return true;
  }
}
