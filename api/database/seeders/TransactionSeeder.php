<?php

namespace Database\Seeders;

use App\Models\Transaction;
use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Str;


class TransactionSeeder extends Seeder
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
                "category" => "Pendapatan",
                "amount" => 8000000,
                "date_time" => "2023-11-05 13:30:00",
                "description" => "Gajian Bulan November"
            ],
            [
                "id" => Str::uuid(),
                "user_id" => $userId,
                "category" => "Pengeluaran",
                "amount" => 20000,
                "date_time" => "2023-11-20 11:30:00",
                "description" => "Beli nasi padang"
            ],

        ];

        Transaction::insert($data);
    }
}
