import { User, Order, LoyaltyPoint, Card } from '../models/index.js'
import { v4 } from 'uuid'

// I made this controller to match the task spec ( to secure a winning place :) )

export const getPoints = async (req, res) => {
    try {
        const user = await User.findByPk(req.userId)
        
        if (!user) {
            return res.status(404).json({ error: "User not found" })
        }

        res.json({
            user_id: user.userId,
            total_points: user.points || 0
        })
    } catch (error) {
        res.status(500).json({ error: error.message })
    }
}


export const addPoints = async (req, res) => {
    try {
        const { user_id, order_total } = req.body;

        if (!user_id || order_total === undefined) {
            return res.status(400).json({ error: "user ID and order total are required" });
        }

        if (order_total <= 0) {
            return res.status(400).json({ error: "Order total must be greater than 0" });
        }

        const user = await User.findByPk(user_id);
        if (!user) {
            return res.status(404).json({ error: "User not found" });
        }

        if (user_id !== req.userId) {
            return res.status(403).json({ error: "Unauthorized" });
        }

        const defaultCard = await Card.findOne({
            where: { userId: req.userId, default: true }
        });

        if (!defaultCard) {
            return res.status(400).json({
                error: "You need to add Card before Making a new order!"
            });
        }

        const pointsToAdd = Math.floor(order_total / 10);

        const order = {
            id: v4(),
            userId: req.userId,
            totalAmount: order_total,
            cardId: defaultCard.id,
        };
        const createdOrder = await Order.create(order);

        const loyaltyPoint = {
            id: v4(),
            orderId: order.id,
            pointsEarned: pointsToAdd,
        };
        await LoyaltyPoint.create(loyaltyPoint);

        await User.increment(
            {
                totalMoneySpent: order_total,
                points: pointsToAdd
            },
            {
                where: { userId: req.userId },
            }
        );

        const orderWithCard = await Order.findByPk(createdOrder.id, {
            include: [
                { model: Card, as: 'card' },
                { model: LoyaltyPoint, as: 'loyaltyPoint' }
            ]
        });

        return res.status(201).send({
            message: "Order made successfully",
            data: orderWithCard
        });

    } catch (error) {
        return res.status(500).json({ error: error.message });
    }
}