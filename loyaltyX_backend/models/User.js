import { DataTypes } from 'sequelize'
import sequelize from '../db.js'

const User = sequelize.define('User', {
  userId: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true,
    primaryKey: true
  },
  username: {
    type: DataTypes.STRING,
    allowNull: false
  },
  email: {
    type: DataTypes.STRING,
    allowNull: false
  },
  password: {
    type: DataTypes.STRING
  },
  points: {
    type: DataTypes.INTEGER,
    defaultValue: 0
  },
  totalMoneySpent: {
    type: DataTypes.DOUBLE,
    defaultValue: 0
  }
}, {
  tableName: 'users',
})

export default User