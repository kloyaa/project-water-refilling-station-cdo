const express = require("express");
const router = express.Router();

const profile = require("../controllers/profile/profileController");
const protected = require("../middleware/authentication");

// PROFILE
router.post("/profile", (req, res) => 
    profile.createProfile(req, res)
);
router.get("/profile", (req, res) => 
    profile.getAllProfiles(req, res)
);
router.get("/profile/:id", (req, res) => 
    profile.getProfile(req, res)
);
router.put("/profile", (req, res) => 
    profile.updateProfile(req, res)
);
router.put("/profile/address", (req, res) => 
    profile.updateProfileAddress(req, res)
);
router.put("/profile/contact", (req, res) => 
    profile.updateProfileContact(req, res)
);
router.put("/profile/img", (req, res) => 
    profile.updateImg(req, res)
);
router.put("/profile/visibility", (req, res) => 
    profile.updateProfileVisibility(req, res)
);
router.delete("/profile/:id", (req, res) => 
    profile.deleteProfile(req, res)
);

module.exports = router;
