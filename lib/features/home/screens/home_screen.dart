import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/core/network/api_error.dart';
import 'package:hungry/core/utils/pref_helper.dart';
import 'package:hungry/features/favorite/data/favorite_model.dart';
import 'package:hungry/features/favorite/data/favorite_repo.dart';
import 'package:hungry/features/home/data/repo/product_repo.dart';
import 'package:hungry/features/home/data/model/product_model.dart';
import 'package:hungry/features/home/widgets/custom_card.dart';
import 'package:hungry/features/home/widgets/custom_food_categories.dart';
import 'package:hungry/features/productDetails/screens/product_details_screen.dart';
import 'package:hungry/shared/custom_text.dart';
import 'package:hungry/shared/scaffold_message_error.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../widgets/custom_search_field.dart';
import '../widgets/custom_user_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const List<String> categories = [
    "All",
    "Combo",
    "Classic",
    "Classic",
    "Classic",
    "Classic",
  ];
  static const int selectedCategory = 0;
  late List<ProductModel> productsList = [];
  List<int> favListId = [];
  List<String> favListIdString = [];

  ProductRepo _productRepo = ProductRepo();
  FavoriteRepo _favoriteRepo = FavoriteRepo();
  bool isLoading = true;

  Future<void> fetchProduct() async {
    try {
      final products = await _productRepo.getProduct("/products");
      if (!mounted) return;

      setState(() {
        productsList = products;
        isLoading = false;
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> toggleFavorite(int productId) async {
    try {
      final response = await _favoriteRepo.toggleFavorite(productId);

      print(response);
      if (response["message"] is ApiError) {
        scaffoldMessengerError(context, response["message"]);
      }
      scaffoldMessengerError(context, response["message"], color: Colors.green);
      if (response["code"] == 200) {
        if (favListId.contains(productId)) {
          setState(() {
            favListId.remove(productId);
          });
        } else {
          setState(() {
            favListId.add(productId);
          });
        }
        await PrefHelper.setFavListId(favListId);
      }
    } catch (e) {
      print(e);
      String mess = "unhandled exc";
      if (e is ApiError) {
        mess = e.toString();
      }
      scaffoldMessengerError(context, mess);
    }
  }

  Future<void> loadFavIds() async {
    final List = await PrefHelper.getFavListId();
    if (!mounted) return;
    setState(() {
      favListIdString = List ?? [];
      favListId = favListIdString.map((e) => int.parse(e)).toList();
    });
  }

  // step 1 save the prouctID at List<int>
  //step 2 set the productId in the shared Pref
  //step 3 get the List save in the shared pref
  // step 4 make new list<String> equal it with the getList of shared pref
  // step 5 convert the List<String> items to int and eqaual it with List<int>
  // reuse the List<int> and all needed functions
  // Future<void> loadFavIds() async {

  @override
  void initState() {
    fetchProduct();
    loadFavIds();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Skeletonizer(
            enabled: isLoading,
            enableSwitchAnimation: true,

            child: CustomScrollView(
              slivers: [
                //App bar + search
                SliverAppBar(
                  pinned: false,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  automaticallyImplyLeading: false,
                  backgroundColor: AppColors.basic,
                  toolbarHeight: 190,
                  flexibleSpace: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 20,
                    ),
                    child: Column(
                      children: [
                        Gap(50),
                        CustomUserHeader(),
                        Gap(10),
                        CustomSearchField(),
                      ],
                    ),
                  ),
                ),
                //Categories
                SliverToBoxAdapter(
                  child: CustomFoodCategories(
                    categories: categories,
                    selectedCategory: selectedCategory,
                  ),
                ),
                //Gridview
                SliverPadding(
                  padding: EdgeInsets.all(8),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      if (isLoading) {
                        return Skeleton.leaf(
                          child: CustomCard(
                            onTapFav: () {},
                            image: '',
                            title: '',
                            price: "0",
                            rate: "",
                            productId: 0,
                            favListId: [],
                          ),
                        );
                      }
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailsScreen(
                                product: productsList[index],
                              ),
                            ),
                          );
                        },
                        child: CustomCard(
                          isFavorite: favListId!.contains(
                            productsList[index].id,
                          ),
                          onTapFav: () =>
                              toggleFavorite(productsList[index].id),
                          image: productsList[index].image,
                          title: productsList[index].name,
                          price: productsList[index].price,
                          rate: productsList[index].rating,
                          productId: productsList[index].id,
                          favListId: favListId!,
                        ),
                      );
                    }, childCount: isLoading ? 6 : productsList.length),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.65,
                      mainAxisSpacing: 0,
                      crossAxisSpacing: 6,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
