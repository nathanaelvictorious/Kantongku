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
        Schema::create('bill_reminders', function (Blueprint $table) {
            $table->uuid('id')->primary()->nullable(false);
            $table->string('name', 100)->nullable(false);
            $table->integer('amount')->nullable(false);
            $table->date('due_date')->nullable(false);
            $table->text('description')->nullable(true);
            $table->foreignUuid('user_id')->references('id')->on('users');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('bill_reminders');
    }
};
