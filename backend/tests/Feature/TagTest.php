<?php

namespace Tests\Feature;

use App\Models\Tag;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class TagTest extends TestCase
{
    use RefreshDatabase;

    private function authenticatedUser()
    {
        $user = User::factory()->create();
        $token = $user->createToken('test-token')->plainTextToken;
        
        return [$user, $token];
    }

    public function test_user_can_create_tag()
    {
        [$user, $token] = $this->authenticatedUser();

        $tagData = [
            'name' => 'Test Tag',
            'color' => '#FF5733',
            'is_shared' => false,
        ];

        $response = $this->withHeader('Authorization', 'Bearer ' . $token)
            ->postJson('/api/tags', $tagData);

        $response->assertStatus(201)
            ->assertJsonStructure(['id', 'name', 'color', 'is_shared']);

        $this->assertDatabaseHas('tags', [
            'user_id' => $user->id,
            'name' => 'Test Tag',
        ]);
    }

    public function test_user_cannot_create_duplicate_tag()
    {
        [$user, $token] = $this->authenticatedUser();
        
        Tag::factory()->create([
            'user_id' => $user->id,
            'name' => 'Existing Tag',
        ]);

        $response = $this->withHeader('Authorization', 'Bearer ' . $token)
            ->postJson('/api/tags', [
                'name' => 'Existing Tag',
                'color' => '#FF5733',
            ]);

        $response->assertStatus(409)
            ->assertJson(['error' => 'Tag with this name already exists']);
    }

    public function test_user_can_get_tags()
    {
        [$user, $token] = $this->authenticatedUser();
        
        Tag::factory()->count(3)->create(['user_id' => $user->id]);

        $response = $this->withHeader('Authorization', 'Bearer ' . $token)
            ->getJson('/api/tags');

        $response->assertStatus(200)
            ->assertJsonCount(3);
    }

    public function test_user_can_update_tag()
    {
        [$user, $token] = $this->authenticatedUser();
        
        $tag = Tag::factory()->create(['user_id' => $user->id]);

        $updateData = [
            'name' => 'Updated Tag',
            'color' => '#33FF57',
            'is_shared' => true,
        ];

        $response = $this->withHeader('Authorization', 'Bearer ' . $token)
            ->putJson("/api/tags/{$tag->id}", $updateData);

        $response->assertStatus(200);

        $this->assertDatabaseHas('tags', [
            'id' => $tag->id,
            'name' => 'Updated Tag',
        ]);
    }

    public function test_user_can_delete_tag()
    {
        [$user, $token] = $this->authenticatedUser();
        
        $tag = Tag::factory()->create(['user_id' => $user->id]);

        $response = $this->withHeader('Authorization', 'Bearer ' . $token)
            ->deleteJson("/api/tags/{$tag->id}");

        $response->assertStatus(200);

        $this->assertDatabaseMissing('tags', ['id' => $tag->id]);
    }

    public function test_user_can_share_tag()
    {
        [$user, $token] = $this->authenticatedUser();
        $otherUser = User::factory()->create();
        
        $tag = Tag::factory()->create(['user_id' => $user->id]);

        $response = $this->withHeader('Authorization', 'Bearer ' . $token)
            ->postJson("/api/tags/{$tag->id}/share", [
                'user_email' => $otherUser->email,
            ]);

        $response->assertStatus(200)
            ->assertJson(['message' => 'Tag shared successfully']);

        $this->assertDatabaseHas('tag_shares', [
            'tag_id' => $tag->id,
            'shared_with_user_id' => $otherUser->id,
        ]);
    }

    public function test_user_cannot_share_tag_with_themselves()
    {
        [$user, $token] = $this->authenticatedUser();
        
        $tag = Tag::factory()->create(['user_id' => $user->id]);

        $response = $this->withHeader('Authorization', 'Bearer ' . $token)
            ->postJson("/api/tags/{$tag->id}/share", [
                'user_email' => $user->email,
            ]);

        $response->assertStatus(400)
            ->assertJson(['error' => 'Cannot share tag with yourself']);
    }

    public function test_user_can_get_shared_tags()
    {
        [$user, $token] = $this->authenticatedUser();
        $otherUser = User::factory()->create();
        
        $tag = Tag::factory()->create(['user_id' => $otherUser->id]);
        $tag->sharedUsers()->attach($user->id, [
            'shared_by_user_id' => $otherUser->id
        ]);

        $response = $this->withHeader('Authorization', 'Bearer ' . $token)
            ->getJson('/api/shared-tags');

        $response->assertStatus(200)
            ->assertJsonCount(1);
    }

    public function test_tag_validation()
    {
        [$user, $token] = $this->authenticatedUser();

        $response = $this->withHeader('Authorization', 'Bearer ' . $token)
            ->postJson('/api/tags', [
                'name' => 'A', // Too short
                'color' => 'invalid-color',
            ]);

        $response->assertStatus(422)
            ->assertJsonValidationErrors(['name', 'color']);
    }

    public function test_user_cannot_access_other_users_tags()
    {
        [$user, $token] = $this->authenticatedUser();
        $otherUser = User::factory()->create();
        
        $tag = Tag::factory()->create(['user_id' => $otherUser->id]);

        $response = $this->withHeader('Authorization', 'Bearer ' . $token)
            ->getJson("/api/tags/{$tag->id}");

        $response->assertStatus(403);
    }
}