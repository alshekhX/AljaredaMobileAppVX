//logic
import 'package:flutter/widgets.dart';

class AdaptiveTextSize {
  const AdaptiveTextSize();

  getadaptiveTextSize(BuildContext context, dynamic value) {
    // 720 is medium screen height
    return (value / 720) * MediaQuery.of(context).size.height;
  }

  getadaptiveTextSizeSetting(
      BuildContext context, dynamic value, double sizeSetting) {
    if (sizeSetting == null) {
      sizeSetting = 1;
    }
    // 720 is medium screen height
    return (value / 720) * MediaQuery.of(context).size.height * sizeSetting;
  }
}
