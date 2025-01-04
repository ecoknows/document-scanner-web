import 'package:document_scanner_web/features/home/presentation/blocs/get_users_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return BlocBuilder<GetUsersBloc, GetUsersState>(
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
                                DataCell(
                                    Text(user.emailVerified ? 'Yes' : 'No')),
                                DataCell(
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.document_scanner,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.image,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  IconButton(
                                    onPressed: () {},
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
    );
  }
}
