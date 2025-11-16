import express from 'express'

import { getCards, postCard, deleteCard, setDefaultCard } from '../controllers/cardController.js'

const router = express.Router()

router.get('/', getCards)
router.post('/', postCard)
router.delete('/:cardId', deleteCard)
router.put('/:cardId', setDefaultCard)

export default router