rm -r ./build/flutter_assets/
flutter pub get
flutterpi_tool build --arch=arm64 --cpu=pi4 --release
scp -r ./build/flutter_assets/ rp@raspberrypi:/home/rp/my_apps_flutter_assets