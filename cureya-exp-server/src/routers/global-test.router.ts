import { Router } from "express";
import GlobalDiagnosisTestController from "../controllers/global-test.controller";
import passport from "passport";
import { RBACValidator } from "../middlewares/rbac.middleware";
import { Role } from "../constants/enums";

const globalDiagnosticTestRouter: Router = Router();

globalDiagnosticTestRouter.get(
  "",
  passport.authenticate("jwt", { session: false }),
  GlobalDiagnosisTestController.get
);
globalDiagnosticTestRouter.post(
  "",
  passport.authenticate("jwt", { session: false }),
  RBACValidator([Role.ADMIN]),
  GlobalDiagnosisTestController.post
);

export default globalDiagnosticTestRouter;
