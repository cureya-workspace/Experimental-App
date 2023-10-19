import { Router } from "express";
import passport from "passport";
import AppointmentController from "../controllers/appointment.controller";
import { RBACValidator } from "../middlewares/rbac.middleware";
import { Role } from "../constants/enums";
import AppointmentDiagnosisTestController from "../controllers/appointment-dtest.controller";

const appointmentDTestRouter: Router = Router();

appointmentDTestRouter.get(
  "/",
  [passport.authenticate("jwt", { session: false })],
  AppointmentDiagnosisTestController.get
);

appointmentDTestRouter.post(
  "/",
  [
    passport.authenticate("jwt", { session: false }),
    RBACValidator([Role.USER]),
  ],
  AppointmentDiagnosisTestController.post
);

export default appointmentDTestRouter;
