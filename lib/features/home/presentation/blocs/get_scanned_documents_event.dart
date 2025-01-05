part of 'get_scanned_documents_bloc.dart';

sealed class GetScannedDocumentsEvent extends Equatable {}

final class GetScannedDocumentsStarted extends GetScannedDocumentsEvent {
  final bool showLoadingIndicator;
  final String uid;

  GetScannedDocumentsStarted({
    required this.showLoadingIndicator,
    required this.uid,
  });

  @override
  List<Object?> get props => [showLoadingIndicator];
}
