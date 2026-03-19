import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../configurations/frontend_config.dart';

class ZiaratShimmer extends StatelessWidget {
  const ZiaratShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Shimmer.fromColors(
            baseColor: FrontEndConfig.backgroundColor.withOpacity(0.85),
            highlightColor: FrontEndConfig.backgroundColor.withOpacity(0.42),
            child: Container(
              height: 296,
              decoration: BoxDecoration(
                color: FrontEndConfig.backgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image placeholder
                  Container(
                    height: 163,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.50),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Title placeholder
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 11.0),
                    child: Container(
                      height: 16,
                      width: MediaQuery.of(context).size.width * 0.55,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.50),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Location row placeholder
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 11.0),
                    child: Row(
                      children: [
                        Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.50),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          height: 12,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.50),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Description line 1
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 11.0),
                    child: Container(
                      height: 12,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.50),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Description line 2
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 11.0),
                    child: Container(
                      height: 12,
                      width: MediaQuery.of(context).size.width * 0.65,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.50),
                        borderRadius: BorderRadius.circular(4),
                      ),
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