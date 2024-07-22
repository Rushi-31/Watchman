# ID Card and Certificate Generator App

This Flutter app allows users to generate ID cards and certificates using simple forms. The app communicates with a backend API to process the data and generate PDF files for download.

## Features

- **User Authentication**: Secure login and signup functionalities.
- **ID Card Generation**: Input user details to generate a personalized ID card.
- **Certificate Generation**: Create certificates for individuals or in bulk using CSV files.
- **Bulk Operations**: Upload CSV files for batch ID or certificate generation.
  
## Screenshots

### Screens Overview
<p align="center">
  <img src="ss%20for%20watchmen/login.png" alt="Login Screen" width="300"/>
  <img src="ss%20for%20watchmen/signup.png" alt="Signup Screen" width="300"/>
</p>

<p align="center">
  <img src="ss%20for%20watchmen/home.png" alt="Home Screen" width="300"/>
  <img src="ss%20for%20watchmen/id%20generate.png" alt="ID Generation Screen" width="300"/>
</p>

<p align="center">
  <img src="ss%20for%20watchmen/certificate%20generate.png" alt="Certificate Generation Screen" width="300"/>
  <img src="ss%20for%20watchmen/bulk.png" alt="Bulk Certificate/ID Generation Screen" width="300"/>
</p>

## How to Run the App

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- A backend server running Node.js with the provided API for generating IDs and certificates

### Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/Rushi-31/Watchman.git
   ```

2. Navigate into the project directory:
   ```bash
   cd Watchman
   ```

3. Install the necessary dependencies:
   ```bash
   flutter pub get
   ```

### Running the App

To run the app on your device or emulator, use the following command:
```bash
flutter run
```

Make sure the backend server is also running for the app to connect and generate IDs or certificates.

### API Integration

- The app communicates with a backend Node.js API for generating the IDs and certificates.
- Example API endpoint for ID generation:
  ```bash
  POST http://your-api-endpoint/generate-id-card
  ```
  Example body:
  ```json
  {
    "name": "Rushikesh",
    "dob": "01-01-1990",
    "role": "Developer"
  }
  ```

## Notes

- Make sure your backend server is running and accessible to the Flutter app.
- If running locally, use `http://localhost:5000` as the backend API URL. If running on a remote server, update the API URLs accordingly.

