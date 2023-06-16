function getWifiSSID() {
  return new Promise((resolve, reject) => {
    const networkInfo = navigator.connection;
    if (networkInfo && networkInfo.type === "wifi") {
      const wifi = navigator.wifi;
      if (wifi) {
        wifi
          .getSSID()
          .then((ssid) => {
            resolve(ssid);
          })
          .catch((error) => {
            reject(error);
          });
      } else {
        reject("Wi-Fi API not available");
      }
    } else {
      reject("Not connected to Wi-Fi");
    }
  });
}

window.flutter_inject_wifi_extension = {
  getWifiSSID: getWifiSSID,
};
