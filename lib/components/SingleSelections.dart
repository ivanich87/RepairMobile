import 'package:flutter/material.dart';

class SingleSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;

  const SingleSection({
    Key? key,
    this.title,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          titleHeader(title),
        Column(
          children: children,
        ),
      ],
    );
  }
}

class SingleRowSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;

  const SingleRowSection({
    Key? key,
    this.title,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          titleHeader(title),
        ListView(scrollDirection: Axis.horizontal,
          children: children,
        ),
      ],
    );
  }
}

titleHeader(String? title) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(
      title!,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
  );
}

