<?php

namespace App\Http\Controllers;

use App\Models\Expense;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class ExpenseController extends Controller
{
    public function index(Request $request)
    {
        $query = $request->user()->expenses()->with('tags');

        if ($request->has('start_date') && $request->has('end_date')) {
            $query->whereBetween('date', [$request->start_date, $request->end_date]);
        }

        if ($request->has('category')) {
            $query->where('category', $request->category);
        }

        if ($request->has('tag_id')) {
            $query->whereHas('tags', function ($q) use ($request) {
                $q->where('tags.id', $request->tag_id);
            });
        }

        $expenses = $query->orderBy('date', 'desc')
            ->paginate($request->get('per_page', 20));

        return response()->json($expenses);
    }

    public function store(Request $request)
    {
        $request->validate([
            'amount' => 'required|numeric|min:0.01|max:999999999.99',
            'description' => 'required|string|max:255',
            'category' => 'required|string|max:100',
            'date' => 'required|date',
            'receipt_image_url' => 'nullable|string|url',
            'tag_ids' => 'nullable|array',
            'tag_ids.*' => 'exists:tags,id',
        ]);

        DB::beginTransaction();
        
        try {
            $expense = $request->user()->expenses()->create($request->only([
                'amount', 'description', 'category', 'date', 'receipt_image_url'
            ]));

            if ($request->has('tag_ids')) {
                $validTagIds = $request->user()->tags()
                    ->whereIn('id', $request->tag_ids)
                    ->pluck('id')
                    ->toArray();
                
                $expense->tags()->attach($validTagIds);
            }

            DB::commit();

            return response()->json($expense->load('tags'), 201);
        } catch (\Exception $e) {
            DB::rollback();
            return response()->json(['error' => 'Failed to create expense'], 500);
        }
    }

    public function show(Request $request, Expense $expense)
    {
        if ($expense->user_id !== $request->user()->id) {
            return response()->json(['error' => 'Unauthorized'], 403);
        }

        return response()->json($expense->load('tags'));
    }

    public function update(Request $request, Expense $expense)
    {
        if ($expense->user_id !== $request->user()->id) {
            return response()->json(['error' => 'Unauthorized'], 403);
        }

        $request->validate([
            'amount' => 'required|numeric|min:0.01|max:999999999.99',
            'description' => 'required|string|max:255',
            'category' => 'required|string|max:100',
            'date' => 'required|date',
            'receipt_image_url' => 'nullable|string|url',
            'tag_ids' => 'nullable|array',
            'tag_ids.*' => 'exists:tags,id',
        ]);

        DB::beginTransaction();
        
        try {
            $expense->update($request->only([
                'amount', 'description', 'category', 'date', 'receipt_image_url'
            ]));

            if ($request->has('tag_ids')) {
                $validTagIds = $request->user()->tags()
                    ->whereIn('id', $request->tag_ids)
                    ->pluck('id')
                    ->toArray();
                
                $expense->tags()->sync($validTagIds);
            }

            DB::commit();

            return response()->json($expense->load('tags'));
        } catch (\Exception $e) {
            DB::rollback();
            return response()->json(['error' => 'Failed to update expense'], 500);
        }
    }

    public function destroy(Request $request, Expense $expense)
    {
        if ($expense->user_id !== $request->user()->id) {
            return response()->json(['error' => 'Unauthorized'], 403);
        }

        $expense->delete();

        return response()->json(['message' => 'Expense deleted successfully']);
    }

    public function statistics(Request $request)
    {
        $user = $request->user();
        
        $totalExpenses = $user->expenses()->sum('amount');
        
        $monthlyExpenses = $user->expenses()
            ->whereMonth('date', now()->month)
            ->whereYear('date', now()->year)
            ->sum('amount');

        $categoryStats = $user->expenses()
            ->select('category', DB::raw('SUM(amount) as total'))
            ->groupBy('category')
            ->get();

        $recentExpenses = $user->expenses()
            ->with('tags')
            ->orderBy('date', 'desc')
            ->limit(5)
            ->get();

        return response()->json([
            'total_expenses' => $totalExpenses,
            'monthly_expenses' => $monthlyExpenses,
            'category_stats' => $categoryStats,
            'recent_expenses' => $recentExpenses,
        ]);
    }
}