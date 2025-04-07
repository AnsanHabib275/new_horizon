class UserDocument {
  final String documentId;
  final String url;
  final DateTime uploadDate;

  UserDocument({
    required this.documentId,
    required this.url,
    required this.uploadDate,
  });

  factory UserDocument.fromJson(Map<String, dynamic> json) {
    return UserDocument(
      documentId: json['document_id'] as String,
      url: json['url'] as String,
      uploadDate: DateTime.parse(json['upload_date'] as String),
    );
  }
}

class DocumentsUserResponse {
  final List<UserDocument> userDocs;
  final List<UserDocument> adminDocs;

  DocumentsUserResponse({
    required this.userDocs,
    required this.adminDocs,
  });

  factory DocumentsUserResponse.fromJson(Map<String, dynamic> json) {
    List<UserDocument> parseDocs(List<dynamic>? jsonDocs) {
      if (jsonDocs == null || jsonDocs.isEmpty) {
        return [];
      }
      return jsonDocs.map((json) => UserDocument.fromJson(json)).toList();
    }

    return DocumentsUserResponse(
      userDocs: parseDocs(json['userDocs'] as List<dynamic>?),
      adminDocs: parseDocs(json['adminDocs'] as List<dynamic>?),
    );
  }
}
