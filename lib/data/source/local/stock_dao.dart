import 'package:hive/hive.dart';
import 'package:stock_app/data/source/local/company_listing_entity.dart';

class StockDao {
  static const companyListing = 'companyListing';
  final box = Hive.box('stock.db');

  // add
  Future<void> insertCompanyListings(
      List<CompanyListingEntity> companyListingEntity) async {
    await box.put(StockDao.companyListing, companyListingEntity);
  }

  // clear
  Future clearCompanyListings() async {
    await box.clear();
  }

  // search
  Future<List<CompanyListingEntity>> searchCompanyListing(String query) async {
    final List<CompanyListingEntity> companyListing = box
        .get(StockDao.companyListing, defaultValue: <CompanyListingEntity>[]);

    return companyListing
        .where((e) =>
            e.name.toLowerCase().contains(query) ||
            query.toUpperCase() == e.symbol)
        .toList();
  }
}
