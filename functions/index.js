const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.getAllUsers = functions.https.onRequest(async (req, res) => {
  // Dynamically allow the origin from request headers
  const allowedOrigin = req.get("Origin");
  const allowedDomains = [
    "https://document-scanner-bay.vercel.app", // Add all allowed origins
  ];

  if (allowedDomains.includes(allowedOrigin)) {
    res.set("Access-Control-Allow-Origin", allowedOrigin);
  } else {
    res.set("Access-Control-Allow-Origin", "*"); // Optional for debugging; limit in production
  }

  res.set("Access-Control-Allow-Methods", "GET, OPTIONS");
  res.set("Access-Control-Allow-Headers", "Content-Type");

  if (req.method === "OPTIONS") {
    return res.status(204).end(); // End preflight request
  }

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
    res.status(200).json(users);
  } catch (error) {
    res.status(500).send("Error fetching users: " + error.message);
  }
});


exports.deleteUser = functions.https.onRequest(async (req, res) => {
  // Dynamically allow the origin from request headers
  const allowedOrigin = req.get("Origin");
  const allowedDomains = [
    "https://document-scanner-bay.vercel.app", // Add all allowed origins
  ];

  if (allowedDomains.includes(allowedOrigin)) {
    res.set("Access-Control-Allow-Origin", allowedOrigin);
  } else {
    res.set("Access-Control-Allow-Origin", "*"); // Optional for debugging; limit in production
  }

  res.set("Access-Control-Allow-Methods", "POST, OPTIONS");
  res.set("Access-Control-Allow-Headers", "Content-Type");

  if (req.method === "OPTIONS") {
    return res.status(204).end(); // End preflight request
  }

  // Validate the request method and body
  if (req.method !== "POST") {
    return res.status(405).send("Method Not Allowed");
  }

  const { uid } = req.body;

  if (!uid) {
    return res.status(400).send("UID is required to delete a user.");
  }

  try {
    // Delete the user by UID
    await admin.auth().deleteUser(uid);
    res.status(200).send(`Successfully deleted user with UID: ${uid}`);
  } catch (error) {
    res.status(500).send(`Error deleting user: ${error.message}`);
  }
});