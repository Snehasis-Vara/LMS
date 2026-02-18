import { IsString, IsEnum, IsOptional } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';
import { BookCopyStatus } from '@prisma/client';

export class CreateBookCopyDto {
  @ApiProperty()
  @IsString()
  bookId: string;

  @ApiProperty({ enum: BookCopyStatus, required: false })
  @IsEnum(BookCopyStatus)
  @IsOptional()
  status?: BookCopyStatus;
}

export class UpdateBookCopyDto {
  @ApiProperty({ enum: BookCopyStatus, required: false })
  @IsEnum(BookCopyStatus)
  @IsOptional()
  status?: BookCopyStatus;
}
