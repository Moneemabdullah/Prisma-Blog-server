/*
  Warnings:

  - You are about to drop the column `statue` on the `comments` table. All the data in the column will be lost.

*/
-- CreateEnum
CREATE TYPE "CommentStatus" AS ENUM ('APPROVED', 'REJECTED');

-- AlterTable
ALTER TABLE "comments" DROP COLUMN "statue",
ADD COLUMN     "status" "CommentStatus" NOT NULL DEFAULT 'APPROVED';

-- DropEnum
DROP TYPE "CommentStatues";
