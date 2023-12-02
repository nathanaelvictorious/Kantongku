<?php

namespace App\Http\Controllers;

use App\Http\Requests\UserTransactionCreateRequest;
use App\Http\Requests\UserTransactionUpdateRequest;
use App\Http\Resources\TransactionResource;
use App\Models\Budget;
use App\Models\Saving;
use App\Models\Transaction;
use App\Models\User;
use DateTime;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Http\Exceptions\HttpResponseException;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class UserTransactionController extends Controller
{
    public function create(UserTransactionCreateRequest $userTransactionCreateRequest): JsonResponse
    {
        $data = $userTransactionCreateRequest->validated();

        $user = $this->validateUser($data['user_id']);

        return DB::transaction(function () use ($user, $data) {
            try {
                $transaction = new Transaction($data);

                $userBalance = $user->balance;
                $userBudget = $user->budgets()->find($transaction->budget_id);
                $userSaving = $user->savings()->find($transaction->saving_id);
                $userBillReminder = $user->billReminders()->find($transaction->bill_reminder_id);

                switch ($transaction->category) {
                    case 'Pengeluaran':
                        $userBalance->decrement('balance', $transaction->amount);

                        if ($userBudget != null) {
                            $userBudget->increment('spend_total', $transaction->amount);
                        }

                        if ($userBillReminder != null) {
                            $userBillReminder->increment('current_amount', $transaction->amount);
                            if ($userBillReminder->current_amount >= $userBillReminder->amount) {
                                $userBillReminder->is_paid_off = true;
                                $userBillReminder->save();
                            } else {
                                $userBillReminder->is_paid_off = false;
                                $userBillReminder->save();
                            }
                        }

                        break;

                    case 'Pendapatan':
                        $this->validateIncomeTransaction($transaction);

                        $userBalance->increment('balance', $transaction->amount);
                        break;

                    case 'Tabungan':
                        $this->validateTrasactionSavingId($transaction);

                        $userBalance->decrement('balance', $transaction->amount);
                        $userSaving->increment('current_balance', $transaction->amount);
                        if ($userSaving->current_balance >= $userSaving->goal_amount) {
                            $userSaving->is_achieved = true;
                            $userSaving->save();
                        } else {
                            $userSaving->is_achieved = false;
                            $userSaving->save();
                        }
                        break;

                    default:
                        break;
                }

                $transaction->save();

                return response()->json(new TransactionResource($transaction))->setStatusCode(201);
            } catch (\PDOException $e) {
                return response()->json(['error' => $e->getMessage()])->setStatusCode(500);
            }
        });
    }

    public function get(string $userId, Request $request): JsonResponse
    {
        $user = $this->validateUser($userId);

        $date = $request->input('date', null);

        if ($date) {
            $transactions = $user->transactions()
                ->whereYear('date_time', date('Y', strtotime($date)))
                ->whereMonth('date_time', date('m', strtotime($date)))
                ->get();

            return response()->json(TransactionResource::collection($transactions))->setStatusCode(200);
        }

        $transactions = $user->transactions;

        return response()->json(TransactionResource::collection($transactions))->setStatusCode(200);
    }

    public function put(string $transactionId, UserTransactionUpdateRequest $userTransactionUpdateRequest): JsonResponse
    {
        $transaction = $this->validateTransaction($transactionId);

        $data = $userTransactionUpdateRequest->validated();

        return DB::transaction(function () use ($transaction, $data) {
            try {
                $user = $transaction->user;

                $userBalance = $user->balance;
                $userBudget = $user->budgets()->find($transaction->budget_id);
                $userSaving = $user->savings()->find($transaction->saving_id);
                $userBillReminder = $user->billReminders()->find($transaction->bill_reminder_id);
                $pastTransactionAmount = $transaction->amount;

                switch ($transaction->category) {
                    case 'Pengeluaran':
                        $userBalance->decrement('balance', $data["amount"]);
                        $userBalance->increment('balance', $transaction->amount);

                        $budgetIdInput =  $data['budget_id'] ?? null;
                        if ($transaction->budget_id == $budgetIdInput) {
                            if ($userBudget != null) {
                                $userBudget->decrement('spend_total', $transaction->amount);
                            }

                            $transaction->fill($data);

                            if ($userBudget != null) {
                                $userBudget->increment('spend_total', $data["amount"]);
                            }
                        } else {
                            if ($userBudget != null) {
                                $userBudget->decrement('spend_total', $transaction->amount);
                            }

                            $transaction->fill($data);

                            $userBudget = $user->budgets()->find($transaction->budget_id);

                            if ($userBudget != null) {
                                $userBudget->increment('spend_total', $data["amount"]);
                            }
                        }

                        $billReminderIdInput = $data['bill_reminder_id'] ?? null;
                        if ($transaction->bill_reminder_id == $billReminderIdInput) {
                            if ($userBillReminder != null) {
                                $userBillReminder->decrement('current_amount', $pastTransactionAmount);
                            }

                            // $transaction->fill($data);

                            if ($userBillReminder != null) {
                                $userBillReminder->increment('current_amount', $data["amount"]);
                                if ($userBillReminder->current_amount >= $userBillReminder->amount) {
                                    $userBillReminder->is_paid_off = true;
                                    $userBillReminder->save();
                                } else {
                                    $userBillReminder->is_paid_off = false;
                                    $userBillReminder->save();
                                }
                            }
                        } else {
                            if ($userBillReminder != null) {
                                $userBillReminder->decrement('current_amount', $pastTransactionAmount);
                            }

                            // $transaction->fill($data);

                            $userBillReminder = $user->billReminders()->find($transaction->bill_reminder_id);

                            if ($userBillReminder != null) {
                                $userBillReminder->increment('current_amount', $data['amount']);
                                if ($userBillReminder->current_amount >= $userBillReminder->amount) {
                                    $userBillReminder->is_paid_off = true;
                                    $userBillReminder->save();
                                } else {
                                    $userBillReminder->is_paid_off = false;
                                    $userBillReminder->save();
                                }
                            }
                        }

                        break;

                    case 'Pendapatan':
                        $userBalance->decrement('balance', $transaction->amount);
                        $userBalance->increment('balance', $data["amount"]);

                        $transaction->fill($data);

                        break;

                    case 'Tabungan':
                        $userBalance->increment('balance', $transaction->amount);
                        $userBalance->decrement('balance', $data["amount"]);

                        $savingIdInput = $data['saving_id'] ?? null;
                        if ($transaction->saving_id == $savingIdInput) {
                            if ($userSaving != null) {
                                $userSaving->decrement('current_balance', $transaction->amount);
                            }

                            $transaction->fill($data);

                            if ($userSaving != null) {
                                $userSaving->increment('current_balance', $data["amount"]);
                                if ($userSaving->current_balance >= $userSaving->goal_amount) {
                                    $userSaving->is_achieved = true;
                                    $userSaving->save();
                                } else {
                                    $userSaving->is_achieved = false;
                                    $userSaving->save();
                                }
                            }
                        } else {
                            if ($userSaving != null) {
                                $userSaving->decrement('current_balance', $transaction->amount);
                            }

                            $transaction->fill($data);

                            $userSaving = $user->savings()->find($transaction->saving_id);

                            if ($userSaving != null) {
                                $userSaving->increment('current_balance', $data["amount"]);
                                if ($userSaving->current_balance >= $userSaving->goal_amount) {
                                    $userSaving->is_achieved = true;
                                    $userSaving->save();
                                } else {
                                    $userSaving->is_achieved = false;
                                    $userSaving->save();
                                }
                            }
                        }

                        break;

                    default:

                        break;
                }

                $transaction->save();

                return response()->json(new TransactionResource($transaction))->setStatusCode(200);
            } catch (\PDOException $e) {
                return response()->json(['error' => $e->getMessage()])->setStatusCode(500);
            }
        });
    }

    public function delete(string $transactionId): JsonResponse
    {
        return DB::transaction(function () use ($transactionId) {
            try {
                $transaction = $this->validateTransaction($transactionId);

                $user = $transaction->user;

                $userBalance = $user->balance;
                $userBudget = $user->budgets()->find($transaction->budget_id);
                $userSaving = $user->savings()->find($transaction->saving_id);
                $userBillReminder = $user->billReminders()->find($transaction->bill_reminder_id);

                switch ($transaction->category) {
                    case 'Pengeluaran':
                        $userBalance->increment('balance', $transaction->amount);

                        if ($userBudget != null) {
                            $userBudget->decrement('spend_total', $transaction->amount);
                        }

                        if ($userBillReminder != null) {
                            $userBillReminder->decrement('current_amount', $transaction->amount);
                            if ($userBillReminder->current_amount >= $userBillReminder->amount) {
                                $userBillReminder->is_paid_off = true;
                                $userBillReminder->save();
                            } else {
                                $userBillReminder->is_paid_off = false;
                                $userBillReminder->save();
                            }
                        }

                        break;
                    case 'Pendapatan':
                        $userBalance->decrement('balance', $transaction->amount);
                        break;
                    case 'Tabungan':
                        $userBalance->increment('balance', $transaction->amount);

                        if ($userSaving != null) {
                            $userSaving->decrement('current_balance', $transaction->amount);
                            if ($userSaving->current_balance >= $userSaving->goal_amount) {
                                $userSaving->is_achieved = true;
                                $userSaving->save();
                            } else {
                                $userSaving->is_achieved = false;
                                $userSaving->save();
                            }
                        }
                        break;

                    default:
                        break;
                }

                $transaction->delete();

                return response()->json([
                    "message" => "transaksi berhasil dihapus"
                ])->setStatusCode(200);
            } catch (\PDOException $e) {
                return response()->json(['error' => $e->getMessage()])->setStatusCode(500);
            }
        });
    }

    public function eachTransactionCategoryCount(string $userId, Request $request): JsonResponse
    {
        $user = $this->validateUser($userId);

        $date = $request->input('date', null);

        if ($date) {
            $incomeTransactionsCount = $user->transactions()
                ->where('category', 'Pendapatan')
                ->whereYear('date_time', date('Y', strtotime($date)))
                ->whereMonth('date_time', date('m', strtotime($date)))
                ->count();

            $expenseTransactionsCount = $user->transactions()
                ->where('category', 'Pengeluaran')
                ->whereYear('date_time', date('Y', strtotime($date)))
                ->whereMonth('date_time', date('m', strtotime($date)))
                ->count();

            $savingTransactionsCount = $user->transactions()
                ->where('category', 'Tabungan')
                ->whereYear('date_time', date('Y', strtotime($date)))
                ->whereMonth('date_time', date('m', strtotime($date)))
                ->count();

            $incomeTransactionsAmount = $user->transactions()
                ->where('category', 'Pendapatan')
                ->whereYear('date_time', date('Y', strtotime($date)))
                ->whereMonth('date_time', date('m', strtotime($date)))
                ->sum('amount');
            $expenseTransactionsAmount = $user->transactions()
                ->where('category', 'Pengeluaran')
                ->whereYear('date_time', date('Y', strtotime($date)))
                ->whereMonth('date_time', date('m', strtotime($date)))
                ->sum('amount');
            $savingTransactionsAmount = $user->transactions()
                ->where('category', 'Tabungan')
                ->whereYear('date_time', date('Y', strtotime($date)))
                ->whereMonth('date_time', date('m', strtotime($date)))
                ->sum('amount');

            return response()->json([
                [
                    "category" => "Pendapatan",
                    "total" => $incomeTransactionsCount,
                    "amount" => (int) $incomeTransactionsAmount,
                ],
                [
                    "category" => "Pengeluaran",
                    "total" => $expenseTransactionsCount,
                    "amount" => (int) $expenseTransactionsAmount,
                ],
                [
                    "category" => "Tabungan",
                    "total" => $savingTransactionsCount,
                    "amount" => (int) $savingTransactionsAmount,
                ],
            ])->setStatusCode(200);
        }

        $incomeTransactionsCount = $user->transactions()->where('category', 'Pendapatan')->count();
        $expenseTransactionsCount = $user->transactions()->where('category', 'Pengeluaran')->count();
        $savingTransactionsCount = $user->transactions()->where('category', 'Tabungan')->count();

        $incomeTransactionsAmount = $user->transactions()->where('category', 'Pendapatan')->sum('amount');
        $expenseTransactionsAmount = $user->transactions()->where('category', 'Pengeluaran')->sum('amount');
        $savingTransactionsAmount = $user->transactions()->where('category', 'Tabungan')->sum('amount');

        return response()->json([
            [
                "category" => "Pendapatan",
                "total" => $incomeTransactionsCount,
                "amount" => (int) $incomeTransactionsAmount,
            ],
            [
                "category" => "Pengeluaran",
                "total" => $expenseTransactionsCount,
                "amount" => (int) $expenseTransactionsAmount,
            ],
            [
                "category" => "Tabungan",
                "total" => $savingTransactionsCount,
                "amount" => (int) $savingTransactionsAmount,
            ],
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

    private function validateTransaction(string $transactionId): Model
    {
        $transaction = Transaction::query()->find($transactionId);

        if (!$transaction) {
            throw new HttpResponseException(response([
                "errors" => "transaksi tidak ditemukan"
            ], 404));
        }

        return $transaction;
    }

    public function sumByCategory(string $userId, Request $request): JsonResponse
    {
        $user = User::find($userId);

        $category = $request->input('category', null);

        if ($category == null) {
            throw new HttpResponseException(response([
                "errors" => "category pada query parameter tidak boleh kosong"
            ], 404));
        }

        $transactionsSum = $user->transactions()->where('category', $category)->sum('amount');

        return response()->json($transactionsSum)->setStatusCode(200);
    }

    public function sumByCategoryPerMonth(string $userId, Request $request): JsonResponse
    {
        $user = User::find($userId);

        $category = $request->input('category', null);

        if ($category == null) {
            throw new HttpResponseException(response([
                "errors" => "category pada query parameter tidak boleh kosong"
            ], 404));
        }

        $transactions = $user->transactions()->where('category', $category)->get();

        $sumByMonth = [];

        foreach ($transactions as $transaction) {
            $date = new DateTime($transaction->date_time);

            $month = $date->format('F Y');

            if (!isset($sumByMonth[$month])) {
                $sumByMonth[$month] = 0;
            }

            $sumByMonth[$month] += $transaction->amount;
        }

        $result = [];

        foreach ($sumByMonth as $month => $amount) {
            $result[] = [
                "amount" => $amount,
                "month" => $month,
            ];
        }

        return response()->json($result)->setStatusCode(200);
    }

    private function validateIncomeTransaction(Transaction $transaction): void
    {
        if ($transaction->saving_id != null || $transaction->budget_id != null || $transaction->bill_reminder_id != null) {
            throw new HttpResponseException(response([
                "errors" => "saving_id, budget_id atau bill_reminder_id tidak boleh ada jika kategori transaksi adalah pendapatan"
            ], 400));
        }
    }

    private function validateTrasactionSavingId(Transaction $transaction): void
    {
        if ($transaction->saving_id == null) {
            throw new HttpResponseException(response([
                "errors" => "saving_id tidak boleh kosong jika kategori transaksi adalah tabungan"
            ], 400));
        }
        if ($transaction->budget_id != null) {
            throw new HttpResponseException(response([
                "errors" => "budget_id tidak boleh ada jika kategori transaksi adalah tabungan"
            ], 400));
        }
        if ($transaction->bill_reminder_id != null) {
            throw new HttpResponseException(response([
                "errors" => "bill_reminder_id tidak boleh ada jika kategori transaksi adalah tabungan"
            ], 400));
        }
    }
}
