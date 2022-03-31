require("dotenv").config();
const jwt = require("jsonwebtoken");

module.exports = {
  auth(req, res, next) {
    try {
      const authHeader = req.headers["authorization"];
      if (authHeader != null) {
        const token = authHeader.split(" ")[1];
        jwt.verify(token, process.env.ACCESS_TOKEN_SECRET, (err, value) => {
          if (err)
            return res
              .status(401)
              .json({ message: "Token is invalid or expired" });
          req.user = value;
          next();
        });
      } else if (authHeader == null) {
        return res.status(401).json({ message: "Token is required" });
      }
    } catch (error) {
      console.log(error);
    }
  },
};
