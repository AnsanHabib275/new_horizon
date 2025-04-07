class Document {
  final String documentId;
  final String url;
  final DateTime uploadDate;

  Document({
    required this.documentId,
    required this.url,
    required this.uploadDate,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      documentId: json['document_id'],
      url: json['url'],
      uploadDate: DateTime.parse(json['upload_date']),
    );
  }
}

class DocumentsResponse {
  final List<Document> userDocs;
  final List<Document> adminDocs;

  DocumentsResponse({
    required this.userDocs,
    required this.adminDocs,
  });

  factory DocumentsResponse.fromJson(Map<String, dynamic> json) {
    List<Document> parseDocs(List<dynamic> jsonDocs) {
      return jsonDocs.map((json) => Document.fromJson(json)).toList();
    }

    return DocumentsResponse(
      userDocs: parseDocs(json['userDocs'] as List<dynamic>),
      adminDocs: parseDocs(json['adminDocs'] as List<dynamic>),
    );
  }
}
