import 'package:flutter/material.dart';
class MenuItem extends StatelessWidget {
  String menuTitle;
  Icon menuIcon;
  var page;
  MenuItem(this.menuTitle,this.menuIcon,this.page);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(menuTitle),
      leading: menuIcon,
      trailing: Icon(Icons.arrow_right),
      onTap: (){
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(
            builder: (context)=>page));
      },
    );
  }
}
