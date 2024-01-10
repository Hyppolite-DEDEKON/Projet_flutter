// dialogs/add_article_dialog.dart
import 'package:flutter/material.dart';
import '../model/article.dart';

class AddArticleDialog extends StatefulWidget {
  final Article? initialArticle;

  const AddArticleDialog({Key? key, this.initialArticle}) : super(key: key);

  @override
  _AddArticleDialogState createState() => _AddArticleDialogState();
}

class _AddArticleDialogState extends State<AddArticleDialog> {
  late TextEditingController nameController;
  late TextEditingController categoryController;
  late TextEditingController quantityController;

  @override
  void initState() {
    super.initState();
    nameController =
        TextEditingController(text: widget.initialArticle?.name ?? '');
    categoryController =
        TextEditingController(text: widget.initialArticle?.category ?? '');
    quantityController = TextEditingController(
        text: widget.initialArticle?.quantity.toString() ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialArticle != null
          ? 'Modifier Article'
          : 'Ajouter Article'),
      content: SizedBox(
        height: 180.0, // Ajustez la hauteur selon vos besoins
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nom'),
            ),
            TextField(
              controller: categoryController,
              decoration: InputDecoration(labelText: 'Catégorie'),
            ),
            TextField(
              controller: quantityController,
              decoration: InputDecoration(labelText: 'Quantité'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Annuler
          },
          child: Text('Annuler'),
        ),
        TextButton(
          onPressed: () {
            // Valider
            Article updatedArticle = Article(
              name: nameController.text,
              category: categoryController.text,
              quantity: int.tryParse(quantityController.text) ?? 0,
              isBought: widget.initialArticle?.isBought ?? false,
            );
            Navigator.of(context).pop(updatedArticle);
          },
          child: Text('Valider'),
        ),
      ],
    );
  }
}
