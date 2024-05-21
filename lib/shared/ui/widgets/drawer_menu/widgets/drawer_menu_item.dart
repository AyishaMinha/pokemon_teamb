import 'package:app/shared/utils/spacer.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:app/shared/ui/widgets/pokeball.dart';
import 'package:app/theme/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DrawerMenuItemWidget extends StatelessWidget {
  final String text;
  final double height;
  final double width;
  final IconData icon;
  final VoidCallback? onTap;
  final MainAxisAlignment? contentAlignment;

  const DrawerMenuItemWidget({
    Key? key,
    required this.text,
    this.height = 50,
    this.width = 155,
    this.onTap,
    required this.icon,
    this.contentAlignment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(7),
      child: InkWell(
        onTap: onTap ??
            () {
              BotToast.showText(text: "Not implemented yet");
            },
        child: Ink(
          child: Container(
            width: width,
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: (onTap != null)
                    ? Colors.white.withOpacity(0.75)
                    : Colors.white.withOpacity(0.15),
              ),
              color: onTap != null
                  ? Colors.transparent
                  : AppTheme.getColors(context)
                      .drawerDisabled
                      .withOpacity(0.15),
              borderRadius: BorderRadius.circular(15),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: -12,
                    right: -14,
                    child: PokeballWidget(
                      size: 83,
                      color: Colors.white.withOpacity(0.05),
                    ),
                  ),
                  Positioned(
                    top: -60,
                    left: -50,
                    child: PokeballWidget(
                      size: 83,
                      color: Colors.white.withOpacity(0.05),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment:
                          contentAlignment ?? MainAxisAlignment.start,
                      children: [
                        Icon(
                          icon,
                          color: (onTap != null)
                              ? Colors.white
                              : Colors.white.withOpacity(0.25),
                        ),
                        wSpace(10),
                        Text(
                          text,
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: (onTap != null)
                                ? Colors.white
                                : Colors.white.withOpacity(0.5),
                            fontFamily: 'Circular',
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
