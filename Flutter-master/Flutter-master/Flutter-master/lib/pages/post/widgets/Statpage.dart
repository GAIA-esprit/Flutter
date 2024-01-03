// StatPage.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StatPage extends StatefulWidget {
  @override
  _StatPageState createState() => _StatPageState();
}

class _StatPageState extends State<StatPage> {
  late List<Post> posts;

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
  try {
    final response = await http.get(Uri.parse('http://127.0.0.1:3000/api/posts'));

    if (response.statusCode == 200) {
      final dynamic responseData = json.decode(response.body);

      if (responseData != null && responseData is List) {
        final List<dynamic> postsData = responseData;

        setState(() {
          posts = postsData.map((data) => Post.fromJson(data)).toList();
        });
      } else {
        throw Exception('No posts found in the response');
      }
    } else {
      throw Exception('Failed to load posts. Status code: ${response.statusCode}');
    }
  } catch (error) {
    print('Error in fetchPosts: $error');
  }
}
  List<Post> getTopThreePosts() {
    // Trie les publications par nombre de likes de manière décroissante
    posts.sort((a, b) => b.like.compareTo(a.like));
    // Récupère les trois premières publications
    return posts.take(3).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statistiques'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Top 3 des Publications avec le Plus de Likes',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          if (posts != null)
            DataTable(
              columns: [
                DataColumn(label: Text('Iduser')),
                DataColumn(label: Text('Titre')),
                DataColumn(label: Text('Contenu')),
                DataColumn(label: Text('Author')),
                DataColumn(label: Text('Likes')),
                DataColumn(label: Text('Dislikes')),
              ],
              rows: getTopThreePosts().map((post) {
                return DataRow(cells: [
                  DataCell(Text(post.iduser)),
                  DataCell(Text(post.title)),
                  DataCell(Text(post.content)),
                  DataCell(Text(post.author)),
                  DataCell(Text(post.like.toString())),
                  DataCell(Text(post.dislike.toString())),
                ]);
              }).toList(),
            ),
        ],
      ),
    );
  }
}

class Post {
  final String id;
  final String iduser;
  final String title;
  final String content;
  final String author;
  final int like;
  final int dislike;

  Post({
    required this.id,
    required this.iduser,
    required this.title,
    required this.content,
    required this.author,
    required this.like,
    required this.dislike,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id'],
      iduser: json['iduser'],
      title: json['title'],
      content: json['content'],
      author: json['author'],
      like: json['like'],
      dislike: json['dislike'],
    );
  }
}
