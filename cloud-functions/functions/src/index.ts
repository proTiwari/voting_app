import * as functions from "firebase-functions";

// // Start writing functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

interface SendEmailCallableData {
    to: string;
}

export const sendEmail = functions.https.onCall(async (data: SendEmailCallableData, context) => {
  const sgMail = await import('@sendgrid/mail');
  sgMail.setApiKey(process.env.SENDGRID_API_KEY || '');
  const msg = {
    to: data.to,
    from: 'proshubham5@gmail.com',
    subject: 'Sending with SendGrid is Fun',
    text: 'and easy to do anywhere, even with Node.js',
    html: '<strong>and easy to do anywhere, even with Node.js</strong>',
    };
    await sgMail.send(msg);
    return {success: true, message: 'Email sent'};
});