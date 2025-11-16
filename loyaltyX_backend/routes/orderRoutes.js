import express from 'express'

import { getOrders, postOrder } from '../controllers/orderController.js'

const router = express.Router()

router.get('/', getOrders)
router.post('/', postOrder)

export default router