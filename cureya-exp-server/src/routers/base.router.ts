import { Router } from 'express'
import userRouter from './user.router';
import authRouter from './auth.router';
import diagnosticCenterRouter from './diagnostic-center.router';
import globalDiagnosticTestRouter from './global-test.router';
import dCTestRouter from './dc-test.router';
import appointmentRouter from './appointment.router';
import searchRouter from './search.router';
import appointmentDTestRouter from './appointment-dtest.router';

const baseRouter: Router = Router();

// Routes
baseRouter.use('/search', searchRouter);
baseRouter.use('/user', userRouter);
baseRouter.use('/auth', authRouter);
baseRouter.use('/diagnostic-center', diagnosticCenterRouter);
baseRouter.use('/global-test', globalDiagnosticTestRouter);
baseRouter.use('/dc-test', dCTestRouter); 
baseRouter.use('/appointment', appointmentRouter);
baseRouter.use('/appointment-dtest', appointmentDTestRouter);

export default baseRouter; 