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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
      content: Container(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: 'Nom'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Champ requis';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: categoryController,
                      decoration: InputDecoration(labelText: 'Catégorie'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Champ requis';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: quantityController,
                      decoration: InputDecoration(labelText: 'Quantité'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Champ requis';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                  height: 16), // Espacement entre le formulaire et les boutons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Annuler
                    },
                    child: Text('Annuler'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Valider le formulaire
                      if (_formKey.currentState?.validate() ?? false) {
                        Article updatedArticle = Article(
                          name: nameController.text,
                          category: categoryController.text,
                          quantity: int.tryParse(quantityController.text) ?? 0,
                          isBought: widget.initialArticle?.isBought ?? false,
                        );
                        Navigator.of(context).pop(updatedArticle);
                      }
                    },
                    child: Text('Valider'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
