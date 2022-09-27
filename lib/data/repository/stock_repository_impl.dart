import 'package:stock_app/data/csv/company_listings_parser.dart';
import 'package:stock_app/data/source/local/stock_dao.dart';
import 'package:stock_app/data/source/remote/stock_api.dart';
import 'package:stock_app/domain/model/company_listing.dart';
import 'package:stock_app/domain/repository/stock_repository.dart';
import 'package:stock_app/util/result.dart';
import 'package:stock_app/data/mapper/company_mapper.dart';

class StockRepositoryImpl implements StockRepository {
  final StockApi _api;
  final StockDao _dao;
  final _parser = CompanyListingsParser();

  StockRepositoryImpl(this._api, this._dao);

  @override
  Future<Result<List<CompanyListing>>> getCompanyListings(
    bool fetchFromRemote,
    String query,
  ) async {
    // find from cache
    final localListings = await _dao.searchCompanyListing(query);

    // else from remote
    final isDbEmpty = localListings.isEmpty && query.isEmpty;
    final shouldJustLoadFromCache = !isDbEmpty && !fetchFromRemote;

    if (shouldJustLoadFromCache) {
      return Result.success(
          localListings.map((e) => e.toCompanyListing()).toList());
    }

    // remote
    try {
      final response = await _api.getListings();
      final remoteListings = await _parser.parse(response.body);

      // clear
      await _dao.clearCompanyListings();

      // caching
      await _dao.insertCompanyListings(
          remoteListings.map((e) => e.toCompanyListingEntity()).toList());

      return Result.success(remoteListings);
    } catch (e) {
      return Result.error(Exception('failed to load data'));
    }
  }
}
