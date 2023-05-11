import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_api/Domain/article.dart';
import 'package:news_api/Presentation/cubits/home/Local/local_cubit.dart';
import 'package:news_api/Presentation/cubits/home/Local/local_state.dart';

class ArticleDetailScreen extends StatelessWidget {
  final Articles? article;
  // final String assetImage;
  const ArticleDetailScreen({
    super.key,
    required this.article,
    //required this.assetImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Article Detail'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,
              width: double.infinity,
              child: Image.network(
                article!.urlToImage!,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                article!.title!,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'By ${article!.author}- ${article!.publishedAt}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                article!.description!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                article!.description!,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ElevatedButton(
                      onPressed: () async {
                        // Open article link in browser
                        // if (await canLaunchUrl(Uri.parse(article.url!))) {
                        //   await launchUrl(Uri.parse(article.url!));
                        // }
                      },
                      child: const Text('Read Full Article'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: BlocConsumer<LocalDatabaseCubit, LocalDatabaseState>(
                    listener: (context, state) {
                      if (state is LocalDatabaseLoadingState) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Saving')));
                      } else if (state is LocalDatabaseArticleAdded) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.value.toString())));
                      } else if (state is LocalDatabaseErrorState) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message.toString())));
                      }
                    },
                    builder: (context, state) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ElevatedButton(
                          onPressed: () async {
                            context
                                .read<LocalDatabaseCubit>()
                                .saveArticle(article!);
                          },
                          child: const Text('Save Article'),
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
