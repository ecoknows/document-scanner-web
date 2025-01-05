import 'package:document_scanner_web/common/classes/get_scanned_document.dart';
import 'package:document_scanner_web/features/home/presentation/blocs/get_all_scanned_documents_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher_string.dart';

class StorageTab extends StatefulWidget {
  const StorageTab({super.key});

  @override
  State<StorageTab> createState() => _StorageTabState();
}

class _StorageTabState extends State<StorageTab> {
  @override
  void initState() {
    super.initState();

    context.read<GetAllScannedDocumentsBloc>().add(
          GetAllScannedDocumentsStarted(showLoadingIndicator: true),
        );
  }

  Future<void> openPdfInNewTab(String url) async {
    // Open the image URL in a new browser tab
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not open the image URL';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetAllScannedDocumentsBloc, GetAllScannedDocumentsState>(
      builder: (context, getAllScannedDocumentsState) {
        if (getAllScannedDocumentsState is GetAllScannedDocumentsSuccess) {
          List<GetScannedDocument> documents =
              getAllScannedDocumentsState.documents;

          if (documents.isEmpty) {
            return Column(
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 8,
                    ), //
                    Image.asset(
                      'assets/images/logo.jpg', // Path to your logo image
                      height: 40, // Adjust height as needed
                    ),
                    const SizedBox(
                      width: 8,
                    ), // Add spacing between the logo and title
                    const Expanded(
                      child: Text(
                        "ADMIN CONSOLE FOR MOBILE DOCUMENT SCANNER APP FOR PSU",
                        maxLines: 2,
                        overflow: TextOverflow.visible,
                        softWrap: true,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.picture_as_pdf,
                        color: Colors.black,
                        size: 100.0,
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      Text(
                        "No pdf found",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return Column(
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 8,
                  ), //
                  Image.asset(
                    'assets/images/logo.jpg', // Path to your logo image
                    height: 40, // Adjust height as needed
                  ),
                  const SizedBox(
                    width: 8,
                  ), // Add spacing between the logo and title
                  const Expanded(
                    child: Text(
                      "ADMIN CONSOLE FOR MOBILE DOCUMENT SCANNER APP FOR PSU",
                      maxLines: 2,
                      overflow: TextOverflow.visible,
                      softWrap: true,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 8.0, // Horizontal space between items
                    runSpacing: 8.0, // Vertical space between rows
                    children: documents.map<Widget>((document) {
                      return GestureDetector(
                        onTap: () {
                          openPdfInNewTab(document.pdf);
                        },
                        child: Stack(
                          children: [
                            Container(
                              width: 100, // Set desired width for each image
                              height: 100, // Set desired height for each image
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                image: DecorationImage(
                                  image: NetworkImage(document.image),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const Positioned(
                              top: 5,
                              right: 5,
                              child: Icon(
                                Icons.picture_as_pdf, // Use any Material icon
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          );
        }
        return Column(
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 8,
                ), //
                Image.asset(
                  'assets/images/logo.jpg', // Path to your logo image
                  height: 40, // Adjust height as needed
                ),
                const SizedBox(
                  width: 8,
                ), // Add spacing between the logo and title
                const Expanded(
                  child: Text(
                    "ADMIN CONSOLE FOR MOBILE DOCUMENT SCANNER APP FOR PSU",
                    maxLines: 2,
                    overflow: TextOverflow.visible,
                    softWrap: true,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
