import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class NoteWidget extends StatelessWidget {
  const NoteWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey.shade50
      ),
      padding: EdgeInsets.all(18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(Iconsax.note_favorite,size: 18,),
          SizedBox(width: 12,),
          Flexible(child: Text('If you are not tagged in any task you will see all tasks otherwise your will see only your taks where you are tagged.',style: TextStyle(fontSize: 12,color: Colors.grey),))
        ],
      ),
    );
  }
}
