import 'dart:io';

class UtilMethod{



//internetcheker
  Future<String> checkInternetConnection() async {
    try {
      final response = await InternetAddress.lookup('www.google.com');
      if (response.isNotEmpty) {
        return 'success';
      }
      return 'success';
    } on SocketException catch (err) {
      return 'false';
    }
  }

  
//validators

  String? Function(String?)? emailValidation = (value) {
    if (value!.isEmpty) {
      return 'البريد الألكتروني مطلوب';
    }
    String pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) return 'الرجاء ادخال بريد إلكتروني صحيح';

    return null;
  };

  String? Function(String?)? passwordValidation = (value) {
    if (value!.isEmpty) {
      return 'أدخل كلمة السر';
    }
    return null;
  };

  String? Function(String?)? phoneValidation = (value) {
    if (value!.isEmpty) {
      return 'أدخل رقم الهاتف';
    }
    if (value.length < 10) {
      return 'أدخل رقم هاتف صحيح';
    }

    return null;
  };

  String? Function(String?)? usernameValidation = (value) {
    if (value!.isEmpty) {
      return 'أدخل إسم المستخدم ';
    }
    if (value.length < 3) {
      return 'الاسم قصير جدا ';
    }

    return null;
  };


}