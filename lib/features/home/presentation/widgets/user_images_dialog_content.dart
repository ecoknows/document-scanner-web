import 'package:document_scanner_web/features/home/presentation/blocs/get_scanned_documents_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher_string.dart';

class UserImagesDialogContent extends StatefulWidget {
  final String id;

  const UserImagesDialogContent({super.key, required this.id});

  @override
  State<UserImagesDialogContent> createState() =>
      _UserImagesDialogContentState();
}

class _UserImagesDialogContentState extends State<UserImagesDialogContent> {
  @override
  void initState() {
    super.initState();

    context.read<GetScannedDocumentsBloc>().add(
          GetScannedDocumentsStarted(
              showLoadingIndicator: true, uid: widget.id),
        );
  }

  Future<void> openImageInNewTab(String url) async {
    // Open the image URL in a new browser tab
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not open the image URL';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height *
          0.9, // Occupy 90% of screen height
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "User Images",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<GetScannedDocumentsBloc,
                  GetScannedDocumentsState>(
                builder: (context, getScannedDocumentsState) {
                  if (getScannedDocumentsState is GetScannedDocumentsSuccess) {
                    final images = getScannedDocumentsState.images;

                    if (images.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.image,
                              color: Colors.black,
                              size: 100.0,
                            ),
                            const SizedBox(
                              height: 16.0,
                            ),
                            Text(
                              "No image found",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      );
                    }

                    return SingleChildScrollView(
                      child: Wrap(
                        spacing: 8.0, // Horizontal space between items
                        runSpacing: 8.0, // Vertical space between rows
                        children: images.map<Widget>((imageUrl) {
                          return GestureDetector(
                            onTap: () {
                              openImageInNewTab(imageUrl);
                            },
                            child: Container(
                              width: 100, // Set desired width for each image
                              height: 100, // Set desired height for each image
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                image: DecorationImage(
                                  image: NetworkImage(imageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }

                  return Container();
                },
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
