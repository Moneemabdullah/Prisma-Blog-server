import express, { Router } from "express";
import { PostController } from "./post.controller";
import { auth } from "../../middleware/auth";
import { userRole as UserRole } from "../../middleware/auth";

const router = express.Router();

router.get("/", PostController.getAllPost);

router.get("/:postId", PostController.getPostById);

router.post("/", auth(UserRole.USER), PostController.createPost);

export const postRouter: Router = router;
