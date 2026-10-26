// Inside your build method / widget tree in home_screen.dart:
ElevatedButton(
  onPressed: () {
    Navigator.pushNamed(context, '/report');
  },
  child: const Text('Go to Report Form'),
),