import 'dart:ui';
import 'package:flutter/material.dart';

class GlassPostCard extends StatelessWidget {
  final Map<String, dynamic> post;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const GlassPostCard({
    super.key,
    required this.post,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.25),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white30),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🖼 HERO IMAGE
              if (post['image_url'] != null)
                Hero(
                  tag: 'post-image-${post['id']}',
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(22)),
                    child: Image.network(
                      post['image_url'],
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 📝 HERO TITLE
                    Hero(
                      tag: 'post-title-${post['id']}',
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          post['title'],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      post['content'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style:
                      const TextStyle(color: Colors.white70),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit,
                              color: Colors.lightBlueAccent),
                          onPressed: onEdit,
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete,
                              color: Colors.redAccent),
                          onPressed: onDelete,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
