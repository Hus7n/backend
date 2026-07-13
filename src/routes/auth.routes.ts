import { Router } from "express";
import { authController } from "../controllers/auth.controller.js";
import { authenticate } from "../middleware/auth.middleware.js";

export const authRouter = Router();

authRouter.post("/register" , authController.register);
authRouter.post("/login" , authController.login);
authRouter.post("/refresh" , authController.refresh);
authRouter.post("/logout" , authController.logout);
authRouter.post("logout-all" , authController.logOutAll);

authRouter.get("/me" , authenticate , authController.me);
authRouter.get("/token-info" , authenticate , authController.tokenInfo);

authRouter.get("/verify-email" , authController.verifyEmail);
authRouter.get("/reset-password" , authController.resetPassword);