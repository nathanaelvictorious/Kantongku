<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class SavingResource extends JsonResource
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
           "title" => $this->title,
           "current_balance" =>  $this->current_balance,
           "goal_amount" =>  $this->goal_amount,
           "description" => $this->description,
           "is_achieved" => (boolean) $this->is_achieved,
           "created_at" => $this->created_at,
        ];
    }
}
