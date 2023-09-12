import 'package:appwrite/appwrite.dart';
import 'package:biometric_auth/constants/appwrite_constants.dart';

void checkList() {
  Client client = Client();
  Databases databases = Databases(client);

  client.setEndpoint(appw.endpoint).setProject(appw.projectID);

  Future result = databases.listDocuments(
      databaseId: appw.databaseID, collectionId: appw.collectionID);

  result.then((response) {
    print(response);
  }).catchError((error) {
    print(error.response);
  });
}
