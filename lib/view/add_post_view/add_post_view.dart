import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../view_models/controller/post_controller/post_controller.dart';
import '../../view_models/services/supabase_services.dart';

class AddEditPostScreen extends StatefulWidget {
  final Map? post;
  const AddEditPostScreen({super.key, this.post});

  @override
  State<AddEditPostScreen> createState() => _AddEditPostScreenState();
}

class _AddEditPostScreenState extends State<AddEditPostScreen> {
  final controller = Get.find<PostController>();
  final service = SupabaseService();

  final titleCtrl = TextEditingController();
  final contentCtrl = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String category = 'Tech';
  File? image;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.post != null) {
      titleCtrl.text = widget.post!['title'];
      contentCtrl.text = widget.post!['content'];
      category = widget.post!['category'];
    }
  }

  // 🖼 PICK IMAGE
  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => image = File(picked.path));
    }
  }

  // 💾 SAVE POST
  Future<void> savePost() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    try {
      String? imageUrl;

      if (image != null) {
        imageUrl = await service.uploadImage(image!);
      }

      final data = {
        'title': titleCtrl.text.trim(),
        'content': contentCtrl.text.trim(),
        'category': category,
        if (imageUrl != null) 'image_url': imageUrl,
      };

      if (widget.post == null) {
        await controller.addPost(data); // ✅ awaited
      } else {
        await controller.updatePost(widget.post!['id'], data);
      }

      Get.back();
      Get.snackbar(
        "Success",
        widget.post == null ? "Post added" : "Post updated",
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4F46E5),

      appBar: AppBar(
        title: Text(widget.post == null ? "Add Post" : "Edit Post"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // 🧊 IMAGE CARD
              GestureDetector(
                onTap: pickImage,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                    child: Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: Colors.white30),
                      ),
                      child: image != null
                          ? Image.file(image!, fit: BoxFit.cover)
                          : widget.post?['image_url'] != null
                          ? Image.network(
                        widget.post!['image_url'],
                        fit: BoxFit.cover,
                      )
                          : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo,
                              color: Colors.white, size: 36),
                          SizedBox(height: 8),
                          Text("Tap to add cover image",
                              style: TextStyle(
                                  color: Colors.white70)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 🧊 TITLE FIELD
              _glassTextField(
                controller: titleCtrl,
                hint: "Post Title",
                validator: (v) =>
                v!.isEmpty ? "Title required" : null,
              ),

              const SizedBox(height: 14),

              // 🧊 CONTENT FIELD
              _glassTextField(
                controller: contentCtrl,
                hint: "Write your post...",
                maxLines: 5,
                validator: (v) =>
                v!.isEmpty ? "Content required" : null,
              ),

              const SizedBox(height: 14),

              // 🏷 CATEGORY DROPDOWN
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.white30),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        dropdownColor: const Color(0xFF4F46E5),
                        value: category,
                        isExpanded: true,
                        iconEnabledColor: Colors.white,
                        style:
                        const TextStyle(color: Colors.white),
                        items: controller.categories
                            .where((e) => e != 'All')
                            .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                            .toList(),
                        onChanged: (v) =>
                            setState(() => category = v!),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // 💾 SAVE BUTTON
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                  ),
                  onPressed: loading ? null : savePost,
                  child: loading
                      ? const CircularProgressIndicator()
                      : Text(
                    widget.post == null
                        ? "Publish Post"
                        : "Update Post",
                    style: const TextStyle(
                      color: Color(0xFF4F46E5),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // 🧊 GLASS TEXT FIELD
  Widget _glassTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.25),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white30),
          ),
          child: TextFormField(
            controller: controller,
            validator: validator,
            maxLines: maxLines,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle:
              const TextStyle(color: Colors.white70),
              border: InputBorder.none,
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ),
    );
  }
}
