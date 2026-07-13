import express from "express";
import { env } from "./config/env.js";
import cors from "cors";
import helmet from "helmet";
import morgan from "morgan";
import cookieParser from "cookie-parser";

const app = express();
app.use(helmet());
app.use(morgan("dev"));

app.use(cors({origin: env.frontendUrl ,credentials : true}));
app.use(express.json());
app.use(express.urlencoded({extended:true}));
app.use(cookieParser());
app.get('/health',(req , res) =>res.json({status : "ok" , message : "Server is running"}));

export default app;