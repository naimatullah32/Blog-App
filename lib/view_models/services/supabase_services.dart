import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final supabase = Supabase.instance.client;

  Future<List> fetchPosts() async {
    return await supabase.from('posts').select().order('created_at');
  }

  Future<String> uploadImage(File file) async {
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

    await supabase.storage
        .from('blog-images')
        .upload(fileName, file);

    return supabase.storage
        .from('blog-images')
        .getPublicUrl(fileName);
  }

  Future<void> addPost(Map data) async {
    await supabase.from('posts').insert(data);
  }

  Future<void> updatePost(int id, Map data) async {
    await supabase.from('posts').update(data).eq('id', id);
  }

  Future<void> deletePost(int  id) async {
    await supabase.from('posts').delete().eq('id', id);
  }
}
