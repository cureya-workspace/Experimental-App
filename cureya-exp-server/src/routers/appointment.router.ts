import { Router } from "express";
import AppointmentController from "../controllers/appointment.controller";
import passport from "passport";
import { RBACValidator } from "../middlewares/rbac.middleware";
import { Role } from "../constants/enums";

const appointmentRouter: Router = Router();

appointmentRouter.get(
  "/",
  [passport.authenticate("jwt", { session: false })],
  AppointmentController.get
);

appointmentRouter.post(
  "/",
  [
    passport.authenticate("jwt", { session: false }),
    RBACValidator([Role.USER]),
  ],
  AppointmentController.post
);

export default appointmentRouter;
