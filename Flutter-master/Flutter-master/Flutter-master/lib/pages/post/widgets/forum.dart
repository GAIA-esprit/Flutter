import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    home: Forum(),
  ));
}

class Forum extends StatefulWidget {
  @override
  _ForumState createState() => _ForumState();
}

class _ForumState extends State<Forum> {
  bool _sortAscending = true;
  TextEditingController _iduserController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  TextEditingController _authorController = TextEditingController();
  
  late List<Post> posts;
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    posts = [];
    fetchPosts();
  }

  void _toggleSortOrder() {
    setState(() {
      _sortAscending = !_sortAscending;
      posts.sort((a, b) =>
          _sortAscending ? a.like.compareTo(b.like) : b.like.compareTo(a.like));
    });
  }

  void _showAddPostDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ajouter une publication'),
          content: Column(
            children: [
              TextField(
                controller: _iduserController,
                decoration: InputDecoration(labelText: 'Iduser'),
              ),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Titre'),
              ),
              TextField(
                controller: _contentController,
                decoration: InputDecoration(labelText: 'Contenu'),
              ),
              TextField(
                controller: _authorController,
                decoration: InputDecoration(labelText: 'Author'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _addPost();
                Navigator.of(context).pop();
              },
              child: Text('Ajouter'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annuler'),
            ),
          ],
        );
      },
    );
  }

  void _addPost() async {
    print('Adding post:  ${_iduserController.text},${_titleController.text}, ${_contentController.text},${_authorController.text}');
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:3000/api/posts/add'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'iduser': _iduserController.text,
          'title': _titleController.text,
          'content': _contentController.text,
          'author': _authorController.text,
        }),
      );

      if (response.statusCode == 200) {
        print('Publication ajoutée avec succès!');
        fetchPosts();
      } else {
        print(
            'Erreur lors de l\'ajout de la publication. Code: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      print('Error adding post: $e');
    }
  }

  Future<void> fetchPosts() async {
    try {
      final response = await http
          .get(Uri.parse('http://127.0.0.1:3000/api/posts'));

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);

        if (responseData != null && responseData['posts'] != null) {
          final List<dynamic> postsData = responseData['posts'];

          List<Post> filteredPosts = postsData
              .map((data) => Post.fromJson(data))
              .where((post) =>
                  post.iduser
                      .toLowerCase()
                      .contains(_searchText.toLowerCase()) ||
                  post.title
                      .toLowerCase()
                      .contains(_searchText.toLowerCase()) ||
                  post.content
                      .toLowerCase()
                      .contains(_searchText.toLowerCase())||
                      post.author
                      .toLowerCase()
                      .contains(_searchText.toLowerCase())
                      )
              .toList();

          filteredPosts.sort((a, b) => _sortAscending
              ? a.like.compareTo(b.like)
              : b.like.compareTo(a.like));

          setState(() {
            posts = filteredPosts;
          });
        } else {
          throw Exception('No posts found in the response');
        }
      } else {
        throw Exception(
            'Failed to load posts. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error in fetchPosts: $error');
    }
  }

  void _editPost(Post post) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Détails de la publication'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                post.iduser,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                post.title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                post.content,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 16),
              Text(
                post.author,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.thumb_up),
                  Text(' ${post.like} Likes'),
                  SizedBox(width: 16),
                  Icon(Icons.thumb_down),
                  Text(' ${post.dislike} Dislikes'),
                ],
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Fermer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forum Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showAddPostDialog,
          ),
          IconButton(
            icon: Icon(Icons.show_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistoryPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.insert_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StatPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchText = value;
                        fetchPosts();
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Recherche',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                DropdownButton<String>(
                  items: <String>[
                    'Ordre croissant',
                    'Ordre décroissant',
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue == 'Ordre croissant' ||
                        newValue == 'Ordre décroissant') {
                      _toggleSortOrder();
                    }
                  },
                  value:
                      _sortAscending ? 'Ordre croissant' : 'Ordre décroissant',
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: posts
                  .map((post) => PostWidget(
                        iduser : post.iduser,
                        title: post.title,
                        content: post.content,
                        author: post.author,
                        likes: post.like,
                        dislikes: post.dislike,
                        onEdit: () => _editPost(post),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class PostWidget extends StatelessWidget {
  final String iduser; 
  final String title;
  final String content;
  final String author;
  final int likes;
  final int dislikes;
  final VoidCallback onEdit;

  PostWidget({
    required this.iduser,
    required this.title,
    required this.content,
    required this.author,
    required this.likes,
    required this.dislikes,
    required this.onEdit,
  });

  void _deletePost() {
    print('Publication supprimée: $title');
  }

@override
Widget build(BuildContext context) {
  return Card(
    elevation: 5,
    margin: EdgeInsets.all(16),
    child: Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            iduser,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 53, 46, 46)),
          ),
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 53, 46, 46)),
          ),
          SizedBox(height: 10),
          Text(
            content,
            style: TextStyle(fontSize: 16,color: Color.fromARGB(255, 53, 46, 46)),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 10),
          Text(
            author,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 53, 46, 46)),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.thumb_up, color: Colors.green),
              Text(' $likes Likes'),
              SizedBox(width: 12),
              Icon(Icons.thumb_down, color: Colors.green),
              Text(' $dislikes Dislikes'),
            ],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: onEdit,
                child: Text('Voir détails'),
              ),
            ],
          ),
        ],
      ),
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

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statistiques'),
      ),
      body: Center(
        child: Text('Contenu de la page des statistiques'),
      ),
    );
  }
}
class StatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statistiques'),
      ),
      body: Center(
        child: Text('Contenu de la page des statistiques'),
      ),
    );
  }
}
