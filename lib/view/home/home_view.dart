import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animations/animations.dart';

import '../../res/components/glass_post_card.dart';
import '../../view_models/controller/post_controller/post_controller.dart';
import '../add_post_view/add_post_view.dart';
import '../post_details/post_details.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final PostController controller = Get.put(PostController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4F46E5),

      appBar: AppBar(
        title: const Text(
          "Flutter Blog",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: Column(
        children: [
          // 🔍 SEARCH
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: controller.setSearch,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search posts...",
                hintStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                filled: true,
                fillColor: Colors.white.withOpacity(0.2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // 🏷 CATEGORY FILTER
          SizedBox(
            height: 44,
            child: Obx(
                  () => ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: controller.categories.map((cat) {
                  final active =
                      controller.selectedCategory.value == cat;
                  return GestureDetector(
                    onTap: () => controller.setCategory(cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        color: active
                            ? Colors.white
                            : Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        cat,
                        style: TextStyle(
                          color: active
                              ? const Color(0xFF4F46E5)
                              : Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // 📰 POSTS LIST
          Expanded(
            child: Obx(() {
              if (controller.loading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }

              if (controller.filteredPosts.isEmpty) {
                return const Center(
                  child: Text(
                    "No posts found",
                    style: TextStyle(color: Colors.white70),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.filteredPosts.length,
                itemBuilder: (context, index) {
                  final post = controller.filteredPosts[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: OpenContainer(
                      closedElevation: 0,
                      openElevation: 0,
                      closedColor: Colors.transparent,
                      openColor: Colors.transparent,
                      transitionDuration:
                      const Duration(milliseconds: 450),

                      openBuilder: (_, __) =>
                          PostDetailScreen(post: post),

                      closedBuilder: (_, __) => GlassPostCard(
                        post: post,
                        onEdit: () {
                          Get.to(() =>
                              AddEditPostScreen(post: post));
                        },
                        onDelete: () {
                          _confirmDelete(post['id']);
                        },
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),

      // ➕ FAB
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          Get.to(() => const AddEditPostScreen());
        },
        child: const Icon(Icons.add,
            color: Color(0xFF4F46E5), size: 30),
      ),
    );
  }

  // 🗑 DELETE CONFIRM
  void _confirmDelete(int id) {
    Get.dialog(
      AlertDialog(
        title: const Text("Delete Post"),
        content:
        const Text("Are you sure you want to delete this post?"),
        actions: [
          TextButton(onPressed: Get.back, child: const Text("Cancel")),
          ElevatedButton(
            style:
            ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              controller.deletePost(id);
              Get.back();
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}
