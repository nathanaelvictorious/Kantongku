<?php

namespace App\Http\Controllers;

use App\Http\Requests\UserLoginRequest;
use App\Http\Requests\UserRegisterRequest;
use App\Http\Resources\UserResource;
use App\Models\Balance;
use App\Models\User;
use Illuminate\Http\Exceptions\HttpResponseException;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Hash;

class UserController extends Controller
{
    public function register(UserRegisterRequest $userRegisterRequest): JsonResponse
    {
        $data = $userRegisterRequest->validated();

        $isUserExist = User::where('username', $data['username'])->count() == 1;

        if ($isUserExist) {
            throw new HttpResponseException(response([
                "errors" => "username sudah teregistrasi"
            ], 400));
        }

        $user = new User($data);
        $user->password = Hash::make($data['password']);
        $user->save();

        $userBalance = new Balance();
        $userBalance->user_id = $user->id;
        $userBalance->save();

        return response()->json(new UserResource($user))->setStatusCode(201);
    }

    public function login(UserLoginRequest $userLoginRequest): JsonResponse
    {
        $data = $userLoginRequest->validated();

        $user = User::where('username', $data['username'])->first();

        if (!$user || !Hash::check($data['password'], $user->password)) {
            throw new HttpResponseException(response([
                "errors" => "username atau password salah"
            ], 401));
        }

        return response()->json(new UserResource($user))->setStatusCode(200);
    }

    public function get(string $userId): JsonResponse
    {
        $user = User::query()->find($userId);

        if (!$user) {
            throw new HttpResponseException(response([
                "errors" => "user dengan user_id {$userId} tidak ditemukan"
            ], 404));
        }

        return response()->json(new UserResource($user))->setStatusCode(200);
    }
}
