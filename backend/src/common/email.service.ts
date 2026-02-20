import { Injectable, Logger } from '@nestjs/common';
import * as nodemailer from 'nodemailer';

@Injectable()
export class EmailService {
  private transporter;
  private readonly logger = new Logger(EmailService.name);

  constructor() {
    const smtpUser = process.env.SMTP_USER;
    const smtpPass = process.env.SMTP_PASS;

    if (!smtpUser || !smtpPass || smtpUser === 'your-email@gmail.com') {
      this.logger.warn('SMTP credentials not configured. Email sending will be simulated.');
      this.transporter = null;
    } else {
      this.transporter = nodemailer.createTransport({
        host: process.env.SMTP_HOST || 'smtp.gmail.com',
        port: parseInt(process.env.SMTP_PORT) || 587,
        secure: false,
        auth: {
          user: smtpUser,
          pass: smtpPass,
        },
      });
    }
  }

  async sendOTP(email: string, otp: string) {
    this.logger.log(`📧 Attempting to send OTP to: ${email}`);
    this.logger.log(`🔢 OTP Generated: ${otp}`);
    
    if (!this.transporter) {
      this.logger.log(`[SIMULATED EMAIL] OTP for ${email}: ${otp}`);
      this.logger.warn('To enable real email sending, configure SMTP credentials in .env file');
      this.logger.log('✅ OTP saved in DB (simulated email mode)');
      return;
    }

    try {
      this.logger.log('🔌 Connecting to Gmail SMTP...');
      this.logger.log(`📡 SMTP Host: ${process.env.SMTP_HOST || 'smtp.gmail.com'}`);
      this.logger.log(`🔌 SMTP Port: ${process.env.SMTP_PORT || '587'}`);
      this.logger.log(`👤 SMTP User: ${process.env.SMTP_USER}`);
      
      await this.transporter.sendMail({
        from: process.env.SMTP_FROM || process.env.SMTP_USER,
        to: email,
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
      
      this.logger.log(`✅ SMTP connected successfully`);
      this.logger.log(`✅ Email sent successfully to: ${email}`);
    } catch (error) {
      this.logger.error(`❌ Failed to send email to ${email}:`, error.message);
      this.logger.log(`[FALLBACK] OTP for ${email}: ${otp}`);
      this.logger.warn('Email sending failed, but OTP is saved in database');
    }
  }
}
