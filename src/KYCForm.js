import React, { useState } from 'react';
import { initializeApp } from 'firebase/app';
import { getFirestore, collection, addDoc } from 'firebase/firestore';
import { getStorage, ref, uploadBytes } from 'firebase/storage';
import { FaceioReact } from '@faceio/faceio-react';

// Initialize Firebase
const firebaseConfig = {
  apiKey: "YOUR_FIREBASE_API_KEY",
  authDomain: "YOUR_AUTH_DOMAIN",
  projectId: "gropesa-kyc",
  storageBucket: "YOUR_STORAGE_BUCKET",
  messagingSenderId: "YOUR_SENDER_ID",
  appId: "YOUR_APP_ID"
};
const app = initializeApp(firebaseConfig);
const db = getFirestore(app);
const storage = getStorage(app);

export default function KYCForm() {
  const [idNumber, setIdNumber] = useState('');
  const [idPhoto, setIdPhoto] = useState(null);
  const [selfie, setSelfie] = useState(null);
  const [faceio, setFaceio] = useState(null);

  const handleSubmit = async (e) => {
    e.preventDefault();
    const submission = {
      idNumber,
      status: 'pending',
      timestamp: new Date(),
    };

    // Upload files to Firebase Storage
    const idPhotoRef = ref(storage, `kyc/${idNumber}/idPhoto.jpg`);
    const selfieRef = ref(storage, `kyc/${idNumber}/selfie.jpg`);
    await uploadBytes(idPhotoRef, idPhoto);
    await uploadBytes(selfieRef, selfie);

    // Save submission to Firestore
    await addDoc(collection(db, 'kycSubmissions'), {
      ...submission,
      idPhotoPath: `kyc/${idNumber}/idPhoto.jpg`,
      selfiePath: `kyc/${idNumber}/selfie.jpg`,
    });

    alert('KYC submitted! Wait for admin approval.');
  };

  return (
    <div>
      <h1>GroPesa KYC Verification</h1>
      <form onSubmit={handleSubmit}>
        <input
          type="text"
          placeholder="Kenyan National ID Number"
          value={idNumber}
          onChange={(e) => setIdNumber(e.target.value)}
          required
        />
        <input
          type="file"
          accept="image/*"
          onChange={(e) => setIdPhoto(e.target.files[0])}
          required
        />
        <FaceioReact
          ref={setFaceio}
          publicId="YOUR_FACEIO_PUBLIC_ID" // Get from FaceIO dashboard
          onSuccess={(data) => setSelfie(data.photo)}
          required
        />
        <button type="submit">Submit KYC</button>
      </form>
    </div>
  );
}
