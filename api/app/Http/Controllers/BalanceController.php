<?php

namespace App\Http\Controllers;

use App\Http\Resources\BalanceResource;
use App\Models\User;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Http\Exceptions\HttpResponseException;
use Illuminate\Http\JsonResponse;

class BalanceController extends Controller
{
    public function get(string $userId): JsonResponse
    {
        $user = $this->validateUser($userId);

        return response()->json(new BalanceResource($user->balance))->setStatusCode(200);
    }

    private function validateUser(string $userId): Model
    {
        $user = User::query()->find($userId);

        if (!$user) {
            throw new HttpResponseException(response([
                "errors" => "user tidak ditemukan"
            ], 404));
        }

        return $user;
    }
}
