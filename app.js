require("dotenv").config();
const express = require("express");
const multer = require("multer");
const mongoose = require("mongoose");

const user = require("./routes/routeUser");
const profile = require("./routes/routeProfile");
const listing = require("./routes/routeListing");
const order = require("./routes/routeOrder");
const pricing = require("./routes/routePricing");

const { fileFilter } = require("./services/img-upload/fileFilter");
const storage = multer.diskStorage({});

const port = process.env.PORT || 5000;
const app = express();

try {
    mongoose
      .connect(process.env.CONNECTION_STRING)
      .then((value) =>console.log(`SERVER IS CONNECTED TO ${value.connections[0]._connectionString}`))
      .catch(() => console.log("SERVER CANNOT CONNECT TO MONGODB"));

    app.use(express.json());
    app.use(express.urlencoded({ extended: true }));
    app.use(multer({ storage, fileFilter }).single("img"));

    app.use("/api", user);
    app.use("/api", profile);
    app.use("/api", listing);
    app.use("/api", order);
    app.use("/api", pricing);
    
    app.listen(port, () => console.log("SERVER IS RUNNING"));
} catch (error) {
  console.log(error);
}
