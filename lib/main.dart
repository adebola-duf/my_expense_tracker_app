import 'package:flutter/material.dart';
import 'package:my_expense_tracker_app/widgets/expenses_app.dart';

// with this color scheme, you define one color scheme and flutter infers different shade of colros for different widgets
// this .fromSeed constructor function creates your  color scheme based on one color you select - the seed color
var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 96, 59, 181),
);

var kDarkColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 5, 99, 125),
  // without this brightness, the shades and the variants of the color scheme would be optimized for light mode.
  // so they wouldn't look good at all for dark mode.
  // This brightness is to make the shades optimized for dark mode.
  brightness: Brightness.dark,
);

void main() {
  runApp(
    MaterialApp(
      // if you create a ThemeData object like this by instantiating ThemeData like this and passing some configurations to it,
      // What you are telling flutter is that you are setting up the entire theme from scratch, which means that you should configure
      // all the named parameters that the ThemeData objects take. And this is a lot of work especially when you are happy
      // with some default theme styles that flutter already uses.
      // theme: ThemeData(useMaterial3: false),
      // A better way to do this is to use copywith that only changes the things that we pass.
      // So, the everything remain the default, but the ones we pass are overried by the new values we pass
      // So, we are only overriding selected styles

      theme: ThemeData().copyWith(
        // useMaterial3: false,
        // scaffoldBackgroundColor: Colors.deepPurple[100],
        colorScheme: kColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: kColorScheme.onPrimaryContainer,
          foregroundColor: kColorScheme.primaryContainer,
        ),
        cardTheme: const CardTheme().copyWith(
          color: kColorScheme.secondaryContainer,
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
        // we didn't use copyWith cause not all have the copyWith sha for elevated button use .styleForm
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kColorScheme.primaryContainer,
          ),
        ),
        // textTheme: const TextTheme().copyWith(
        //   titleLarge: TextStyle(
        //     fontWeight: FontWeight.bold,
        //     color: kColorScheme.onSecondaryContainer,
        //     fontSize: 14,
        //   ),
        // ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: kDarkColorScheme,
        cardTheme: const CardTheme().copyWith(
          color: kDarkColorScheme.secondaryContainer,
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kDarkColorScheme.primaryContainer,
            foregroundColor: kDarkColorScheme.onPrimaryContainer,
          ),
        ),
      ),
      // by default, themeode is set to system
      // Thememode pretty much tells flutter which of the defined themes to use. Either the light theme or the dark theme
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const ExpensesApp(),
    ),
  );
}
