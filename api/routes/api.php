<?php

use App\Http\Controllers\BalanceController;
use App\Http\Controllers\BillReminderController;
use App\Http\Controllers\BudgetCategoryController;
use App\Http\Controllers\BudgetController;
use App\Http\Controllers\BudgetTransactionController;
use App\Http\Controllers\SavingController;
use App\Http\Controllers\SavingTransactionController;
use App\Http\Controllers\UserController;
use App\Http\Controllers\UserTransactionController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

// Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
//     return $request->user();
// });

Route::post('/users', [UserController::class, 'register']);
Route::post('/users/login', [UserController::class, 'login']);
Route::get('/users/{userId}', [UserController::class, 'get']);

Route::get('/balance/{userId}', [BalanceController::class, 'get']);

Route::post('/bill-reminders', [BillReminderController::class, 'create']);
Route::get('/bill-reminders/{userId}', [BillReminderController::class, 'get']);
Route::put('/bill-reminders/{billReminderId}', [BillReminderController::class, 'update']);
Route::delete('/bill-reminders/{billReminderId}', [BillReminderController::class, 'delete']);

Route::get('/budget-categories', [BudgetCategoryController::class, 'get']);

Route::post('/budgets', [BudgetController::class, 'create']);
Route::get('/budgets/{userId}', [BudgetController::class, 'get']);
Route::put('/budgets/{budgetId}', [BudgetController::class, 'update']);
Route::delete('/budgets/{budgetId}', [BudgetController::class, 'delete']);

Route::post('/savings', [SavingController::class, 'create']);
Route::get('/savings/{userId}', [SavingController::class, 'get']);
Route::put('/savings/{savingId}', [SavingController::class, 'put']);
Route::delete('/savings/{savingId}', [SavingController::class, 'delete']);

Route::post('/transactions', [UserTransactionController::class, 'create']);
Route::get('/transactions/user/{userId}', [UserTransactionController::class, 'get']);
Route::put('/transactions/{transactionId}', [UserTransactionController::class, 'put']);
Route::delete('/transactions/{transactionId}', [UserTransactionController::class, 'delete']);

Route::get('/transactions/budget/{budgetId}', [BudgetTransactionController::class, 'get']);

Route::get('/transactions/saving/{savingId}', [SavingTransactionController::class, 'get']);

Route::get('/transactions/sum-by-category/{userId}', [UserTransactionController::class, 'sumByCategory']);

Route::get('/transactions/sum-by-category/graph/{userId}', [UserTransactionController::class, 'sumByCategoryPerMonth']);
Route::get('/transactions/each-category-count/{userId}', [UserTransactionController::class, 'eachTransactionCategoryCount']);
