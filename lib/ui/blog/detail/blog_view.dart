import 'dart:async';

import 'package:flutterstore/config/ps_colors.dart';
import 'package:flutterstore/config/ps_config.dart';
import 'package:flutterstore/constant/ps_dimens.dart';

import 'package:flutterstore/ui/common/ps_back_button_with_circle_bg_widget.dart';
import 'package:flutterstore/ui/common/ps_ui_widget.dart';
import 'package:flutterstore/utils/utils.dart';
import 'package:flutterstore/viewobject/blog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BlogView extends StatefulWidget {
  const BlogView({Key key, @required this.blog, @required this.heroTagImage})
      : super(key: key);

  final Blog blog;
  final String heroTagImage;

  @override
  _BlogViewState createState() => _BlogViewState();
}

class _BlogViewState extends State<BlogView> {
  bool isReadyToShowAppBarIcons = false;

  @override
  Widget build(BuildContext context) {
    if (!isReadyToShowAppBarIcons) {
      Timer(const Duration(milliseconds: 800), () {
        setState(() {
          isReadyToShowAppBarIcons = true;
        });
      });
    }

    return Scaffold(
        body: CustomScrollView(
      shrinkWrap: true,
      slivers: <Widget>[
        SliverAppBar(
          brightness: Utils.getBrightnessForAppBar(context),
          expandedHeight: PsDimens.space300,
          floating: true,
          pinned: true,
          snap: false,
          elevation: 0,
          leading: PsBackButtonWithCircleBgWidget(
              isReadyToShow: isReadyToShowAppBarIcons),
          backgroundColor: PsColors.mainColor,
          flexibleSpace: FlexibleSpaceBar(
            background: PsNetworkImage(
              photoKey: widget.heroTagImage,
              height: PsDimens.space300,
              width: double.infinity,
              defaultPhoto: widget.blog.defaultPhoto,
              boxfit: BoxFit.cover,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: TextWidget(
            blog: widget.blog,
          ),
        )
      ],
    ));
  }
}

class TextWidget extends StatefulWidget {
  const TextWidget({
    Key key,
    @required this.blog,
  }) : super(key: key);

  final Blog blog;

  @override
  _TextWidgetState createState() => _TextWidgetState();
}

class _TextWidgetState extends State<TextWidget> {
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isConnectedToInternet) {

      checkConnection();
    }
    return Container(
      color: PsColors.backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(PsDimens.space12),
            child: Text(
              widget.blog.name,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: PsDimens.space12,
                right: PsDimens.space12,
                bottom: PsDimens.space12),
            child: Text(
              widget.blog.description,
              style:
                  Theme.of(context).textTheme.bodyText2.copyWith(height: 1.5),
            ),
          ),

          // Visibility(
          //   visible: PsConfig.showAdMob &&
          //       isSuccessfullyLoaded &&
          //       isConnectedToInternet,
          //   child: AdmobBanner(
          //     adUnitId: Utils.getBannerAdUnitId(),
          //     adSize: AdmobBannerSize.FULL_BANNER,
          //     listener: (AdmobAdEvent event, Map<String, dynamic> map) {
          //      //print('BannerAd event is $event');
          //       if (event == AdmobAdEvent.loaded) {
          //         isSuccessfullyLoaded = true;
          //       } else {
          //         isSuccessfullyLoaded = false;
          //         setState(() {});
          //       }
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
