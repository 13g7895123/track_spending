<?php

namespace Database\Factories;

use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Tag>
 */
class TagFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        $colors = ['#FF5733', '#33FF57', '#3357FF', '#FF33F1', '#F1FF33', '#33FFF1', '#FF8C33', '#8C33FF'];

        return [
            'user_id' => User::factory(),
            'name' => $this->faker->unique()->word(),
            'color' => $this->faker->randomElement($colors),
            'is_shared' => $this->faker->boolean(20), // 20% chance of being shared
        ];
    }
}