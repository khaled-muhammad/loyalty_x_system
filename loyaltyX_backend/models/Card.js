import { DataTypes } from 'sequelize'
import sequelize from '../db.js'
import User from './User.js'

const Card = sequelize.define('Card', {
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
  cardHolderName: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  cardNumber: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  cardYear: {
    type: DataTypes.INTEGER,
    allowNull: false,
  },
  cardMonth: {
    type: DataTypes.INTEGER,
    allowNull: false,
  },
  cardCvv: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  default: {
    type: DataTypes.BOOLEAN,
    defaultValue: false
  }
}, {
  tableName: 'cards',
})

export default Card