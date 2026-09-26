// ЛР 1 — шесть независимых виджетов.
//
// Как сдавать: скопируйте этот файл целиком себе в main.dart, допишите
// шесть функций ниже вместо TODO, запустите — все шесть элементов должны
// появиться на экране. Пришлите готовый файл на проверку.
//
// Основной виджет трогать не нужно. Редактируйте там, где написано TODO.

import 'package:flutter/material.dart';

void main() {
  runApp(const Lab1App());
}

class Lab1App extends StatelessWidget {
  const Lab1App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('ЛР 1')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              task1(),
              const SizedBox(height: 4),
              Divider(),
              const SizedBox(height: 4),
              task2(),
              const SizedBox(height: 4),
              Divider(),
              const SizedBox(height: 4),
              task3(),
              const SizedBox(height: 4),
              Divider(),
              const SizedBox(height: 4),
              task4(),
              const SizedBox(height: 4),
              Divider(),
              const SizedBox(height: 4),
              task5(),
              const SizedBox(height: 4),
              Divider(),
              const SizedBox(height: 4),
              task6(),
            ],
          ),
        ),
      ),
    );
  }
}

// 1. Заголовок — Text, крупный жирный текст чёрного цвета, обрезается в одну строку, если не помещается.
Widget task1() {
  return const Text(
    'Заголовок экрана',
    style: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
  );
}

// 2. Подпись — небольшой, нежирный курсивный текст белого цвета, обрезается в две строки.
// Также реализуйте подложку из тёмно-серого контейнера с закруглениями, чтобы текст было видно
Widget task2() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.grey[800],
      borderRadius: BorderRadius.circular(12),
    ),
    child: const Text(
      'Небольшая курсивная подпись, поясняющая суть экрана и то, '
      'что здесь происходит.',
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.italic,
        color: Colors.white,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    ),
  );
}

// 3. Иконка — любая Icon на ваш вкус,
// с применением цвета и размером.
Widget task3() {
  return const Icon(
    Icons.star,
    color: Colors.amber,
    size: 48,
  );
}

// 4. Кнопка с иконкой избранного — большая иконка сердца красного цвета без фона.
// При нажатии пишет в консоль "Вы добавили в избранное"
Widget task4() {
  return IconButton(
    icon: const Icon(
      Icons.favorite,
      color: Colors.red,
      size: 48,
    ),
    onPressed: () {
      // ignore: avoid_print
      print('Вы добавили в избранное');
    },
  );
}

// 5. Кнопка «Подробнее» — кнопка с текстом и обводкой, при нажатии пишет в консоль "Узнать детали"
Widget task5() {
  return OutlinedButton(
    onPressed: () {
      // ignore: avoid_print
      print('Узнать детали');
    },
    child: const Text('Подробнее'),
  );
}

// 6. Изображение в стиле Polaroid—  выберите любое из каталога по ссылке
// https://picsum.photos/ (необходим vpn), либо используйте https://docs.flutter.dev/assets/images/dash/dash-fainting.gif
// Добавьте чёрную обводку, а внутри белую рамку в стиле фотографии Polaroid (https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSAeKRHzUEOMCX836O6p8R5-XBkrSlf8C4go4C7f1q8ClnmlFaV9emSrUFL&s=10)
// Для реализации используйте Container
Widget task6() {
  return Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(4),
    ),
    child: Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 24),
      color: Colors.white,
      child: Image.network(
        'https://picsum.photos/300/300',
        width: 220,
        height: 220,
        fit: BoxFit.cover,
      ),
    ),
  );
}