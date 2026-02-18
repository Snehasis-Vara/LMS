import { IsString } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class IssueBookDto {
  @ApiProperty()
  @IsString()
  userId: string;

  @ApiProperty()
  @IsString()
  bookCopyId: string;
}

export class ReturnBookDto {
  @ApiProperty()
  @IsString()
  transactionId: string;
}

export class RenewBookDto {
  @ApiProperty()
  @IsString()
  transactionId: string;
}
