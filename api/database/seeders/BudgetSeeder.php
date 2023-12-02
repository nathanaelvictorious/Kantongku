<?php

namespace Database\Seeders;

use App\Models\Budget;
use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Support\Str;
use Illuminate\Database\Seeder;

class BudgetSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $user = User::where('username', 'kadita')->first();

        $budgets = [
            [
                "id" => Str::uuid(),
                "user_id" => $user->id,
                "title" => "Anggaran Keperluan Harian November",
                "category" => "Keperluan Harian",
                "limit" => 3000000,
                "description" => "Keperluan harian bulan November",
                "date" => "2023-11-01",
            ],
            [
                "id" => Str::uuid(),
                "user_id" => $user->id,
                "title" => "Anggaran Entertainment November",
                "category" => "Hiburan",
                "limit" => 1000000,
                "description" => "Keperluan entertainment (Games, Nonton Bioskop, Spotify, Dll) bulan November",
                "date" => "2023-11-01",
            ],
            [
                "id" => Str::uuid(),
                "user_id" => $user->id,
                "title" => "Anggaran Kendaraan November",
                "category" => "Kendaraan",
                "limit" => 300000,
                "description" => "Keperluan service motor bulan November",
                "date" => "2023-11-01",
            ],
        ];

        Budget::insert($budgets);
    }
}
