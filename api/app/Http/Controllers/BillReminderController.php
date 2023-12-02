<?php

namespace App\Http\Controllers;

use App\Http\Requests\BillReminderCreateRequest;
use App\Http\Requests\BillReminderUpdateRequest;
use App\Http\Resources\BillReminderResource;
use App\Models\BillReminder;
use App\Models\User;
use Illuminate\Http\JsonResponse;

class BillReminderController extends Controller
{
    public function get(string $userId): JsonResponse
    {
        $user = User::find($userId);

        if ($user == null) {
            return response()->json([
                "errors" => "user tidak ditemukan"
            ])->setStatusCode(404);
        }

        $billReminders = $user->billReminders;

        return response()->json(BillReminderResource::collection($billReminders))->setStatusCode(200);
    }

    public function create(BillReminderCreateRequest $billReminderCreateRequest): JsonResponse
    {
        $data = $billReminderCreateRequest->validated();

        $user = User::find($data["user_id"]);

        if ($user == null) {
            return response()->json([
                "errors" => "user tidak ditemukan"
            ])->setStatusCode(404);
        }

        $billReminder = new BillReminder($data);
        $billReminder->current_amount = 0;
        $billReminder->save();

        return response()->json(new BillReminderResource($billReminder))->setStatusCode(201);
    }

    public function update(string $billReminderId, BillReminderUpdateRequest $billReminderUpdateRequest): JsonResponse
    {
        $billReminder = BillReminder::query()->find($billReminderId);

        if ($billReminder == null) {
            return response()->json([
                "errors" => "data tagihan tidak ditemukan"
            ])->setStatusCode(404);
        }

        $data = $billReminderUpdateRequest->validated();

        $billReminder->fill($data);
        $billReminder->save();

        return response()->json(new BillReminderResource($billReminder))->setStatusCode(200);
    }

    public function delete(string $billReminderId): JsonResponse
    {
        $billReminder = BillReminder::query()->find($billReminderId);

        if ($billReminder == null) {
            return response()->json([
                "errors" => "data tagihan tidak ditemukan"
            ])->setStatusCode(404);
        }

        $billReminder->delete();

        return response()->json([
            "message" => "data tagihan berhasil dihapus"
        ])->setStatusCode(200);
    }
}
