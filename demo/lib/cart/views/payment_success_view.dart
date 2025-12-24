import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentSuccessView extends StatelessWidget {
  const PaymentSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    // Otomatis pindah ke Home setelah 3 detik jika user diam saja (opsional)
    // Future.delayed(const Duration(seconds: 4), () => Get.offAllNamed('/home'));

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animasi Icon (Scale Up)
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 800),
                curve: Curves.elasticOut,
                builder: (context, double value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check_rounded, size: 80, color: Colors.green),
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
              
              const Text(
                "Pembayaran Berhasil!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 12),
              const Text(
                "Pesananmu sedang disiapkan oleh dapur kami. Mohon tunggu sebentar ya!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
              ),
              
              const SizedBox(height: 60),

              // Tombol Kembali ke Home
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => Get.offAllNamed('/home'), // Sesuaikan route home kamu
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: const Text("Kembali ke Beranda", 
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                   // Arahkan ke history pesanan jika ada
                   Get.offAllNamed('/home'); 
                   // Get.toNamed('/order-history'); 
                }, 
                child: const Text("Lihat Detail Pesanan", style: TextStyle(color: Colors.orange)),
              )
            ],
          ),
        ),
      ),
    );
  }
}