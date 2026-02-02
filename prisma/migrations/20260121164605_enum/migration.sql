/*
  Warnings:

  - The values [DRUFT] on the enum `PostStatus` will be removed. If these variants are still used in the database, this will fail.
  - You are about to drop the column `AuthorId` on the `comments` table. All the data in the column will be lost.
  - You are about to drop the column `CreatdeAt` on the `comments` table. All the data in the column will be lost.
  - You are about to drop the column `parentID` on the `comments` table. All the data in the column will be lost.
  - You are about to drop the column `AuthorID` on the `posts` table. All the data in the column will be lost.
  - Added the required column `authorId` to the `comments` table without a default value. This is not possible if the table is not empty.

*/
-- AlterEnum
BEGIN;
CREATE TYPE "PostStatus_new" AS ENUM ('DRAFT', 'PUBLISHED', 'ARCHIVED');
ALTER TABLE "public"."posts" ALTER COLUMN "status" DROP DEFAULT;
ALTER TABLE "posts" ALTER COLUMN "status" TYPE "PostStatus_new" USING ("status"::text::"PostStatus_new");
ALTER TYPE "PostStatus" RENAME TO "PostStatus_old";
ALTER TYPE "PostStatus_new" RENAME TO "PostStatus";
DROP TYPE "public"."PostStatus_old";
ALTER TABLE "posts" ALTER COLUMN "status" SET DEFAULT 'PUBLISHED';
COMMIT;

-- DropForeignKey
ALTER TABLE "comments" DROP CONSTRAINT "comments_parentID_fkey";

-- DropIndex
DROP INDEX "comments_AuthorId_idx";

-- DropIndex
DROP INDEX "comments_PostId_AuthorId_idx";

-- DropIndex
DROP INDEX "posts_AuthorID_idx";

-- AlterTable
ALTER TABLE "comments" DROP COLUMN "AuthorId",
DROP COLUMN "CreatdeAt",
DROP COLUMN "parentID",
ADD COLUMN     "authorId" TEXT NOT NULL,
ADD COLUMN     "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "parentId" TEXT;

-- AlterTable
ALTER TABLE "posts" DROP COLUMN "AuthorID",
ADD COLUMN     "authorID" TEXT;

-- CreateIndex
CREATE INDEX "comments_PostId_authorId_idx" ON "comments"("PostId", "authorId");

-- CreateIndex
CREATE INDEX "comments_authorId_idx" ON "comments"("authorId");

-- CreateIndex
CREATE INDEX "posts_authorID_idx" ON "posts"("authorID");

-- AddForeignKey
ALTER TABLE "comments" ADD CONSTRAINT "comments_parentId_fkey" FOREIGN KEY ("parentId") REFERENCES "comments"("id") ON DELETE SET NULL ON UPDATE CASCADE;
