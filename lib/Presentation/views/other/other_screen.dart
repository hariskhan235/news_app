import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:news_api/App/Constants/constants.dart';
import 'package:news_api/Presentation/cubits/other/country_news_cubit.dart';
import 'package:news_api/Presentation/cubits/other/country_news_state.dart';
import 'package:shimmer/shimmer.dart';

class CountryHeadlines extends StatefulWidget {
  const CountryHeadlines({super.key});

  @override
  State<CountryHeadlines> createState() => _CountryHeadlinesState();
}

class _CountryHeadlinesState extends State<CountryHeadlines> {
  String seletedCountry = '';

  String seletedCategory = '';
  final ScrollController controller = ScrollController();
  late final RxBool showFloatingButton = false.obs;
  @override
  void initState() {
    controller.addListener(() {
      if (controller.offset >= 50) {
        showFloatingButton.value = true;
      } else {
        showFloatingButton.value = false;
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    onTap: () {
                      // Show the dropdown menu on tap.
                      showMenu(
                        context: context,
                        position: const RelativeRect.fromLTRB(0, 0, 0, 0),
                        items: countries.map((item) {
                          return PopupMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                      ).then((value) {
                        // Update the selected item when the user selects one.
                        setState(() {
                          seletedCountry = value!;
                        });
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Country',
                      border: outlineInputBorder,
                    ),
                    controller: TextEditingController(text: seletedCountry),
                    onSubmitted: (value) {
                      FocusScope.of(context).unfocus();
                    },
                    readOnly: true,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 2,
                  child: TextField(
                    onTap: () {
                      showMenu(
                        context: context,
                        position: RelativeRect.fromDirectional(
                            textDirection: TextDirection.ltr,
                            start: 20,
                            top: 10,
                            end: 0,
                            bottom: 0),
                        items: catogories.map((item) {
                          return PopupMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                      ).then((value) {
                        // Update the selected item when the user selects one.
                        setState(() {
                          seletedCategory = value!;
                        });
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Catogory',
                      border: outlineInputBorder,
                    ),
                    controller: TextEditingController(text: seletedCategory),
                    onSubmitted: (value) {
                      FocusScope.of(context).unfocus();
                    },
                    readOnly: true,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    onPressed: () {
                      seletedCountry.isEmpty && seletedCountry.isEmpty
                          ? showSnackBar(context)
                          : context.read<CountryNewsCubit>().fetchCountryNews(
                              seletedCountry.substring(0, 2).toLowerCase(),
                              seletedCategory);
                    },
                    icon: const Icon(Icons.search),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: BlocBuilder<CountryNewsCubit, CountryNewsState>(
        builder: (context, state) {
          if (state is CountryNewsLoading) {
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
          } else if (state is CountryNewsLoaded) {
            final articles = state.articles;
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                  controller: controller,
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: ListTile(
                          title: Text(articles[index].title ?? ''),
                          subtitle: Text(articles[index].author ?? ''),
                          leading: articles[index].urlToImage != null
                              ? Image.network(articles[index].urlToImage ?? '')
                              : Image.asset('assets/images/news.jpg'),
                        ),
                      ),
                    );
                  }),
            );
          } else if (state is CountryNewsInitial) {
            return const Center(
              child: Text('Search'),
            );
          }
          return SizedBox();
        },
      ),
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

  showSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Fields are required')));
  }
}
