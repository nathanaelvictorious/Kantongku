<?php

namespace Database\Seeders;

use App\Models\Saving;
use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Str;

class SavingSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $user = User::query()->where('username', 'kadita')->first();

        $userId = $user->id;

        $data = [
            [
                "id" => Str::uuid(),
                "user_id" => $userId,
                "title" => "Tabungan Beli Meja Belajar",
                "goal_amount" => 500000,
                "description" => "Tabungan untuk beli meja belajar",
                "created_at" => "2023-11-01",
            ],
            [
                "id" => Str::uuid(),
                "user_id" => $userId,
                "title" => "Tabungan Beli TWS Sony",
                "goal_amount" => 1000000,
                "description" => "Tabungan untuk beli TWS Sony",
                "created_at" => "2023-11-01",
            ],
        ];

        Saving::insert($data);
    }
}
