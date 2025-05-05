import 'dart:convert';

class Images {
    Id id;
    String imageUrl;
    String status;
    String ocassion;
    String phone;

    Images({
        required this.id,
        required this.imageUrl,
        required this.status,
        required this.ocassion,
        required this.phone,
    });

    factory Images.fromJson(Map<String, dynamic> json) => Images(
        id: Id.fromJson(json["_id"]),
        imageUrl: json["imageUrl"],
        status: json["status"],
        ocassion: json["ocassion"],
        phone: json["phone"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id.toJson(),
        "imageUrl": imageUrl,
        "status": status,
        "ocassion": ocassion,
        "phone": phone,
    };
}

class Id {
    String oid;

    Id({
        required this.oid,
    });

    factory Id.fromJson(Map<String, dynamic> json) => Id(
        oid: json["\u0024oid"],
    );

    Map<String, dynamic> toJson() => {
        "\u0024oid": oid,
    };
}

Images imagesFromJson(String str) => Images.fromJson(json.decode(str));

String imagesToJson(Images data) => json.encode(data.toJson());