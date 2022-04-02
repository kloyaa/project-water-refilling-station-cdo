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
        const visibility =  req.query.visibility;
        
        const d1StartDistance =  req.query.d1StartDistance;
        const d1EndDistance =  req.query.d1EndDistance;
        const d2StartDistance =  req.query.d2StartDistance;
        const d2EndDistance =  req.query.d2EndDistance;
        

        if(accountType === undefined) {
            return Profile.find()
                .sort({ createdAt: -1 }) // filter by date
                .select({ _id: 0, __v: 0 }) // Do not return _id and __v
                .then((value) => res.status(200).json(value))
                .catch((err) => res.status(400).json(err));
        }

        return Profile.find({ accountType, visibility })
            .sort({ createdAt: -1 }) // filter by date
            .select({ _id: 0, __v: 0 }) // Do not return _id and __v
            .then((value) => {
                console.log({
                    "point1Start":d1StartDistance,        
                    "point1End":d1EndDistance,
                    "point2Start":d2StartDistance,        
                    "point2End":d2EndDistance,
                });
                function distance(lat1, lon1, lat2, lon2, unit)  {
                    var radlat1 = Math.PI * lat1/180
                    var radlat2 = Math.PI * lat2/180
                    var theta = lon1-lon2
                    var radtheta = Math.PI * theta/180
                    var dist = Math.sin(radlat1) * Math.sin(radlat2) + Math.cos(radlat1) * Math.cos(radlat2) * Math.cos(radtheta);
                    dist = Math.acos(dist)
                    dist = dist * 180/Math.PI
                    dist = dist * 60 * 1.1515
                    if (unit=="K") { dist = dist * 1.609344 }
                    if (unit=="N") { dist = dist * 0.8684 }
                    return dist
                }
                const distanceBetween =  distance(d1StartDistance, d1EndDistance,d2StartDistance, d2EndDistance, "K").toFixed(1);
                console.log(distanceBetween);
                return res.status(200).json(value);

            })
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
        const { accountId, firstName, lastName } = req.body;
        Profile.findOneAndUpdate(
            { accountId },
            {  
                $set:  {
                    "name.first": firstName,
                    "name.last": lastName,
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

const updateProfileVisibility = (req, res) => {
    try {
        const { accountId, visibility } = req.query;
        Profile.findOneAndUpdate(
            { accountId },
            { visibility }, 
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
      const { accountId, name, lat, long } = req.query;

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
        { new: true })
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
      const { accountId, email, number } = req.query;

      Profile.findOneAndUpdate(
        { accountId },
        {
          $set: {
            "contact.email": email,
            "contact.number": number,
            "date.updatedAt": Date.now(),
          },
        },
        { new: true })
        .then((value) => {
            if (!value)
                return res.status(400).json({ message: "accountId not found" });
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

const updateImg = async (req, res) => {
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
                    "img": uploadedImg.url, 
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
    updateImg,
    updateProfileContact,
    updateProfileAddress,
    updateProfileVisibility
}
