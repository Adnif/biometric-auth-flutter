import 'package:appwrite/appwrite.dart';

Client client = Client()
    .setEndpoint('https://cloud.appwrite.io/v1') // Your Appwrite Endpoint
    .setProject('[PROJECT_ID]'); // Your project ID

Account account = Account(client);

final user = account.create(
    userId: ID.unique(),
    email: 'me@appwrite.io',
    password: 'password',
    name: 'My Name');
