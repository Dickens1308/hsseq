import 'package:flutter/material.dart';

class DashboardTile extends StatelessWidget {
  const DashboardTile(
      {Key? key,
      required this.title,
      required this.iconData,
      required this.function})
      : super(key: key);
  final String title;
  final IconData iconData;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => function(),
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: MediaQuery.of(context).size.height * .18,
        width: MediaQuery.of(context).size.width * .43,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              spreadRadius: .4,
              blurRadius: .4,
              offset: const Offset(1, 0),
              color: const Color.fromARGB(255, 179, 179, 179).withOpacity(.1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey.withOpacity(.3),
              child: Center(
                child: Icon(
                  iconData,
                  color: title == "Logout" ? Colors.red : Colors.blue,
                  size: 35,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
