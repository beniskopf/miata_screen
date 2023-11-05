rm -r ./build/flutter_assets/
flutter build bundle
scp -r ./build/flutter_assets/ rp@raspberrypi:/home/rp/my_apps_flutter_assets