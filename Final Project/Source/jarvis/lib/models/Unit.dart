class Unit {
  String id; // Unique identifier for the unit
  String name; // Name of the unit
  UnitType unitType; // Type of the unit

  bool? isEnabled; // Whether the unit is enabled (default: true)
  String? createdAt; // Thời gian tạo
  String? updatedAt; // Thời gian cập nhật
  String? createdBy; // Người tạo (nullable)
  String? updatedBy; // Người cập nhật (nullable)
  String? deletedAt; // Thời gian xóa (nullable)
  int? size; // Kích thước tệp
  bool? status;
  String? userId; // ID người dùng
  String? knowledgeId; // ID knowledge base
  List<String>? openAiFileIds; // Danh sách ID tệp OpenAI
  Metadata? metadata; // Thông tin metadata

  Unit({
    required this.id,
    required this.name,
    required this.unitType,
    this.isEnabled = true,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.deletedAt,
    this.size,
    this.status,
    this.userId,
    this.knowledgeId,
    this.openAiFileIds,
    this.metadata,
  });

  /// Convert JSON to Unit
  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      id: json['id'] as String,
      name: json['name'] as String,
      unitType: json['type'] == 'local_file'
          ? UnitType.localfile
          : UnitType.values.firstWhere((type) => type.name == json['type']),
      isEnabled: json['status'] as bool? ?? true,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      createdBy: json['createdBy'] as String?,
      updatedBy: json['updatedBy'] as String?,
      deletedAt: json['deletedAt'],
      size: json['size'] as int?,
      status: json['status'] as bool?,
      userId: json['userId'] as String?,
      knowledgeId: json['knowledgeId'] as String?,
      openAiFileIds: (json['openAiFileIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      metadata: json['metadata'] != null
          ? Metadata.fromJson(json['metadata'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Convert Unit to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': unitType.name,
      'status': isEnabled,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'deletedAt': deletedAt,
      'size': size,
      'userId': userId,
      'knowledgeId': knowledgeId,
      'openAiFileIds': openAiFileIds,
      'metadata': metadata?.toJson(),
    };
  }
}

class Metadata {
  String? name;
  String? mimeType;
  String? weburl;
  Metadata({
    this.name,
    this.mimeType,
    this.weburl,
  });

  /// Convert JSON to Metadata
  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
      name: json['name'] as String?,
      mimeType: json['mimetype'] as String?,
      weburl: json['web_url'] as String?,
    );
  }

  /// Convert Metadata to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'mimetype': mimeType,
      'web_url': weburl,
    };
  }
}

enum UnitType { localfile, googleDrive, slack, web, confluence }
