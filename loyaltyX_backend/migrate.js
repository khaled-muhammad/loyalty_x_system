import sequelize from './db.js'
import {User, Card, Order, LoyaltyPoint} from './models/index.js'

try {
  await sequelize.authenticate()
  console.log('DB Connected :)')

  await User.sync({ alter: true }) 
  console.log('User Model pushed ...')
  await Card.sync({ alter: true }) 
  console.log('Card Model pushed ...')

  await Order.sync({ alter: true }) 
  console.log('Order Model pushed ...')

  await LoyaltyPoint.sync({ alter: true }) 
  console.log('LoyaltyPoint Model pushed ...')
} catch (error) {
  console.error('error:', error)
}