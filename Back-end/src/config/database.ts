import mongoose from "mongoose";
import "dotenv/config";

const MONGO_URI = String(process.env.MONGO_URI);

const connectDatabase = () => {
  mongoose
    .connect(MONGO_URI)
    .then(() => {
      console.log("Mongoose Connected");
    });
};
export default connectDatabase;
