import 'BoltPriceEstimates.dart';
import 'BoltTimeEstimates.dart';

class Bolt{
  late BoltPriceEstimates boltPriceEstimates = new BoltPriceEstimates();
  late BoltTimeEstimates boltTimeEstimates = new BoltTimeEstimates();

  Bolt() {}


  BoltPriceEstimates get getBoltPriceEstimates {
    return boltPriceEstimates;
  }

  BoltTimeEstimates get getBoltTimeEstimates {
    return boltTimeEstimates;
  }

}