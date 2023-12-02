<?php

namespace Tests\Feature;

use App\Models\Budget;
use App\Models\Saving;
use App\Models\Transaction;
use App\Models\TransactionType;
use App\Models\User;
use Database\Seeders\BalanceSeeder;
use Database\Seeders\BudgetSeeder;
use Database\Seeders\SavingSeeder;
use Database\Seeders\TransactionSeeder;
use Database\Seeders\TransactionTypeSeeder;
use Database\Seeders\UserSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Illuminate\Support\Facades\DB;
use Tests\TestCase;

class TransactionTest extends TestCase
{
    protected function setUp(): void
    {
        parent::setUp();

        $this->resetDBForTest();
    }

    public function testCreateNormalTransactionSuccess(): void
    {
        $this->seed([UserSeeder::class, BalanceSeeder::class]);

        $user = User::query()->where('username', 'kadita')->first();

        $this->post('/api/transactions', [
            "user_id" => $user->id,
            "category" => "Pengeluaran",
            "amount" => 20000,
            "date_time" => "2023-11-22 11:30:00",
            "description" => "Beli nasi padang"
        ])->assertStatus(201)
            ->assertJson([
                "saving_id" => null,
                "budget_id" => null,
                "category" => "Pengeluaran",
                "amount" => 20000,
                "date_time" => "2023-11-22 11:30:00",
                "description" => "Beli nasi padang"
            ]);
    }

    public function testCreateNormalTransactionFailed(): void
    {
        $this->post('/api/transactions', [])->assertStatus(400);
    }

    public function testCreateNormalTransactionUserValidationFailed(): void
    {
        $this->post('/api/transactions', [
            "user_id" => "UNKNOWN-USER-ID",
            "category" => "Pengeluaran",
            "amount" => 20000,
            "date_time" => "2023-11-22 11:30:00",
            "description" => "Beli nasi padang"
        ])->assertStatus(404)
            ->assertJson([
                "errors" => "user tidak ditemukan",
            ]);
    }

    public function testGetNormalTransactionSuccess(): void
    {
        $this->seed([UserSeeder::class, TransactionSeeder::class]);

        $user = User::query()->where('username', 'kadita')->first();

        $response = $this->get("/api/transactions/user/$user->id")
            ->assertStatus(200);

        $this->assertCount(2, $response->json());
    }

    public function testGetNormalTransactionFailed(): void
    {
        $this->get("/api/transactions/user/UNKNOWN-USER-ID")
            ->assertStatus(404)
            ->assertJson([
                "errors" => "user tidak ditemukan",
            ]);
    }

    public function testUpdateNormalTransactionSuccess(): void
    {
        $this->seed([UserSeeder::class, BalanceSeeder::class, TransactionSeeder::class]);

        $transaction = Transaction::query()->where('amount', 20000)->where('description', 'Beli nasi padang')->first();

        $this->put("/api/transactions/$transaction->id", [
            "amount" => 16000,
            "description" => "Beli nasi padang tidak pakai perkedel"
        ])->assertStatus(200)
            ->assertJson([
                "saving_id" => null,
                "budget_id" => null,
                "category" => "Pengeluaran",
                "amount" => 16000,
                "date_time" => "2023-11-20 11:30:00",
                "description" => "Beli nasi padang tidak pakai perkedel"
            ]);

        $updatedTransaction = Transaction::query()->find($transaction->id);

        $this->assertNotNull($updatedTransaction);
        $this->assertEquals($transaction->id, $updatedTransaction->id);
        $this->assertEquals($transaction->user_id, $updatedTransaction->user_id);
        $this->assertEquals($transaction->saving_id, $updatedTransaction->saving_id);
        $this->assertEquals($transaction->budget_id, $updatedTransaction->budget_id);
        $this->assertEquals($transaction->category, $updatedTransaction->category);
        $this->assertNotEquals($transaction->amount, $updatedTransaction->amount);
        $this->assertEquals($transaction->date_time, $updatedTransaction->date_time);
        $this->assertNotEquals($transaction->description, $updatedTransaction->description);
    }

    public function testUpdateNormalTransactionFailed(): void
    {
        $this->put("/api/transactions/UNKNOWN-TRANSACTION-ID", [
            "amount" => 16000,
            "description" => "Beli nasi padang tidak pakai perkedel"
        ])->assertStatus(404)
            ->assertJson([
                "errors" => "transaksi tidak ditemukan",
            ]);
    }

    public function testUpdateNormalTransactionValidationFailed(): void
    {
        $this->seed([UserSeeder::class, TransactionSeeder::class]);

        $transaction = Transaction::query()->where('amount', 20000)->where('description', 'Beli nasi padang')->first();

        $this->put("/api/transactions/$transaction->id", [])
            ->assertStatus(400);
    }

    public function testDeleteNormalTransactionSuccess(): void
    {
        $this->seed([UserSeeder::class, BalanceSeeder::class, TransactionSeeder::class]);

        $transaction = Transaction::query()->where('amount', 20000)->where('description', 'Beli nasi padang')->first();

        $this->delete("/api/transactions/$transaction->id")
            ->assertStatus(200)
            ->assertJson([
                "message" => "transaksi berhasil dihapus"
            ]);
    }

    public function testDeleteNormalTransactionFailed(): void
    {
        $this->delete("/api/transactions/UNKNOWN-TRANSACTION-ID")
            ->assertStatus(404)
            ->assertJson([
                "errors" => "transaksi tidak ditemukan"
            ]);
    }

    public function testCreateBudgetTransactionSuccess(): void
    {
        $this->seed([UserSeeder::class, BalanceSeeder::class, BudgetSeeder::class,]);

        $user = User::query()->where('username', 'kadita')->first();

        $vehicleBudget = $user->budgets()->where('category', 'Kendaraan')->first();

        $response = $this->post('/api/transactions', [
            "user_id" => $user->id,
            "budget_id" => $vehicleBudget->id,
            "category" => "Pengeluaran",
            "amount" => 80000,
            "date_time" => "2023-11-05 11:30:00",
            "description" => "Pengeluaran anggaran kendaraan untuk ganti oli motor"
        ])->assertStatus(201)
            ->assertJson([
                "saving_id" => null,
                "budget_id" => $vehicleBudget->id,
                "category" => "Pengeluaran",
                "amount" => 80000,
                "date_time" => "2023-11-05 11:30:00",
                "description" => "Pengeluaran anggaran kendaraan untuk ganti oli motor"
            ]);

        $data = $response->json();
        $newBudgetTransactionId = $data['id'];

        $updatedUserBudget = Budget::query()->find($vehicleBudget->id);
        $this->assertEquals(80000, $updatedUserBudget->spend_total);

        $newBudgetTransaction = Transaction::query()->find($newBudgetTransactionId);
        $this->assertNotNull($newBudgetTransaction);

        $response = $this->post('/api/transactions', [
            "user_id" => $user->id,
            "budget_id" => $vehicleBudget->id,
            "category" => "Pengeluaran",
            "amount" => 50000,
            "date_time" => "2023-11-05 11:30:00",
            "description" => "Pengeluaran anggaran kendaraan untuk beli spion baru"
        ])->assertStatus(201)
            ->assertJson([
                "saving_id" => null,
                "budget_id" => $vehicleBudget->id,
                "category" => "Pengeluaran",
                "amount" => 50000,
                "date_time" => "2023-11-05 11:30:00",
                "description" => "Pengeluaran anggaran kendaraan untuk beli spion baru"
            ]);

        $data = $response->json();
        $newBudgetTransactionId = $data['id'];

        $updatedUserBudget = Budget::query()->find($vehicleBudget->id);
        $this->assertEquals(130000, $updatedUserBudget->spend_total);

        $newBudgetTransaction = Transaction::query()->find($newBudgetTransactionId);
        $this->assertNotNull($newBudgetTransaction);
    }

    public function testCreateBudgetTransactionFailed(): void
    {
        $this->seed([UserSeeder::class, BalanceSeeder::class, BudgetSeeder::class,]);

        $user = User::query()->where('username', 'kadita')->first();

        $vehicleBudget = $user->budgets()->where('category', 'Kendaraan')->first();

        $this->post('/api/transactions', [
            "user_id" => "UNKNOWN-USER-ID",
            "budget_id" => $vehicleBudget->id,
            "category" => "Pengeluaran",
            "amount" => 80000,
            "date_time" => "2023-11-05 11:30:00",
            "description" => "Pengeluaran anggaran kendaraan untuk ganti oli motor"
        ])->assertStatus(404)
            ->assertJson([
                "errors" => "user tidak ditemukan"
            ]);

        $this->post('/api/transactions', [
            "user_id" => $user->id,
            "budget_id" => "UNKNOWN-BUDGET-ID",
            "category" => "Pengeluaran",
            "amount" => 80000,
            "date_time" => "2023-11-05 11:30:00",
            "description" => "Pengeluaran anggaran kendaraan untuk ganti oli motor"
        ])->assertStatus(500);
    }

    public function testGetBudgetTransactionSuccess(): void
    {
        $this->testCreateBudgetTransactionSuccess();

        $user = User::query()->where('username', 'kadita')->first();

        $kaditaVehicleBudget = $user->budgets()->where('category', 'Kendaraan')->first();

        $response = $this->get("/api/transactions/budget/$kaditaVehicleBudget->id")
            ->assertStatus(200);

        $this->assertCount(2, $response->json());

        $kaditaEntertainBudget = $user->budgets()->where('category', 'Hiburan')->first();

        $response = $this->get("/api/transactions/budget/$kaditaEntertainBudget->id")
            ->assertStatus(200);

        $this->assertCount(0, $response->json());
    }

    public function testGetBudgetTransactionFailed(): void
    {
        $this->get("/api/transactions/budget/UNKNOWN-BUDGET-ID")
            ->assertStatus(404)
            ->assertJson([
                "errors" => "anggaran tidak ditemukan"
            ]);
    }

    public function testCreateSavingTransactionSuccess(): void
    {
        $this->seed([UserSeeder::class, BalanceSeeder::class, SavingSeeder::class,]);

        $user = User::query()->where('username', 'kadita')->first();

        $kaditaTableSaving = $user->savings()->where('goal_amount', 500000)->first();

        $response = $this->post('/api/transactions', [
            "user_id" => $user->id,
            "saving_id" => $kaditaTableSaving->id,
            "category" => "Tabungan",
            "amount" => 50000,
            "date_time" => "2023-11-05 11:30:00",
            "description" => "Tambah tabungan untuk beli meja belajar."
        ])->assertStatus(201)
            ->assertJson([
                "saving_id" => $kaditaTableSaving->id,
                "budget_id" => null,
                "category" => "Tabungan",
                "amount" => 50000,
                "date_time" => "2023-11-05 11:30:00",
                "description" => "Tambah tabungan untuk beli meja belajar."
            ]);

        $data = $response->json();
        $newSavingTransactionId = $data['id'];

        $updatedUserSaving = Saving::query()->find($kaditaTableSaving->id);
        $this->assertEquals(50000, $updatedUserSaving->current_balance);

        $newSavingTransaction = Transaction::query()->find($newSavingTransactionId);
        $this->assertNotNull($newSavingTransaction);

        $response = $this->post('/api/transactions', [
            "user_id" => $user->id,
            "saving_id" => $kaditaTableSaving->id,
            "category" => "Tabungan",
            "amount" => 70000,
            "date_time" => "2023-11-05 11:30:00",
            "description" => "Tambah tabungan untuk beli meja belajar."
        ])->assertStatus(201)
            ->assertJson([
                "saving_id" => $kaditaTableSaving->id,
                "budget_id" => null,
                "category" => "Tabungan",
                "amount" => 70000,
                "date_time" => "2023-11-05 11:30:00",
                "description" => "Tambah tabungan untuk beli meja belajar."
            ]);

        $data = $response->json();
        $newSavingTransactionId = $data['id'];

        $updatedUserSaving = Saving::query()->find($kaditaTableSaving->id);
        $this->assertEquals(120000, $updatedUserSaving->current_balance);

        $newSavingTransaction = Transaction::query()->find($newSavingTransactionId);
        $this->assertNotNull($newSavingTransaction);
    }

    public function testCreateSavingTransactionFailed(): void
    {
        $this->seed([UserSeeder::class, BalanceSeeder::class, SavingSeeder::class,]);

        $user = User::query()->where('username', 'kadita')->first();

        $kaditaTableSaving = $user->savings()->where('goal_amount', 500000)->first();

        $this->post('/api/transactions', [
            "user_id" => "UNKNOWN-USER-ID",
            "saving_id" => $kaditaTableSaving->id,
            "category" => "Tabungan",
            "amount" => 50000,
            "date_time" => "2023-11-05 11:30:00",
            "description" => "Tambah tabungan untuk beli meja belajar."
        ])->assertStatus(404)
            ->assertJson([
                "errors" => "user tidak ditemukan"
            ]);

        $this->post('/api/transactions', [
            "user_id" => $user->id,
            "saving_id" => null,
            "category" => "Tabungan",
            "amount" => 50000,
            "date_time" => "2023-11-05 11:30:00",
            "description" => "Tambah tabungan untuk beli meja belajar."
        ])->assertStatus(400)
            ->assertJson([
                "errors" => "saving_id tidak boleh kosong jika kategori transaksi adalah tabungan"
            ]);
    }

    public function testGetSavingTransactionSuccess(): void
    {
        $this->testCreateSavingTransactionSuccess();

        $user = User::query()->where('username', 'kadita')->first();

        $kaditaTableSaving = $user->savings()->where('goal_amount', 500000)->first();

        $response = $this->get("/api/transactions/saving/$kaditaTableSaving->id")
            ->assertStatus(200);

        $this->assertCount(2, $response->json());

        $kaditaTWSSaving = $user->savings()->where('goal_amount', 1000000)->first();

        $response = $this->get("/api/transactions/saving/$kaditaTWSSaving->id")
            ->assertStatus(200);

        $this->assertCount(0, $response->json());
    }

    public function testDeleteSavingTransactionFailed(): void
    {
        $this->get("/api/transactions/saving/UNKNOWN-SAVING-ID")
            ->assertStatus(404)
            ->assertJson([
                "errors" => "tabungan tidak ditemukan"
            ]);
    }

    private function resetDBForTest(): void
    {
        DB::delete("DELETE FROM transactions");
        DB::delete("DELETE FROM budgets");
        DB::delete("DELETE FROM savings");
        DB::delete("DELETE FROM balances");
        DB::delete("DELETE FROM bill_reminders");
        DB::delete("DELETE FROM users");
    }

    protected function tearDown(): void
    {
        $this->resetDBForTest();
    }
}
