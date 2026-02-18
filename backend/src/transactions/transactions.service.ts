import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { IssueBookDto, ReturnBookDto, RenewBookDto } from './dto/transaction.dto';

@Injectable()
export class TransactionsService {
  constructor(private prisma: PrismaService) {}

  async issue(dto: IssueBookDto) {
    const user = await this.prisma.user.findUnique({
      where: { id: dto.userId },
    });
    if (!user) throw new NotFoundException('User not found');

    const bookCopy = await this.prisma.bookCopy.findUnique({
      where: { id: dto.bookCopyId },
      include: { book: true },
    });
    if (!bookCopy) throw new NotFoundException('Book copy not found');

    if (bookCopy.status !== 'AVAILABLE') {
      throw new BadRequestException('Book copy is not available');
    }

    const dueDate = new Date();
    dueDate.setDate(dueDate.getDate() + 14);

    const transaction = await this.prisma.transaction.create({
      data: {
        userId: dto.userId,
        bookCopyId: dto.bookCopyId,
        dueDate,
        status: 'ISSUED',
      },
      include: {
        user: true,
        bookCopy: { include: { book: true } },
      },
    });

    await this.prisma.bookCopy.update({
      where: { id: dto.bookCopyId },
      data: { status: 'ISSUED' },
    });

    return transaction;
  }

  async return(dto: ReturnBookDto) {
    const transaction = await this.prisma.transaction.findUnique({
      where: { id: dto.transactionId },
      include: {
        user: true,
        bookCopy: { include: { book: true } },
      },
    });

    if (!transaction) throw new NotFoundException('Transaction not found');

    if (transaction.status === 'RETURNED') {
      throw new BadRequestException('Book already returned');
    }

    const returnDate = new Date();
    const overdueDays = Math.max(
      0,
      Math.floor((returnDate.getTime() - transaction.dueDate.getTime()) / (1000 * 60 * 60 * 24)),
    );
    const fine = overdueDays * 10;

    const updated = await this.prisma.transaction.update({
      where: { id: dto.transactionId },
      data: {
        returnDate,
        status: 'RETURNED',
      },
      include: {
        user: true,
        bookCopy: { include: { book: true } },
      },
    });

    await this.prisma.bookCopy.update({
      where: { id: transaction.bookCopyId },
      data: { status: 'AVAILABLE' },
    });

    return { ...updated, overdueDays, fine };
  }

  async renew(dto: RenewBookDto) {
    const transaction = await this.prisma.transaction.findUnique({
      where: { id: dto.transactionId },
      include: {
        user: true,
        bookCopy: { include: { book: true } },
      },
    });

    if (!transaction) throw new NotFoundException('Transaction not found');

    if (transaction.status !== 'ISSUED') {
      throw new BadRequestException('Only issued books can be renewed');
    }

    if (transaction.renewCount >= 1) {
      throw new BadRequestException('Maximum renewal limit reached');
    }

    const newDueDate = new Date(transaction.dueDate);
    newDueDate.setDate(newDueDate.getDate() + 7);

    return this.prisma.transaction.update({
      where: { id: dto.transactionId },
      data: {
        dueDate: newDueDate,
        renewCount: transaction.renewCount + 1,
      },
      include: {
        user: true,
        bookCopy: { include: { book: true } },
      },
    });
  }

  async findAll() {
    return this.prisma.transaction.findMany({
      include: {
        user: true,
        bookCopy: { include: { book: true } },
      },
    });
  }

  async findOverdue() {
    const now = new Date();
    const overdue = await this.prisma.transaction.findMany({
      where: {
        status: 'ISSUED',
        dueDate: { lt: now },
      },
      include: {
        user: true,
        bookCopy: { include: { book: true } },
      },
    });

    await this.prisma.transaction.updateMany({
      where: {
        status: 'ISSUED',
        dueDate: { lt: now },
      },
      data: { status: 'OVERDUE' },
    });

    return overdue;
  }

  async findActiveByUser(userId: string) {
    return this.prisma.transaction.findMany({
      where: {
        userId,
        status: { in: ['ISSUED', 'OVERDUE'] },
      },
      include: {
        bookCopy: { include: { book: true } },
      },
    });
  }

  async findOne(id: string) {
    const transaction = await this.prisma.transaction.findUnique({
      where: { id },
      include: {
        user: true,
        bookCopy: { include: { book: true } },
      },
    });

    if (!transaction) throw new NotFoundException('Transaction not found');
    return transaction;
  }
}
