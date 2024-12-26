import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:communityapp/models/group_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:communityapp/utils/logging.dart';

final  log = Logging.log;

class ChatviewController extends GetxController {
  final String username;
  ChatviewController({required this.username});

  RxList<Group> groups = <Group>[].obs;
  RxList meetings = [].obs;
  RxBool isGroup = true.obs;

  Set<String> activeListeners = {}; // Set to track active listeners

  @override
  void onInit() {
    super.onInit();
    log.d("I am alive haha ha");
    getGroupIds();
  }

  void setListeners(String groupName, int unreads) {
    String user = username;
    final db = FirebaseFirestore.instance.collection("users").doc(user);

    // Check if a listener is already set for this group
    if (activeListeners.contains(groupName)) {
      log.d("Listener already set for $groupName. Skipping...");
      return; // Exit if listener is already set
    } else {
      activeListeners.add(groupName); // Add to active listeners
    }

    try {
      final DatabaseReference channelRef =
          FirebaseDatabase.instance.ref("channels/$groupName/ChannelInfo");
      channelRef.onValue.listen((event) async {
        final dataSnapshot = event.snapshot.value;
        if (dataSnapshot is Map<Object?, Object?>) {
          Map<String, dynamic> data = {};
          dataSnapshot.forEach((key, value) {
            data[key as String] = value;
          });
          log.d(data);
          // Check if the group already exists in the list
          int existingGroupIndex =
              groups.indexWhere((group) => group.name == data['name']);

          if (existingGroupIndex != -1) {
            // Group exists, update its unread count
            int updatedUnreads =
                groups[existingGroupIndex].unreads!.toInt() + 1;
            Group updatedGroup =
                Group.fromJson(data, updatedUnreads, groupName);
            groups.removeAt(existingGroupIndex);

            groups.insert(0, updatedGroup); // Update the group in the list
            db.update({'joinedGroups.$groupName': updatedUnreads});
          } else {
            // New group, add it to the list
            log.d("New group $groupName");
            Group newGroup = Group.fromJson(data, unreads, groupName);
            groups.add(newGroup);
          }
        }
      });
    } on Exception catch (e) {
      log.e(e.toString());
    }
  }

  Future<void> getGroupIds() async {
    final db = FirebaseFirestore.instance.collection("users").doc(username);

    db.get().then((querySnapshot) async {
      log.d(querySnapshot);
      if (querySnapshot['joinedGroups'] is Map) {
        querySnapshot['joinedGroups'].forEach((key, value) async {
          setListeners(key, value);
        });
      }
    });
  }
}
