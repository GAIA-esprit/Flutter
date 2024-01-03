import 'package:flutter/material.dart';
import 'package:quiz_backoffice/constants/style.dart';
import 'package:quiz_backoffice/widgets/custom_text.dart';
import 'package:quiz_backoffice/api/quizapi.dart';
import 'package:quiz_backoffice/model/quiz.dart';
import 'package:quiz_backoffice/pages/quiz/widgets/quiz_detail.dart';

class QuizHiddenTable extends StatefulWidget {
  final List<Quiz> quizzes;

  const QuizHiddenTable({Key? key, required this.quizzes}) : super(key: key);

  @override
  _QuizHiddenTableState createState() => _QuizHiddenTableState();
}

class _QuizHiddenTableState extends State<QuizHiddenTable> {
  String selectedDifficulty = 'All';
  final ApiService quizApi = ApiService();
  String searchQuery = '';
  late int _rowsPerPage;
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    _rowsPerPage = 10; // Set the initial number of rows per page
    _currentPage = 1; // Set the initial current page
  }

  @override
  Widget build(BuildContext context) {
    final filteredQuizzes = _filterQuizzes();
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: active.withOpacity(.4), width: .5),
        boxShadow: [
          BoxShadow(
              offset: const Offset(0, 6),
              color: lightGrey.withOpacity(.1),
              blurRadius: 12)
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              SizedBox(
                width: 10,
              ),
              CustomText(
                text: "Hidden Quiz Data",
                color: lightGrey,
                weight: FontWeight.bold,
                size: 20,
              ),
              SizedBox(width: 20),
              DropdownButton<String>(
                value: selectedDifficulty,
                onChanged: (value) {
                  setState(() {
                    selectedDifficulty = value!;
                  });
                },
                items: ['All', 'easy', 'medium', 'hard']
                    .map<DropdownMenuItem<String>>((difficulty) {
                  return DropdownMenuItem<String>(
                    value: difficulty,
                    child: CustomText(text: difficulty),
                  );
                }).toList(),
              ),
              SizedBox(width: 20),
              Expanded(
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value.toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Search',
                    hintText: 'Enter quiz title...',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: (56 * _rowsPerPage) + 40,
            child: DataTable(
              columnSpacing: 12,
              dataRowHeight: 56,
              headingRowHeight: 40,
              horizontalMargin: 12,
              columns: const [
                DataColumn(
                  label: Text("#"),
                ),
                DataColumn(
                  label: Text("Question"),
                ),
                DataColumn(
                  label: Text('Category'),
                ),
                DataColumn(
                  label: Text('Type'),
                ),
                DataColumn(
                  label: Text('Difficulty'),
                ),
                DataColumn(
                  label: Text('Actions'),
                ),
              ],
              rows: _generateTableRows(filteredQuizzes),
            ),
          ),
          SizedBox(
            height: 60, // Adjust the height as needed
            child: _buildPagination(),
          ),
        ],
      ),
    );
  }

  List<DataRow> _generateTableRows(List<Quiz> quizzes) {
    final int startIndex = (_currentPage - 1) * _rowsPerPage;
    final int endIndex = (startIndex + _rowsPerPage) < quizzes.length
        ? (startIndex + _rowsPerPage)
        : quizzes.length;

    return quizzes
        .getRange(startIndex, endIndex)
        .map<DataRow>((quiz) {
          final index = widget.quizzes.indexOf(quiz);
          return DataRow(
            cells: [
              DataCell(
                CustomText(
                  text: "${index + 1 + _currentPage * _rowsPerPage}",
                  weight: FontWeight.bold,
                ),
              ),
              DataCell(
                CustomText(
                  text: quiz.question,
                ),
              ),
              DataCell(
                CustomText(
                  text: quiz.category,
                ),
              ),
              DataCell(
                CustomText(
                  text: quiz.type,
                ),
              ),
              DataCell(
                CustomText(
                  text: quiz.difficulty,
                  weight: FontWeight.bold,
                  color: _getColorForDifficulty(quiz.difficulty),
                ),
              ),
              DataCell(
                PopupMenuButton(
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(
                        child: ListTile(
                          leading: Icon(Icons.visibility),
                          title: CustomText(
                            text: 'Show Details',
                            color: Colors.black,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            _showQuizDetailsDialog(context, quiz);
                          },
                        ),
                      ),
                      PopupMenuItem(
                        child: ListTile(
                          leading: Icon(Icons.add),
                          title: CustomText(
                            text: 'Put in circulation',
                            color: Colors.green,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            _showDeleteConfirmation(context, quiz);
                          },
                        ),
                      ),
                    ];
                  },
                  icon: Icon(Icons.more_vert),
                ),
              ),
            ],
          );
        })
        .toList();
  }

  Widget _buildPagination() {
    final int totalPages =
        ((widget.quizzes.length - 1) / _rowsPerPage).ceil();
    return Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: () {
              setState(() {
                if (_currentPage > 1) {
                  _currentPage--;
                }
              });
            },
          ),
          CustomText(text: 'Page $_currentPage of $totalPages'),
          IconButton(
            icon: Icon(Icons.chevron_right),
            onPressed: () {
              setState(() {
                if ((_currentPage * _rowsPerPage) < widget.quizzes.length) {
                  _currentPage++;
                }
              });
            },
          ),
        ],
      ),
    );
  }

  List<Quiz> _filterQuizzes() {
    final difficultyFilteredQuizzes = selectedDifficulty == 'All'
        ? widget.quizzes
        : widget.quizzes
            .where((quiz) => quiz.difficulty == selectedDifficulty)
            .toList();

    return difficultyFilteredQuizzes.where((quiz) {
      final title = quiz.question.toLowerCase();
      return title.contains(searchQuery);
    }).toList();
  }

  void _showQuizDetailsDialog(BuildContext context, Quiz quiz) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return QuizDetailPage(
              quiz: quiz); // Use QuizDetailPage instead of QuizDetailScreen
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: label,
            color: Colors.black,
            weight: FontWeight.bold,
          ),
          SizedBox(width: 8),
          Expanded(
            child: CustomText(
              text: value,
              color: Colors.black54,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  //feetus deletus
  void _showDeleteConfirmation(BuildContext context, Quiz quiz) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: CustomText(text: "Unhide Quiz"),
          content: CustomText(text: "Are you sure you want to make this quiz available?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: CustomText(
                text: 'Cancel',
                color: Color.fromARGB(255, 12, 150, 0),
              ),
            ),
            TextButton(
              onPressed: () {
                _deleteQuiz(context, quiz);
              },
              child: CustomText(
                text: 'Delete',
                color: Colors.red,
              ),
            ),
          ],
        );
      },
    );
  }

   void _deleteQuiz(BuildContext context, Quiz quiz) async {
  try {
    String quizId = quiz.id ?? '';
    await ApiService.unhideQuiz(quizId); // Call hideQuiz method

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: CustomText(text: 'Quiz hidden successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: CustomText(text: 'Failed to hide quiz: $error'),
        duration: Duration(seconds: 2),
      ),
    );
  }
  Navigator.pop(context);
}

  Color _getColorForDifficulty(String difficulty) {
    switch (difficulty) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.black;
    }
  }
}
