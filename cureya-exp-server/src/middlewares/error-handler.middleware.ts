import { NextFunction, Request, Response } from "express";

const handleError = (err: any, req: Request, res: Response, next: NextFunction) => {
    const output: any = {
        success: false,
        err: err.message,
    };
    return res.status(400).json(output);
}

export default handleError;