<h1> Node Express CRUD API </h1>
<p>I created this template to make Node JS and Express backend programming simpler. Everyone is welcome to raise an issue because this project is not flawless.</p>
<h2>Project Dependencies</h2>
<ul>
    <li>Mongoose</li>
    <li>Express</li>
    <li>Bcrypt</li>
    <li>Cloudinary</li>
    <li>Multer</li>
    <li>Nodemailer</li>
    <li>Nodemailer Sendgrid Transport</li>
    <li>JSON Web Token</li>
    <li>Uuid</li>
    <li>Dotenv</li>
</ul>

<h2>Project Content</h2>

<ul>
    <li><h3>Create, Read, Update and Delete</h3></li>
        <ul>
            <li>In a REST environment, CRUD often corresponds to the HTTP methods POST, GET, PUT, and DELETE, respectively. These are the fundamental elements of a persistent storage system.</li>
        </ul>
    <li><h3>JSON Web Token Authentication HTTP only</h3></li>
        <ul>
            <li>It provides a gate that prevents the specialized cookie from being accessed by anything other than the server.
            </li>
        </ul>
    <li><h3>Send email using Nodemailer</h3></li>
        <ul>
            <li>Nodemailer is a module for Node.js applications to allow easy as cake email sending. The project got started back in 2010 when there was no sane option to send email messages, today it is the solution most Node.js users turn to by default.</li>
        </ul>
    <li><h3>Upload file/images to cloudinary</h3></li>
        <ul>
            <li>The Cloudinary Node SDK allows you to quickly and easily integrate your application with Cloudinary. Effortlessly optimize, transform, upload and manage your cloud's assets.</li>
        </ul>
</ul>


<h2>Environment Variables</h2>

| Variables | Description |
| :--- | :--- |
| `CONNECTION_STRING` | Connection string for database |
| `CLOUDINARY_NAME` | Cloudinary name |
| `CLOUDINARY_KEY` | Cloudinary key |
| `CLOUDINARY_SECRET` | Cloudinary secret key |
| `CLOUDINARY_FOLDER` | Cloudinary folder for the upload destination. This is optional and you can remove the "folder" key safely in upload option |
| `ACCESS_TOKEN_SECRET` | Cloudinary folder for the upload destination. This is optional and you can remove the "folder" key safely in upload option |

<h2>How to install/run the project? </h2>


1. Clone/Download repository
2. Open the downloaded repository folder using your preferred IDE e.g. [Visual Studio Code](https://code.visualstudio.com/Download)
3. Download [JavaScript runtime built on Chrome's V8 JavaScript engine](https://nodejs.org/en/) and install it
4. Type command "npm install" in terminal/cmd  to install the dependencies
5. Type command "npm run dev" to run the project


<h2>Authors</h2>
<ul>
    <li>Kolya Madridano </li>
</ul>



     
