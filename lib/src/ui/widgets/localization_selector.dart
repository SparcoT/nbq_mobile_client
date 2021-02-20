import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:nbq_mobile_client/src/base/assets.dart';

class LocalizationSelector extends StatefulWidget {
  static final locale = ValueNotifier<Locale>(
    Locale(Intl.systemLocale.contains('en') ? 'en' : 'es'),
  );

  @override
  _LocalizationSelectorState createState() => _LocalizationSelectorState();
}

class _LocalizationSelectorState extends State<LocalizationSelector> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('here');
        LocalizationSelector.locale.value =
            Locale(LocalizationSelector.locale.value.languageCode == 'en' ? 'es' : 'en');
        setState(() {});
      },
      child: SizedBox(
        width: 60,
        height: 37,
        child: LocalizationSelector.locale.value.languageCode == 'es'
            ? Stack(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(Assets.ukFlag, width: 37),
          ),
          Positioned(
            left: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(Assets.spainFlag, width: 37),
            ),
          ),
        ])
            : Stack(children: [
          Positioned(
            left: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(Assets.spainFlag, width: 37),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(Assets.ukFlag, width: 37),
          ),
        ]),
      ),
    );
  }
}
