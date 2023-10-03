import { User } from "@prisma/client";
import { Request, Response } from "express";
import prismaClient from "../constants/prisma_client_singleton";
import { Role } from "../constants/enums";
import assert from "assert";

export default class AppointmentController {
  static async get(req: Request, res: Response) {
    const user: User = req.user as User;
    const page: number = Number.parseInt(req.params.page) || 1;
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
        skip: (page - 1) * LIMIT,
        take: LIMIT,
      });

      const totalPages = Math.ceil(resultCount / LIMIT);
      const hasNextData = totalPages > page;
      const hasPreviousData = page !== 1;

      const response = {
        success: true,
        paging: {
          totalPages: Math.ceil(resultCount / LIMIT),
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
    const { diagnostic_center_id, visit_date_time } = req.body;

    const user: User = req.user as any;

    try {
      assert(diagnostic_center_id, "Please provide diagnostic center id");
      assert(visit_date_time, "Please provide visit date time");
    } catch (error: any) {
      return res.status(400).json({
        success: false,
        message: error.message,
      });
    }

    try {
      const result = await prismaClient.appointment.create({
        data: {
          diagnostic_center_id: diagnostic_center_id,
          visit_date: Date.now().toLocaleString(),
          status: "Not Verified",
          user_id: user.id,
        },
      });
      return res.json({
        success: false,
        data: result,
      });
    } catch (err: any) {
      return res.status(400).json({
        success: false,
        message: err.message,
      });
    }
  }
  static async put(req: Request, res: Response) {
    // const 
  }
  static async delete(req: Request, res: Response) {}
}
