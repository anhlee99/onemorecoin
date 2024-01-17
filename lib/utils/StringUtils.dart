
class StringUtils {
  StringUtils._(); // Private constructor to prevent instantiation

  static bool isEmpty(String text) {
    return text.isEmpty;
  }

  static String capitalize(String text) {
    if (isEmpty(text)) {
      return '';
    }
    return text[0].toUpperCase() + text.substring(1);
  }
}