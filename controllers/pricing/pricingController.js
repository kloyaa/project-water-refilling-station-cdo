const Pricing = require("../../models/pricing");

const createPricing = async (req, res) => {
    try {
        const accountId = req.body.accountId;
        const doesExist = await Pricing.findOne({ accountId });
        if(doesExist)
            return res.status(400).json({ message: "cannot add more pricing"})
            
        return new Pricing(req.body)
            .save()
            .then((value) => res.status(200).json(value))
            .catch((err) => res.status(400).json(err.errors));
    } catch (error) {
        console.error(error);
    }
}

const getPricing = (req, res) => {
    try {
        const accountId = req.params.id;
        Pricing.findOne({ accountId })
            .select({ __v: 0 })
            .then((value) => {
                if (!value) 
                    return res.status(400).json({ message: "accountId not found" });
                return res.status(200).json(value);
            })
            .catch((err) => res.status(400).json(err));
    } catch (error) {
        console.error(error);
    }
}

const updatePricing = (req, res) => {
    try {
        const accountId = req.query.accountId;
        const pricing = req.query.pricing;
        Pricing.findOneAndUpdate({ accountId }, { pricing }, { new: true })
            .then((value) => {
                if (!value) 
                    return res.status(400).json({ message: "accountId not found" });
                return res.status(200).json(value);
            })
            .catch((err) => res.status(400).json(err));
    } catch (error) {
        console.error(error);
    }
}

module.exports = {
    createPricing,
    getPricing,
    updatePricing
}