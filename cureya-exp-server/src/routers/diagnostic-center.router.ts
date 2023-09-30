import {Router} from 'express';
import passport from 'passport';
import { DiagnosticCenterController } from '../controllers/diagnostic-center.controller';
import { RBACValidator } from '../middlewares/rbac.middleware';
import { Role } from '../constants/enums';

const diagnosticCenterRouter: Router = Router();

diagnosticCenterRouter.get('', [
    passport.authenticate('jwt', {session: false})
], DiagnosticCenterController.get);

diagnosticCenterRouter.post('', [
    passport.authenticate('jwt', {session: false}),
    RBACValidator([Role.ADMIN]),
], DiagnosticCenterController.post);

export default diagnosticCenterRouter;