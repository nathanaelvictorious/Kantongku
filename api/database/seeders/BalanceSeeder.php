<?php

namespace Database\Seeders;

use App\Models\Balance;
use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Str;

class BalanceSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $user = User::query()->where('username', 'kadita')->first();

        $data = [
            "id" => Str::uuid(),
            "user_id" => $user->id,
            "balance" => 0,
        ];

        Balance::create($data);
    }
}
