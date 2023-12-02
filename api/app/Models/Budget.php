<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Budget extends Model
{
    use HasUuids;

    protected $table = 'budgets';
    protected $primaryKey = 'id';
    protected $keyType = 'string';
    public $incrementing = false;
    public $timestamps = false;

    protected $fillable = [
        "user_id",
        "category",
        "title",
        "spend_total",
        "limit",
        "description",
        "date",
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }
    
    public function transactions(): HasMany
    {
        return $this->hasMany(Transaction::class);
    }
}
