// import 'package:get/get.dart';
// import '../../../main.dart';
// import '../models/post_model.dart';
// import '../main.dart';
//
// class HomeController extends GetxController {
//   var isLoading = true.obs;
//   var posts = <PostModel>[].obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchPosts();
//   }
//
//   Future<void> fetchPosts() async {
//     try {
//       isLoading(true);
//       // Select * from posts order by created_at descending
//       final response = await supabase
//           .from('posts')
//           .select()
//           .order('created_at', ascending: false);
//
//       final data = response as List<dynamic>;
//       posts.value = data.map((json) => PostModel.fromJson(json)).toList();
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to fetch posts: $e');
//     } finally {
//       isLoading(false);
//     }
//   }
//
//   Future<void> deletePost(String postId, String? imageUrl) async {
//     try {
//       isLoading(true);
//       // 1. Delete image from storage if it exists
//       if(imageUrl != null) {
//         // Extract filename from URL. A bit hacky, but works for Supabase storage URLs.
//         final fileName = imageUrl.split('/').last;
//         await supabase.storage.from('blog-images').remove([fileName]);
//       }
//
//       // 2. Delete post data
//       await supabase.from('posts').delete().eq('id', postId);
//
//       // 3. Remove locally and update UI
//       posts.removeWhere((post) => post?.id == postId);
//       Get.snackbar("Success", "Post deleted successfully", snackPosition: SnackPosition.BOTTOM);
//     } catch(e) {
//       Get.snackbar('Error', 'Failed to delete post: $e');
//     } finally {
//       isLoading(false);
//     }
//   }
// }