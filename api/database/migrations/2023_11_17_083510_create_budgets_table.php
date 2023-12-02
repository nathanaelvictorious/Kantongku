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
        Schema::create('budgets', function (Blueprint $table) {
            $table->uuid('id')->primary()->nullable(false);
            $table->integer('spend_total')->nullable(false)->default(0);
            $table->integer('limit')->nullable(false)->default(0);
            $table->text('description')->nullable(false);
            $table->dateTime('date_time')->nullable(false)->useCurrent();
            $table->foreignUuid('user_id')->references('id')->on('users');
            $table->foreignUuid('budget_category_id')->references('id')->on('budget_categories');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('budgets');
    }
};
