<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Balance extends Model
{
    use HasUuids;

    protected $table = 'balances';
    protected $primaryKey = 'id';
    protected $keyType = 'string';
    public $incrementing = false;
    public $timestamps = false;

    protected $fillable = [
        "id",
        "user_id",
        "balance",
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }
}
