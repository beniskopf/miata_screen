rm -r ./build/flutter_assets/
flutter build bundle
scp -r ./build/flutter_assets/ rp@192.168.1.22:/home/rp/my_apps_flutter_assets