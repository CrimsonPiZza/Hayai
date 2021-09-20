// To parse this JSON data, do
//
//     final onSalesModel = onSalesModelFromJson(jsonString);

import 'dart:convert';

OnSalesModel onSalesModelFromJson(String str) =>
    OnSalesModel.fromJson(json.decode(str));

String onSalesModelToJson(OnSalesModel data) => json.encode(data.toJson());

class OnSalesModel {
  OnSalesModel({
    required this.statusCode,
    required this.data,
  });

  int statusCode;
  Data data;

  factory OnSalesModel.fromJson(Map<String, dynamic> json) => OnSalesModel(
        statusCode: json["statusCode"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.results,
    required this.totalResult,
    required this.currentPage,
    required this.lastPage,
  });

  List<Result> results;
  int totalResult;
  int currentPage;
  int lastPage;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
        totalResult: json["total_result"],
        currentPage: json["current_page"],
        lastPage: json["last_page"],
      );

  Map<String, dynamic> toJson() => {
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "total_result": totalResult,
        "current_page": currentPage,
        "last_page": lastPage,
      };
}

class Result {
  Result({
    required this.lastModified,
    required this.title,
    required this.description,
    required this.url,
    required this.nsuid,
    required this.slug,
    required this.horizontalHeaderImage,
    required this.platform,
    required this.releaseDateDisplay,
    required this.esrbRating,
    required this.numOfPlayers,
    required this.featured,
    required this.freeToStart,
    required this.esrbDescriptors,
    required this.franchises,
    required this.genres,
    required this.publishers,
    required this.developers,
    required this.generalFilters,
    required this.howToShop,
    required this.playerFilters,
    required this.priceRange,
    required this.msrp,
    required this.salePrice,
    required this.lowestPrice,
    required this.availability,
    required this.objectId,
  });

  int lastModified;
  String? title;
  String? description;
  String? url;
  String? nsuid;
  String? slug;
  String? horizontalHeaderImage;
  String? platform;
  DateTime releaseDateDisplay;
  String? esrbRating;
  String? numOfPlayers;
  bool? featured;
  bool? freeToStart;
  List<dynamic> esrbDescriptors;
  List<dynamic> franchises;
  List<dynamic> genres;
  List<dynamic> publishers;
  List<dynamic> developers;
  List<dynamic> generalFilters;
  List<dynamic> howToShop;
  List<dynamic> playerFilters;
  String? priceRange;
  double msrp;
  double salePrice;
  double? lowestPrice;
  List<dynamic> availability;
  String objectId;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        lastModified: json["lastModified"],
        title: json["title"],
        description: json["description"],
        url: json["url"],
        nsuid: json["nsuid"],
        slug: json["slug"],
        horizontalHeaderImage: json["horizontalHeaderImage"],
        platform: json["platform"],
        releaseDateDisplay: DateTime.parse(json["releaseDateDisplay"]),
        esrbRating: json["esrbRating"],
        numOfPlayers: json["numOfPlayers"],
        featured: json["featured"],
        freeToStart: json["freeToStart"],
        esrbDescriptors:
            List<dynamic>.from(json["esrbDescriptors"].map((x) => x)),
        franchises: List<dynamic>.from(json["franchises"].map((x) => x)),
        genres: List<dynamic>.from(json["genres"].map((x) => x)),
        publishers: List<dynamic>.from(json["publishers"].map((x) => x)),
        developers: List<dynamic>.from(json["developers"].map((x) => x)),
        generalFilters:
            List<dynamic>.from(json["generalFilters"].map((x) => x)),
        howToShop: List<dynamic>.from(json["howToShop"].map((x) => x)),
        playerFilters: List<dynamic>.from(json["playerFilters"].map((x) => x)),
        priceRange: json["priceRange"],
        msrp: json["msrp"].toDouble(),
        salePrice: json["salePrice"].toDouble(),
        lowestPrice: json["lowestPrice"].toDouble(),
        availability: List<dynamic>.from(json["availability"].map((x) => x)),
        objectId: json["objectID"],
      );

  Map<String, dynamic> toJson() => {
        "lastModified": lastModified,
        "title": title,
        "description": description,
        "url": url,
        "nsuid": nsuid,
        "slug": slug,
        "horizontalHeaderImage": horizontalHeaderImage,
        "platform": platform,
        "releaseDateDisplay": releaseDateDisplay.toIso8601String(),
        "esrbRating": esrbRating,
        "numOfPlayers": numOfPlayers,
        "featured": featured,
        "freeToStart": freeToStart,
        "esrbDescriptors": List<dynamic>.from(esrbDescriptors.map((x) => x)),
        "franchises": List<dynamic>.from(franchises.map((x) => x)),
        "genres": List<dynamic>.from(genres.map((x) => x)),
        "publishers": List<dynamic>.from(publishers.map((x) => x)),
        "developers": List<dynamic>.from(developers.map((x) => x)),
        "generalFilters": List<dynamic>.from(generalFilters.map((x) => x)),
        "howToShop": List<dynamic>.from(howToShop.map((x) => x)),
        "playerFilters": List<dynamic>.from(playerFilters.map((x) => x)),
        "priceRange": priceRange,
        "msrp": msrp,
        "salePrice": salePrice,
        "lowestPrice": lowestPrice,
        "availability": List<dynamic>.from(availability.map((x) => x)),
        "objectID": objectId,
      };
}
