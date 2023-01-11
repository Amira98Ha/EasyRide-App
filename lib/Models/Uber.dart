import 'UberPriceEstimates.dart';
import 'UberTimeEstimates.dart';

class Uber{
  late UberPriceEstimates uberPriceEstimates = new UberPriceEstimates();
  late UberTimeEstimates uberTimeEstimates = new UberTimeEstimates();

  Uber() {}


  UberPriceEstimates get getUberPriceEstimates {
    return uberPriceEstimates;
  }

  UberTimeEstimates get getUberTimeEstimates {
    return uberTimeEstimates;
  }

}