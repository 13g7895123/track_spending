<?php

namespace App\Http\Controllers;

use App\Models\Tag;
use App\Models\User;
use Illuminate\Http\Request;

class TagController extends Controller
{
    public function index(Request $request)
    {
        $tags = $request->user()->tags()->get();
        return response()->json($tags);
    }

    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:50|min:2',
            'color' => 'required|string|regex:/^#([0-9A-Fa-f]{6})$/',
            'is_shared' => 'boolean',
        ]);

        // Check if tag name already exists for this user
        $existingTag = $request->user()->tags()
            ->where('name', $request->name)
            ->first();

        if ($existingTag) {
            return response()->json([
                'error' => 'Tag with this name already exists'
            ], 409);
        }

        $tag = $request->user()->tags()->create($request->only([
            'name', 'color', 'is_shared'
        ]));

        return response()->json($tag, 201);
    }

    public function show(Request $request, Tag $tag)
    {
        if ($tag->user_id !== $request->user()->id) {
            return response()->json(['error' => 'Unauthorized'], 403);
        }

        return response()->json($tag);
    }

    public function update(Request $request, Tag $tag)
    {
        if ($tag->user_id !== $request->user()->id) {
            return response()->json(['error' => 'Unauthorized'], 403);
        }

        $request->validate([
            'name' => 'required|string|max:50|min:2',
            'color' => 'required|string|regex:/^#([0-9A-Fa-f]{6})$/',
            'is_shared' => 'boolean',
        ]);

        // Check if tag name already exists for this user (excluding current tag)
        $existingTag = $request->user()->tags()
            ->where('name', $request->name)
            ->where('id', '!=', $tag->id)
            ->first();

        if ($existingTag) {
            return response()->json([
                'error' => 'Tag with this name already exists'
            ], 409);
        }

        $tag->update($request->only([
            'name', 'color', 'is_shared'
        ]));

        return response()->json($tag);
    }

    public function destroy(Request $request, Tag $tag)
    {
        if ($tag->user_id !== $request->user()->id) {
            return response()->json(['error' => 'Unauthorized'], 403);
        }

        $tag->delete();

        return response()->json(['message' => 'Tag deleted successfully']);
    }

    public function share(Request $request, Tag $tag)
    {
        if ($tag->user_id !== $request->user()->id) {
            return response()->json(['error' => 'Unauthorized'], 403);
        }

        $request->validate([
            'user_email' => 'required|email|exists:users,email',
        ]);

        $sharedUser = User::where('email', $request->user_email)->first();

        if ($sharedUser->id === $request->user()->id) {
            return response()->json([
                'error' => 'Cannot share tag with yourself'
            ], 400);
        }

        // Check if already shared
        if ($tag->sharedUsers()->where('shared_with_user_id', $sharedUser->id)->exists()) {
            return response()->json([
                'error' => 'Tag already shared with this user'
            ], 409);
        }

        $tag->sharedUsers()->attach($sharedUser->id, [
            'shared_by_user_id' => $request->user()->id
        ]);

        $tag->update(['is_shared' => true]);

        return response()->json([
            'message' => 'Tag shared successfully',
            'shared_with' => $sharedUser->only(['id', 'name', 'email'])
        ]);
    }

    public function unshare(Request $request, Tag $tag)
    {
        if ($tag->user_id !== $request->user()->id) {
            return response()->json(['error' => 'Unauthorized'], 403);
        }

        $request->validate([
            'user_id' => 'required|exists:users,id',
        ]);

        $tag->sharedUsers()->detach($request->user_id);

        // If no more shares, mark as not shared
        if ($tag->sharedUsers()->count() === 0) {
            $tag->update(['is_shared' => false]);
        }

        return response()->json(['message' => 'Tag unshared successfully']);
    }

    public function sharedTags(Request $request)
    {
        $user = $request->user();
        
        $sharedTags = Tag::whereHas('sharedUsers', function ($query) use ($user) {
            $query->where('shared_with_user_id', $user->id);
        })->with('user:id,name,email')->get();

        return response()->json($sharedTags);
    }
}