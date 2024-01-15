class BashCommands{

  static String getSongInfo1 = "dbus-send --system --print-reply --dest=org.bluez /org/bluez/hci0/dev_DC_52_85_B0_B8_04/player0 org.freedesktop.DBus.Properties.Get string:org.bluez.MediaPlayer1 string:Track";
  static String getSongInfo2 = "dbus-send --system --print-reply --dest=org.bluez /org/bluez/hci0/dev_DC_52_85_B0_B8_04/player2 org.freedesktop.DBus.Properties.Get string:org.bluez.MediaPlayer1 string:Track";
  static String backButton =  "dbus-send --system --print-reply --dest=org.bluez /org/bluez/hci0/dev_DC_52_85_B0_B8_04 org.bluez.MediaControl1.Previous";
  static String skipButton =  "dbus-send --system --print-reply --dest=org.bluez /org/bluez/hci0/dev_DC_52_85_B0_B8_04 org.bluez.MediaControl1.Next";
  static String pauseButton =  "dbus-send --system --print-reply --dest=org.bluez /org/bluez/hci0/dev_DC_52_85_B0_B8_04 org.bluez.MediaControl1.Pause";
  static String playButton =  "dbus-send --system --print-reply --dest=org.bluez /org/bluez/hci0/dev_DC_52_85_B0_B8_04 org.bluez.MediaControl1.Play";
  static String getTime = "date +\"%H %M\"";
  static String getDate = "date +\"%b %e\"";
  static String restartSystem = "sudo reboot now";
  static String shutdownSystem = "sudo shutdown now";
  static String btconnect = "bash /home/rp/btconnect.sh";
  static String btdisconnect = "bash /home/rp/btdisconnect.sh";
  static String btpair = "bash /home/rp/btpair.sh";
  static String getGifDirFileCount = "echo \$(ls -lA | wc -l)";
  static String toggleGarage = "sudo bash /home/rp/garagetoggle.sh";
  static String getGpsData = "curl http://127.0.0.1:5000/get_gps_data";
  static String unblockWifi = "sudo rfkill unblock wifi";
  static String blockWifi = "sudo rfkill block wifi";
  static String unblockBt = "sudo rfkill unblock bluetooth";
  static String blockBt = "sudo rfkill block bluetooth";
  static String rfkill = "rfkill";
  static String ifconfig = "ifconfig | grep \"inet \"";
  static String connectMultimetro = "sudo nmcli device wifi connect multimetro25787 password \"QyCyUHsUGu\"";
  static String connectFritzbox = "sudo nmcli device wifi connect Fleischhaus password \"hurensohn123\"";

}