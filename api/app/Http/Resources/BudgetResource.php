<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class BudgetResource extends JsonResource
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
            "category" => $this->category,
            "title" => $this->title,
            "spend_total" => $this->spend_total,
            "limit" => $this->limit,
            "description" => $this->description,
            "date" => $this->date,
        ];
    }
}
