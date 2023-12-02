<?php

namespace Tests\Feature;

use App\Models\Saving;
use App\Models\User;
use Database\Seeders\SavingSeeder;
use Database\Seeders\UserSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Illuminate\Support\Facades\DB;
use Tests\TestCase;

class SavingTest extends TestCase
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

    public function testGetSavingsSuccess(): void
    {
        $this->seed([UserSeeder::class, SavingSeeder::class]);

        $user = User::query()->where('username', 'kadita')->first();

        $userId = $user->id;

        $response = $this->get("/api/savings/$userId")
            ->assertStatus(200);

        $data = $response->json();

        $this->assertCount(2, $data);
    }

    public function testGetSavingsFailed(): void
    {
        $this->get("/api/savings/UNKNOWN-USER-ID")
            ->assertStatus(404)
            ->assertJson([
                "errors" => "user tidak ditemukan"
            ]);
    }

    public function testGetSavingsZeroItem(): void
    {
        $this->seed(UserSeeder::class);

        $user = User::query()->where('username', 'kadita')->first();

        $userId = $user->id;

        $response = $this->get("/api/savings/$userId")
            ->assertStatus(200);

        $data = $response->json();

        $this->assertCount(0, $data);
    }

    public function testCreateSavingSuccess(): void
    {
        $this->seed(UserSeeder::class);

        $user = User::query()->where('username', 'kadita')->first();

        $userId = $user->id;

        $response = $this->post('/api/savings', [
            "user_id" => $userId,
            "title" => "Tabungan Beli Meja Belajar",
            "goal_amount" => 500000,
            "description" => "Tabungan untuk beli meja belajar",
            "created_at" => "2023-11-01",
        ])->assertStatus(201)
            ->assertJson([
                "title" => "Tabungan Beli Meja Belajar",
                "current_balance" => 0,
                "goal_amount" => 500000,
                "description" => "Tabungan untuk beli meja belajar",
                "is_achieved" => false,
                "created_at" => "2023-11-01",
            ]);

        $data = $response->json();

        $savingId = $data['id'];

        $saving = Saving::find($savingId);

        $this->assertNotNull($saving);
        $this->assertEquals($userId, $saving->user_id);
        $this->assertEquals("Tabungan Beli Meja Belajar", $saving->title);
        $this->assertEquals(0, $saving->current_balance);
        $this->assertEquals(500000, $saving->goal_amount);
        $this->assertEquals("Tabungan untuk beli meja belajar", $saving->description);
        $this->assertEquals(false, $saving->is_achieved);
        $this->assertEquals("2023-11-01", $saving->created_at);
    }

    public function testCreateSavingFailed(): void
    {
        $this->post('/api/savings', [
            "user_id" => "UNKNOWN-USER-ID",
            "title" => "Tabungan Beli Meja Belajar",
            "goal_amount" => 500000,
            "description" => "Tabungan untuk beli meja belajar",
            "created_at" => "2023-11-01",
        ])->assertStatus(404)
            ->assertJson([
                "errors" => "user tidak ditemukan"
            ]);
    }

    public function testCreateSavingValidationFailed(): void
    {
        $this->post('/api/savings', [])->assertStatus(400);
    }

    public function testUpdateSavingSuccess(): void
    {
        $this->seed([UserSeeder::class, SavingSeeder::class]);

        $user = User::query()->where('username', 'kadita')->first();

        $saving = $user->savings->first();

        $response = $this->put("/api/savings/$saving->id", [
            "title" => "Tabungan Beli TWS JBL",
            "goal_amount" => 1500000,
            "description" => "Tabungan untuk beli TWS JBL, tidak jadi beli merk Sony",
        ])->assertStatus(200)
            ->assertJson([
                "title" => "Tabungan Beli TWS JBL",
                "current_balance" => 0,
                "goal_amount" => 1500000,
                "description" => "Tabungan untuk beli TWS JBL, tidak jadi beli merk Sony",
                "is_achieved" => false,
                "created_at" => "2023-11-01"
            ]);

        $data = $response->json();

        $savingId = $data['id'];

        $saving = Saving::query()->find($savingId);

        $this->assertNotNull($saving);
        $this->assertEquals($user->id, $saving->user_id);
        $this->assertEquals("Tabungan Beli TWS JBL", $saving->title);
        $this->assertEquals(0, $saving->current_balance);
        $this->assertEquals(1500000, $saving->goal_amount);
        $this->assertEquals("Tabungan untuk beli TWS JBL, tidak jadi beli merk Sony", $saving->description);
        $this->assertEquals(false, $saving->is_achieved);
        $this->assertEquals("2023-11-01", $saving->created_at);
    }

    public function testUpdateSavingFailed(): void
    {
        $this->put("/api/savings/UNKNOWN-SAVING-ID", [
            "title" => "Tabungan Beli TWS JBL",
            "goal_amount" => 1500000,
            "description" => "Tabungan untuk beli TWS JBL, tidak jadi beli merk Sony",
            "is_achieved" => false,
        ])->assertStatus(404)
            ->assertJson([
                "errors" => "tabungan tidak ditemukan"
            ]);
    }

    public function testUpdateSavingValidationFailed(): void
    {
        $this->seed([UserSeeder::class, SavingSeeder::class]);

        $user = User::query()->where('username', 'kadita')->first();

        $saving = $user->savings->first();

        $this->put("/api/savings/$saving->id", [])
            ->assertStatus(400);
    }

    public function testDeleteSavingSuccess(): void
    {
        $this->seed([UserSeeder::class, SavingSeeder::class]);

        $user = User::query()->where('username', 'kadita')->first();

        $saving = $user->savings->first();

        $this->delete("/api/savings/$saving->id")
            ->assertStatus(200)
            ->assertJson([
                "message" => "tabungan berhasil dihapus"
            ]);

        $saving = Saving::query()->find($saving->id);

        $this->assertNull($saving);
    }

    public function testDeleteSavingFailed(): void
    {
        $this->delete('/api/savings/UNKNOWN-SAVING-ID')
            ->assertStatus(404)
            ->assertJson([
                "errors" => "tabungan tidak ditemukan"
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
