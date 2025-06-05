import 'package:flutter/material.dart';
import 'package:lecheplan/services/auth_service.dart';
import 'package:lecheplan/services/profile_service.dart';

class UserAvatar extends StatefulWidget {
  final double radius;
  final VoidCallback? onTap;
  final bool showBorder;
  final Color? borderColor;
  final double borderWidth;

  const UserAvatar({
    super.key,
    this.radius = 22,
    this.onTap,
    this.showBorder = false,
    this.borderColor,
    this.borderWidth = 2,
  });

  @override
  State<UserAvatar> createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> {
  String? _profileImageUrl;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  //load user profile image from database
  Future<void> _loadProfileImage() async {
    try {
      final currentUser = AuthService.getCurrentUser();
      if (currentUser == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final profileResult = await ProfileService.getUserProfile(currentUser.id);
      
      if (profileResult['success'] && mounted) {
        final profile = profileResult['profile'];
        setState(() {
          _profileImageUrl = profile['profile_photo_url'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget avatar = CircleAvatar(
      radius: widget.radius,
      backgroundImage: (_profileImageUrl != null && _profileImageUrl!.isNotEmpty)
          ? NetworkImage(_profileImageUrl!)
          : const AssetImage('assets/images/sampleAvatar.jpg') as ImageProvider,
    );

    if (widget.showBorder) {
      avatar = Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: widget.borderColor ?? Colors.white,
            width: widget.borderWidth,
          ),
        ),
        child: avatar,
      );
    }

    if (widget.onTap != null) {
      return GestureDetector(
        onTap: widget.onTap,
        child: avatar,
      );
    }

    return avatar;
  }
} 