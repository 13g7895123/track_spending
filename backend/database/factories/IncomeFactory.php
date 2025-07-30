<?php

namespace Database\Factories;

use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Income>
 */
class IncomeFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        $sources = ['salary', 'bonus', 'investment', 'freelance', 'gift', 'other'];

        return [
            'user_id' => User::factory(),
            'amount' => $this->faker->randomFloat(2, 100, 5000),
            'description' => $this->faker->sentence(3),
            'source' => $this->faker->randomElement($sources),
            'date' => $this->faker->dateTimeBetween('-1 year', 'now')->format('Y-m-d'),
        ];
    }
}