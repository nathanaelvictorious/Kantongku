<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class BillReminderResource extends JsonResource
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
            "name" => $this->name,
            "amount" => $this->amount,
            "current_amount" => $this->current_amount,
            "due_date" => $this->due_date,
            "description" => $this->description,
            "is_paid_off" => (boolean) $this->is_paid_off,
        ];
    }
}
