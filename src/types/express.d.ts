import type { UserRole } from "./user.ts";

declare global {
    namespace Express {
        interface Request {
            user?: {
                userId : string;
                role : UserRole;
            };
        }
    }
}