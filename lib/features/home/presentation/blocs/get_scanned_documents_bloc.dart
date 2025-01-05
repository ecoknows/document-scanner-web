import 'package:bloc/bloc.dart';
import 'package:document_scanner_web/common/classes/firebase_helpers.dart';
import 'package:document_scanner_web/common/classes/get_scanned_document.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

part 'get_scanned_documents_event.dart';
part 'get_scanned_documents_state.dart';

class GetScannedDocumentsBloc
    extends Bloc<GetScannedDocumentsEvent, GetScannedDocumentsState> {
  GetScannedDocumentsBloc() : super(GetScannedDocumentsInitial()) {
    on<GetScannedDocumentsStarted>(_getScannedDocuments);
  }
  void _getScannedDocuments(
    GetScannedDocumentsStarted event,
    Emitter<GetScannedDocumentsState> emit,
  ) async {
    if (event.showLoadingIndicator) {
      EasyLoading.show();
    }

    final List<GetScannedDocument> documents = [];
    final List<String> images = [];
    final List<String> imagesFilename = [];
    final List<String> pdfs = [];

    // Paths for scanned documents and folders
    final String documentsUserPath = "images/scanned_documents/${event.uid}";
    final String foldersUserPath = "images/folders/${event.uid}";
    final String pdfsUserPath = "pdf/scanned_documents/${event.uid}";
    final String pdfImagesUserPath = "pdf/scanned_image/${event.uid}";

    final documentStorage = FirebaseStorage.instance.ref(documentsUserPath);
    final folderStorage =
        FirebaseStorage.instance.ref(foldersUserPath); // For folders

    emit(GetScannedDocumentsInProgress());

    // Get images from the scanned_documents path
    ListResult documentResult = await documentStorage.listAll();

    for (Reference documentRef in documentResult.prefixes) {
      ListResult imageResult = await documentRef.listAll();

      for (Reference imageRef in imageResult.items) {
        final imageUrl = await imageRef.getDownloadURL();
        images.add(imageUrl);
        imagesFilename.add(imageRef.name);
      }
    }

    // Get images from the nested folders path
    await _getImagesFromNestedFolders(folderStorage, images, imagesFilename);

    // Get PDF documents and corresponding images
    final pdfStorage = FirebaseStorage.instance.ref().child(pdfsUserPath);
    ListResult pdfResult = await pdfStorage.listAll();

    for (Reference pdfRef in pdfResult.items) {
      final pdfUrl = await pdfRef.getDownloadURL();
      final pdfName = pdfRef.name.split(".").first;

      final imagePath = "$pdfImagesUserPath/$pdfName.jpg";
      final imageDownload =
          await FirebaseHelpers.getDownloadUrlIfExists(imagePath);

      final document = GetScannedDocument(
        name: pdfRef.name.split(".").first,
        image: imageDownload!,
        pdf: pdfUrl,
      );

      pdfs.add(pdfUrl);
      documents.add(document);
    }

    emit(GetScannedDocumentsSuccess(
      documents: documents,
      images: images,
      imagesFilename: imagesFilename,
    ));

    if (event.showLoadingIndicator) {
      EasyLoading.dismiss();
    }
  }

// Recursive function to get images from nested folders
  Future<void> _getImagesFromNestedFolders(
    Reference folderStorage,
    List<String> images,
    List<String> imagesFilename,
  ) async {
    // List all items in the current folder
    ListResult folderResult = await folderStorage.listAll();

    for (Reference folderRef in folderResult.prefixes) {
      // If it's a folder, recursively call the function
      await _getImagesFromNestedFolders(folderRef, images, imagesFilename);
    }

    // Get the files (images) in the current folder
    for (Reference imageRef in folderResult.items) {
      final imageUrl = await imageRef.getDownloadURL();
      images.add(imageUrl);
      imagesFilename.add(imageRef.name);
    }
  }
}
