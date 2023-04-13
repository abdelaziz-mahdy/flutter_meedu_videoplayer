cd "${0%/*}" 
cd package
@REM flutter clean
@REM cd example
@REM flutter clean
@REM cd ..
dart fix --apply 
dart format .
dart pub publish