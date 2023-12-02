<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('transactions', function (Blueprint $table) {
            $table->uuid('id')->primary()->nullable(false);
            $table->enum('category', ['pendapatan', 'pengeluaran'])->nullable(false);
            $table->integer('amount')->nullable(false)->default(0);
            $table->dateTime('date_time')->nullable(false)->useCurrent();
            $table->text('description')->nullable(false);
            $table->foreignUuid('user_id')->nullable(false)->references('id')->on('users');
            $table->foreignUuid('saving_id')->nullable(true)->references('id')->on('savings');
            $table->foreignUuid('budget_id')->nullable(true)->references('id')->on('budgets');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('transactions');
    }
};
