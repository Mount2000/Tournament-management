import express from "express";
import {Request, Response} from "express";
import "dotenv/config";
import axios from 'axios';
import connectDatabase from "./config/database";
import bodyParser from "body-parser";
import userRoutes from "./routes/UserRoute";

const app = express();
const port = 3000;

const db = connectDatabase();

app.use(express.json());
app.use(bodyParser.json());
app.use(express.urlencoded({ extended: true }));


// Route to handle sending transactions
app.use('/api/users', userRoutes);


app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
