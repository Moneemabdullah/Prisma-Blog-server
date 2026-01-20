import { betterAuth } from "better-auth";
import { prismaAdapter } from "better-auth/adapters/prisma";
import { prisma } from "./prisma";
import nodemailer from "nodemailer";

const transporter = nodemailer.createTransport({
    host: "smtp.gmail.com",
    port: 465,
    secure: true, // Use true for port 465, false for port 587
    auth: {
        user: process.env.APP_USER || "",
        pass: process.env.APP_PASSWORD || "",
    },
});

export const auth = betterAuth({
    database: prismaAdapter(prisma, {
        provider: "postgresql",
    }),
    emailAndPassword: {
        enabled: true,
        autoSignIn: false,
        requireEmailVerification: true,
    },
    trustedOrigins: [process.env.BETTER_AUTH_URL ?? ""],
    user: {
        additionalFields: {
            role: {
                type: "string",
                defaultValue: "user",
            },
            phone: {
                type: "string",
                required: false,
            },
            status: {
                type: "string",
                defaultValue: "ACTIVE",
                required: false,
            },
        },
    },
    emailVerification: {
        sendOnSignInUp: true,
        autoSignInAfterVerification: true,
        sendVerificationEmail: async ({ user, url, token }, request) => {
            // Better Auth usually provides the full URL in the 'url' param,
            // but using your custom logic:

            const verificationLink = `${process.env.APP_URL}/verify-email?token=${token}`;

            const info = await transporter.sendMail({
                from: `"Prisma Auth" <${process.env.APP_USER}>`,
                to: user.email,
                subject: "Verify your email address",
                text: `Hello ${user.name}, please verify your email by clicking: ${verificationLink}`,
                html: `
        <div style="font-family: sans-serif; background-color: #f9f9f9; padding: 40px 0; width: 100%;">
            <table align="center" border="0" cellpadding="0" cellspacing="0" width="600" style="background-color: #ffffff; border-radius: 8px; border: 1px solid #e1e1e1;">
                <tr>
                    <td align="center" style="padding: 40px 0 20px 0;">
                        <h1 style="color: #333; margin: 0; font-size: 24px;">Confirm Your Email</h1>
                    </td>
                </tr>
                <tr>
                    <td style="padding: 0 40px 20px 40px; color: #555; line-height: 1.5;">
                        <p>Hi ${user.name || "there"},</p>
                        <p>Thanks for signing up! To get started, please click the button below to verify your email address.</p>
                    </td>
                </tr>
                <tr>
                    <td align="center" style="padding: 20px 0 40px 0;">
                        <a href="${verificationLink}" 
                           style="background-color: #007bff; color: #ffffff; padding: 12px 24px; text-decoration: none; border-radius: 5px; font-weight: bold; display: inline-block;">
                           Verify Email Address
                        </a>
                    </td>
                </tr>
                <tr>
                    <td style="padding: 0 40px 40px 40px; color: #999; font-size: 12px; line-height: 1.5;">
                        <p>If the button doesn't work, copy and paste this link into your browser:</p>
                        <p style="word-break: break-all;"><a href="${verificationLink}" style="color: #007bff;">${verificationLink}</a></p>
                        <hr style="border: 0; border-top: 1px solid #eee; margin: 20px 0;">
                        <p>If you didn't create an account, you can safely ignore this email.</p>
                    </td>
                </tr>
            </table>
        </div>
        `,
            });

            console.log("Message sent:", info.messageId);
            console.log("Verification email sent to:", user.email);
        },
    },
    socialProviders: {
        google: {
            prompt: "select_account consent",
            accessType: "offline",
            clientId: process.env.GOOGLE_CLIENT_ID as string,
            clientSecret: process.env.GOOGLE_CLIENT_SECRET as string,
        },
    },
});
