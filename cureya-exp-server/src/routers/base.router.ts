import { Router } from 'express'
import userRouter from './user.router';
import authRouter from './auth.router';
import diagnosticCenterRouter from './diagnostic-center.router';

const baseRouter: Router = Router();

// Routes
baseRouter.use('/user', userRouter);
baseRouter.use('/auth', authRouter);
baseRouter.use('/diagnostic-center', diagnosticCenterRouter);


export default baseRouter; 