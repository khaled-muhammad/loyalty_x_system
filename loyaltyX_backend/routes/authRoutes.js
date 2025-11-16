import express from 'express'

import { register, login, me } from '../controllers/authControllers.js'
import { verifyToken } from '../middlewares/authJWT.js'

const router = express.Router()

router.post('/register', register)
router.post('/login', login)
router.get('/me', verifyToken, me)

export default router