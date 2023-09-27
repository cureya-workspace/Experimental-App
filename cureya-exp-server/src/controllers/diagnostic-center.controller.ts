import { NextFunction, Request, Response } from "express";

export class DiagnosticCenterController {
  static async get(req: Request, res: Response, next: NextFunction) {
    const params: {
        pincode?: string;
        city?: string;
    } = req.query;

    // Validation Block
    try {
        if (!(params.pincode || params.city)) {
            throw new Error('Please provide ')
        }
    } catch (error: any) {

    }

    return res.json(params);
  }

  static async put(req: Request, res: Response, next: NextFunction) {}
  static async post(req: Request, res: Response, next: NextFunction) {}
  static async delete(req: Request, res: Response, next: NextFunction) {}
}
