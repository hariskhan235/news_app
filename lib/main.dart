import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_api/Presentation/cubits/home/Local/local_cubit.dart';
import 'package:news_api/Presentation/cubits/home/news_cubit.dart';
import 'package:news_api/Presentation/cubits/other/country_news_cubit.dart';

import 'App/news_app.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<NewsCubit>(
          create: (context) => NewsCubit(),
        ),
        BlocProvider<CountryNewsCubit>(
          create: (context) => CountryNewsCubit(),
        ),
        BlocProvider<LocalDatabaseCubit>(
          create: (context) => LocalDatabaseCubit()..getListArticles(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
