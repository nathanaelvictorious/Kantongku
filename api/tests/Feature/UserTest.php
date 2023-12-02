<?php

namespace Tests\Feature;

use App\Models\User;
use Database\Seeders\UserSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Illuminate\Support\Facades\DB;
use Tests\TestCase;

class UserTest extends TestCase
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

    public function testRegisterSuccess(): void
    {
        $this->post('/api/users', [
            "username" => "kadita",
            "name" => "Kadita",
            "password" => "123456",
            "email" => "kadita@example.com",
        ])->assertStatus(201)
            ->assertJson([
                "username" => "kadita",
                "name" => "Kadita",
                "email" => "kadita@example.com",
            ]);
    }

    public function testRegisterFailed(): void
    {
        $this->post('/api/users', [
            "username" => "",
            "name" => "",
            "password" => "",
            "email" => "",
        ])->assertStatus(400);
    }

    public function testRegisterUserAlreadyExist(): void
    {
        $this->testRegisterSuccess();
        $this->post('/api/users', [
            "username" => "kadita",
            "name" => "Kadita",
            "password" => "123456",
            "email" => "kadita@example.com",
        ])->assertStatus(400);
    }

    public function testLoginSuccess(): void
    {
        $this->seed(UserSeeder::class);

        $this->post('/api/users/login', [
            "username" => "kadita",
            "password" => "123456",
        ])->assertStatus(200)
            ->assertJson([
                "username" => "kadita",
                "name" => "Kadita",
                "email" => "kadita@example.com"
            ]);
    }

    public function testLoginValidationFailed(): void
    {
        $this->post('/api/users/login', [
            "username" => "",
            "password" => "",
        ])->assertStatus(400);
    }

    public function testLoginFailed(): void
    {
        $this->seed(UserSeeder::class);

        $this->post('/api/users/login', [
            "username" => "kadita",
            "password" => "salah",
        ])->assertStatus(401);
    }

    public function testGetUserSuccess(): void
    {
        $this->seed(UserSeeder::class);

        $userFromDb = User::query()->where('username', 'kadita')->first();

        $this->get("/api/users/$userFromDb->id")
            ->assertStatus(200)->assertJson([
                "id" => $userFromDb->id,
                "username" => "kadita",
                "name" => "Kadita",
                "email" => "kadita@example.com"
            ]);
    }

    public function testGetUserFailed(): void
    {
        $this->get('/api/users/UNKNOWN-ID')
            ->assertStatus(404)->assertJson([
                "errors" => "user dengan user_id UNKNOWN-ID tidak ditemukan"
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
