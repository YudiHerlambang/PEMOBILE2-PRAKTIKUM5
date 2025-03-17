import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:praktikum_5/models/recipe_model.dart';
import 'package:praktikum_5/services/api_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:praktikum_5/models/review_model.dart';
import 'dart:io';

class RecipeDetailScreen extends StatefulWidget {
  final RecipeModel recipe;

  const RecipeDetailScreen({Key? key, required this.recipe}) : super(key: key);

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _description = '';
  String _ratting = 'good';
  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _submitReview() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        String imageId = _image != null ? await ApiService.uploadImage(_image!) : "";
        
        ReviewModel review = ReviewModel(
          recipesId: widget.recipe.id,
          name: _name,
          description: _description,
          ratting: _ratting,
          image: imageId,
          status: "published",
        );
        
        bool success = await ApiService.postReview(review);
        if (success) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Review berhasil dikirim!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengirim review: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _showReviewDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 16,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Nama'),
                    validator: (value) => value?.isEmpty ?? true ? 'Masukkan nama Anda' : null,
                    onSaved: (value) => _name = value ?? '',
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Isi Review'),
                    validator: (value) => value?.isEmpty ?? true ? 'Masukkan review Anda' : null,
                    onSaved: (value) => _description = value ?? '',
                  ),
                  DropdownButtonFormField<String>(
                    value: _ratting,
                    items: ['good', 'not_good'].map((value) => DropdownMenuItem(
                      value: value,
                      child: Text(value == 'good' ? 'Good' : 'Not Good'),
                    )).toList(),
                    onChanged: (value) => setState(() => _ratting = value ?? 'good'),
                    decoration: const InputDecoration(labelText: 'Rating'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: const Text('Pilih Gambar'),
                  ),
                  if (_image != null) Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Image.file(_image!, height: 100),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                    child: ElevatedButton(
                      onPressed: _submitReview,
                      child: const Text('Kirim Review'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Column(
          children: [
            Text(
              widget.recipe.name!.toUpperCase(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: 300,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                        child: Image.network(
                          ApiService.getAsset(widget.recipe.image),
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withAlpha(108),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: MarkdownBody(data: widget.recipe.ingredients!),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: MarkdownBody(data: widget.recipe.steps!),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showReviewDialog,
        child: const Icon(Icons.rate_review),
      ),
    );
  }
}
