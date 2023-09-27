import {Router} from 'express';
import passport from 'passport';
import { DiagnosticCenterController } from '../controllers/diagnostic-center.controller';

const diagnosticCenterRouter: Router = Router();

diagnosticCenterRouter.get('', [
    passport.authenticate('jwt', {session: false})
], DiagnosticCenterController.get);

export default diagnosticCenterRouter;