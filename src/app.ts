import express, { Application } from "express";
import { postRouter } from "./modules/post/post.route";
import { toNodeHandler } from "better-auth/node";
import { auth } from "./lib/auth";
import cors from "cors";



const app: Application = express();



app.use(
    cors({
        origin: process.env.BETTER_AUTH_URL ?? "",
        credentials: true,
    }),
);

app.all("/api/auth/{*any}", toNodeHandler(auth));
app.use(express.json());

app.get("/", (req, res) => {
    res.send("Hello, Prisma with Express!");
});

app.use("/posts", postRouter);

export default app;
