import 'package:flutter/material.dart';
import 'package:lecheplan/providers/theme_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:lecheplan/services/people_services.dart';
import 'package:lecheplan/models/friendlist.dart';
import 'package:lecheplan/models/group_model.dart';
import 'package:lecheplan/widgets/reusableWidgets/user_avatar.dart';
import 'package:lecheplan/services/groups_services.dart';
import 'package:lecheplan/widgets/reusableWidgets/custom_filledinputfield.dart';

class PeoplePage extends StatefulWidget {
  final VoidCallback? onProfileTap;
  final List<Group> groups;
  const PeoplePage({Key? key, this.onProfileTap, this.groups = const []})
    : super(key: key);

  @override
  State<PeoplePage> createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  String _searchQuery = '';
  String _addFriendSearchQuery = '';
  String _createGroupSearchQuery = '';

  // State variables to hold fetched data
  List<Map<String, dynamic>> _friendsData = [];
  List<Map<String, dynamic>> _groupsData = [];
  List<Map<String, dynamic>> _allUsersData = [];
  bool _isLoading = true;

  // Temporarily hardcoded userId for testing
  final String _currentTestUserId = '00000000-0000-0000-0000-000000000001';

  @override
  void initState() {
    super.initState();
    _fetchPeopleData();
  }

  Future<void> _fetchPeopleData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final friends = await fetchAllFriends();
      final groups = await fetchAllGroups();
      final users = await fetchAllUsers();
      setState(() {
        _friendsData = friends;
        _groupsData = groups;
        _allUsersData = users;
      });
    } catch (e) {
      print('Error fetching people data: \$e'); // Or use the logger
      setState(() {
        _friendsData = [];
        _groupsData = [];
        _allUsersData = [];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> _getFilteredPeople(String query) {
    if (query.isEmpty) {
      return _allUsersData;
    }
    // username here key but remind to change key
    return _allUsersData
        .where(
          (user) =>
              user['username'].toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  // Helper to get the friend's username from a friend entry
  String _getFriendUsername(Map<String, dynamic> friendData) {
    if (friendData['member1_id'] == _currentTestUserId) {
      return friendData['user2']?['username'] ?? 'Unknown Friend';
    } else if (friendData['member2_id'] == _currentTestUserId) {
      return friendData['user1']?['username'] ?? 'Unknown Friend';
    } else {
      return 'Unknown Friend';
    }
  }

  void _showAddCreateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            List<Map<String, dynamic>> dialogFilteredPeople =
                _getFilteredPeople(_addFriendSearchQuery);

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: DefaultTabController(
                length: 2,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Toggles
                      Container(
                        height: 35,
                        decoration: BoxDecoration(
                          color: greyAccentColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          clipBehavior: Clip.antiAlias,
                          child: TabBar(
                            //labels
                            labelStyle: TextStyle(
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                            unselectedLabelColor: darktextColor,
                            labelColor: darktextColor,

                            //indicator
                            indicator: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [defaultBoxShadow],
                            ),
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicatorPadding: const EdgeInsets.all(4),
                            indicatorAnimation: TabIndicatorAnimation.elastic,
                            dividerHeight: 0,
                            //content
                            tabs: [
                              Tab(text: 'Add Friend'),
                              Tab(text: 'Create Group'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        height: 300,
                        child: TabBarView(
                          children: [
                            // Add Friend View
                            Column(
                              children: [
                                // Search Field
                                _AddFriendSearch(
                                  onSearchChanged: (value) {
                                    setState(() {
                                      _addFriendSearchQuery = value;
                                      dialogFilteredPeople = _getFilteredPeople(
                                        _addFriendSearchQuery,
                                      );
                                    });
                                  },
                                ),
                                const SizedBox(height: 10),
                                // Sample List
                                Expanded(
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: dialogFilteredPeople.length,
                                    itemBuilder: (context, index) {
                                      final person =
                                          dialogFilteredPeople[index];
                                      return Container(
                                        margin: const EdgeInsets.only(
                                          bottom: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: darktextColor.withAlpha(50),
                                            width: 1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: ListTile(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 2,
                                              ),
                                          leading: const CircleAvatar(
                                            backgroundImage: AssetImage(
                                              'assets/images/sampleAvatar.jpg',
                                            ),
                                            radius: 18,
                                          ),
                                          title: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                person['username'] ??
                                                    'Unknown User', // Use 'username' from fetched users data
                                                style: const TextStyle(
                                                  fontFamily: 'Quicksand',
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                '${person['mutualFriends']} mutual friends',
                                                style: TextStyle(
                                                  fontFamily: 'Quicksand',
                                                  fontSize: 11,
                                                  color: darktextColor
                                                      .withAlpha(150),
                                                ),
                                              ),
                                            ],
                                          ),
                                          subtitle: null,
                                          trailing: IconButton(
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                            icon: Icon(
                                              Icons.add_box,
                                              color: orangeAccentColor,
                                              size: 24,
                                            ),
                                            onPressed: () {
                                              print(
                                                'Add friend: ${person['user_id']}',
                                              ); // Use user_id
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            // Create Group View
                            Column(
                              children: [
                                // Group Name Field
                                Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: greyAccentColor,
                                    border: Border.all(
                                      color: orangeAccentColor,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: TextField(
                                    onChanged: (value) {
                                      setState(() {
                                        _createGroupSearchQuery = value;
                                        dialogFilteredPeople =
                                            _getFilteredPeople(
                                              _createGroupSearchQuery,
                                            );
                                      });
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Enter group name',
                                      hintStyle: TextStyle(
                                        color: darktextColor.withAlpha(120),
                                        fontFamily: 'Quicksand',
                                        fontSize: 13,
                                      ),
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 12,
                                          ),
                                      alignLabelWithHint: true,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                // Search Field for adding members to group
                                _CreateGroupSearch(
                                  onSearchChanged: (value) {
                                    setState(() {
                                      _createGroupSearchQuery = value;
                                      dialogFilteredPeople = _getFilteredPeople(
                                        _createGroupSearchQuery,
                                      );
                                    });
                                  },
                                ),
                                const SizedBox(height: 10),
                                Expanded(
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: dialogFilteredPeople.length,
                                    itemBuilder: (context, index) {
                                      final person =
                                          dialogFilteredPeople[index];
                                      return Container(
                                        margin: const EdgeInsets.only(
                                          bottom: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: darktextColor.withAlpha(50),
                                            width: 1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: ListTile(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 2,
                                              ),
                                          leading: const CircleAvatar(
                                            backgroundImage: AssetImage(
                                              'assets/images/sampleAvatar.jpg',
                                            ),
                                            radius: 18,
                                          ),
                                          title: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                person['username'] ??
                                                    'Unknown User',
                                                style: const TextStyle(
                                                  fontFamily: 'Quicksand',
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                '${person['mutualFriends']} mutual friends',
                                                style: TextStyle(
                                                  fontFamily: 'Quicksand',
                                                  fontSize: 11,
                                                  color: darktextColor
                                                      .withAlpha(150),
                                                ),
                                              ),
                                            ],
                                          ),
                                          subtitle: null,
                                          trailing: IconButton(
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                            icon: Icon(
                                              Icons.add_box,
                                              color: orangeAccentColor,
                                              size: 24,
                                            ),
                                            onPressed: () {
                                              print(
                                                'Add user to group: ${person['user_id']}',
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  List<Map<String, dynamic>> get filteredFriends {
    if (_searchQuery.isEmpty) {
      return _friendsData;
    }
    // Filter by the friend's username
    return _friendsData
        .where(
          (friend) =>
              _getFriendUsername(friend).toLowerCase().contains(_searchQuery),
        )
        .toList();
  }

  List<Group> get filteredGroups {
    if (_searchQuery.isEmpty) {
      return widget.groups;
    }
    return widget.groups
        .where(
          (group) =>
              group.groupName.toLowerCase().contains(_searchQuery) ||
              group.members.any(
                (member) => member.toLowerCase().contains(_searchQuery),
              ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DefaultTabController(
          length: 2,
          child: Column(
            children: [
              _HeaderContent(onSearchChanged: _updateSearchQuery),
              const _PeopleBar(),
              Expanded(
                child:
                    _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : _MainContent(
                          filteredFriends: filteredFriends,
                          filteredGroups: filteredGroups,
                        ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 95,
          right: 15,
          child: Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              color: orangeAccentColor,
              shape: BoxShape.circle,
              boxShadow: [defaultBoxShadow],
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.group_add_outlined,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () => _showAddCreateDialog(context),
            ),
          ),
        ),
      ],
    );
  }
}

class _HeaderContent extends StatelessWidget {
  final Function(String) onSearchChanged;
  final VoidCallback? onProfileTap;
  const _HeaderContent({
    Key? key,
    required this.onSearchChanged,
    this.onProfileTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 60, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _SearchBar(onSearchChanged: onSearchChanged),
          _NotificationAndAvatar(onProfileTap: onProfileTap),
        ],
      ),
    );
  }
}

class _SearchBar extends StatefulWidget {
  final Function(String) onSearchChanged;

  const _SearchBar({required this.onSearchChanged});

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  late TextEditingController _searchController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    widget.onSearchChanged(value);
    setState(() {});
  }

  void _clearSearch() {
    _searchController.clear();
    _onSearchChanged('');
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: greyAccentColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextField(
          controller: _searchController,
          focusNode: _focusNode,
          style: TextStyle(
            color: darktextColor,
            fontFamily: 'Quicksand',
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: 'Search friend or group name',
            hintStyle: TextStyle(
              color: darktextColor.withAlpha(120),
              fontFamily: 'Quicksand',
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: darktextColor.withAlpha(120),
              size: 22,
            ),
            suffixIcon:
                _searchController.text.isNotEmpty
                    ? IconButton(
                      icon: Icon(
                        Icons.clear_rounded,
                        color: darktextColor.withAlpha(120),
                        size: 20,
                      ),
                      onPressed: _clearSearch,
                    )
                    : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          onChanged: _onSearchChanged,
        ),
      ),
    );
  }
}

class _NotificationAndAvatar extends StatelessWidget {
  final VoidCallback? onProfileTap;
  const _NotificationAndAvatar({Key? key, this.onProfileTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 2,
      children: [
        IconButton(
          onPressed: () => context.push('/notifications'),
          icon: Icon(
            Icons.notifications_outlined,
            color: orangeAccentColor,
            size: 30,
          ),
        ),
        GestureDetector(onTap: onProfileTap, child: UserAvatar(radius: 22)),
      ],
    );
  }
}

class _PeopleBar extends StatelessWidget {
  const _PeopleBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 40,
      decoration: BoxDecoration(
        color: greyAccentColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        clipBehavior: Clip.antiAlias,

        child: TabBar(
          //labels
          labelStyle: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
          unselectedLabelColor: darktextColor,
          labelColor: darktextColor,

          //indicator
          indicator: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [defaultBoxShadow],
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorPadding: const EdgeInsets.all(5),
          indicatorAnimation: TabIndicatorAnimation.elastic,
          dividerHeight: 0,
          //content
          tabs: [Tab(text: 'Friends'), Tab(text: 'Groups')],
        ),
      ),
    );
  }
}

class _MainContent extends StatelessWidget {
  final List<Map<String, dynamic>> filteredFriends;
  final List<Group> filteredGroups;

  // Temporarily hardcoded userId for testing - use the same one as in people_services.dart
  final String _currentTestUserId = '00000000-0000-0000-0000-000000000001';

  const _MainContent({
    required this.filteredFriends,
    required this.filteredGroups,
  });

  // Helper to get the friend's username from a friend entry
  String _getFriendUsername(Map<String, dynamic> friendData) {
    if (friendData['member1_id'] == _currentTestUserId) {
      return friendData['user2']?['username'] ?? 'Unknown Friend';
    } else if (friendData['member2_id'] == _currentTestUserId) {
      return friendData['user1']?['username'] ?? 'Unknown Friend';
    } else {
      return 'Unknown Friend'; // Should not happen if query is correct
    }
  }

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        //friends tab
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child:
              filteredFriends.isEmpty
                  ? const Center(
                    child: Text(
                      'No friends found',
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  )
                  : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: filteredFriends.length,
                    itemBuilder: (context, index) {
                      final friend = filteredFriends[index];
                      // Determine the friend's user ID to pass to the card if needed for navigation/actions
                      final friendUserId =
                          friend['member1_id'] == _currentTestUserId
                              ? friend['member2_id']
                              : friend['member1_id'];
                      return _FriendCard(
                        userID: friendUserId ?? '', // Pass the friend's user ID
                        name: _getFriendUsername(
                          friend,
                        ), // Use the helper to get friend's username
                        activity:
                            friend['activity']?.toString() ?? 'No activity',
                        profile:
                            'assets/images/sampleAvatar.jpg', // Placeholder
                        onTap: () {
                          // adding em to an activity
                        },
                      );
                    },
                  ),
        ),
        //group tab
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child:
              filteredGroups.isEmpty
                  ? const Center(
                    child: Text(
                      'No groups found',
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  )
                  : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: filteredGroups.length,
                    itemBuilder: (context, index) {
                      final group = filteredGroups[index];
                      return _GroupCard(
                        groupID: group.groupID,
                        groupName: group.groupName,
                        groupProfile: group.groupProfile,
                        memberCount: group.memberCount,
                        activity: group.activity,
                        members: group.members,
                        onTap: () {
                          // View group details
                        },
                      );
                    },
                  ),
        ),
      ],
    );
  }
}

class _FriendCard extends StatelessWidget {
  final String userID;
  final String name;
  final String activity;
  final String profile;
  final VoidCallback? onTap;

  const _FriendCard({
    required this.userID,
    required this.name,
    required this.activity,
    required this.profile,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Format of the activity text
    final String activityText =
        activity != 'No activity' && activity != 'null'
            ? '${activity} upcoming activity planned'
            : 'No activity';

    return Card(
      margin: const EdgeInsets.only(bottom: 5),
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: greyAccentColor, width: 2),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(backgroundImage: AssetImage(profile), radius: 25),
        title: Text(
          name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            fontFamily: 'Quicksand',
          ),
        ),
        subtitle: Text(
          activityText,
          style: const TextStyle(fontFamily: 'Quicksand'),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: darktextColor.withAlpha(100),
        ),
        onTap: onTap,
      ),
    );
  }
}

class _GroupCard extends StatelessWidget {
  final String groupID;
  final String groupName;
  final String groupProfile;
  final int memberCount;
  final String activity;
  final List<String> members;
  final VoidCallback? onTap;

  const _GroupCard({
    required this.groupID,
    required this.groupName,
    required this.groupProfile,
    required this.memberCount,
    required this.activity,
    required this.members,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 5),
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: greyAccentColor, width: 2),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundImage:
              groupProfile.isNotEmpty
                  ? NetworkImage(groupProfile)
                  : const AssetImage('assets/images/sampleAvatar.jpg')
                      as ImageProvider,
          radius: 25,
        ),
        title: Text(
          groupName,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Quicksand',
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${memberCount} members: ${members.join(", ")}',
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 10,
                color: darktextColor.withAlpha(150),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(activity, style: const TextStyle(fontFamily: 'Quicksand')),
          ],
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: Colors.grey[400],
        ),
        onTap: onTap,
      ),
    );
  }
}

class _AddFriendSearchState extends State<_AddFriendSearch> {
  late TextEditingController _searchController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    widget.onSearchChanged(value);
    setState(() {});
  }

  void _clearSearch() {
    _searchController.clear();
    _onSearchChanged('');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: greyAccentColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _focusNode,
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Search name or friend code',
          hintStyle: TextStyle(
            color: darktextColor.withAlpha(120),
            fontFamily: 'Quicksand',
            fontSize: 13,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: darktextColor.withAlpha(120),
            size: 18,
          ),
          suffixIcon:
              _searchController.text.isNotEmpty
                  ? IconButton(
                    icon: Icon(
                      Icons.clear_rounded,
                      color: darktextColor.withAlpha(120),
                      size: 20,
                    ),
                    onPressed: _clearSearch,
                  )
                  : null,
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 12,
          ),
          alignLabelWithHint: true,
        ),
      ),
    );
  }
}

class _AddFriendSearch extends StatefulWidget {
  final Function(String) onSearchChanged;

  const _AddFriendSearch({required this.onSearchChanged});

  @override
  State<_AddFriendSearch> createState() => _AddFriendSearchState();
}

class _CreateGroupSearchState extends State<_CreateGroupSearch> {
  late TextEditingController _searchController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    widget.onSearchChanged(value);
    setState(() {});
  }

  void _clearSearch() {
    _searchController.clear();
    _onSearchChanged('');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: greyAccentColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _focusNode,
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Search friends to add',
          hintStyle: TextStyle(
            color: darktextColor.withAlpha(120),
            fontFamily: 'Quicksand',
            fontSize: 13,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: darktextColor.withAlpha(120),
            size: 18,
          ),
          suffixIcon:
              _searchController.text.isNotEmpty
                  ? IconButton(
                    icon: Icon(
                      Icons.clear_rounded,
                      color: darktextColor.withAlpha(120),
                      size: 20,
                    ),
                    onPressed: _clearSearch,
                  )
                  : null,
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 12,
          ),
          alignLabelWithHint: true,
        ),
      ),
    );
  }
}

class _CreateGroupSearch extends StatefulWidget {
  final Function(String) onSearchChanged;

  const _CreateGroupSearch({required this.onSearchChanged});

  @override
  State<_CreateGroupSearch> createState() => _CreateGroupSearchState();
}
