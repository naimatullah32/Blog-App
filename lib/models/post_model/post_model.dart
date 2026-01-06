class PostModel {
  final String id;
  final String title;
  final String content;
  final String category;
  final String? imageUrl;
  final String userId;
  final DateTime createdAt;

  PostModel({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    this.imageUrl,
    required this.userId,
    required this.createdAt,
  });

  // Factory constructor to create a PostModel from Supabase JSON data
  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      category: json['category'] as String,
      imageUrl: json['image_url'] as String?,
      userId: json['user_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  // Method to convert PostModel back to JSON for uploading (if needed)
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'category': category,
      'image_url': imageUrl,
      // id, user_id, created_at are handled by Supabase defaults
    };
  }
}