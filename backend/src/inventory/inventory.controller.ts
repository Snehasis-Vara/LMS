import { Controller, Get, Post, Body, Patch, Param, Delete, UseGuards, Query } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { ApiTags, ApiOperation, ApiBearerAuth, ApiQuery } from '@nestjs/swagger';
import { InventoryService } from './inventory.service';
import { CreateBookCopyDto, UpdateBookCopyDto } from './dto/inventory.dto';
import { Roles } from '../common/decorators/roles.decorator';
import { RolesGuard } from '../common/guards/roles.guard';
import { Role } from '@prisma/client';

@ApiTags('inventory')
@ApiBearerAuth()
@Controller('api/inventory')
@UseGuards(AuthGuard('jwt'), RolesGuard)
export class InventoryController {
  constructor(private inventoryService: InventoryService) {}

  @Post()
  @Roles(Role.ADMIN, Role.LIBRARIAN)
  @ApiOperation({ summary: 'Create book copy (ADMIN, LIBRARIAN)' })
  create(@Body() dto: CreateBookCopyDto) {
    return this.inventoryService.create(dto);
  }

  @Post('bulk/:bookId')
  @Roles(Role.ADMIN, Role.LIBRARIAN)
  @ApiOperation({ summary: 'Create multiple copies (ADMIN, LIBRARIAN)' })
  @ApiQuery({ name: 'count', type: Number })
  createBulk(@Param('bookId') bookId: string, @Query('count') count: string) {
    return this.inventoryService.createBulk(bookId, parseInt(count));
  }

  @Get()
  @ApiOperation({ summary: 'Get all book copies' })
  findAll() {
    return this.inventoryService.findAll();
  }

  @Get('summary')
  @ApiOperation({ summary: 'Get inventory summary' })
  getSummary() {
    return this.inventoryService.getSummary();
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get book copy by ID' })
  findOne(@Param('id') id: string) {
    return this.inventoryService.findOne(id);
  }

  @Patch(':id')
  @Roles(Role.ADMIN, Role.LIBRARIAN)
  @ApiOperation({ summary: 'Update book copy (ADMIN, LIBRARIAN)' })
  update(@Param('id') id: string, @Body() dto: UpdateBookCopyDto) {
    return this.inventoryService.update(id, dto);
  }

  @Delete(':id')
  @Roles(Role.ADMIN, Role.LIBRARIAN)
  @ApiOperation({ summary: 'Delete book copy (ADMIN, LIBRARIAN)' })
  remove(@Param('id') id: string) {
    return this.inventoryService.remove(id);
  }
}
