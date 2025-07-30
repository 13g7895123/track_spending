import 'package:flutter/material.dart';
import '../models/tag_model.dart';
import '../services/mock_data_service.dart';

class TagRepository {
  final MockDataService _dataService;

  TagRepository(this._dataService);

  Future<List<Tag>> getTags() async {
    try {
      return await _dataService.getTags();
    } catch (e) {
      throw Exception('Failed to get tags: $e');
    }
  }

  Future<Tag> createTag(Tag tag) async {
    try {
      if (tag.name.trim().isEmpty) {
        throw Exception('Tag name is required');
      }

      if (tag.name.trim().length < 2) {
        throw Exception('Tag name must be at least 2 characters');
      }

      final existingTags = await getTags();
      final nameExists = existingTags.any(
        (existingTag) => existingTag.name.toLowerCase() == tag.name.toLowerCase()
      );

      if (nameExists) {
        throw Exception('Tag with this name already exists');
      }

      return await _dataService.createTag(tag);
    } catch (e) {
      throw Exception('Failed to create tag: $e');
    }
  }

  Future<Tag> updateTag(Tag tag) async {
    try {
      if (tag.name.trim().isEmpty) {
        throw Exception('Tag name is required');
      }

      if (tag.name.trim().length < 2) {
        throw Exception('Tag name must be at least 2 characters');
      }

      final existingTags = await getTags();
      final nameExists = existingTags.any(
        (existingTag) => 
          existingTag.id != tag.id && 
          existingTag.name.toLowerCase() == tag.name.toLowerCase()
      );

      if (nameExists) {
        throw Exception('Tag with this name already exists');
      }

      return await _dataService.updateTag(tag);
    } catch (e) {
      throw Exception('Failed to update tag: $e');
    }
  }

  Future<void> deleteTag(String tagId) async {
    try {
      if (tagId.trim().isEmpty) {
        throw Exception('Tag ID is required');
      }

      await _dataService.deleteTag(tagId);
    } catch (e) {
      throw Exception('Failed to delete tag: $e');
    }
  }

  Future<Tag?> getTagById(String tagId) async {
    try {
      final tags = await getTags();
      return tags.firstWhere(
        (tag) => tag.id == tagId,
        orElse: () => throw Exception('Tag not found'),
      );
    } catch (e) {
      return null;
    }
  }

  Future<List<Tag>> getTagsByName(String name) async {
    try {
      final tags = await getTags();
      return tags.where(
        (tag) => tag.name.toLowerCase().contains(name.toLowerCase())
      ).toList();
    } catch (e) {
      throw Exception('Failed to search tags by name: $e');
    }
  }

  Future<List<Tag>> getTagsByColor(Color color) async {
    try {
      final tags = await getTags();
      return tags.where((tag) => tag.color.value == color.value).toList();
    } catch (e) {
      throw Exception('Failed to get tags by color: $e');
    }
  }

  Future<bool> isTagNameAvailable(String name, {String? excludeTagId}) async {
    try {
      final tags = await getTags();
      return !tags.any(
        (tag) => 
          tag.name.toLowerCase() == name.toLowerCase() &&
          (excludeTagId == null || tag.id != excludeTagId)
      );
    } catch (e) {
      return false;
    }
  }
}