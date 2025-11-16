import {v4} from 'uuid'

import { User, Card, Order, LoyaltyPoint } from '../models/index.js'


export const getOrders = async (req, res) => {
    res.send((await User.findByPk(req.userId, {
      include: [
        {
          model: Order,
          as: 'orders',
          include: [
            {
              model: Card,
              as: 'card',
            },
            {
              model: LoyaltyPoint,
              as: 'loyaltyPoint',
            }
          ]
        }
      ]
    })).orders)
}

export const postOrder = async (req, res) => {
    const {totalAmount} = req.body || {}

    if (!totalAmount) {
        res
        .status(400)
        .send({ error: "Amount should be filled correctly!" })
        return
    }

    if (totalAmount < 1) {
        res
        .status(400)
        .send({ error: "Amount must be at least 1!" })
        return
    }

    const defaultCard = await Card.findOne({where: {userId: req.userId, default: true}})

    if (!defaultCard) {
        res
        .status(400)
        .send({ error: "You need to add Card before Making a new order!" })
        return
    }

    const order = {
        id: v4(),
        userId: req.userId,
        totalAmount,
        cardId: defaultCard.id,
    }
    const createdOrder = await Order.create(order)

    const pointsToAdd = Math.floor(totalAmount / 10)

    const loyaltyPoint = {
        id: v4(),
        orderId: order.id,
        pointsEarned: pointsToAdd,
    }

    await LoyaltyPoint.create(loyaltyPoint)


    await User.increment(
        {
            totalMoneySpent: totalAmount,
            points: pointsToAdd
        },
        {
            where: { userId: req.userId },
        }
    )

    const orderWithCard = await Order.findByPk(createdOrder.id, {
        include: [
            { model: Card, as: 'card' },
            { model: LoyaltyPoint, as: 'loyaltyPoint' }
        ]
    })

    res.status(201).send({message: "Order made successfully", data: orderWithCard})

}

