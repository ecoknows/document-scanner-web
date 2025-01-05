part of 'get_all_scanned_documents_bloc.dart';

sealed class GetAllScannedDocumentsState extends Equatable {}

final class GetAllScannedDocumentsInitial extends GetAllScannedDocumentsState {
  @override
  List<Object?> get props => [];
}

final class GetAllScannedDocumentsInProgress
    extends GetAllScannedDocumentsState {
  @override
  List<Object?> get props => [];
}

final class GetAllScannedDocumentsSuccess extends GetAllScannedDocumentsState {
  final List<GetScannedDocument> documents;
  final List<String> images;
  final List<String> imagesFilename;

  GetAllScannedDocumentsSuccess({
    required this.documents,
    required this.images,
    required this.imagesFilename,
  });

  @override
  List<Object?> get props => [
        documents,
        images,
        imagesFilename,
      ];
}

final class GetAllScannedDocumentsFail extends GetAllScannedDocumentsState {
  final String message;

  GetAllScannedDocumentsFail({required this.message});

  @override
  List<Object?> get props => [message];
}
