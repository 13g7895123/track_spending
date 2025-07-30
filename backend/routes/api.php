<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\ExpenseController;
use App\Http\Controllers\IncomeController;
use App\Http\Controllers\TagController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
*/

// Public routes
Route::post('/auth/register', [AuthController::class, 'register']);
Route::post('/auth/login', [AuthController::class, 'login']);

// Protected routes
Route::middleware('auth:sanctum')->group(function () {
    // Authentication
    Route::post('/auth/logout', [AuthController::class, 'logout']);
    Route::get('/auth/user', [AuthController::class, 'user']);
    Route::put('/auth/profile', [AuthController::class, 'updateProfile']);
    Route::put('/auth/password', [AuthController::class, 'changePassword']);

    // Expenses
    Route::apiResource('expenses', ExpenseController::class);
    Route::get('/expenses-statistics', [ExpenseController::class, 'statistics']);

    // Incomes
    Route::apiResource('incomes', IncomeController::class);
    Route::get('/incomes-statistics', [IncomeController::class, 'statistics']);

    // Tags
    Route::apiResource('tags', TagController::class);
    Route::post('/tags/{tag}/share', [TagController::class, 'share']);
    Route::delete('/tags/{tag}/unshare', [TagController::class, 'unshare']);
    Route::get('/shared-tags', [TagController::class, 'sharedTags']);
});