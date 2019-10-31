const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.alarmNotification = functions.database.ref('bike1/alarm').onWrite(evt => {
    const payload = {
        notification:{
            title : 'Alarme ativado!',
            body : 'Desbloqueie sua bike para desativar!',
            badge : '1',
            sound : 'default',
            icon : 'bikeicon',
            color: '#0055FF'        }
    };

    return admin.database().ref('fcm-token').once('value').then(allToken => {
        if(allToken.val()){
            console.log('token available');
            const token = Object.keys(allToken.val());
            return admin.messaging().sendToDevice(token,payload);
        }else{
            console.log('No token available');
            return;
        }
    });

});
