<?php

namespace App\Http\Controllers;

use App\Http\Requests\SavingTransactionCreateRequest;
use App\Http\Requests\SavingTransactionUpdateRequest;
use App\Http\Resources\TransactionResource;
use App\Models\Saving;
use App\Models\Transaction;
use App\Models\User;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Http\Exceptions\HttpResponseException;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class SavingTransactionController extends Controller
{
    public function get(string $savingId): JsonResponse
    {
        $saving = $this->validateSaving($savingId);

        $transactions = $saving->transactions;

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

    public function validateSaving(string $savingId): Model
    {
        $saving = Saving::query()->find($savingId);

        if (!$saving) {
            throw new HttpResponseException(response([
                "errors" => "tabungan tidak ditemukan"
            ], 404));
        }

        return $saving;
    }
}
