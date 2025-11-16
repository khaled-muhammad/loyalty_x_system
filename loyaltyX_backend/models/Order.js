import { DataTypes } from 'sequelize'
import sequelize from '../db.js'
import User from './User.js'
import Card from './Card.js'

const Order = sequelize.define('Order', {
  id: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true,
    primaryKey: true
  },
  userId: {
    type: DataTypes.STRING,
    allowNull: false,
    references: {
        model: User,
        key: 'userId',
    },
    onUpdate: 'CASCADE',
    onDelete: 'CASCADE'
  },
  totalAmount: {
    type: DataTypes.DOUBLE,
    allowNull: false,
  },
  cardId: {
    type: DataTypes.STRING,
    allowNull: false,
    references: {
        model: Card,
        key: 'id',
    },
    onUpdate: 'CASCADE',
    onDelete: 'CASCADE'
  },

}, {
    tableName: 'orders',
    updatedAt: false,

})

export default Order