const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.getAllUsers = functions.https.onRequest(async (req, res) => {
  try {
    const users = [];
    async function listAllUsers(nextPageToken) {
      const result = await admin.auth().listUsers(1000, nextPageToken);
      result.users.forEach((user) => users.push(user.toJSON()));
      if (result.pageToken) {
        await listAllUsers(result.pageToken);
      }
    }
    await listAllUsers();

    // Sort the users by creationTime (latest first)
    users.sort((a, b) => {
      return new Date(b.metadata.creationTime) - new Date(a.metadata.creationTime);
    });

    res.status(200).json(users);
  } catch (error) {
    res.status(500).send("Error fetching users: " + error.message);
  }
});