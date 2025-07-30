<?php

namespace Tests\Feature;

use App\Models\Expense;
use App\Models\Tag;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class ExpenseTest extends TestCase
{
    use RefreshDatabase;

    private function authenticatedUser()
    {
        $user = User::factory()->create();
        $token = $user->createToken('test-token')->plainTextToken;
        
        return [$user, $token];
    }

    public function test_user_can_create_expense()
    {
        [$user, $token] = $this->authenticatedUser();

        $expenseData = [
            'amount' => 100.50,
            'description' => 'Test expense',
            'category' => 'food',
            'date' => '2024-01-15',
        ];

        $response = $this->withHeader('Authorization', 'Bearer ' . $token)
            ->postJson('/api/expenses', $expenseData);

        $response->assertStatus(201)
            ->assertJsonStructure([
                'id', 'amount', 'description', 'category', 'date', 'tags'
            ]);

        $this->assertDatabaseHas('expenses', [
            'user_id' => $user->id,
            'amount' => 100.50,
            'description' => 'Test expense',
        ]);
    }

    public function test_user_can_create_expense_with_tags()
    {
        [$user, $token] = $this->authenticatedUser();
        
        $tag = Tag::factory()->create(['user_id' => $user->id]);

        $expenseData = [
            'amount' => 100.50,
            'description' => 'Test expense',
            'category' => 'food',
            'date' => '2024-01-15',
            'tag_ids' => [$tag->id],
        ];

        $response = $this->withHeader('Authorization', 'Bearer ' . $token)
            ->postJson('/api/expenses', $expenseData);

        $response->assertStatus(201);

        $expense = Expense::first();
        $this->assertTrue($expense->tags->contains($tag));
    }

    public function test_user_can_get_expenses()
    {
        [$user, $token] = $this->authenticatedUser();
        
        Expense::factory()->count(3)->create(['user_id' => $user->id]);

        $response = $this->withHeader('Authorization', 'Bearer ' . $token)
            ->getJson('/api/expenses');

        $response->assertStatus(200)
            ->assertJsonStructure([
                'data' => [
                    '*' => ['id', 'amount', 'description', 'category', 'date', 'tags']
                ]
            ]);
    }

    public function test_user_can_update_expense()
    {
        [$user, $token] = $this->authenticatedUser();
        
        $expense = Expense::factory()->create(['user_id' => $user->id]);

        $updateData = [
            'amount' => 200.75,
            'description' => 'Updated expense',
            'category' => 'transport',
            'date' => '2024-01-16',
        ];

        $response = $this->withHeader('Authorization', 'Bearer ' . $token)
            ->putJson("/api/expenses/{$expense->id}", $updateData);

        $response->assertStatus(200);

        $this->assertDatabaseHas('expenses', [
            'id' => $expense->id,
            'amount' => 200.75,
            'description' => 'Updated expense',
        ]);
    }

    public function test_user_can_delete_expense()
    {
        [$user, $token] = $this->authenticatedUser();
        
        $expense = Expense::factory()->create(['user_id' => $user->id]);

        $response = $this->withHeader('Authorization', 'Bearer ' . $token)
            ->deleteJson("/api/expenses/{$expense->id}");

        $response->assertStatus(200);

        $this->assertDatabaseMissing('expenses', ['id' => $expense->id]);
    }

    public function test_user_cannot_access_other_users_expenses()
    {
        [$user, $token] = $this->authenticatedUser();
        $otherUser = User::factory()->create();
        
        $expense = Expense::factory()->create(['user_id' => $otherUser->id]);

        $response = $this->withHeader('Authorization', 'Bearer ' . $token)
            ->getJson("/api/expenses/{$expense->id}");

        $response->assertStatus(403);
    }

    public function test_user_can_get_expense_statistics()
    {
        [$user, $token] = $this->authenticatedUser();
        
        Expense::factory()->count(5)->create([
            'user_id' => $user->id,
            'amount' => 100,
        ]);

        $response = $this->withHeader('Authorization', 'Bearer ' . $token)
            ->getJson('/api/expenses-statistics');

        $response->assertStatus(200)
            ->assertJsonStructure([
                'total_expenses',
                'monthly_expenses',
                'category_stats',
                'recent_expenses'
            ]);
    }

    public function test_expense_validation()
    {
        [$user, $token] = $this->authenticatedUser();

        $response = $this->withHeader('Authorization', 'Bearer ' . $token)
            ->postJson('/api/expenses', [
                'amount' => -100,
                'description' => '',
                'category' => '',
                'date' => 'invalid-date',
            ]);

        $response->assertStatus(422)
            ->assertJsonValidationErrors(['amount', 'description', 'category', 'date']);
    }
}