const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const fs = require('fs');
const path = require('path');
const archiver = require('archiver');
const csvParser = require('csv-parser');
const session = require('express-session');
const multer = require('multer');
const ejs = require('ejs');
const pdf = require('html-pdf');
const axios = require('axios');

const app = express();
const PORT = 5000;

// Middleware setup
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.use(session({
  secret: 'your_secret_key',
  resave: false,
  saveUninitialized: true,
  cookie: { secure: false } // Set to true in production with HTTPS
}));

// Directory setup
const certificatesDir = path.join(__dirname, 'certificates');
const idsDir = path.join(__dirname, 'ids');
const zipDir = path.join(__dirname, 'generated_zips');
const uploadsDir = path.join(__dirname, 'uploads');

[certificatesDir, idsDir, zipDir, uploadsDir].forEach(dir => {
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir);
    console.log(`Directory created: ${dir}`);
  } else {
    console.log(`Directory exists: ${dir}`);
  }
});

// Multer setup for file uploads
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    console.log(`Uploading file: ${file.originalname}`);
    cb(null, uploadsDir);
  },
  filename: (req, file, cb) => {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    const fileName = uniqueSuffix + path.extname(file.originalname);
    console.log(`Saved file as: ${fileName}`);
    cb(null, fileName);
  }
});
const upload = multer({ storage });

// Temporary in-memory user storage (for demonstration purposes)
let users = [{ username: 'username1', password: '12345' }];

// User signup endpoint
app.post('/signup', (req, res) => {
  const { username, password } = req.body;
  const userExists = users.find(u => u.username === username);
  if (userExists) {
    return res.status(400).json({ message: 'User already exists' });
  }
  users.push({ username, password });
  res.status(201).json({ message: 'User created successfully' });
});

// User login endpoint
app.post('/login', (req, res) => {
  const { username, password } = req.body;
  const user = users.find(u => u.username === username && u.password === password);

  if (user) {
    req.session.user = user;
    res.status(200).json({ message: 'Login successful!' });
  } else {
    res.status(401).json({ message: 'Invalid username or password' });
  }
});

// Load EJS templates
const idCardTemplatePath = path.join(__dirname, 'templates/idCardTemplate.ejs');
const certificateTemplatePath = path.join(__dirname, 'templates/certificateTemplate.ejs');

if (!fs.existsSync(idCardTemplatePath) || !fs.existsSync(certificateTemplatePath)) {
  console.error('EJS template files not found. Please ensure idCardTemplate.ejs and certificateTemplate.ejs exist in the templates directory.');
  process.exit(1);
}

const idCardTemplate = fs.readFileSync(idCardTemplatePath, 'utf-8');
const certificateTemplate = fs.readFileSync(certificateTemplatePath, 'utf-8');

// Generate certificate endpoint
app.post('/generate-certificate', (req, res) => {
  const { name, dob } = req.body;

  if (!name || !dob) {
    return res.status(400).json({ message: 'Both name and dob are required.' });
  }

  const renderedHtml = ejs.render(certificateTemplate, {
    NAME: name,
    DOB: dob
  });

  const certificatePath = path.join(certificatesDir, `${name}_certificate.pdf`);

  pdf.create(renderedHtml).toFile(certificatePath, (err) => {
    if (err) {
      return res.status(500).json({ message: 'Error generating certificate', error: err.message });
    }

    res.status(200).json({
      message: 'Certificate generated successfully!',
      filePath: `http://localhost:${PORT}/certificates/${path.basename(certificatePath)}` // Return full URL
    });
  });
});

// Generate ID card endpoint
app.post('/generate-id-card', (req, res) => {
  const { name, dob, role, photoBase64 } = req.body;

  if (!name || !dob || !role || !photoBase64) {
    return res.status(400).json({ message: 'All fields are required.' });
  }

  const photoBuffer = Buffer.from(photoBase64, 'base64');
  const photoPath = path.join(uploadsDir, `${name}_photo.png`);

  fs.writeFile(photoPath, photoBuffer, (err) => {
    if (err) {
      return res.status(500).json({ message: 'Error saving photo' });
    }

    const renderedHtml = ejs.render(idCardTemplate, {
      NAME: name,
      DOB: dob,
      POSITION: role,
      PHOTO_URL: `http://localhost:${PORT}/uploads/${path.basename(photoPath)}` // Full URL for image
    });

    const pdfPath = path.join(idsDir, `${name}_id_card.pdf`);

    pdf.create(renderedHtml, { format: 'A7', orientation: 'landscape' }).toFile(pdfPath, (err) => {
      if (err) {
        return res.status(500).json({ message: 'Error generating ID card', error: err.message });
      }

      res.status(200).json({
        message: 'ID card generated successfully!',
        filePath: `http://localhost:${PORT}/ids/${path.basename(pdfPath)}` // Return full URL
      });
    });
  });
});

// Static file serving
app.use('/uploads', express.static(uploadsDir));
app.use('/ids', express.static(idsDir));
app.use('/certificates', express.static(certificatesDir));

// Start server
app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
