import 'package:amazon_clone/features/account/services/account_services.dart';
import 'package:flutter/material.dart';

import 'account_button.dart';

class TopBottomWidget extends StatelessWidget {
  const TopBottomWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            AccountButtonWidget(
              onTap: () {},
              text: "Your Orders",
            ),
            AccountButtonWidget(
              onTap: () {},
              text: "Turn Seller",
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            AccountButtonWidget(
              onTap: () =>AccountServices().logOut(context),
              text: "Log Out",
            ),
            AccountButtonWidget(
              onTap: () {},
              text: "Your Wish List",
            ),
          ],
        )
      ],
    );
  }
}
