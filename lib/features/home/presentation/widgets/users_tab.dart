import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:document_scanner_web/features/auth/data/models/user_model.dart';
import 'package:document_scanner_web/features/home/presentation/blocs/delete_user_bloc.dart';
import 'package:document_scanner_web/features/home/presentation/blocs/get_scanned_documents_bloc.dart';
import 'package:document_scanner_web/features/home/presentation/blocs/get_users_bloc.dart';
import 'package:document_scanner_web/features/home/presentation/widgets/user_documents_dialog_content.dart';
import 'package:document_scanner_web/features/home/presentation/widgets/user_images_dialog_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class UsersTab extends StatefulWidget {
  const UsersTab({super.key});

  @override
  State<UsersTab> createState() => _UsersTabState();
}

class _UsersTabState extends State<UsersTab> {
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<GetUsersBloc>().add(GetUsersStarted());
    searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      searchQuery = searchController.text;
    });
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DeleteUserBloc, DeleteUserState>(
          listener: (context, deleteUserState) {
            if (deleteUserState is DeleteUserSuccess) {
              AnimatedSnackBar.material(
                "Successfully delete user",
                type: AnimatedSnackBarType.success,
                duration: const Duration(seconds: 5),
                mobileSnackBarPosition: MobileSnackBarPosition.top,
              ).show(context);
              context.read<GetUsersBloc>().add(GetUsersStarted());
            }
          },
        ),
      ],
      child: BlocBuilder<GetUsersBloc, GetUsersState>(
        builder: (context, getUsersState) {
          if (getUsersState is GetUsersSuccess) {
            final filteredUsers = getUsersState.users.where((user) {
              final emailLower = user.email.toLowerCase();
              final displayNameLower = (user.displayName ?? '').toLowerCase();
              final searchLower = searchQuery.toLowerCase();
              return emailLower.contains(searchLower) ||
                  displayNameLower.contains(searchLower);
            }).toList();

            return SizedBox(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const SizedBox(
                            width: 8,
                          ),
                          Image.asset(
                            'assets/images/logo.jpg', // Path to your logo image
                            height: 40, // Adjust height as needed
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          const Expanded(
                            child: Text(
                              "MOBILE DOCUMENT SCANNER APP FOR PSU",
                              maxLines: 2,
                              overflow: TextOverflow.visible,
                              softWrap: true,
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Container(
                        width: 400,
                        padding: const EdgeInsets.all(8),
                        child: TextField(
                          controller: searchController,
                          decoration: const InputDecoration(
                            labelText: 'Search by Email or Display Name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('Name')),
                            DataColumn(label: Text('Email')),
                            DataColumn(label: Text('Email Verified')),
                            DataColumn(label: Text('Documents')),
                            DataColumn(label: Text('Images')),
                            DataColumn(label: Text('Delete')),
                          ],
                          rows: filteredUsers
                              .map(
                                (user) => DataRow(
                                  cells: [
                                    DataCell(
                                      Row(
                                        children: [
                                          user.photoURL == null
                                              ? Image.asset(
                                                  'assets/images/default-avatar.png',
                                                  height: 40,
                                                  width: 40,
                                                )
                                              : Image.network(
                                                  user.photoURL ?? "",
                                                  height: 40,
                                                  width: 40,
                                                ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(user.displayName ?? 'N/A')
                                        ],
                                      ),
                                    ),
                                    DataCell(Text(user.email)),
                                    DataCell(Text(
                                        user.emailVerified ? 'Yes' : 'No')),
                                    DataCell(
                                      IconButton(
                                        onPressed: () {
                                          _showUserDocumentsDialog(
                                            context,
                                            user.uid,
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.picture_as_pdf,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      IconButton(
                                        onPressed: () {
                                          _showUserImagesDialog(
                                            context,
                                            user.uid,
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.image,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      IconButton(
                                        onPressed: () {
                                          _showDeleteDialog(user);
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 8,
                  ),
                  Image.asset(
                    'assets/images/logo.jpg', // Path to your logo image
                    height: 40, // Adjust height as needed
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  const Expanded(
                    child: Text(
                      "MOBILE DOCUMENT SCANNER APP FOR PSU",
                      maxLines: 2,
                      overflow: TextOverflow.visible,
                      softWrap: true,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
              const Center(
                child: CircularProgressIndicator(),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _showDeleteDialog(User user) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding:
              const EdgeInsets.all(16), // Adjust padding around the dialog
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height *
                0.8, // Occupy 80% of the screen height
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Deleting User',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(height: 16),
                Text("Are you sure you want to delete user ${user.email}?"),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      child: const Text('Yes'),
                      onPressed: () {
                        context.read<DeleteUserBloc>().add(
                              DeleteUserStarted(uid: user.uid),
                            );
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showUserImagesDialog(BuildContext context, String id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // Dismiss on tap outside
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(16), // Padding around the dialog
          child: UserImagesDialogContent(id: id),
        );
      },
    );
  }

  Future<void> _showUserDocumentsDialog(BuildContext context, String id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // Dismiss on tap outside
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(16), // Padding around the dialog
          child: UserDocumentsDialogContent(id: id),
        );
      },
    );
  }
}
