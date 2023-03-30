cd "${0%/*}" 
cd package
flutter clean
cd example
flutter clean
cd ..
dart pub publish