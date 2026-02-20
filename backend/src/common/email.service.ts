import { Injectable, Logger } from '@nestjs/common';
import { Resend } from 'resend';

@Injectable()
export class EmailService {
  private resend: Resend;
  private readonly logger = new Logger(EmailService.name);

  constructor() {
    const apiKey = process.env.RESEND_API_KEY;

    if (!apiKey || apiKey === 'your-resend-api-key') {
      this.logger.warn('⚠️  Resend API key not configured. Email sending will be simulated.');
      this.resend = null;
    } else {
      this.resend = new Resend(apiKey);
      this.logger.log('✅ Resend email service initialized');
    }
  }

  async sendOTP(email: string, otp: string) {
    this.logger.log(`📧 Sending OTP to: ${email}`);
    this.logger.log(`🔢 OTP: ${otp}`);
    
    if (!this.resend) {
      this.logger.log(`[SIMULATED] OTP for ${email}: ${otp}`);
      this.logger.warn('Configure RESEND_API_KEY in .env to enable real emails');
      return;
    }

    try {
      const { data, error } = await this.resend.emails.send({
        from: process.env.RESEND_FROM_EMAIL || 'Library Management <onboarding@resend.dev>',
        to: [email],
        subject: 'Password Reset OTP - Library Management System',
        html: `
          <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
            <h2 style="color: #4F46E5;">Password Reset Request</h2>
            <p>You have requested to reset your password.</p>
            <p>Your OTP code is:</p>
            <div style="background-color: #F3F4F6; padding: 20px; text-align: center; font-size: 32px; font-weight: bold; letter-spacing: 5px; margin: 20px 0;">
              ${otp}
            </div>
            <p style="color: #EF4444; font-weight: bold;">This OTP will expire in 5 minutes.</p>
            <p>If you did not request this, please ignore this email.</p>
            <hr style="margin: 30px 0; border: none; border-top: 1px solid #E5E7EB;">
            <p style="color: #6B7280; font-size: 12px;">Library Management System</p>
          </div>
        `,
      });

      if (error) {
        throw new Error(error.message);
      }

      this.logger.log(`✅ Email sent successfully via Resend (ID: ${data.id})`);
    } catch (error) {
      this.logger.error(`❌ Failed to send email: ${error.message}`);
      this.logger.log(`[FALLBACK] OTP for ${email}: ${otp}`);
      // Don't throw error - OTP is still saved in database and logged
    }
  }
}
