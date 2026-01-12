
# Community App

A Flutter-based community platform developed for **HackSlash Coding Club** to enable collaboration, content sharing, real-time communication, and event management.

---

## 📌 About the Project

The Community App was built to provide a centralized digital platform for students and developers to collaborate, communicate, and participate in community-driven activities.  
The application focuses on scalability, real-time interaction, and clean architecture using modern Flutter development practices.

---

## ✨ Key Features

- 🔐 Secure user authentication using Firebase Auth  
- 🏠 Community feed for announcements and content sharing  
- 💬 Real-time chat using Firebase Realtime Database  
- 🎥 Video meetings integration using Agora API  
- 📚 Learning and resource-sharing module  
- 👤 User profile management  
- 📅 Event management system  
- 💾 Local storage using Hive  
- ⚡ Reactive UI with GetX state management  

---

## 🚀 Working Prototype

https://drive.google.com/file/d/141LoPm9ikwKmZ_Mpwb64nAC-5g16jBJV/view?usp=drivesdk

A fully functional **working prototype** has been developed demonstrating:
- Authentication flow
- Real-time chat
- Video meeting functionality
- Community feed
- Profile and learning modules

The prototype validates the core system architecture and feature feasibility.

---

## 🛠️ Tech Stack

- **Frontend:** Flutter  
- **State Management:** GetX  
- **Backend Services:** Firebase  
- **Authentication:** Firebase Auth  
- **Database:** Firebase Realtime Database  
- **Video Calling:** Agora API  
- **Local Storage:** Hive  
- **Media Storage:** Cloudinary  

---

## 🧱 App Architecture

The application follows a **modular MVC-based architecture** using GetX:

- **Controllers** handle state and business logic  
- **Views** manage UI components  
- **Services** encapsulate API and backend interactions  
- **Models** represent structured application data  

This architecture ensures:
- Scalability  
- Maintainability  
- Clear separation of concerns  

---

## 📁 Folder Structure

```bash
lib/
│
├── controllers/               # Contains all the controllers for state management (using GetX)
│   ├── auth_controller.dart        # Handles authentication logic
│   ├── home_controller.dart        # Handles home screen state and logic
│   ├── chat_controller.dart        # Handles chat logic and real-time data
│   ├── learning_controller.dart   # Handles learning content logic
│   ├── profile_controller.dart    # Handles user profile data and updates
│
├── models/                    # Contains the data models for the app
│   ├── user_model.dart             # Model for user data
│   ├── message_model.dart          # Model for chat messages
│   ├── course_model.dart           # Model for learning content or courses
│   ├── profile_model.dart          # Model for profile data
│
├── services/                  # Contains services for API calls and business logic
│   ├── auth_service.dart           # Auth-related logic (e.g., login, register, token management)
│   ├── chat_service.dart           # Chat service (e.g., message sending, receiving)
│   ├── learning_service.dart      # Service to fetch learning content or courses
│   ├── profile_service.dart       # Service to handle user profile data
│
├── utils/                      # Contains utility functions and constants
│   ├── constants.dart              # App-wide constants (e.g., URLs, keys)
│   ├── validators.dart             # Validation functions (e.g., email, password validation)
│   ├── network_util.dart           # Helper functions for making API calls
│   ├── storage_util.dart           # Utility functions for handling local storage
│
├── views/                      # Contains all views (UI screens) for the app
│   ├── auth/
│   │   ├── login_view.dart         # Login screen view
│   │   ├── register_view.dart      # Registration screen view
│   ├── home/
│   │   └── home_view.dart          # Home screen view
│   ├── chat/
│   │   └── chat_view.dart          # Chat screen view
│   ├── learning/
│   │   └── learning_view.dart     # Learning content screen view
│   ├── profile/
│   │   └── profile_view.dart      # Profile screen view
│
├── widgets/                    # Reusable UI components
│   ├── bottom_nav_bar.dart        # Bottom navigation bar widget
│   └── custom_widgets.dart        # Any other reusable UI components
│
├── routes/                      # Contains routing logic for the app
│   └── app_routes.dart            # Handles routing logic
│
├── res/                         # Contains assets like fonts and colors
│   ├── fonts/                     # Folder for custom fonts
│   │   └── OpenSans-Regular.ttf    # Example custom font
│   ├── colors.dart                # File for defining color constants
│
└── main.dart                      # Main app entry point, where GetX bindings are set up
