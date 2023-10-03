import { Router } from "express";
import passport from "passport";
import AppointmentController from "../controllers/appointment.controller";
import { RBACValidator } from "../middlewares/rbac.middleware";
import { Role } from "../constants/enums";

const appointmentDTestRouter: Router = Router();

appointmentDTestRouter.get(
  "/",
  [passport.authenticate("jwt", { session: false })],
  AppointmentController.get
);

appointmentDTestRouter.post(
  "/",
  [
    passport.authenticate("jwt", { session: false }),
    RBACValidator([Role.USER]),
  ],
  AppointmentController.post
);

export default appointmentDTestRouter;
