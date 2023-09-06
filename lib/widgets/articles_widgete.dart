import 'package:flutter/material.dart';
import 'package:newzy/consts/vars.dart';
import 'package:newzy/inner_screens/blog_details.dart';
import 'package:newzy/inner_screens/news_details_webview.dart';
import 'package:newzy/models/bookmarks_model.dart';
import 'package:newzy/services/utils.dart';
import 'package:newzy/widgets/vertical_spacing.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../inner_screens/bookmarks_screen.dart';
import '../models/news_model.dart';

class ArticlesWidget extends StatelessWidget {
  const ArticlesWidget({
    super.key, this.isBookmark=false,
  });
  //final String imageUrl, title, url, dateToShow, readingTime;
  final bool isBookmark;
  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    dynamic newsModelProvider = isBookmark?   //using dynamic instead of final
    Provider.of<BookmarksModel>(context):
    Provider.of<NewsModel>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Theme.of(context).cardColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, NewsDetailsScreen.routeName,
                  arguments: newsModelProvider.publishedAt);
            },
            child: Stack(children: [
              Container(
                height: 60,
                width: 60,
                color: Theme.of(context).colorScheme.secondary,
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  height: 60,
                  width: 60,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              Container(
                color: Theme.of(context).cardColor,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: size.height * 0.12,
                        width: size.height * 0.12,
                        child: Hero(
                          tag: newsModelProvider.publishedAt,
                          child: Image.network(newsModelProvider.urlToImage),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            newsModelProvider.title,
                            textAlign: TextAlign.justify,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: smallTextStyle,
                          ),
                          const VerticalSpacing(5),
                          Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              '🕒 ${newsModelProvider.readingTimeText}',
                              style: smallTextStyle,
                            ),
                          ),
                          FittedBox(
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                          type: PageTransitionType.rightToLeft,
                                          child: NewsDetailsWebView(
                                            url: newsModelProvider.url,
                                          ),
                                          inheritTheme: true,
                                          ctx: context),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.link,
                                    color: Colors.blue,
                                  ),
                                ),
                                Text(
                                  newsModelProvider.dateToShow,
                                  maxLines: 1,
                                  style: smallTextStyle,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
