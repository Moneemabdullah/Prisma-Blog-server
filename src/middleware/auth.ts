import { auth as betterAuth } from "../lib/auth";
import { NextFunction, Request, Response } from "express";

export enum userRole {
    USER = "user",
    ADMIN = "admin",
}

declare global {
    namespace Express {
        interface Request {
            user?: {
                id: string;
                email: string;
                role: userRole;
                name?: string;
                emailVerified?: boolean;
            }; // Adjust the type as needed
        }
    }
}

export const auth = (...roles: userRole[]) => {
    return async (req: Request, res: Response, next: NextFunction) => {
        // Authentication logic here
        // get user session

        const session = await betterAuth.api.getSession({
            headers: req.headers as any,
        });

        if (!session) {
            return res.status(401).json({
                success: false,
                message: "Unauthorized request",
            });
        }

        if (!session.user.emailVerified) {
            return res.status(401).json({
                success: false,
                message: "email verification required",
            });
        }

        req.user = {
            id: session.user.id,
            email: session.user.email,
            role: session.user.role as userRole,
            emailVerified: session.user.emailVerified,
        };

        if (roles.length > 0 && !roles.includes(req.user.role as userRole)) {
            return res.status(403).json({
                success: false,
                message: "Forbidden",
            });
        }
        next();
    };
};
