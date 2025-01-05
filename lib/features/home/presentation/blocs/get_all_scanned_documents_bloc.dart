import 'package:bloc/bloc.dart';
import 'package:document_scanner_web/common/classes/firebase_helpers.dart';
import 'package:document_scanner_web/common/classes/get_scanned_document.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

part 'get_all_scanned_documents_event.dart';
part 'get_all_scanned_documents_state.dart';

class GetAllScannedDocumentsBloc
    extends Bloc<GetAllScannedDocumentsEvent, GetAllScannedDocumentsState> {
  GetAllScannedDocumentsBloc() : super(GetAllScannedDocumentsInitial()) {
    on<GetAllScannedDocumentsStarted>(_getAllScannedDocuments);
  }

  void _getAllScannedDocuments(
    GetAllScannedDocumentsStarted event,
    Emitter<GetAllScannedDocumentsState> emit,
  ) async {
    if (event.showLoadingIndicator) {
      EasyLoading.show();
    }

    final List<GetScannedDocument> documents = [];
    final List<String> images = [];
    final List<String> imagesFilename = [];
    final List<String> pdfs = [];

    // Modify the paths to fetch all documents without relying on event.uid
    String documentsPath = "images/scanned_documents/";
    String pdfsPath = "pdf/scanned_documents/";
    String pdfImagesPath = "pdf/scanned_image/";

    final documentStorage = FirebaseStorage.instance.ref(documentsPath);

    ListResult documentResult = await documentStorage.listAll();

    // Loop through all user folders
    for (Reference userRef in documentResult.prefixes) {
      ListResult imageResult = await userRef.listAll();

      // Loop through all images in the user's folder
      for (Reference imageRef in imageResult.items) {
        final imageUrl = await imageRef.getDownloadURL();
        images.add(imageUrl);
        imagesFilename.add(imageRef.name);
      }
    }

    final pdfStorage = FirebaseStorage.instance.ref().child(pdfsPath);
    ListResult pdfResult = await pdfStorage.listAll();

    // Loop through all user folders for PDF documents
    for (Reference userRef in pdfResult.prefixes) {
      ListResult pdfFilesResult = await userRef.listAll();

      // Fetch PDFs within each user folder
      for (Reference pdfRef in pdfFilesResult.items) {
        final pdfUrl = await pdfRef.getDownloadURL();
        final pdfName = pdfRef.name.split(".").first;

        // Check for associated image for the PDF
        final imagePath = "$pdfImagesPath/${userRef.name}/$pdfName.jpg";
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
    }

    emit(GetAllScannedDocumentsSuccess(
      documents: documents,
      images: images,
      imagesFilename: imagesFilename,
    ));

    if (event.showLoadingIndicator) {
      EasyLoading.dismiss();
    }
  }
}
