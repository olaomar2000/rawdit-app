import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final bool isFirst;
  final String title;
  final String description;
  const CustomListTile({
    Key key,
    this.isFirst,
    this.title,
    this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 75,
      decoration: isFirst
          ? BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: const Radius.circular(10),
              ),
              color: Colors.grey[300],
            )
          : null,
      color: isFirst ? null : Colors.grey[300],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          title: Text(
            title,
            style: const TextStyle(
                color: const Color(0xff707070),
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          subtitle: isFirst
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    description,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 75, 75, 75),
                      fontSize: 19,
                    ),
                  ),
                )
              : null,
          trailing: isFirst
              ? null
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    description,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 75, 75, 75),
                      fontSize: 19,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
