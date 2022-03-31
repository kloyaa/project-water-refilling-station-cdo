require("dotenv").config();

const nodemailer = require("nodemailer");
const sendgridTransport = require("nodemailer-sendgrid-transport");

module.exports = {
  async sendEmail(to, from, subject, text, html) {
    await nodemailer
      .createTransport(
        sendgridTransport({
          auth: {
            api_key: process.env.TWILIO_SENDGRID_APIKEY,
          },
        })
      )
      .sendMail({ to, from, subject, text, html })
      .then((value) => console.log(value))
      .catch((err) => console.log(err));
  },
};
