import 'package:easypg/model/user.dart';
import 'package:easypg/provider/data_provider.dart';
import 'package:easypg/services/api_handler.dart';
import 'package:easypg/utils/colors.dart';
import 'package:easypg/utils/styles.dart';
import 'package:easypg/utils/tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfileNameBottomSheetModal extends StatefulWidget {
  const EditProfileNameBottomSheetModal({
    super.key,
  });

  @override
  State<EditProfileNameBottomSheetModal> createState() => _EditProfileNameBottomSheetModalState();
}

class _EditProfileNameBottomSheetModalState extends State<EditProfileNameBottomSheetModal> {
  final currentName = DataProvider.instance.getUser.displayName;

  String? _name;
  @override
  void initState() {
    super.initState();
  }

  void _saveProfile() async {
    if (_name == null) return;
    Navigator.of(context).pop();
    AppUser newUser = DataProvider.instance.getUser;
    newUser.displayName = _name!;
    DataProvider.instance.setUser(newUser);
    await ApiHandler.instance.updateUserNameOrPhoto(newUser, false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          reverse: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Edit Name',
                style: unSelectedOptionTextStyle.copyWith(fontSize: 18.sp),
              ),
              space(16),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    _name = value; // Update name as user types
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter your name',
                  border: OutlineInputBorder(),
                ),
                initialValue: DataProvider.instance.getUser.displayName,
              ),
              space(16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(), // Close without saving
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: _saveProfile,
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditProfilePicture extends StatefulWidget {
  const EditProfilePicture({super.key});

  @override
  State<EditProfilePicture> createState() => _EditProfilePictureState();
}

class _EditProfilePictureState extends State<EditProfilePicture> {
  String currentProfilePicture = DataProvider.instance.getUser.profileUrl;
  final ImagePicker _picker = ImagePicker();
  File? _profileImage;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _saveProfile() async {
    if (_profileImage == null) return;
    setState(() => _isLoading = true);
    String? file = await ApiHandler.instance.saveProfileUrl(_profileImage!);
    if (file == null) {
      showToast('Unable to Save Image', Colors.redAccent, Colors.white);
    } else {
      AppUser newUser = DataProvider.instance.getUser;
      newUser.profileUrl = file;
      DataProvider.instance.setUser(newUser);
      await ApiHandler.instance.updateUserNameOrPhoto(newUser, true);
      setState(() => _isLoading = false);
    }
    Navigator.of(context).pop(); // Close the modal after saving
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          reverse: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: myOrange,
                      ),
                    )
                  : GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 50.r,
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : NetworkImage(currentProfilePicture) as ImageProvider,
                        child: _profileImage == null
                            ? Icon(Icons.camera_alt, size: 30.sp, color: Colors.grey)
                            : null,
                      ),
                    ),
              space(16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(), // Close without saving
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: _saveProfile,
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
