import 'package:get/get.dart';
import '../../services/supabase_services.dart';

class PostController extends GetxController {
  final _service = SupabaseService();

  var posts = [].obs;
  var filteredPosts = [].obs;
  var loading = false.obs;
  var selectedCategory = 'All'.obs;
  var searchText = ''.obs;

  final categories = ['All', 'Tech', 'Lifestyle', 'Travel'];

  @override
  void onInit() {
    fetchPosts();
    super.onInit();
  }

  void fetchPosts() async {
    loading.value = true;
    posts.value = await _service.fetchPosts();
    applyFilters();
    loading.value = false;
  }

  void applyFilters() {
    filteredPosts.value = posts.where((post) {
      final matchCategory =
          selectedCategory.value == 'All' ||
              post['category'] == selectedCategory.value;

      final matchSearch = post['title']
          .toString()
          .toLowerCase()
          .contains(searchText.value.toLowerCase());

      return matchCategory && matchSearch;
    }).toList();
  }

  void setCategory(String category) {
    selectedCategory.value = category;
    applyFilters();
  }

  void setSearch(String value) {
    searchText.value = value;
    applyFilters();
  }

  Future<void> addPost(Map data) async {
    await _service.addPost(data);
    fetchPosts();
  }

  Future<void> updatePost(int id, Map data) async {
    await _service.updatePost(id, data);
    fetchPosts();
  }

  Future<void> deletePost(int id) async {
    await _service.deletePost(id);
    fetchPosts();
  }
}
