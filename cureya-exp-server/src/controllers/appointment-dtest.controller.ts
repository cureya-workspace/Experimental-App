import assert from "assert";
import { Request, Response } from "express";
import prismaClient from "../constants/prisma_client_singleton";
import {
  Appointment,
  AppointmentDiagnosisTest,
  DCTest,
  User,
} from "@prisma/client";

export default class AppointmentDiagnosisTestController {
  static async get(req: Request, res: Response) {
    const { appointment_id: appointmentId } = req.query as any;

    try {
      assert(appointmentId, "Please provide appointment id");
    } catch (error: any) {
      return res.json(400).json({
        success: false,
        message: error.message,
      });
    }

    try {
      const result = await prismaClient.appointmentDiagnosisTest.findMany({
        where: {
          appointment_id: appointmentId,
        },
      });

      return res.json({
        success: true,
        data: result,
      });
    } catch (error: any) {
      return res.json(400).json({
        success: false,
        message: error.message,
      });
    }
  }

  static async post(req: Request, res: Response) {
    const { dc_test_id, appointment_id } = req.body;
    const user: User = req.user as User;

    try {
      assert(dc_test_id, "Please provide dc test id");
      assert(appointment_id, "please provide appointment id.");

      const apt: Appointment | null = await prismaClient.appointment.findUnique(
        {
          where: {
            id: appointment_id,
          },
        }
      );

      if (!apt) {
        throw new Error("Invalid appointment id");
      }

      if (apt.user_id !== user.id) {
        throw new Error("Unauthorized appointment!!");
      }

      const dCTest: DCTest | null = await prismaClient.dCTest.findUnique({
        where: {
          id: dc_test_id,
        },
      });

      if (!dCTest) {
        throw new Error("Invalid diagnosis test id");
      }

      if (dCTest.diagnostic_center_id != apt.diagnostic_center_id) {
        throw new Error("Unauthorized appointment 2 !!");
      }
    } catch (error: any) {
      return res.json(400).json({
        success: false,
        message: error.message,
      });
    }

    try {
      const result: AppointmentDiagnosisTest | null =
        await prismaClient.appointmentDiagnosisTest.create({
          data: {
            dc_test_id: dc_test_id,
            appointment_id: appointment_id,
          },
        });

      return res.json({
        success: true,
        data: result,
      });
    } catch (error: any) {
      return res.json({
        success: false,
        message: error.message,
      });
    }
  }

  static async put(req: Request, res: Response) {}
  static async delete(req: Request, res: Response) {}
}
