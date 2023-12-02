<?php

namespace App\Http\Controllers;

use App\Http\Requests\BudgetTransactionCreateRequest;
use App\Http\Resources\TransactionResource;
use App\Models\Budget;
use App\Models\Transaction;
use App\Models\User;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Http\Exceptions\HttpResponseException;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;
use Illuminate\Http\Request;

class BudgetTransactionController extends Controller
{
    public function get(string $budgetId, Request $request): JsonResponse
    {
        $budget = $this->validateBudget($budgetId);

        $transactions = $budget->transactions;

        return response()->json(TransactionResource::collection($transactions))->setStatusCode(200);
    }

    public function validateUser(string $userId): Model
    {
        $user = User::query()->find($userId);

        if (!$user) {
            throw new HttpResponseException(response([
                "errors" => "user tidak ditemukan"
            ], 404));
        }

        return $user;
    }

    public function validateBudget(string $budgetId): Model
    {
        $budget = Budget::query()->find($budgetId);

        if (!$budget) {
            throw new HttpResponseException(response([
                "errors" => "anggaran tidak ditemukan"
            ], 404));
        }

        return $budget;
    }
}
