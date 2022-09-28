import 'package:hive_flutter/hive_flutter.dart';
import 'package:stock_app/data/source/local/company_listing_entity.dart';

class StockDao {
  static const companyListing = 'companyListing';
  static const stock_db = 'stock.db';

  // add
  Future<void> insertCompanyListings(
      List<CompanyListingEntity> companyListingEntitis) async {
    final box = await Hive.openBox<CompanyListingEntity>(stock_db);
    await box.addAll(companyListingEntitis);
  }

  // clear
  Future clearCompanyListings() async {
    final box = await Hive.openBox<CompanyListingEntity>(stock_db);
    await box.clear();
  }

  // search
  Future<List<CompanyListingEntity>> searchCompanyListing(String query) async {
    final box = await Hive.openBox<CompanyListingEntity>(stock_db);
    final List<CompanyListingEntity> companyListing = box.values.toList();

    return companyListing
        .where((e) =>
            e.name.toLowerCase().contains(query) ||
            query.toUpperCase() == e.symbol)
        .toList();
  }
}
