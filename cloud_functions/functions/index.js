
'use strict';
const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

/**
 * Triggers when a user gets a new follower and sends a notification.
 *
 * Followers add a flag to `/followers/{followedUid}/{followerUid}`.
 * Users save their device notification tokens to `/users/{followedUid}/notificationTokens/{notificationToken}`.
 */
exports.sendUserNotfication = functions.database.ref('/snaps/{userUid}/{snapID}').onWrite(event => {
  const snapID = event.params.snapID;
  const userUid = event.params.userUid;
  // If un-follow we exit the function.
  if (!event.data.val()) {
    return console.log('User ', userUid, 'deleted snap', snapID);
  }
  console.log('We have a new message:', snapID, 'for user:', userUid);

  // Get the list of device notification tokens.
  const getDeviceTokensPromise = admin.database().ref(`/users/${userUid}/NotificationKeys`).once('value');
  // Get the follower profile.
  const getUserProfilePromise = admin.auth().getUser(userUid);

  //Get new
  let snap = event.data.val()
  let message = snap.message
  let fromName = snap.fromName


  return Promise.all([getDeviceTokensPromise, getUserProfilePromise]).then(results => {
    const tokensSnapshot = results[0];
    const user = results[1];

    // Check if there are any device tokens.
    if (!tokensSnapshot.hasChildren()) {
      return console.log('There are no notification tokens to send to.');
    }
    console.log('There are', tokensSnapshot.numChildren(), 'tokens to send notifications to.');
    console.log('Fetched user profile', user);

    // Notification details.
    const payload = {
      notification: {
        title: `Hi, ${user.displayName}.`,
        body: fromName+': '+message,
        sound: 'default'
        //icon: follower.photoURL
      }
    };

    // Listing all tokens.
    const tokens = Object.keys(tokensSnapshot.val());

    // Send notifications to all tokens.
    return admin.messaging().sendToDevice(tokens, payload).then(response => {
      // For each message check if there was an error.
      const tokensToRemove = [];
      response.results.forEach((result, index) => {
        const error = result.error;
        if (error) {
          console.error('Failure sending notification to', tokens[index], error);
          // Cleanup the tokens who are not registered anymore.
          if (error.code === 'messaging/invalid-registration-token' ||
              error.code === 'messaging/registration-token-not-registered') {
            tokensToRemove.push(tokensSnapshot.ref.child(tokens[index]).remove());
          }
        }
      });
      return Promise.all(tokensToRemove);
    });
  });
});
