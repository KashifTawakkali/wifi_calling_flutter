import type { VercelRequest, VercelResponse } from '@vercel/node';
import express from 'express';
import mongoose from 'mongoose';
import cors from 'cors';
import morgan from 'morgan';
import auth from '../src/routes/auth';
import contacts from '../src/routes/contacts';

const app = express();
app.use(cors());
app.use(express.json());
app.use(morgan('dev'));
app.use('/auth', auth);
app.use('/contacts', contacts);
app.get('/health', (_req, res) => res.json({ ok: true }));

let isConnected = false;

async function ensureDb() {
  if (isConnected) return;
  const url = process.env.URL as string;
  const dbName = process.env.DBNAME as string;
  const user = process.env.USERNAME as string;
  const pass = process.env.PASSWORD as string;
  await mongoose.connect(url, { dbName, user, pass } as any);
  isConnected = true;
}

export default async function handler(req: VercelRequest, res: VercelResponse) {
  await ensureDb();
  // Let Express handle routing
  return new Promise<void>((resolve) => {
    app(req as any, res as any, () => resolve());
  });
} 