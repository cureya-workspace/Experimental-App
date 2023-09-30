import { NextFunction, Request, Response } from "express";
import prismaClient from "../constants/prisma_client_singleton";
import assert from "assert";

export class DiagnosticCenterController {
  static async get(req: Request, res: Response, next: NextFunction) {
    const params: {
      pincode?: string;
      city?: string;
      page?: string;
    } = req.query;

    let PAGE: number;
    let COUNT: number;

    // Validation Block
    try {
      PAGE = params.page ? Number.parseInt(params.page) : 1;
      COUNT = Number.parseInt(process.env.ENTITY_COUNT_PER_PAGE as unknown as string);

      if (PAGE === 0) {
        throw new Error("Please provide valid page number.");
      }

      if (!(params.pincode || params.city)) {
        throw new Error("Please provide either pincode or city.");
      }
    } catch (error: any) {
      return res.status(400).json({ success: false, message: error.message });
    }

    const result = await prismaClient.diagnosticCenter.findMany({
      where: {
        pincode: params.pincode ? params.pincode : undefined,
        city: params.city ? params.city : undefined,
      },
      skip: 5 * (PAGE - 1),
      take: 10,
    });
    const totalCount = await prismaClient.diagnosticCenter.count({
      where: {
        pincode: params.pincode ? params.pincode : undefined,
        city: params.city ? params.city : undefined,
      },
    });

    console.log(result)

    const hasNextData = Math.ceil(result.length / totalCount) < PAGE;
    const hasPreviousData = PAGE !== 1;

    try {
      
    const response = {
      success: true,
      paging: {
        totalCount: totalCount,
        next: hasNextData
          ? `${req.protocol}://${req.get("host")}${req.baseUrl}?page=${
              PAGE + 1
            }`
          : false,
        previous: hasPreviousData
          ? `${req.protocol}://${req.get("host")}${req.baseUrl}?page=${
              PAGE - 1
            }`
          : false,
      },
      data: result,
    };

    return res.json(response);
    } catch (error: any) {
      console.log(error)
      return res.status(500).json({
        success: false,
        message: error.messsage
      });
    }
  }

  static async post(req: Request, res: Response, next: NextFunction) {
    const {
      name,
      email,
      phone,
      address,
      pincode,
      city,
      operating_start_time,
      operating_end_time,
      does_home_visit,
      center_type,
    } = req.body;

    const emailRegex: RegExp =
      /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;
    const phoneRegex: RegExp = /^(?:\+\d{1,3})?(?:\d{10,15})$/;

    // Validation block
    try {
      assert(name, "please provide name");
      assert(email, "Please provide email");
      assert(phone, "Please provide address");
      assert(address, "Please provide address");
      assert(pincode, "Please provide pincode");
      assert(city, "Please provide city");
      assert(operating_start_time, "Please provide operating start time");
      assert(operating_end_time, "Please provide operating end time");
      assert(center_type, "please provide center type");
      assert(does_home_visit !== undefined, "please provide does_home_visit");

      // if (!emailRegex.test(email)) {
      //   throw new Error('Please provide valid email');
      // }

      // if (!phoneRegex.test(phone)) {
      //   throw new Error('Please provide valid phone');
      // }
    } catch (error: any) {
      return res.status(400).json({
        success: false,
        message: error.message,
      });
    }

    try {
      const center = await prismaClient.diagnosticCenter.create({
        data: {
          name: name,
          email: email,
          phone: phone,
          address: address,
          pincode: pincode,
          city: city,
          operating_start_time: operating_start_time,
          operating_end_time: operating_end_time,
          does_home_visit: does_home_visit,
          center_type: center_type,          
        },
      });

      return res.json({
        success: true,
        data: center
      });
    } catch (error: any) {
      console.log(error)
      return res.status(500).json({
        success: false,
        message: error.messsage
      });
    }
  }
}