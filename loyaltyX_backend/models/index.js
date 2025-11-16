import sequelize from '../db.js'
import User from './User.js'
import Card from './Card.js'
import Order from './Order.js'
import LoyaltyPoint from './LoyaltyPoint.js'

User.hasMany(Card, { foreignKey: 'userId', as: 'cards' })
User.hasMany(Order, { foreignKey: 'userId', as: 'orders' })

Order.hasOne(LoyaltyPoint, {
  foreignKey: 'orderId',
  as: 'loyaltyPoint',
  onDelete: 'CASCADE'
})

Card.belongsTo(User, { foreignKey: 'userId', as: 'user' })
Order.belongsTo(User, { foreignKey: 'userId', as: 'user' })
LoyaltyPoint.belongsTo(Order, { foreignKey: 'orderId', as: 'order' })

Order.belongsTo(Card, { foreignKey: 'cardId', as: 'card' });
Card.hasMany(Order, { foreignKey: 'cardId', as: 'orders' });

export { sequelize, User, Card, Order, LoyaltyPoint }