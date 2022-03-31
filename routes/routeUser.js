const express = require("express");
const router = express.Router();

const user = require("../controllers/user/userController");

// @path: api/user/register
// @Description: Register user
router.post("/user/register", (req, res) =>
    user.createUser(req, res)
);

// @path: api/user/login
// @Description: Login user
router.post("/user/login", (req, res) =>
    user.loginUser(req, res)
);

module.exports = router;
