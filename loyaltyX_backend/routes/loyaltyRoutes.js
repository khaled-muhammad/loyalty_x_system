import express from 'express'
import { getPoints, addPoints } from '../controllers/loyaltyController.js'

const router = express.Router()

router.get('/points', getPoints)
router.post('/add', addPoints)

export default router