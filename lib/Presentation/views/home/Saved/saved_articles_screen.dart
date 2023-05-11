import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_api/Presentation/cubits/home/Local/local_cubit.dart';
import 'package:news_api/Presentation/cubits/home/Local/local_state.dart';

class SavedArticlesScreen extends StatelessWidget {
  const SavedArticlesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<LocalDatabaseCubit, LocalDatabaseState>(
          builder: (context, state) {
        if (state is LocalDatabaseSuccessState) {
          final articles = state.data;
          return articles.isEmpty
              ? const Center(
                  child: Text('No Saved Articles'),
                )
              : ListView.builder(
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(),
                    child: ListTile(
                      title: Text(articles[index].author!),
                      subtitle: Text(articles[index].publishedAt!),
                    ),
                  );
                });
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      }),
    );
  }
}
