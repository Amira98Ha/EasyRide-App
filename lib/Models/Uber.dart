import 'UberPriceEstimates.dart';
import 'UberTimeEstimates.dart';

class Uber{
  late UberPriceEstimates uberPriceEstimates;
  late UberTimeEstimates uberTimeEstimates;

  Uber() {}

  UberPriceEstimates get getUberPriceEstimates {
    return uberPriceEstimates;
  }

  UberTimeEstimates get getUberTimeEstimates {
    return uberTimeEstimates;
  }

}