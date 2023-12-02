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
        Schema::create('savings', function (Blueprint $table) {
            $table->uuid('id')->primary()->nullable(false);
            $table->text('description')->nullable(false);
            $table->integer('current_balance')->nullable(false);
            $table->integer('goal_amount')->nullable(false);
            $table->foreignUuid('user_id')->references('id')->on('users');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('savings');
    }
};
