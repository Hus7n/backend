import dotenv from "dotenv";
import { envSchema } from "../validators/env.schema.js";

dotenv.config();
const parsedEnv = envSchema.parse(process.env);
function required (name:string):string{
    const value = process.env[name];

    if(!value)
        throw new Error(`Missing environment variable:${name}`);
    return value;
}
export const env = {
    nodeEnv : parsedEnv.NODE_ENV,
    port : parsedEnv.PORT,
    databaseUrl : parsedEnv.DATABASE_URL,
    jwtSecret :parsedEnv.JWT_SECRET,
    frontendUrl : parsedEnv.FRONTEND_URL ?? "http://localhost:3000",
    passwordSaltRounds : parsedEnv.PASSSWORD_SALT_ROUNDS,
} satisfies {
    nodeEnv : "development" | "test" | "production";
    port : number;
    databaseUrl : string ;
    jwtSecret : string ;
    frontendUrl : string;
    passwordSaltRounds : number;
};

export type Env = typeof env;