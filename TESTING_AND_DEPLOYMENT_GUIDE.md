# StitchMate — Testing & Deployment Guide

> **For non-technical users.** This guide assumes you have the StitchMate project folder on your Mac and want to test it on your phone, then publish it to the App Store and Google Play Store.

---

## PART A: Testing the App on Your Phone

### Step 1: Check What You Already Have

Open the **Terminal** app on your Mac (press `Cmd + Space`, type "Terminal", press Enter).

Copy and paste this command, then press Enter:

```bash
cd ~/Documents/DEV/StitchMate && ~/Documents/DEV/flutter_sdk_316/bin/flutter doctor
```

You will see a report. Look for these symbols:
- ✓ (green tick) = good, you have this
- ✗ (red cross) = missing, you need to install this
- ! (yellow warning) = not ideal but might still work

**Right now, you are missing:**
1. Android Studio (for Android testing)
2. CocoaPods (for iPhone testing)
3. Android SDK (for Android testing)

We will fix these below.

---

### Step 2: Install Android Studio (for Android phones)

1. Open your web browser and go to: https://developer.android.com/studio
2. Click the green **"Download Android Studio"** button
3. Download the file (it's large — about 1 GB)
4. Open the downloaded file and drag "Android Studio" into your Applications folder
5. Open Android Studio from your Applications folder
6. On first launch, it will ask you to install the **Android SDK** — click **Next** through all the prompts and let it install everything
7. When it finishes, restart your Mac

---

### Step 3: Install CocoaPods (for iPhones)

CocoaPods is a tool that helps Flutter talk to your iPhone.

1. Open **Terminal** again
2. Copy and paste this command, press Enter:

```bash
sudo gem install cocoapods
```

3. It will ask for your Mac password. Type it (you won't see anything on screen — this is normal) and press Enter
4. Wait for it to finish (it may take a few minutes)

---

### Step 4: Run the App on an iPhone Simulator

An iPhone simulator lets you test the app without a real iPhone.

1. Open **Terminal**
2. Copy and paste these commands one at a time, pressing Enter after each:

```bash
cd ~/Documents/DEV/StitchMate
```

```bash
~/Documents/DEV/flutter_sdk_316/bin/flutter pub get
```

```bash
~/Documents/DEV/flutter_sdk_316/bin/flutter run
```

3. The first time you do this, it will take 5–10 minutes to build
4. You should see an iPhone simulator window open with StitchMate running
5. To stop the app, press **Ctrl + C** in Terminal

---

### Step 5: Run the App on a Real iPhone

This is more complex because Apple requires a developer account.

**You need:**
- An Apple Developer account ($99/year) from https://developer.apple.com
- Your iPhone connected to your Mac with a USB cable

**Steps:**
1. Connect your iPhone to your Mac with a USB cable
2. Open the **Xcode** app (it's in your Applications folder)
3. In Xcode, go to **Xcode → Preferences → Accounts** and sign in with your Apple Developer account
4. Open Terminal and run:

```bash
cd ~/Documents/DEV/StitchMate/ios
pod install
```

5. Then run:

```bash
cd ~/Documents/DEV/StitchMate
~/Documents/DEV/flutter_sdk_316/bin/flutter run
```

6. The first time, you may need to trust the developer certificate on your iPhone (go to **Settings → General → VPN & Device Management** on your iPhone and tap "Trust")

---

### Step 6: Run the App on an Android Emulator

An Android emulator lets you test the app without a real Android phone.

1. Open **Android Studio**
2. Click **"More Actions"** on the welcome screen, then **"Virtual Device Manager"**
3. Click **"Create Device"**
4. Select **"Pixel 7"** and click **Next**
5. Select the recommended system image (it will say "Recommended") and click **Next**
6. Click **Finish**
7. Click the **play button** (▶) next to your new device to start it
8. Wait for the emulator to fully boot up (you'll see a phone screen)
9. Open Terminal and run:

```bash
cd ~/Documents/DEV/StitchMate
~/Documents/DEV/flutter_sdk_316/bin/flutter run
```

---

### Step 7: Run the App on a Real Android Phone

1. On your Android phone, go to **Settings → About Phone** and tap **"Build Number"** 7 times to enable Developer Mode
2. Go back to **Settings → System → Developer Options** and turn on **"USB Debugging"**
3. Connect your Android phone to your Mac with a USB cable
4. Open Terminal and run:

```bash
cd ~/Documents/DEV/StitchMate
~/Documents/DEV/flutter_sdk_316/bin/flutter run
```

---

## PART B: Deploying the App to the App Stores

### Overview

To publish StitchMate, you need to:
1. Create app store accounts
2. Build the app in "release mode"
3. Upload to each store

---

### Step 1: Create Your Accounts

**For Apple App Store (iPhones):**
1. Go to https://developer.apple.com
2. Click **"Account"** and sign in with your Apple ID
3. Enroll in the **Apple Developer Program** — costs $99/year
4. Fill in your personal/business details and pay
5. Wait 1–2 days for approval

**For Google Play Store (Android phones):**
1. Go to https://play.google.com/console
2. Sign in with your Google account
3. Pay the one-time $25 registration fee
4. Fill in your developer profile

---

### Step 2: Create App Icons

You need app icons in specific sizes for both platforms.

**The easy way:**
1. Go to https://appicon.co
2. Upload a square image (at least 1024×1024 pixels) for your app icon
3. The website will generate all the sizes you need
4. Download the zip files for both iOS and Android

**For iOS:**
1. Unzip the iOS file
2. Copy all the images into: `StitchMate/ios/Runner/Assets.xcassets/AppIcon.appiconset/`
3. Replace the existing files

**For Android:**
1. Unzip the Android file
2. Copy the folders into: `StitchMate/android/app/src/main/res/`
3. Replace the existing mipmap folders

---

### Step 3: Update the App Version

Before each release, you must increase the version number.

1. Open the file `StitchMate/pubspec.yaml` in a text editor (like TextEdit)
2. Find the line that says: `version: 1.0.0+1`
3. Change it to: `version: 1.0.1+2` for your first update
4. Save the file

The format is: `versionName+versionCode`
- `versionName` is what users see (1.0.0)
- `versionCode` must increase by 1 every time (1, 2, 3...)

---

### Step 4: Build for iOS (Apple App Store)

**Step 4a: Configure signing**
1. Open Xcode
2. Open the file `StitchMate/ios/Runner.xcworkspace` (not .xcodeproj)
3. In Xcode, click "Runner" on the left, then click "Signing & Capabilities" at the top
4. Check "Automatically manage signing"
5. Select your Apple Developer team from the dropdown

**Step 4b: Build the release version**
1. In Terminal, run:

```bash
cd ~/Documents/DEV/StitchMate
~/Documents/DEV/flutter_sdk_316/bin/flutter build ios --release
```

2. This creates the release build

**Step 4c: Upload to App Store Connect**
1. In Xcode, go to **Product → Archive**
2. Wait for it to finish
3. The "Organizer" window will open
4. Select your archive and click **"Distribute App"**
5. Choose **"App Store Connect"** → **"Upload"**
6. Follow the prompts (keep all default settings)
7. Wait for the upload to finish (can take 30+ minutes)

**Step 4d: Submit for review**
1. Go to https://appstoreconnect.apple.com
2. Click **"My Apps"**
3. Click the **"+"** button to add a new app
4. Fill in:
   - Platform: iOS
   - Name: StitchMate
   - Primary Language: English
   - Bundle ID: com.stitchmate.stitch_mate
   - SKU: stitchmate-001
5. Fill in all the required information:
   - Screenshots (see Step 6 below)
   - Description
   - Keywords
   - Support URL
   - Privacy Policy URL
6. Click **"Submit for Review"**
7. Apple will review your app (usually takes 1–2 days)

---

### Step 5: Build for Android (Google Play Store)

**Step 5a: Create a signing key**

A signing key proves the app came from you. You only need to do this once.

1. Open Terminal
2. Run this command (replace with your own details):

```bash
keytool -genkey -v -keitchmate-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias stitchmate
```

3. It will ask for a password — create one and write it down somewhere safe
4. It will ask for your name, organisation, etc. — fill these in
5. This creates a file called `stitchmate-release-key.jks`
6. Move this file to: `~/Documents/DEV/StitchMate/android/app/`

**Step 5b: Configure signing**
1. Create a new file called `key.properties` in `~/Documents/DEV/StitchMate/android/`
2. Open it in TextEdit and paste this (replace with your password):

```
storePassword=YOUR_PASSWORD
keyPassword=YOUR_PASSWORD
keyAlias=stitchmate
storeFile=stitchmate-release-key.jks
```

3. Save the file

**Step 5c: Build the release APK**
1. In Terminal, run:

```bash
cd ~/Documents/DEV/StitchMate
~/Documents/DEV/flutter_sdk_316/bin/flutter build apk --release
```

2. This creates a file at: `build/app/outputs/flutter-apk/app-release.apk`

**Step 5d: Upload to Google Play Console**
1. Go to https://play.google.com/console
2. Click **"Create App"**
3. Fill in:
   - App name: StitchMate
   - Default language: English
   - App or game: App
   - Free or paid: Free
4. Go to **"Production"** → **"Create New Release"**
5. Upload your APK file (`app-release.apk`)
6. Fill in all required information:
   - App access: All functionality available without special access
   - Ads: No, my app does not contain ads
   - Content rating: Fill in the questionnaire
   - Target audience: 18+
   - News apps: No
   - COVID-19: No
   - Data safety: Fill in the form (all data is stored locally)
   - Store listing: Add description, screenshots, feature graphic
7. Click **"Save"** then **"Review Release"**
8. Click **"Start Rollout to Production"**
9. Google will review your app (usually takes 1–3 days)

---

### Step 6: Create Store Screenshots

Both stores require screenshots of your app.

**What you need:**
- iPhone: 6.5" display screenshots (iPhone 14 Pro Max size)
- iPhone: 5.5" display screenshots (iPhone 8 Plus size)
- Android: Phone screenshots (16:9 or 9:16 ratio)
- Android: Tablet screenshots (optional but recommended)

**How to get them:**
1. Run the app in the simulator (see Part A)
2. On a Mac, press **Cmd + S** while the simulator is open to take a screenshot
3. The screenshot saves to your Desktop
4. Take screenshots of the main screens: Counter, Projects, Dictionary, Stash, Tools, Settings
5. You need 3–8 screenshots per device size

**Tip:** You can also use https://screenshot-framer.firebaseapp.com to put your screenshots into nice device frames.

---

## Quick Reference: Common Commands

| What you want to do | Command |
|---------------------|---------|
| Check if everything is installed | `~/Documents/DEV/flutter_sdk_316/bin/flutter doctor` |
| Get dependencies | `~/Documents/DEV/flutter_sdk_316/bin/flutter pub get` |
| Run on simulator | `~/Documents/DEV/flutter_sdk_316/bin/flutter run` |
| Run tests | `~/Documents/DEV/flutter_sdk_316/bin/flutter test` |
| Build iOS release | `~/Documents/DEV/flutter_sdk_316/bin/flutter build ios --release` |
| Build Android release | `~/Documents/DEV/flutter_sdk_316/bin/flutter build apk --release` |
| Build Android app bundle (for Play Store) | `~/Documents/DEV/flutter_sdk_316/bin/flutter build appbundle --release` |
| Check for code issues | `~/Documents/DEV/flutter_sdk_316/bin/flutter analyze` |
| Format code | `~/Documents/DEV/flutter_sdk_316/bin/dart format lib/ test/` |

---

## Troubleshooting

**"Flutter command not found"**
→ Use the full path: `~/Documents/DEV/flutter_sdk_316/bin/flutter` instead of just `flutter`

**"CocoaPods not installed"**
→ Run: `sudo gem install cocoapods`

**"Android SDK not found"**
→ Open Android Studio and let it finish installing the SDK

**"No devices found"**
→ Make sure your simulator is running or your phone is connected with USB debugging on

**Build takes forever**
→ This is normal for the first build. Subsequent builds are faster.

**"Signing certificate expired" (iOS)**
→ In Xcode, go to Preferences → Accounts → Download Manual Profiles

---

## Costs Summary

| Item | Cost |
|------|------|
| Apple Developer Program | $99/year |
| Google Play Developer | $25 one-time |
| App icon generator | Free (appicon.co) |
| Screenshot framer | Free |
| **Total first year** | **$124** |

---

## Timeline Estimate

| Task | Time |
|------|------|
| Install Android Studio + SDK | 1–2 hours |
| Install CocoaPods | 15 minutes |
| Test on simulators | 30 minutes |
| Create app icons | 30 minutes |
| Create screenshots | 1–2 hours |
| Build iOS release | 30 minutes |
| Build Android release | 30 minutes |
| Fill in store listings | 2–3 hours |
| Wait for Apple review | 1–2 days |
| Wait for Google review | 1–3 days |
| **Total active work** | **~8 hours** |
| **Total time to live** | **3–5 days** |

---

## Need Help?

- **Flutter issues:** https://docs.flutter.dev
- **Apple Developer:** https://developer.apple.com/support
- **Google Play:** https://support.google.com/googleplay/android-developer
- **StitchMate code issues:** Check the GitHub repository at https://github.com/miles-a0/StitchMate
