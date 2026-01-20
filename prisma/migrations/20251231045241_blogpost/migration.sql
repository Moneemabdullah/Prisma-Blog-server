-- CreateEnum
CREATE TYPE "PostStatus" AS ENUM ('DRUFT', 'PUBLISHED', 'ARCHIVED');

-- CreateEnum
CREATE TYPE "CommentStatue" AS ENUM ('APPROVED', 'REJECTED');

-- CreateTable
CREATE TABLE "posts" (
    "id" TEXT NOT NULL,
    "title" VARCHAR(225) NOT NULL,
    "content" TEXT,
    "thumbnail" TEXT,
    "isFeatured" BOOLEAN NOT NULL DEFAULT false,
    "status" "PostStatus" NOT NULL DEFAULT 'PUBLISHED',
    "tags" TEXT[],
    "views" INTEGER NOT NULL DEFAULT 0,
    "AuthorID" TEXT NOT NULL,
    "CreatdeAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "UpdatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "posts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "comments" (
    "id" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "AuthorId" TEXT NOT NULL,
    "PostId" TEXT NOT NULL,
    "parentID" TEXT,
    "statue" "CommentStatue" NOT NULL DEFAULT 'APPROVED',
    "CreatdeAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "UpdatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "comments_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "posts_AuthorID_idx" ON "posts"("AuthorID");

-- CreateIndex
CREATE INDEX "comments_PostId_AuthorId_idx" ON "comments"("PostId", "AuthorId");

-- CreateIndex
CREATE INDEX "comments_AuthorId_idx" ON "comments"("AuthorId");

-- AddForeignKey
ALTER TABLE "comments" ADD CONSTRAINT "comments_PostId_fkey" FOREIGN KEY ("PostId") REFERENCES "posts"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "comments" ADD CONSTRAINT "comments_parentID_fkey" FOREIGN KEY ("parentID") REFERENCES "comments"("id") ON DELETE SET NULL ON UPDATE CASCADE;
