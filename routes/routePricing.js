const express = require("express");
const router = express.Router();

const pricing = require("../controllers/pricing/pricingController");

// @path: api/laundry/pricing
// @Description: Create pricing
router.post("/laundry/pricing", (req, res) =>
    pricing.createPricing(req, res)
);

// @path: api/laundry/pricing/623fea2e9fe8e253fd772601
// @Description: Get pricing
router.get("/laundry/pricing/:id", (req, res) =>
    pricing.getPricing(req, res)
);

// @path: api/laundry/pricing
// @Description: Delete pricing
router.put("/laundry/pricing", (req, res) =>
    pricing.updatePricing(req, res)
);

module.exports = router;
