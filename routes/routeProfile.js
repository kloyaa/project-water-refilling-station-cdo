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
router.put("/profile/:id", (req, res) => 
    profile.updateProfile(req, res)
);
router.put("/address/profile/:id", (req, res) => 
    profile.updateProfileAddress(req, res)
);
router.put("/contact/profile/:id", (req, res) => 
    profile.updateProfileContact(req, res)
);
router.delete("/profile/:id", (req, res) => 
    profile.deleteProfile(req, res)
);

router.post("/a/profile", (req, res) => 
    profile.updateCustomerAvatar(req, res)
);

router.post("/b/profile", (req, res) => 
    profile.updateLaundryBanner(req, res)
);

module.exports = router;
