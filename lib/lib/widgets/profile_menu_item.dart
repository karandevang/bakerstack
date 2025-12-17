import 'package:flutter/material.dart';
import '../utils/colors.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const ProfileMenuItem({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Container(
          width: 30,
          child: Icon(icon, color: AppColors.primaryPurple),
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: () {},
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        hoverColor: AppColors.primaryPurple.withOpacity(0.1),
      ),
    );
  }
}