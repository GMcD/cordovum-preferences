define([
	'cordova'
], function() {
       
       var exec = cordova.require('cordova/exec');

       var AppPreferences = {

            get: function(key,success,fail) {
                 exec(success,fail,"AppPreferences","get",[key]);
            },
            set: function(key,value,success,fail) {
                 exec(success,fail,"AppPreferences","set",[key, value]);
            },
            load: function(success,fail) {
                 exec(success,fail,"AppPreferences","load",[]);
            },
            show: function(activity,success,fail) {
                exec(success,fail,"AppPreferences","show",[activity]);
            },
            clear: function(success,fail) {
                exec(success,fail,"AppPreferences","clear", []);
            },
            remove: function(keyToRemove, success,fail) {
                exec(success,fail,"AppPreferences","remove", [keyToRemove]);
            }
        };

       return AppPreferences;
});
