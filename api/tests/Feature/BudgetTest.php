<?php

namespace Tests\Feature;

use App\Models\Budget;
use App\Models\BudgetCategory;
use App\Models\User;
use Database\Seeders\BudgetSeeder;
use Database\Seeders\UserSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Illuminate\Support\Facades\DB;
use Tests\TestCase;

class BudgetTest extends TestCase
{

    protected function setUp(): void
    {
        parent::setUp();

        DB::delete("DELETE FROM transactions");
        DB::delete("DELETE FROM budgets");
        DB::delete("DELETE FROM savings");
        DB::delete("DELETE FROM balances");
        DB::delete("DELETE FROM bill_reminders");
        DB::delete("DELETE FROM users");
    }

    public function testCreateBudgetSuccess(): void
    {
        $this->seed(UserSeeder::class);

        $user = User::query()->where('username', 'kadita')->first();

        $this->post('/api/budgets', [
            "user_id" => $user->id,
            "title" => "Anggaran Transportasi November",
            "category" => "Transportasi",
            "limit" => 500000,
            "description" => "Anggaran transportasi bulan November",
            "date" => "2023-11-01",
        ])->assertStatus(201)
            ->assertJson([
                "title" => "Anggaran Transportasi November",
                "category" => "Transportasi",
                "spend_total" => 0,
                "limit" => 500000,
                "description" => "Anggaran transportasi bulan November",
                "date" => "2023-11-01",
            ]);
    }

    public function testCreateBudgetUserValidationFailed(): void
    {
        $this->post('/api/budgets', [
            "user_id" => "UNKNOWN-USER-ID",
            "title" => "Anggaran Keperluan Harian November",
            "category" => "Keperluan Harian",
            "limit" => 3000000,
            "description" => "Anggaran keperluan harian bulan November",
            "date" => "2023-11-01",
        ])->assertStatus(404)
            ->assertJson([
                "errors" => "user tidak ditemukan",
            ]);
    }

    public function testCreateBudgetRequestValidationFailed(): void
    {
        $this->post('/api/budgets', [])->assertStatus(400);
    }

    public function testGetUserBudgetSuccess(): void
    {
        $this->seed([UserSeeder::class, BudgetSeeder::class]);

        $user = User::query()->where('username', 'kadita')->first();

        $response = $this->get("/api/budgets/$user->id")
            ->assertStatus(200);

        $data = $response->json();

        $this->assertCount(3, $data);
    }

    public function testGetUserBudgetSuccessWithDateQueryParameter(): void
    {
        $this->seed([UserSeeder::class, BudgetSeeder::class]);

        $user = User::query()->where('username', 'kadita')->first();

        $response =  $this->get("/api/budgets/$user->id?date=2023-10-01")
            ->assertStatus(200);

        $data = $response->json();

        $this->assertCount(0, $data);

        $response =  $this->get("/api/budgets/$user->id?date=2023-11-01")
            ->assertStatus(200);

        $data = $response->json();

        $this->assertCount(3, $data);
    }

    public function testUpdateBudgetSuccess(): void
    {
        $this->seed([UserSeeder::class, BudgetSeeder::class]);

        $user = User::query()->where('username', 'kadita')->first();

        $budget = $user->budgets()->where('category', 'Hiburan')->first();

        $this->put("/api/budgets/$budget->id", [
            "title" => "Anggaran Entertainment November",
            "limit" => 500000,
            "description" => "Penghematan anggaran untuk entertaiment bulan November",
        ])->assertStatus(200)
            ->assertJson([
                "title" => "Anggaran Entertainment November",
                "category" => "Hiburan",
                "spend_total" => 0,
                "limit" => 500000,
                "description" => "Penghematan anggaran untuk entertaiment bulan November",
                "date" => "2023-11-01",
            ]);
    }

    public function testUpdateBudgetFailed(): void
    {
        $this->put("/api/budgets/UNKNOWN-BUDGET-ID", [])
            ->assertStatus(400);
    }

    public function testUpdateBudgetFailedBudgetNotFound(): void
    {
        $this->put("/api/budgets/UNKNOWN-BUDGET-ID", [
            "title" => "Anggaran Entertainment November",
            "limit" => 500000,
            "description" => "Penghematan anggaran untuk entertaiment",
        ])->assertStatus(404);
    }

    public function testDeleteBudgetSuccess(): void
    {
        $this->seed([UserSeeder::class, BudgetSeeder::class]);

        $user = User::query()->where('username', 'kadita')->first();

        $budget = $user->budgets()->where('category', 'Hiburan')->first();

        $this->delete("/api/budgets/$budget->id")
            ->assertStatus(200)
            ->assertJson([
                "message" => "data anggaran berhasil dihapus"
            ]);
    }

    public function testDeleteBudgetFailed(): void
    {
        $this->delete("/api/budgets/UNKNOWN-BUDGET-ID")
            ->assertStatus(404)
            ->assertJson([
                "errors" => "data anggaran tidak ditemukan"
            ]);
    }

    protected function tearDown(): void
    {
        DB::delete("DELETE FROM transactions");
        DB::delete("DELETE FROM budgets");
        DB::delete("DELETE FROM savings");
        DB::delete("DELETE FROM balances");
        DB::delete("DELETE FROM bill_reminders");
        DB::delete("DELETE FROM users");
    }
}
