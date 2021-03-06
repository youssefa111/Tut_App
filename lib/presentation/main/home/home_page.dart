import 'package:carousel_slider/carousel_slider.dart';
import 'package:complete_advanced_flutter/app/di.dart';
import 'package:complete_advanced_flutter/domain/model/model.dart';
import 'package:complete_advanced_flutter/presentation/common/state_renderer/state_render_impl.dart';
import 'package:complete_advanced_flutter/presentation/main/home/home_viewmodel.dart';
import 'package:complete_advanced_flutter/presentation/resources/color_manager.dart';
import 'package:complete_advanced_flutter/presentation/resources/strings_manager.dart';
import 'package:complete_advanced_flutter/presentation/resources/values_manager.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeViewModel _viewModel = instance<HomeViewModel>();

  @override
  void initState() {
    _bind();
    super.initState();
  }

  _bind() {
    _viewModel.start();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: StreamBuilder<FlowState>(
          stream: _viewModel.outputState,
          builder: (context, snapshot) {
            return snapshot.data?.getScreenWidget(context, _getContentWidgets(),
                    () {
                  _viewModel.start();
                }) ??
                Container();
          },
        ),
      ),
    );
  }

  Widget _getContentWidgets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _getBannerAdsCarousel(),
        _getSection(AppStrings.services),
        _getServices(),
        _getSection(AppStrings.stores),
        _getStores(),
      ],
    );
  }

  Widget _getSection(String title) {
    return Padding(
      padding: EdgeInsets.only(
        top: AppPadding.p12,
        left: AppPadding.p12,
        right: AppPadding.p12,
        bottom: AppPadding.p2,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headline3,
      ),
    );
  }

  Widget _getBannerAdsCarousel() {
    return StreamBuilder<List<BannerAd>>(
      stream: _viewModel.outputBanners,
      builder: (context, snapshot) {
        return _getBannerAd(snapshot.data);
      },
    );
  }

  Widget _getBannerAd(List<BannerAd>? bannerAds) {
    if (bannerAds != null) {
      return CarouselSlider(
          items: bannerAds
              .map(
                (bannerAds) => SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: AppSize.s1_5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSize.s12),
                      side: BorderSide(
                          color: ColorManager.white, width: AppSize.s1_5),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppSize.s12),
                      child: Image.network(
                        bannerAds.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
          options: CarouselOptions(
            height: AppSize.s180,
            autoPlay: true,
            enableInfiniteScroll: true,
            enlargeCenterPage: true,
          ));
    } else {
      return Container();
    }
  }

  Widget _getServices() {
    return StreamBuilder<List<Service>>(
      stream: _viewModel.outputServices,
      builder: (context, snapshot) {
        return _getServicesWidget(snapshot.data);
      },
    );
  }

  Widget _getServicesWidget(List<Service>? services) {
    if (services != null) {
      return Padding(
        padding: EdgeInsets.only(
          left: AppPadding.p12,
          right: AppPadding.p12,
        ),
        child: Container(
          height: AppSize.s140,
          margin: EdgeInsets.symmetric(vertical: AppMargin.m12),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: services
                .map((service) => Card(
                      elevation: AppSize.s4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSize.s12),
                        side: BorderSide(
                            color: ColorManager.white, width: AppSize.s1_5),
                      ),
                      child: Column(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(AppSize.s12),
                            child: Image.network(
                              service.image,
                              fit: BoxFit.cover,
                              width: AppSize.s130,
                              height: AppSize.s130,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: AppPadding.p8),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                service.title,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _getStores() {
    return Center();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}
