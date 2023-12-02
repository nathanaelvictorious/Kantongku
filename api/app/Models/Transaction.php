<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Transaction extends Model
{
    use HasUuids;

    protected $table = 'transactions';
    protected $primaryKey = 'id';
    protected $keyType = 'string';
    public $incrementing = false;
    public $timestamps = false;

    protected $fillable = [
        "id",
        "user_id",
        "budget_id",
        "saving_id",
        "bill_reminder_id",
        "category",
        "amount",
        "date_time",
        "description"
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function userSaving(): BelongsTo
    {
        return $this->belongsTo(Saving::class);
    }

    public function budget(): BelongsTo
    {
        return $this->belongsTo(Budget::class);
    }

    public function bill_reminder(): BelongsTo
    {
        return $this->belongsTo(BillReminder::class);
    }
}
