Meteor.startup(function () {
// code to run on server at startup
	Accounts.config({
        sendVerificationEmail: true,
        forbidClientAccountCreation: false
    });
});