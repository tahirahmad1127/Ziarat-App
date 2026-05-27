import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../configurations/frontend_config.dart';

class PackageShimmer extends StatelessWidget {
  const PackageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 12),
          child: Shimmer.fromColors(
            baseColor: FrontEndConfig.backgroundColor.withOpacity(0.85),
            highlightColor: FrontEndConfig.backgroundColor.withOpacity(0.42),
            child: Container(
              height: 165,
              decoration: BoxDecoration(
                color: FrontEndConfig.backgroundColor,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Column(
                children: [
                  // Top row: package name, duration, price
                  Container(
                    height: 65,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Name + duration
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 14,
                              width: 120,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.50),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              height: 11,
                              width: 80,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.50),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        ),
                        // Price
                        Container(
                          height: 14,
                          width: 60,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.50),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Divider placeholder
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(height: 1, color: Colors.white.withOpacity(0.22)),
                  ),

                  // Bottom row: 4 icons + values
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(4, (i) {
                        return Column(
                          children: [
                            // Icon placeholder
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.50),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(height: 6),
                            // Label
                            Container(
                              height: 10,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.50),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Value
                            Container(
                              height: 12,
                              width: 30,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.50),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}