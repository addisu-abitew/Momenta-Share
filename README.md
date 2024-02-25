# Momenta Share

Momenta Share is a social media application inspired by Instagram. It allows users to share and discover moments from their lives through photos and videos. This repository contains the source code for the Momenta Share application, developed using **Flutter for the frontend and Firebase for the backend**.

## Features

- **User Authentication**: Users can create accounts, log in, and update their profiles.
- **Post Creation**: Users can upload photos and videos, add captions, and share them with their followers.
- **Feed**: Users can view a personalized feed of posts from the users they follow.
- **Explore**: Users can discover new content by exploring popular posts and trending hashtags.
- **Likes and Comments**: Users can like and comment on posts, engaging with other users.
- **Search**: Users can search for other users.

## Technologies Used

- Flutter: A cross-platform UI toolkit for building natively compiled applications.
- Firebase: A cloud-based platform provided by Google for building mobile and web applications.
  - Firebase Authentication: User authentication and account management.
  - Firebase Cloud Firestore: A NoSQL database for storing and querying user data.
  - Firebase Cloud Storage: A cloud-based storage solution for storing user uploads.

## Getting Started

To run the Momenta Share application locally, follow these steps:

1. Clone the repository: `git clone https://github.com/addisu-abitew/Momenta-Share.git`
3. Install Flutter and set up your development environment: [Flutter Installation Guide](https://flutter.dev/docs/get-started/install)
4. Configure Firebase for the project:
   - Create a new Firebase project at [https://firebase.google.com/](https://firebase.google.com/).
   - Set up Firebase Authentication, Firestore, Cloud Storage, and Cloud Messaging for the project.
   - Download the Firebase configuration file (google-services.json) and place it in the appropriate location in your Flutter project.
5. Install project dependencies: `flutter pub get`
6. Start the application: `flutter run`
