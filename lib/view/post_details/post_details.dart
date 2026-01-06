import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostDetailScreen extends StatelessWidget {
  final Map<String, dynamic> post;

  const PostDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4F46E5),

      body: Stack(
        children: [
          // 🔙 BACK BUTTON
          SafeArea(
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Get.back(),
            ),
          ),

          // 📄 CONTENT
          CustomScrollView(
            slivers: [
              // 🖼 HERO IMAGE
              SliverAppBar(
                backgroundColor: Colors.transparent,
                expandedHeight: 280,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: 'post-image-${post['id']}',
                    child: Image.network(
                      post['image_url'] ??
                          'https://via.placeholder.com/400',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              // 📄 POST BODY
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.white30),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 🏷 CATEGORY
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                post['category'] ?? 'General',
                                style: const TextStyle(
                                  color: Color(0xFF4F46E5),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            const SizedBox(height: 14),

                            // 📝 TITLE (HERO)
                            Hero(
                              tag: 'post-title-${post['id']}',
                              child: Material(
                                color: Colors.transparent,
                                child: Text(
                                  post['title'],
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // 📃 CONTENT
                            Text(
                              post['content'],
                              style: const TextStyle(
                                fontSize: 16,
                                height: 1.6,
                                color: Colors.white70,
                              ),
                            ),

                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
