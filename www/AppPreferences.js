function AppPreferences() {
}

AppPreferences.prototype.get = function(key,success,fail) {
    cordova.exec(success,fail,"AppPreferences","get",[key]);
};
AppPreferences.prototype.set = function(key,value,success,fail) {
    cordova.exec(success,fail,"AppPreferences","set",[key, value]);
};
AppPreferences.prototype.load = function(success,fail) {
    cordova.exec(success,fail,"AppPreferences","load",[]);
};
AppPreferences.prototype.show = function(activity,success,fail) {
    cordova.exec(success,fail,"AppPreferences","show",[activity]);
};
AppPreferences.prototype.clear = function(success,fail) {
    cordova.exec(success,fail,"AppPreferences","clear", []);
};
AppPreferences.prototype.remove = function(keyToRemove, success,fail) {
    cordova.exec(success,fail,"AppPreferences","remove", [keyToRemove]);
};

AppPreferences.install = function () {
  if (!window.plugins) {
    window.plugins = {};
  }

  window.plugins.preferences = new AppPreferences();
  return window.plugins.preferences;
};

cordova.addConstructor(AppPreferences.install);
