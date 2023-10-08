
import 'package:flutter/material.dart';
import '../widgets/slider_widget.dart';
import '../widgets/utils.dart';

class CircularPage extends StatelessWidget {
  const CircularPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.blue,
          ),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.login,
              color: Colors.blue,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Column(
              children: [
                Text(
                  'Temperature',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 26),
                ),
                Text(
                  'Living room',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const Expanded(
              child: SliderWidget(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Current humidity',
                      style: TextStyle(
                        color: Colors.grey.withAlpha(150),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      '55%',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Current temp.',
                      style: TextStyle(
                        color: Colors.grey.withAlpha(150),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      '25°',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 35,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16),
                      ),
                    ),
                    child: const Text(
                      'Automatic',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    ),
                  ),
                  child: Icon(
                    Icons.adjust,
                    color: Colors.black.withAlpha(175),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    ),
                  ),
                  child: Icon(
                    Icons.airplay,
                    color: Colors.black.withAlpha(175),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
          ],
        ),
      ),
    );
  }
}