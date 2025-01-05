part of 'get_all_scanned_documents_bloc.dart';

sealed class GetAllScannedDocumentsEvent extends Equatable {}

final class GetAllScannedDocumentsStarted extends GetAllScannedDocumentsEvent {
  final bool showLoadingIndicator;

  GetAllScannedDocumentsStarted({
    required this.showLoadingIndicator,
  });

  @override
  List<Object?> get props => [showLoadingIndicator];
}
