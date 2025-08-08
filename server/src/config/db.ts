import mongoose from 'mongoose';

export const connectDB = async () => {
  try {
    const url = process.env.URL as string;
    const dbName = process.env.DBNAME as string;
    const user = process.env.USERNAME as string;
    const pass = process.env.PASSWORD as string;

    await mongoose.connect(url, {
      dbName,
      user,
      pass,
    } as any);

    console.log('DB Connection established successfully');
  } catch (error) {
    console.error('DB connection error', error);
    process.exit(1);
  }
}; 