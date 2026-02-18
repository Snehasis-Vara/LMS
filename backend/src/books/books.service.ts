import { Injectable, NotFoundException, ConflictException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateBookDto, UpdateBookDto } from './dto/book.dto';

@Injectable()
export class BooksService {
  constructor(private prisma: PrismaService) {}

  async create(dto: CreateBookDto) {
    const existing = await this.prisma.book.findUnique({
      where: { isbn: dto.isbn },
    });

    if (existing) {
      throw new ConflictException('ISBN already exists');
    }

    return this.prisma.book.create({ data: dto });
  }

  async findAll() {
    return this.prisma.book.findMany({
      include: {
        copies: true,
      },
    });
  }

  async findOne(id: string) {
    const book = await this.prisma.book.findUnique({
      where: { id },
      include: {
        copies: true,
      },
    });

    if (!book) throw new NotFoundException('Book not found');
    return book;
  }

  async update(id: string, dto: UpdateBookDto) {
    await this.findOne(id);
    return this.prisma.book.update({
      where: { id },
      data: dto,
    });
  }

  async remove(id: string) {
    await this.findOne(id);
    await this.prisma.book.delete({ where: { id } });
    return { message: 'Book deleted successfully' };
  }
}
