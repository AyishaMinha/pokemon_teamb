import 'package:flutter/material.dart';
import 'package:app/shared/utils/app_constants.dart';
import 'package:app/theme/app_theme.dart';

class PokemonTypeBadge extends StatelessWidget {
  final String type;
  final double height;
  final double width;
  final bool? showText;
  final bool? showBorder;

  const PokemonTypeBadge({
    Key? key,
    required this.type,
    required this.height,
    required this.width,
    this.showText = true,
    this.showBorder = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: AppTheme.getColors(context).pokemonItem(type),
            border: showBorder!
                ? Border.all(color: AppTheme.getColors(context).pokemonTabTitle)
                : null,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Image.asset(
            AppConstants.pokemonTypeLogo(type, size: width.toInt()),
            width: width,
            height: height,
          ),
        ),
        if (showText!)
          SizedBox(
            width: 30,
            child: Text(
              type,
              textAlign: TextAlign.center,
              style: textTheme.bodySmall?.copyWith(fontSize: 8),
            ),
          )
      ],
    );
  }
}
