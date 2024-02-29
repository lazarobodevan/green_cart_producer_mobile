import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_producer/screens/nav_pages/my_store/bloc/my_store_bloc.dart';
import 'package:mobile_producer/services/product_service.dart';
import 'package:mobile_producer/shared/components/custom_app_bar.dart';
import 'package:mobile_producer/shared/components/custom_icon_button.dart';
import 'package:mobile_producer/shared/components/custom_label.dart';
import 'package:mobile_producer/shared/components/custom_text_field.dart';
import 'package:mobile_producer/shared/components/product_card/product_card.dart';
import 'package:mobile_producer/theme/theme_colors.dart';
import 'package:mobile_producer/theme/typography_styles.dart';

class MyStoreScreen extends StatelessWidget {
  const MyStoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyStoreBloc(
          productService: RepositoryProvider.of<ProductService>(context))
        ..add(MyStoreLoadProductsEvent(
            producerId: "f31f3139-e991-430e-9056-94f5b1ec7c57")),
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed("/product");
          },
          shape: CircleBorder(),
          backgroundColor: ThemeColors.primary3,
          child: const Center(
            child: Icon(
              Icons.add,
              color: ThemeColors.white,
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  controller: TextEditingController(),
                  prefixIcon: Icon(Icons.search),
                  hintText: "Pesquisar...",
                  onChanged: (String s) {},
                ),
                const SizedBox(
                  height: 20,
                ),
                Text("Meus produtos", style: TypographyStyles.label1()),
                const SizedBox(
                  height: 16,
                ),
                BlocBuilder<MyStoreBloc, MyStoreState>(
                  builder: (context, state) {
                    if (state is MyStoreLoadingState) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (state is MyStoreLoadedState) {
                      var data = state.data;
                      var products = data.products.data;
                      return Expanded(
                        child: products.isNotEmpty
                            ? GridView.count(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                childAspectRatio: 0.8,
                                children: products
                                    .map((element) =>
                                        ProductCard(product: element))
                                    .toList())
                            : getAddNewProduct(context),
                      );
                    }

                    return Center(child: Text("Oops"));
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getAddNewProduct(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Você ainda não tem nenhum produto.\nAdicione um!",
            style: TypographyStyles.paragraph2(),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),
          CustomIconButton(
              onTap: () {
                Navigator.pushNamed(context, "/product");
              },
              text: "Adicionar",
              icon: Icons.add)
        ],
      ),
    );
  }
}
