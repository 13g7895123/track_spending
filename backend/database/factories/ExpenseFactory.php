<?php

namespace Database\Factories;

use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Expense>
 */
class ExpenseFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        $categories = ['food', 'transport', 'utilities', 'entertainment', 'shopping', 'housing', 'health', 'education', 'other'];

        return [
            'user_id' => User::factory(),
            'amount' => $this->faker->randomFloat(2, 1, 1000),
            'description' => $this->faker->sentence(3),
            'category' => $this->faker->randomElement($categories),
            'date' => $this->faker->dateTimeBetween('-1 year', 'now')->format('Y-m-d'),
            'receipt_image_url' => $this->faker->optional(0.3)->imageUrl(400, 300, 'receipt'),
        ];
    }
}