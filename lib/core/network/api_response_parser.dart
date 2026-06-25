class ApiResponseParser {
  const ApiResponseParser._();

  static List<dynamic> listFrom(
    dynamic data, {
    List<String> keys = const [
      "data",
      "items",
      "results",
      "drivers",
      "trucks",
      "alerts",
      "locations",
      "destinations",
      "trips",
    ],
  }) {
    if (data is List) {
      return data;
    }

    if (data is Map) {
      final map = Map<String, dynamic>.from(data);

      for (final key in keys) {
        final value = map[key];

        if (value is List) {
          return value;
        }

        if (value is Map) {
          final nestedList = listFrom(value, keys: keys);

          if (nestedList.isNotEmpty) {
            return nestedList;
          }
        }
      }
    }

    return [];
  }

  static Map<String, dynamic> mapFrom(
    dynamic data, {
    List<String> keys = const [
      "data",
      "summary",
      "dashboard",
    ],
  }) {
    if (data is Map) {
      final map = Map<String, dynamic>.from(data);

      for (final key in keys) {
        final value = map[key];

        if (value is Map) {
          return Map<String, dynamic>.from(value);
        }
      }

      return map;
    }

    return {};
  }
}
