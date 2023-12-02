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
        Schema::table('transactions', function (Blueprint $table) {
            $table->dropConstrainedForeignId('saving_id');
            $table->dropConstrainedForeignId('budget_id');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('transactions', function (Blueprint $table) {
            $table->foreignUuid('saving_id')->nullable(true)->references('id')->on('savings');
            $table->foreignUuid('budget_id')->nullable(true)->references('id')->on('budgets');
        });
    }
};
