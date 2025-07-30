<?php

namespace Database\Seeders;

use App\Models\User;
use App\Models\Expense;
use App\Models\Income;
use App\Models\Tag;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // Create a demo user
        $user = User::factory()->create([
            'name' => 'Demo User',
            'email' => 'demo@example.com',
        ]);

        // Create tags for the demo user
        $tags = Tag::factory()->count(8)->create([
            'user_id' => $user->id,
        ]);

        // Create expenses for the demo user
        $expenses = Expense::factory()->count(20)->create([
            'user_id' => $user->id,
        ]);

        // Create incomes for the demo user
        $incomes = Income::factory()->count(5)->create([
            'user_id' => $user->id,
        ]);

        // Attach random tags to expenses
        $expenses->each(function ($expense) use ($tags) {
            $randomTags = $tags->random(rand(1, 3));
            $expense->tags()->attach($randomTags->pluck('id'));
        });

        // Attach random tags to incomes
        $incomes->each(function ($income) use ($tags) {
            $randomTags = $tags->random(rand(1, 2));
            $income->tags()->attach($randomTags->pluck('id'));
        });

        // Create additional users for testing
        User::factory()->count(5)->create();
    }
}