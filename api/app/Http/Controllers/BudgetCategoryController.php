<?php

namespace App\Http\Controllers;

use App\Http\Resources\BudgetCategoryResource;
use App\Models\BudgetCategory;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class BudgetCategoryController extends Controller
{
    public function get(): JsonResponse
    {
        $budgetCategories = BudgetCategory::all();

        return response()->json(BudgetCategoryResource::collection($budgetCategories))->setStatusCode(200);
    }
}
