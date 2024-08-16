import mongoose from "mongoose";

const userSchema = new mongoose.Schema({
    name: String,
    // twitter: String,
  });
const User = mongoose.model('user', userSchema);
export default User;