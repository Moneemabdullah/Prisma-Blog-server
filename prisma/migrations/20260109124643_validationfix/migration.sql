/*
  Warnings:

  - You are about to drop the column `CreatdeAt` on the `posts` table. All the data in the column will be lost.
  - You are about to drop the column `UpdatedAt` on the `posts` table. All the data in the column will be lost.
  - Added the required column `updatedAt` to the `posts` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "posts" DROP COLUMN "CreatdeAt",
DROP COLUMN "UpdatedAt",
ADD COLUMN     "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "updatedAt" TIMESTAMP(3) NOT NULL,
ALTER COLUMN "AuthorID" DROP NOT NULL;
