import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:stock_app/domain/model/company_info.dart';

part 'company_info_state.freezed.dart';
part 'company_info_state.g.dart';

@freezed
class CompanyInfoState with _$CompanyInfoState {
  factory CompanyInfoState({
    CompanyInfo? companyInfo,
    @Default(false) bool isLoading,
  }) = _CompanyInfoState;

  factory CompanyInfoState.fromJson(Map<String, dynamic> json) =>
      _$CompanyInfoStateFromJson(json);
}
