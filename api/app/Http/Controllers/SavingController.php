<?php

namespace App\Http\Controllers;

use App\Http\Requests\SavingCreateRequest;
use App\Http\Requests\SavingUpdateRequest;
use App\Http\Resources\SavingResource;
use App\Models\Saving;
use App\Models\User;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Http\Exceptions\HttpResponseException;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class SavingController extends Controller
{
    public function get(string $userId, Request $request): JsonResponse
    {
        $user = $this->validateUser($userId);

        $date = $request->input('date', null);

        if ($date) {
            $savings = Saving::query()->where('user_id', $user->id)
                ->whereYear('date', date('Y', strtotime($date)))
                ->whereMonth('date', date('m', strtotime($date)))
                ->get();

            return response()->json(SavingResource::collection($savings))->setStatusCode(200);
        }

        $savings = $user->savings;

        return response()->json(SavingResource::collection($savings))->setStatusCode(200);
    }

    public function create(SavingCreateRequest $savingCreateRequest): JsonResponse
    {
        $data = $savingCreateRequest->validated();

        $this->validateUser($data['user_id']);

        $saving = new Saving($data);
        $saving->current_balance = $data['current_balance'] ?? 0;
        $saving->is_achieved = $data['is_achieved'] ?? false;

        $saving->save();

        return response()->json(new SavingResource($saving))->setStatusCode(201);
    }

    public function put(string $savingId, SavingUpdateRequest $savingUpdateRequest): JsonResponse
    {
        $saving = $this->validateSaving($savingId);

        $data = $savingUpdateRequest->validated();

        $saving->fill($data);
        $saving->save();

        return response()->json(new SavingResource($saving))->setStatusCode(200);
    }

    public function delete(string $savingId): JsonResponse
    {
        $saving = $this->validateSaving($savingId);

        $saving->delete();

        return response()->json([
            "message" => "tabungan berhasil dihapus"
        ])->setStatusCode(200);
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

    private function validateSaving(string $savingId): Model
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
