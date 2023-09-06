import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:newzy/services/global_methods.dart';
import 'package:newzy/services/utils.dart';
import 'package:newzy/widgets/vertical_spacing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsDetailsWebView extends StatefulWidget {
  const NewsDetailsWebView({super.key, required this.url});
  final String url;

  @override
  State<NewsDetailsWebView> createState() => _NewsDetailsWebViewState();
}

class _NewsDetailsWebViewState extends State<NewsDetailsWebView> {
  late WebViewController _webViewController;
  double _progress = 0;

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).getColor;
    return WillPopScope(
      onWillPop: () async {
        if (await _webViewController.canGoBack()) {
          _webViewController.goBack();
          //stay inside
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(IconlyLight.arrowLeft2)),
            iconTheme: IconThemeData(color: color),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            centerTitle: true,
            title: Text(
              widget.url,
              style: TextStyle(color: color),
            ),
            actions: [
              IconButton(
                  onPressed: () async {
                    await _showModalSheetFct();
                  },
                  icon: const Icon(Icons.more_horiz))
            ],
          ),
          body: Column(
            children: [
              LinearProgressIndicator(
                value: _progress,
                color: _progress == 1.0 ? Colors.transparent : Colors.blue,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              ),
              Expanded(
                child: WebView(
                  initialUrl: widget
                      .url, //calling widget.url because its outside of state class
                  zoomEnabled: true,
                  onProgress: (progress) {
                    setState(() {
                      _progress = progress / 100;
                    });
                  },
                  onWebViewCreated: (controller) {
                    _webViewController = controller;
                  },
                ),
              ),
            ],
          )),
    );
  }

  Future<void> _showModalSheetFct() async {
    await showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                VerticalSpacing(20),
                Center(
                  child: Container(
                    height: 5,
                    width: 35,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(30)),
                  ),
                ),
                Text(
                  'More options',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                ),
                const VerticalSpacing(20),
                const Divider(
                  thickness: 2,
                ),
                const VerticalSpacing(20),
                ListTile(
                  leading: const Icon(Icons.share),
                  title: const Text('Share'),
                  onTap: () async {
                    GlobalMethods.errorDialog(
                        errorMessage: "An error occured", context: context);
                    try {
                      await Share.share(widget.url,
                          subject: 'Look what I made!');
                    } catch (err) {
                      GlobalMethods.errorDialog(
                          errorMessage: err.toString(), context: context);
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.open_in_browser),
                  title: const Text('Open in browser'),
                  onTap: () async {
                    if (!await launchUrl(Uri.parse(widget.url))) {
                      throw 'Could not launch $widget.url';
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.refresh),
                  title: const Text('Refresh'),
                  onTap: () async {
                    try {
                      await _webViewController.reload();
                    } catch (err) {
                    } finally {
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          );
        });
  }
}
