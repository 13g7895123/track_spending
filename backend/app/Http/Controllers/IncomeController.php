<?php

namespace App\Http\Controllers;

use App\Models\Income;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class IncomeController extends Controller
{
    public function index(Request $request)
    {
        $query = $request->user()->incomes()->with('tags');

        if ($request->has('start_date') && $request->has('end_date')) {
            $query->whereBetween('date', [$request->start_date, $request->end_date]);
        }

        if ($request->has('source')) {
            $query->where('source', $request->source);
        }

        if ($request->has('tag_id')) {
            $query->whereHas('tags', function ($q) use ($request) {
                $q->where('tags.id', $request->tag_id);
            });
        }

        $incomes = $query->orderBy('date', 'desc')
            ->paginate($request->get('per_page', 20));

        return response()->json($incomes);
    }

    public function store(Request $request)
    {
        $request->validate([
            'amount' => 'required|numeric|min:0.01|max:999999999.99',
            'description' => 'required|string|max:255',
            'source' => 'required|string|max:100',
            'date' => 'required|date',
            'tag_ids' => 'nullable|array',
            'tag_ids.*' => 'exists:tags,id',
        ]);

        DB::beginTransaction();
        
        try {
            $income = $request->user()->incomes()->create($request->only([
                'amount', 'description', 'source', 'date'
            ]));

            if ($request->has('tag_ids')) {
                $validTagIds = $request->user()->tags()
                    ->whereIn('id', $request->tag_ids)
                    ->pluck('id')
                    ->toArray();
                
                $income->tags()->attach($validTagIds);
            }

            DB::commit();

            return response()->json($income->load('tags'), 201);
        } catch (\Exception $e) {
            DB::rollback();
            return response()->json(['error' => 'Failed to create income'], 500);
        }
    }

    public function show(Request $request, Income $income)
    {
        if ($income->user_id !== $request->user()->id) {
            return response()->json(['error' => 'Unauthorized'], 403);
        }

        return response()->json($income->load('tags'));
    }

    public function update(Request $request, Income $income)
    {
        if ($income->user_id !== $request->user()->id) {
            return response()->json(['error' => 'Unauthorized'], 403);
        }

        $request->validate([
            'amount' => 'required|numeric|min:0.01|max:999999999.99',
            'description' => 'required|string|max:255',
            'source' => 'required|string|max:100',
            'date' => 'required|date',
            'tag_ids' => 'nullable|array',
            'tag_ids.*' => 'exists:tags,id',
        ]);

        DB::beginTransaction();
        
        try {
            $income->update($request->only([
                'amount', 'description', 'source', 'date'
            ]));

            if ($request->has('tag_ids')) {
                $validTagIds = $request->user()->tags()
                    ->whereIn('id', $request->tag_ids)
                    ->pluck('id')
                    ->toArray();
                
                $income->tags()->sync($validTagIds);
            }

            DB::commit();

            return response()->json($income->load('tags'));
        } catch (\Exception $e) {
            DB::rollback();
            return response()->json(['error' => 'Failed to update income'], 500);
        }
    }

    public function destroy(Request $request, Income $income)
    {
        if ($income->user_id !== $request->user()->id) {
            return response()->json(['error' => 'Unauthorized'], 403);
        }

        $income->delete();

        return response()->json(['message' => 'Income deleted successfully']);
    }

    public function statistics(Request $request)
    {
        $user = $request->user();
        
        $totalIncomes = $user->incomes()->sum('amount');
        
        $monthlyIncomes = $user->incomes()
            ->whereMonth('date', now()->month)
            ->whereYear('date', now()->year)
            ->sum('amount');

        $sourceStats = $user->incomes()
            ->select('source', DB::raw('SUM(amount) as total'))
            ->groupBy('source')
            ->get();

        $recentIncomes = $user->incomes()
            ->with('tags')
            ->orderBy('date', 'desc')
            ->limit(5)
            ->get();

        return response()->json([
            'total_incomes' => $totalIncomes,
            'monthly_incomes' => $monthlyIncomes,
            'source_stats' => $sourceStats,
            'recent_incomes' => $recentIncomes,
        ]);
    }
}