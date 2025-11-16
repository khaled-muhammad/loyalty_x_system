import {v4} from 'uuid'

import { User, Card } from '../models/index.js'


export const getCards = async (req, res) => {
    res.send(await Card.findAll({where: {userId: req.userId}}))
}

export const postCard = async (req, res) => {
    const {cardHolderName, cardNumber, cardYear, cardMonth, cardCvv} = req.body || {}

    if (!cardHolderName || !cardNumber || !cardYear || !cardMonth || !cardCvv) {
        res
        .status(400)
        .send({ error: "Card data aren't filled in correctly!" })
        return
    }

    const card = {
        id: v4(),
        userId: req.userId,
        cardHolderName,
        cardNumber,
        cardYear,
        cardMonth,
        cardCvv,
        default: (await Card.count({where: {userId: req.userId}})) == 0,
    }
        const cardAlreadyExists = await Card.findOne({where: { userId: req.userId, cardNumber }})

        if (cardAlreadyExists) {
            res.status(409).send({error: "Card already exists!"})
        } else {
            await Card.create(card)
            res.status(201).send({message: "Card added successfully", data: card})
        }

}

export const setDefaultCard = async (req, res) => {
    const {cardId} = req.params || {}

    if (!cardId) {
        res
        .status(400)
        .send({ error: "Card ID is required!" })
        return
    }

    const cardToSetDefault = await Card.findOne({where: { id: cardId, userId: req.userId }})

    if (!cardToSetDefault) {
        res
        .status(404)
        .send({ error: "Card not found!" })
        return
    }

    await Card.update({default: false}, {where: {userId: req.userId}})
    await cardToSetDefault.update({default: true})

    res.status(200).send({message: "Default card set successfully"})
}

export const deleteCard = async (req, res) => {
    const {cardId} = req.params || {}

    if (!cardId) {
        res
        .status(400)
        .send({ error: "Card ID is required!" })
        return
    }

    const cardToDelete = await Card.findOne({where: { id: cardId, userId: req.userId }})

    if (!cardToDelete) {
        res
        .status(404)
        .send({ error: "Card not found!" })
        return
    }

    if (cardToDelete.default) {
        const userCardCount = await Card.count({where: { userId: req.userId }})
        
        if (userCardCount > 1) {
            res
            .status(400)
            .send({ error: "Cannot delete default card. Set another card as default first!" })
            return
        }
    }

    await Card.destroy({where: { id: cardId, userId: req.userId }})

    res.status(200).send({message: "Card deleted successfully"})
}