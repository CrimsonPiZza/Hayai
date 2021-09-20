class NSOnSalesRequestConfig {
  String page = "0";
  String limit = "20";
  Map option = {
    "featured": "0",
    "price_high_to_low": "1",
    "price_low_to_high": "0",
    "a_to_z": "0",
    "z_to_a": "0",
  };

  NSOnSalesRequestConfig(page, limit, int optionID) {
    this.page = page.toString();
    this.limit = limit.toString();
    this.option = {
      "featured": optionID == OptionID.FEATURED ? "1" : "0",
      "price_high_to_low":
          optionID == OptionID.PRICE_HIGH_TO_LOW ? "1" : "0",
      "price_low_to_high":
          optionID == OptionID.PRICE_LOW_TO_HIGH ? "1" : "0",
      "a_to_z": optionID == OptionID.A_TO_Z ? "1" : "0",
      "z_to_a": optionID == OptionID.Z_TO_A ? "1" : "0",
    };
  }
}

class OptionID {
  static const int FEATURED = 1;
  static const int PRICE_HIGH_TO_LOW = 2;
  static const int PRICE_LOW_TO_HIGH = 3;
  static const int A_TO_Z = 4;
  static const int Z_TO_A = 5;
}
