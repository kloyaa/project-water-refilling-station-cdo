const multer = require("multer");
const path = require("path");
const { v4: uuidv4 } = require("uuid");

const fileStorage = multer.diskStorage({
  destination: (req, file, callback) => {
    callback(null, "images");
  },
  filename: (req, file, callback) => {
    callback(null, uuidv4() + path.extname(file.originalname));
  },
});
exports.fileStorage = fileStorage;
