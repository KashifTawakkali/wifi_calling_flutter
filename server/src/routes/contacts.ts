import { Router } from 'express';
import User from '../models/User';

const router = Router();

router.get('/', async (_req, res) => {
  const users = await User.find({}, { username: 1, email: 1 }).limit(50);
  res.json(users.map((u) => ({ id: u.id, username: u.username, email: u.email, online: false })));
});

export default router; 