import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class GameState {
  List<String> board;
  String currentPlayer;
  String winner;

  GameState()
      : board = List<String>.filled(9, ''),
        currentPlayer = 'X',
        winner = '';

  bool makeMove(int index) {
    if (board[index] == '' && winner == '') {
      board[index] = currentPlayer;
      if (checkWinner()) {
        winner = currentPlayer;
      } else {
        currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
      }
      return true;
    }
    return false;
  }

  bool checkWinner() {
    List<List<int>> winConditions = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
      [0, 4, 8], [2, 4, 6]             // Diagonals
    ];

    for (var condition in winConditions) {
      if (board[condition[0]] == currentPlayer &&
          board[condition[0]] == board[condition[1]] &&
          board[condition[0]] == board[condition[2]]) {
        return true;
      }
    }
    return false;
  }

  bool isBoardFull() {
    return !board.contains('');
  }

  void reset() {
    board = List<String>.filled(9, '');
    currentPlayer = 'X';
    winner = '';
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GameState _gameState = GameState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _gameState.reset();
              });
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildBoard(),
          _buildCurrentPlayer(),
        ],
      ),
    );
  }

  Widget _buildBoard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemCount: 9,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                if (_gameState.makeMove(index)) {
                  if (_gameState.winner != '' || _gameState.isBoardFull()) {
                    _showResultDialog();
                  }
                }
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: _gameState.board[index] == '' ? Colors.white : Colors.lightBlueAccent,
              ),
              child: Center(
                child: Text(
                  _gameState.board[index],
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: _gameState.board[index] == 'X' ? Colors.red : Colors.green,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCurrentPlayer() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'Current Player: ${_gameState.currentPlayer}',
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _showResultDialog() {
    String result = _gameState.winner != '' ? 'Winner: ${_gameState.winner}' : 'It\'s a Tie!';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(result),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _gameState.reset();
                  Navigator.of(context).pop();
                });
              },
              child: const Text('Play Again'),
            ),
          ],
        );
      },
    );
  }
}
