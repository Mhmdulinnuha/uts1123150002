import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_divider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/route/app_router.dart';


class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}


class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    // Fetch produk begitu halaman dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchProducts();
    });
  }


  @override
  Widget build(BuildContext context) {
    final auth    = context.watch<AuthProvider>();
    final product = context.watch<ProductProvider>();


    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Dashboard', style: TextStyle(fontSize: 18)),
            Text(
              'Halo, ${auth.firebaseUser?.displayName ?? 'User'}!',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.logout();
              if (!mounted) return;
              Navigator.pushReplacementNamed(context, AppRouter.login);
            },
          ),
 ],
      ),


      body: switch (product.status) {
        ProductStatus.loading || ProductStatus.initial => const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Memuat produk...'),
              ],
            ),
          ),


        ProductStatus.error => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(product.error ?? 'Terjadi kesalahan'),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Coba Lagi'),
                  onPressed: () => product.fetchProducts(),
                ),
              ],
            ),
          ),


        ProductStatus.loaded => RefreshIndicator(
            onRefresh: () => product.fetchProducts(),
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: product.products.length,
              itemBuilder: (context, i) {
  final p = product.products[i];

  return InkWell(
    borderRadius: BorderRadius.circular(16),
    onTap: () {
      // TODO: detail produk
    },
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGE + BADGE
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  p.imageUrl,
                  height: 130,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              // Badge kategori
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    p.category,
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ),
            ],
          ),

          // CONTENT
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  Text(
                    'Rp ${p.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
            ),
          ),
      },
    );
  }
}
