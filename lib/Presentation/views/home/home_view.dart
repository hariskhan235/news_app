import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'package:news_api/Presentation/cubits/home/news_cubit.dart';
import 'package:news_api/Presentation/cubits/home/news_state.dart';
import 'package:news_api/Presentation/views/home/Saved/saved_articles_screen.dart';
import 'package:news_api/Presentation/views/home/article_details_screen.dart';
import 'package:shimmer/shimmer.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ScrollController controller = ScrollController();
  late final RxBool showFloatingButton = false.obs;
  final newsController = TextEditingController();

  @override
  void initState() {
    controller.addListener(() {
      controller.addListener(() {
        if (controller.offset >= 50) {
          showFloatingButton.value = true;
        } else {
          showFloatingButton.value = false;
        }
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    newsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Padding(
              padding: const EdgeInsets.only(
                  right: 10, top: 10, bottom: 10, left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: newsController,
                      enabled: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).unfocus();
                        context
                            .read<NewsCubit>()
                            .fetchNews(value.trim().toString());
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      context
                          .read<NewsCubit>()
                          .fetchNews(newsController.text.trim().toString());
                    },
                    icon: const Icon(Icons.search),
                  ),
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'saved',
                        child: Text('Saved'),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'saved') {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const SavedArticlesScreen()));
                      }
                    },
                  )
                ],
              )),
        ),
      ),
      body: BlocConsumer<NewsCubit, NewsState>(builder: (context, state) {
        if (state is NewsLoaded) {
          final newsArticle = state.articles;
          return RefreshIndicator(
            onRefresh: () => context
                .read<NewsCubit>()
                .fetchNews(newsController.text.trim().toString()),
            child: ListView.builder(
                controller: controller,
                itemCount: newsArticle.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ListTile(
                        onTap: () {
                          final article = newsArticle[index];
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ArticleDetailScreen(
                                    article: article,
                                  )));
                        },
                        title: Text(newsArticle[index].title!),
                        subtitle: Text(newsArticle[index].author!),
                      ),
                    ),
                  );
                }),
          );
        } else if (state is NewsLoading) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            enabled: true,
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Card(
                        child: ListTile(
                            title: Container(
                              width: 50,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            subtitle: Container(
                              width: 20,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            leading: const CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey,
                            )),
                      )),
                );
              },
            ),
          );
        } else {
          return const Center(
            child: Text('Search'),
          );
        }
      }, listener: (context, state) {
        if (state is NewsLoaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Articles for ${newsController.text} Loaded'),
            ),
          );
        }
      }),
      floatingActionButton: ObxValue<RxBool>(
          (data) => Visibility(
                visible: data.value,
                child: FloatingActionButton(
                  onPressed: () => controller.animateTo(
                      controller.position.minScrollExtent,
                      duration: const Duration(milliseconds: 700),
                      curve: Curves.easeInOut),
                  backgroundColor: Colors.white,
                  child: const Icon(
                    Icons.arrow_upward,
                    color: Color(0xff124BCD),
                  ),
                ),
              ),
          showFloatingButton),
    );
  }
}
