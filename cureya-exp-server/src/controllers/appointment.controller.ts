import { User } from "@prisma/client";
import { Request, Response } from "express";
import prismaClient from "../constants/prisma_client_singleton";
import { Role } from "../constants/enums";
import assert from "assert";

export default class AppointmentController {
  static async get(req: Request, res: Response) {
    const user: User = req.user as User;
    const page: number = Number.parseInt(req.query.page as string) || 1;
    const LIMIT: number =
      Number.parseInt(process.env.ENTITY_COUNT_PER_PAGE as string) || 10;

    try {
      const resultCount = await prismaClient.appointment.count({
        where: {
          user_id: user.role === Role.ADMIN ? undefined : user.id,
        },
      });
      const result = await prismaClient.appointment.findMany({
        where: {
          user_id: user.role === Role.ADMIN ? undefined : user.id,
        },
        include: {
          diagnostic_centre: {
            select: {
              id: true,
              name: true,
              city: true,
            }
          },
          user: {
            select: {
              id: true,
              first_name: true,
              last_name: true,
              email: true,
              phone: true
            }
          }
        },
        skip: (page - 1) * LIMIT,
        take: LIMIT,
      });

      const totalPages = Math.ceil(resultCount / LIMIT);
      const hasNextData = totalPages > page;
      const hasPreviousData = page !== 1;

      const response = {
        success: true,
        paging: {
          totalPages: totalPages,
          totalCount: resultCount,
          next: hasNextData
            ? `${req.protocol}://${req.get("host")}${req.baseUrl}?page=${
                page + 1
              }`
            : null,
          previous: hasPreviousData
            ? `${req.protocol}://${req.get("host")}${req.baseUrl}?page=${
                page - 1
              }`
            : null,
        },
        data: result,
      };

      return res.json(response);
    } catch (error: any) {
      return res.status(500).json({
        success: false,
        message: error.message,
      });
    }
  }

  static async post(req: Request, res: Response) {
    const { diagnostic_center_id, visit_date_time, appointment_slot } = req.body;
    const user: User = req.user as any;

    try {
      assert(diagnostic_center_id, "Please provide diagnostic center id");
      assert(visit_date_time, "Please provide visit date time");
      assert(appointment_slot, "Please provide visit appointment_slot");
    } catch (error: any) {
      return res.status(400).json({
        success: false,
        message: error.message,
      });
    }

    try {
      const date = new Date(Date.now());
      const result = await prismaClient.appointment.create({
        data: {
          diagnostic_center_id: diagnostic_center_id,
          slot: appointment_slot,
          visit_date: date.toISOString(),
          status: "Not Verified",
          user_id: user.id,
        },
      });
      return res.json({
        success: true,
        data: result,
      });
    } catch (err: any) {
      return res.status(400).json({
        success: false,
        message: err.message,
      });
    }
  }
  static async put(req: Request, res: Response) { }
  static async delete(req: Request, res: Response) {}

  static async getWithId(req: Request, res: Response) {
    const { appointment_id } = req.params;
    const user = req.user as User;
    try {
      const appointmentCount: number = await prismaClient.appointment.count({
        where: {
          id: appointment_id
        }
      });

      if (!appointmentCount) {
        return res.status(404).json({
          success: false,
          message: "Appointment not found"
        });
      }

      const result = await prismaClient.appointment.findUnique({
        where: {
          id: appointment_id
        },
        include: {
          AppointmentDiagnosisTest: {
            include: {
              dc_test: {
                include: {
                  global_diagnosis_test: {
                    select: {
                      test_name: true
                    }
                  }
                }
              }
            }
          },
          diagnostic_centre: {
            select: {
              id: true,
              name: true,
              city: true,
              address: true,
            }
          },
          user: {
            select: {
              id: true,
              first_name: true,
              last_name: true,
              email: true,
              phone: true
            }
          }
      }});

      if (user.role == Role.USER && result?.user_id != user.id) {
        return res.status(401).json({
          success: false,
          message: "You're unauthorized to perform this action!"
        });
      }

      return res.json({
        success: true,
        data: result
      })
    } catch (error) {
      return res.status(500).json({
          success: false,
          message: "Something went wrong!"
        });
    }
  }
}
