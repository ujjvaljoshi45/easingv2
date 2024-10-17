import 'package:easypg/screens/add_property/widgets/exit_dialog.dart';
import 'package:easypg/services/api_handler.dart';
import 'package:easypg/model/property.dart';
import 'package:easypg/utils/tools.dart';
import 'package:flutter/material.dart';

class AddPropertyProvider extends ChangeNotifier {
  // Singleton pattern: Creating a single instance of the provider
  AddPropertyProvider._();
  static final AddPropertyProvider instance = AddPropertyProvider._();

  // Property object to hold property details
  Property property = Property.empty();

  // Controller for navigating through different pages in the form
  final PageController pageController = PageController();

  int currentIndex = 0; // Index of the current form step
  final int totalLength = 5; // Total number of steps in the form
  bool isLoading = false; // Loading indicator for saving data

  // Titles for the app bar corresponding to each form step
  final List<String> appBarTitle = [
    'Let’s get you started',
    'Property Location',
    'Relevant Information',
    'Additional Information',
    'Add Photos',
    'Overview',
  ];

  /// Data for the 'Getting Started' step
  List<String> ownership = ['Owner', 'Agent', 'Builder'];
  List<String> motive = ['Rent / Lease', 'List as PG'];
  int selectedOption = 0; // Selected ownership type
  int selectedPurpose = 0; // Selected purpose for the property

  /// Data for the 'Add Location' step
  List<String> types = ['House', 'Pg/Hostel', 'Apartment', 'Duplex'];
  int propertyTypeSelection = 0; // Selected property type

  /// Data for the 'Other Information' step
  int currentBhkSelection = 0; // Selected number of BHKs
  int currentFurnishedSelection = 0; // Selected furnishing status
  int bathrooms = 1; // Number of bathrooms
  List<String> furnished = [
    'Un Furnished',
    'Semi Furnished',
    'Furnished',
  ];

  /// Data for the 'Add Amenities' step
  Map<String, bool> myAmenities = {
    "Breakfast": false,
    "Lunch": false,
    "Dinner": false,
    "Drinking Water": false,
    "AC": false,
    "Laundry": false,
    "Cleaning": false
  };

  // Handles changing pages in the form
  void handelPageChangeChange(BuildContext context) {
    if (currentIndex < totalLength) {
      // Validates each step before proceeding to the next step
      switch (currentIndex) {
        case 1:
          if (!stepOneValidation()) {
            showToast('Please Fill All the Fields', Colors.redAccent);
            return; // Stop if validation fails
          }
        case 2:
          if (!stepThreeValidation()) {
            showToast('Please Fill All the Fields', Colors.redAccent);
            return; // Stop if validation fails
          }
        case 3:
          setAmenities(
            (List.generate(
                AddPropertyProvider.instance.myAmenities.length,
                (index) => AddPropertyProvider.instance
                        .myAmenities[AddPropertyProvider.instance.myAmenities.keys.toList()[index]]!
                    ? AddPropertyProvider.instance.myAmenities.keys.toList()[index]
                    : '')).toSet().toList(),
          );
        case 4:
          if (!stepFiveValidation()) {
            showToast('Please Fill All the Fields', Colors.redAccent);
            return; // Stop if validation fails
          }
      }
      currentIndex++; // Move to the next step
      debugPrint("cIndex:$currentIndex");
      pageController.animateToPage(currentIndex,
          curve: Curves.linearToEaseOut, duration: const Duration(milliseconds: 100));
    } else {
      // Final step: Set amenities, log data, and save the property
      logEvent(AddPropertyProvider.instance.property.toJson());
      showToast('Saving...', null);

      save().whenComplete(
        () => Navigator.pop(context), // Close the form after saving
      );
    }
    notifyListeners(); // Notify UI about changes
  }

  // Handles going back to the previous step
  void manageBack(BuildContext context) {
    debugPrint("clicked : $currentIndex");
    if (currentIndex <= 0) {
      // If at the first step, show exit confirmation dialog
      showDialog(
        context: context,
        builder: (context) => ExitConfirmationDialog(onExit: () {
          AddPropertyProvider.instance.clear(); // Clear data if exiting
          Navigator.pop(context);
        }),
      );
    } else {
      currentIndex--; // Move back to the previous step
      pageController.animateToPage(currentIndex,
          curve: Curves.linearToEaseOut, duration: const Duration(milliseconds: 250));
    }
    notifyListeners(); // Notify UI about changes
  }

  // Toggles the loading state
  void toggleLoading() {
    isLoading = !isLoading;
    notifyListeners(); // Notify UI about changes
  }

  // Setters to update property details
  void setPosition(String str) => property.position = str;
  void setMotive(String str) => property.motive = str;
  void setPropertyType(String str) => property.propertyType = str;
  void setName(String str) => property.name = str;
  void setStreetAddress(String str) => property.streetAddress = str;
  void setPinCode(String str) => property.pinCode = str;
  void setState(String str) => property.state = str;
  void setCity(String str) => property.city = str;
  void setBHK(String str) => property.bhk = str;
  void setBathroom(String str) => property.bathroom = str;
  void setFurniture(String str) => property.furniture = str;
  void setRent(String str) => property.rent = str;
  void setDeposit(String str) => property.deposit = str;
  void setAmenities(List<String> lis) =>
      property.amenities = lis.where((element) => element.trim().isNotEmpty).toList();
  void setPhotos(photo, index) => property.photos[index] = photo;

  // Saves the property data
  Future<void> save() async {
    toggleLoading(); // Start loading
    String time =
        property.id.isNotEmpty ? property.id : DateTime.now().millisecondsSinceEpoch.toString();
    logEvent(property.toJson());
    List<String> localImages = [];
    List<String> networkImages = [];
    for (String myUrls in property.photos) {
      if (!myUrls.startsWith("https")) {
        localImages.add(myUrls);
      } else {
        networkImages.add(myUrls);
      }
    }
    networkImages.addAll(await ApiHandler.instance.saveImages(localImages, time));

    property.photos = networkImages; // Update property with image URLs
    property.id = time.toString(); // Set the property ID
    await ApiHandler.instance.saveProperty(property); // Save property details
    toggleLoading(); // Stop loading
    clear(); // Clear form data after saving
  }

  // Validates the first step
  bool stepOneValidation() =>
      property.name.isNotEmpty &&
      property.propertyType.isNotEmpty &&
      property.streetAddress.isNotEmpty &&
      property.pinCode.isNotEmpty &&
      property.city.isNotEmpty &&
      property.state.isNotEmpty;

  // Validates the third step
  bool stepThreeValidation() =>
      property.bhk.isNotEmpty &&
      property.bathroom.isNotEmpty &&
      property.furniture.isNotEmpty &&
      property.rent.isNotEmpty &&
      property.deposit.isNotEmpty;

  // Validates the fifth step
  bool stepFiveValidation() => property.photos.length >= 4;

  // Clears all the form data
  void clear() {
    selectedPurpose = 0;
    selectedOption = 0;
    currentIndex = 0;
    bathrooms = 1;
    isLoading = false;
    for (var element in myAmenities.keys) {
      myAmenities[element] = false;
    }
    property = Property.empty(); // Reset property details
  }
}
