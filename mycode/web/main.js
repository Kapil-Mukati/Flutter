// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyCNLdcPt0UD_7soReTtLwYMc8I5dbAbVcA",
  authDomain: "mycode1-87dd9.firebaseapp.com",
  projectId: "mycode1-87dd9",
  storageBucket: "mycode1-87dd9.appspot.com",
  messagingSenderId: "149959819563",
  appId: "1:149959819563:web:993bfebe6add0ae2c0456e",
  measurementId: "G-7Q7727K5RD"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);