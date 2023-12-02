<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class TransactionResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            "id" => $this->id,
            "saving_id" => $this->saving_id,
            "budget_id" => $this->budget_id,
            "bill_reminder_id" => $this->bill_reminder_id,
            "category" => $this->category,
            "amount" => $this->amount,
            "date_time" => $this->date_time,
            "description" => $this->description,
        ];
    }
}
