import 'package:flutter/material.dart';
import 'package:spendwise/common_widget/transaction_row.dart';

import '../../common/color_extension.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int selectButton = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.bg,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(
              height: 20,
            ),

            //Chat
            Container(
              height: 180,
            ),

            const SizedBox(
              height: 20,
            ),

            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: const BoxDecoration(
                      color: Color(0xffECE9FF),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Income",
                              style: TextStyle(
                                  color: Color(0xff958BCE),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              color: Color(0xff02C487),
                              size: 30,
                            )
                          ],
                        ),
                        Text(
                          "+\$764.42",
                          style: TextStyle(
                              color: TColor.primary,
                              fontSize: 25,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: const BoxDecoration(
                      color: Color(0xffEBFBFF),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Expense",
                              style: TextStyle(
                                  color: Color(0xff71C1D5),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                            Icon(
                              Icons.arrow_drop_up,
                              color: Color(0xffFC6158),
                              size: 30,
                            )
                          ],
                        ),
                        Text(
                          "-\$654.20",
                          style: TextStyle(
                              color: TColor.secondary,
                              fontSize: 25,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recent Transactions",
                  style: TextStyle(
                      color: TColor.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  "See all",
                  style: TextStyle(
                      color: TColor.blackColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w700),
                )
              ],
            ),

            const SizedBox(
              height: 20,
            ),

            Column(
              children: [{}, {}, {}, {}]
                  .map((cObj) => const TransactionRow())
                  .toList(),
            )
          ]),
        ),
      ),
    );
  }
}
