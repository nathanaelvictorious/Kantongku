<?php

namespace Tests\Feature;

use App\Models\BillReminder;
use App\Models\User;
use Database\Seeders\UserSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Illuminate\Support\Facades\DB;
use Illuminate\Testing\TestResponse;
use Tests\TestCase;

class BillReminderTest extends TestCase
{
    protected function setUp(): void
    {
        parent::setUp();

        DB::delete("DELETE FROM transactions");
        DB::delete("DELETE FROM savings");
        DB::delete("DELETE FROM budgets");
        DB::delete("DELETE FROM balances");
        DB::delete("DELETE FROM bill_reminders");
        DB::delete("DELETE FROM users");
    }

    public function testCreateBillReminderSuccess(): void
    {
        $this->seed(UserSeeder::class);

        $user = User::where("username", "kadita")->first();

        $response = $this->post('/api/bill-reminders', [
            "user_id" => $user->id,
            "name" => "Beli Iphone 15 Pro Max",
            "amount" => 20000000,
            "due_date" => "2023-11-18",
            "description" => "Untuk kebutuhan konten social media.",
        ])->assertStatus(201)
            ->assertJson([
                "name" => "Beli Iphone 15 Pro Max",
                "amount" => 20000000,
                "due_date" => "2023-11-18",
                "description" => "Untuk kebutuhan konten social media.",
            ]);

        $responseData = $response->json();
        $createdBillReminderId = $responseData['id'];

        $createdBillReminder = BillReminder::find($createdBillReminderId);

        $this->assertEquals($createdBillReminderId, $createdBillReminder->id);
        $this->assertEquals("Beli Iphone 15 Pro Max", $createdBillReminder->name);
        $this->assertEquals(20000000, $createdBillReminder->amount);
        $this->assertEquals("2023-11-18", $createdBillReminder->due_date);
        $this->assertEquals("Untuk kebutuhan konten social media.", $createdBillReminder->description);

        $this->post('/api/bill-reminders', [
            "user_id" => $user->id,
            "name" => "Beli Iphone 16 Pro Max",
            "amount" => 20000000,
            "due_date" => "2023-11-18",
            "description" => "Untuk kebutuhan konten social media.",
        ])->assertStatus(201);

        $this->post('/api/bill-reminders', [
            "user_id" => $user->id,
            "name" => "Beli Iphone 17 Pro Max",
            "amount" => 20000000,
            "due_date" => "2023-11-18",
            "description" => "Untuk kebutuhan konten social media.",
        ])->assertStatus(201);

        $this->post('/api/bill-reminders', [
            "user_id" => $user->id,
            "name" => "Beli Iphone 18 Pro Max",
            "amount" => 20000000,
            "due_date" => "2023-11-18",
            "description" => "Untuk kebutuhan konten social media.",
        ])->assertStatus(201);

        $this->post('/api/bill-reminders', [
            "user_id" => $user->id,
            "name" => "Beli Iphone 19 Pro Max",
            "amount" => 20000000,
            "due_date" => "2023-11-18",
            "description" => "Untuk kebutuhan konten social media.",
        ])->assertStatus(201);
    }

    public function testCreateBillReminderFailed(): void
    {
        $this->post('/api/bill-reminders', [
            "user_id" => "UNKNOWN",
            "name" => "Beli Iphone 15 Pro Max",
            "amount" => 20000000,
            "due_date" => "2023-11-18",
            "description" => "Untuk kebutuhan konten social media.",
        ])->assertStatus(404);
    }

    public function testCreateBillReminderValidationFailed(): void
    {
        $this->post('/api/bill-reminders', [
            "user_id" => "",
            "name" => "",
            "amount" => 20000000,
            "due_date" => "2023-11-18",
            "description" => "Untuk kebutuhan konten social media.",
        ])->assertStatus(400);
    }

    public function testGetUserBillRemindersSuccess(): void
    {
        $this->testCreateBillReminderSuccess();

        $user = User::where("username", "kadita")->first();

        $response = $this->get("/api/bill-reminders/{$user->id}")
            ->assertStatus(200);

        $data = $response->json();

        $this->assertCount(5, $data);
    }

    public function testGetUserBillRemindersFailed(): void
    {
        $this->get("/api/bill-reminders/UNKNOWN-USER-ID")
            ->assertStatus(404);
    }

    public function testUpdateBillReminderSuccess(): void
    {
        $this->testCreateBillReminderSuccess();

        $user = User::where("username", "kadita")->first();

        $response = $this->get("/api/bill-reminders/{$user->id}")
            ->assertStatus(200);

        $data = $response->json();

        $firstBillReminderId = $data[0]['id'];

        $response = $this->put("/api/bill-reminders/$firstBillReminderId", [
            "name" => "Beli Laptop ASUS ROG",
            "amount" => 15000000,
            "due_date" => "2023-12-01",
            "description" => "Gak jadi beli ifong, beli laptop gaming aja",
            "is_paid_off" => true,
        ])->assertStatus(200)
            ->assertJson([
                "name" => "Beli Laptop ASUS ROG",
                "amount" => 15000000,
                "due_date" => "2023-12-01",
                "description" => "Gak jadi beli ifong, beli laptop gaming aja",
                "is_paid_off" => true,
            ]);

        $responseData = $response->json();
        $updatedBillReminderId = $responseData['id'];

        $updatedBillReminder = BillReminder::find($updatedBillReminderId);

        $this->assertEquals($updatedBillReminderId, $updatedBillReminder->id);
        $this->assertEquals("Beli Laptop ASUS ROG", $updatedBillReminder->name);
        $this->assertEquals(15000000, $updatedBillReminder->amount);
        $this->assertEquals("2023-12-01", $updatedBillReminder->due_date);
        $this->assertEquals("Gak jadi beli ifong, beli laptop gaming aja", $updatedBillReminder->description);
        $this->assertEquals(true, $updatedBillReminder->is_paid_off);
    }

    public function testUpdateBillReminderFailed(): void
    {
        $this->put("/api/bill-reminders/UNKNOWN-BILL-ID", [
            "name" => "asdad",
            "amount" => "asdasd",
            "due_date" => "2023-12-01",
            "description" => "Gak jadi beli ifong, beli laptop gaming aja",
            "is_paid_off" => true,
        ])->assertStatus(404);
    }

    public function testUpdateBillReminderValidationFailed(): void
    {
        $this->put("/api/bill-reminders/KNOWN-BILL-ID", [
            "name" => "",
            "amount" => "",
            "due_date" => "",
            "description" => "",
            "is_paid_off" => "",
        ])->assertStatus(400);
    }

    public function testDeleteBillReminderSuccess(): void
    {
        $response = $this->insertOneBillReminder();

        $data = $response->json();
        $billReminderId = $data["id"];

        $this->delete("/api/bill-reminders/$billReminderId")
            ->assertStatus(200)->assertJson([
                "message" => "data tagihan berhasil dihapus"
            ]);
    }

    public function testDeleteBillReminderFailed(): void
    {
        $this->delete("/api/bill-reminders/UNKNOWN-BILL-ID")
            ->assertStatus(404)->assertJson([
                "errors" => "data tagihan tidak ditemukan"
            ]);
    }

    private function insertOneBillReminder(): TestResponse
    {
        $this->seed(UserSeeder::class);

        $user = User::where("username", "kadita")->first();

        return  $this->post('/api/bill-reminders', [
            "user_id" => $user->id,
            "name" => "Beli Iphone 15 Pro Max",
            "amount" => 20000000,
            "due_date" => "2023-11-18",
            "description" => "Untuk kebutuhan konten social media.",
        ]);
    }

    protected function tearDown(): void
    {
        DB::delete("DELETE FROM transactions");
        DB::delete("DELETE FROM savings");
        DB::delete("DELETE FROM budgets");
        DB::delete("DELETE FROM balances");
        DB::delete("DELETE FROM bill_reminders");
        DB::delete("DELETE FROM users");
    }
}
