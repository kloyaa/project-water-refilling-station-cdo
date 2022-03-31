const Profile = require("../../models/profile");
const cloudinary = require("../../services/img-upload/cloundinary");

const createProfile = async (req, res) => {
    try {
        const accountId = req.body.accountId;
        const doesExist = await Profile.findOne({ accountId });
        if(doesExist) 
            return res.status(400).json({message: "accountId already exist"})

        return new Profile(req.body)
            .save()
            .then((value) => res.status(200).json(value))
            .catch((err) => res.status(400).json(err.errors));
    } catch (error) {
        console.error(error);
    }
};

const getAllProfiles = (req, res) => {
    try {
        const accountType =  req.query.accountType;
        if(accountType === undefined) {
            return Profile.find()
                .sort({ createdAt: -1 }) // filter by date
                .select({ _id: 0, __v: 0 }) // Do not return _id and __v
                .then((value) => res.status(200).json(value))
                .catch((err) => res.status(400).json(err));
        }

        return Profile.find({ accountType })
            .sort({ createdAt: -1 }) // filter by date
            .select({ _id: 0, __v: 0 }) // Do not return _id and __v
            .then((value) => res.status(200).json(value))
            .catch((err) => res.status(400).json(err));
    } catch (error) {
        console.error(error);
    }
}

const getProfile = (req, res) => {
    try {
        const accountId = req.params.id;
        Profile.findOne({ accountId })
            .select({ _id: 0, __v: 0 })
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

const updateProfile = (req, res) => {
    try {
        const accountId = req.params.id;
        Profile.findOneAndUpdate(
            { accountId },
            {  
                $set:  {
                    firstName: req.body.firstName,
                    lastName: req.body.lastName,
                    "date.updatedAt": Date.now()
                }
            }, 
            { new: true })
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
const updateProfileAddress = (req, res) => {
    try {
      const accountId = req.params.id;
      const { name, lat, long } = req.body;

      Profile.findOneAndUpdate(
        { accountId },
        {
          $set: {
            "address.name": name,
            "address.coordinates.latitude": lat,
            "address.coordinates.longitude": long,
            "date.updatedAt": Date.now(),
          },
        },
        {new: true})
        .then((value) => {
          if (!value) {
            return res.status(400).json({ message: "accountId not found" });
          }
          res.status(200).json(value);
        })
        .catch((err) => res.status(400).json(err));
    } catch (e) {
      return res.status(400).json({ message: "Something went wrong" });
    }
}
      
const updateProfileContact = (req, res) => {
    try {
      const accountId = req.params.id;
      const { email, number } = req.body;

      Profile.findOneAndUpdate(
        { accountId },
        {
          $set: {
            "contact.email": email,
            "contact.number": number,
            "date.updatedAt": Date.now(),
          },
        },
        {new: true})
        .then((value) => {
          if (!value) {
            return res.status(400).json({ message: "accountId not found" });
          }
          return res.status(200).json(value);
        })
        .catch((err) => res.status(400).json(err));
    } catch (e) {
      return res.status(400).json({ message: "Something went wrong" });
    }
}

const deleteProfile = (req, res) => {
    try {
        const accountId = req.params.id;
        Profile.findOneAndRemove({ accountId })
            .then((value) => {
                if (!value) 
                    return res.status(400).json({ message: "accountId not found" });
                return res.status(200).json({ message: "deleted" });
            })
            .catch((err) => res.status(400).json(err));
    } catch (error) {
        console.log(error);
    }
}

const updateCustomerAvatar = async (req, res) => {
  try {
        const accountId = req.body.accountId;
        const filePath = req.file.path;
        const options = { 
            folder: process.env.CLOUDINARY_FOLDER + "/avatar", 
            unique_filename: true 
        };
        const uploadedImg = await cloudinary.uploader.upload(filePath, options);

        Profile.findOneAndUpdate(
            { accountId }, 
            {  
                $set:  {
                    "img.avatar": uploadedImg.url, 
                    "date.updatedAt": Date.now()
                }
            }, 
            { runValidators: true, new: true })
            .then((value) => {
                if (!value) 
                    return res.status(400).json({ message: "_id not found" });
                return res.status(200).json(value);
            })
            .catch((err) => res.status(400).json(err));
  } catch (error) {
      console.log(error);
  }

}
const updateLaundryBanner = async (req, res) => {
    try {
        const accountId = req.body.accountId;
        const filePath = req.file.path;
        const options = { 
            folder: process.env.CLOUDINARY_FOLDER + "/banner", 
            unique_filename: true 
        };
        const uploadedImg = await cloudinary.uploader.upload(filePath, options);
    
        Profile.findOneAndUpdate(
            { accountId }, 
            {  
                $set:  {
                    "img.banner": uploadedImg.url, 
                    "date.updatedAt": Date.now()
                }
            }, 
            { runValidators: true, new: true })
            .then((value) => {
                if (!value) 
                    return res.status(400).json({ message: "_id not found" });
                return res.status(200).json(value);
            })
            .catch((err) => res.status(400).json(err));
    } catch (error) {
        console.log(error);
    }
}

module.exports = {
    createProfile,
    getAllProfiles,
    getProfile,
    updateProfile,
    deleteProfile,
    updateCustomerAvatar,
    updateLaundryBanner,
    updateProfileContact,
    updateProfileAddress
}
