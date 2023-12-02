<?php

namespace App\Http\Controllers;

use App\Http\Requests\BudgetCreateRequest;
use App\Http\Requests\BudgetUpdateRequest;
use App\Http\Resources\BudgetResource;
use App\Models\Budget;
use App\Models\BudgetCategory;
use App\Models\User;
use Illuminate\Http\Exceptions\HttpResponseException;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class BudgetController extends Controller
{
    public function get(string $userId, Request $request): JsonResponse
    {
        $user = $this->validateUser($userId);

        if (!$user) {
            throw new HttpResponseException(response([
                "errors" => "user tidak ditemukan"
            ], 404));
        }

        $date = $request->input('date', null);

        if ($date) {
            $budgets = Budget::where('user_id', $user->id)
                ->whereYear('date', date('Y', strtotime($date)))
                ->whereMonth('date', date('m', strtotime($date)))
                ->get();

            return response()->json(BudgetResource::collection($budgets))->setStatusCode(200);
        }

        $budgets = Budget::where('user_id', $user->id)->get();

        return response()->json(BudgetResource::collection($budgets))->setStatusCode(200);
    }

    public function create(BudgetCreateRequest $budgetCreateRequest): JsonResponse
    {
        $data = $budgetCreateRequest->validated();

        if (!$this->validateUser($data['user_id'])) {
            throw new HttpResponseException(response([
                "errors" => "user tidak ditemukan"
            ], 404));
        }

        $budget = new Budget($data);

        $budget->spend_total = $data['spend_total'] ?? 0;

        $budget->save();

        return response()->json(new BudgetResource($budget))->setStatusCode(201);
    }

    public function update(string $budgetId, BudgetUpdateRequest $budgetUpdateRequest): JsonResponse
    {
        $budget = Budget::find($budgetId);

        if ($budget == null) {
            return response()->json([
                "errors" => "data anggaran tidak ditemukan"
            ])->setStatusCode(404);
        }

        $data = $budgetUpdateRequest->validated();

        $budget->fill($data);
        $budget->save();

        return response()->json(new BudgetResource($budget))->setStatusCode(200);
    }

    public function delete(string $budgetId): JsonResponse
    {
        $budget = Budget::query()->find($budgetId);

        if ($budget == null) {
            return response()->json([
                "errors" => "data anggaran tidak ditemukan"
            ])->setStatusCode(404);
        }
        
        $budget->delete();

        return response()->json([
            "message" => "data anggaran berhasil dihapus"
        ])->setStatusCode(200);
    }

    private function validateUser(string $userId): bool | \Illuminate\Database\Eloquent\Model
    {
        $user = User::query()->where("id", $userId)->first();

        if (!$user) {
            return false;
        }

        return $user;
    }

    private function validateBudgetCategory(string $categoryId): bool
    {
        $isBudgetCategoryExist = BudgetCategory::query()->where("id", $categoryId)->first();

        if (!$isBudgetCategoryExist) {
            return false;
        }

        return true;
    }
}
