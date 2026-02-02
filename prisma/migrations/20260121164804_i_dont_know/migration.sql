/*
  Warnings:

  - You are about to drop the column `authorID` on the `posts` table. All the data in the column will be lost.

*/
-- DropIndex
DROP INDEX "posts_authorID_idx";

-- AlterTable
ALTER TABLE "posts" DROP COLUMN "authorID",
ADD COLUMN     "authorId" TEXT;

-- CreateIndex
CREATE INDEX "posts_authorId_idx" ON "posts"("authorId");
