import 'package:flutter/material.dart';
import '../../data/models/tag_model.dart';
import '../../data/repositories/tag_repository.dart';
import './auth_provider.dart';

enum TagStatus {
  initial,
  loading,
  loaded,
  error,
}

class TagProvider with ChangeNotifier {
  final TagRepository _tagRepository;
  final AuthProvider _authProvider;

  TagProvider({
    required TagRepository tagRepository,
    required AuthProvider authProvider,
  }) : _tagRepository = tagRepository,
       _authProvider = authProvider;

  TagStatus _status = TagStatus.initial;
  List<Tag> _tags = [];
  String? _errorMessage;

  TagStatus get status => _status;
  List<Tag> get tags => _tags;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == TagStatus.loading;
  bool get isLoaded => _status == TagStatus.loaded;

  Future<void> loadTags() async {
    _setStatus(TagStatus.loading);

    try {
      _tags = await _tagRepository.getTags();
      _setStatus(TagStatus.loaded);
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> createTag(Tag tag) async {
    try {
      final newTag = await _tagRepository.createTag(tag);
      _tags.add(newTag);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> updateTag(Tag tag) async {
    try {
      final updatedTag = await _tagRepository.updateTag(tag);
      final index = _tags.indexWhere((t) => t.id == tag.id);
      if (index != -1) {
        _tags[index] = updatedTag;
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> deleteTag(String tagId) async {
    try {
      await _tagRepository.deleteTag(tagId);
      _tags.removeWhere((tag) => tag.id == tagId);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<bool> isTagNameAvailable(String name, {String? excludeTagId}) async {
    try {
      return await _tagRepository.isTagNameAvailable(name, excludeTagId: excludeTagId);
    } catch (e) {
      return false;
    }
  }

  Tag? getTagById(String tagId) {
    try {
      return _tags.firstWhere((tag) => tag.id == tagId);
    } catch (e) {
      return null;
    }
  }

  List<Tag> getTagsByName(String name) {
    return _tags.where(
      (tag) => tag.name.toLowerCase().contains(name.toLowerCase())
    ).toList();
  }

  List<Tag> getTagsByColor(Color color) {
    return _tags.where((tag) => tag.color.value == color.value).toList();
  }

  List<Tag> getTagsByIds(List<String> tagIds) {
    return _tags.where((tag) => tagIds.contains(tag.id)).toList();
  }

  List<String> getTagNames() {
    return _tags.map((tag) => tag.name).toList();
  }

  List<Color> getUsedColors() {
    return _tags.map((tag) => tag.color).toSet().toList();
  }

  bool hasTag(String tagId) {
    return _tags.any((tag) => tag.id == tagId);
  }

  int get tagCount => _tags.length;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setStatus(TagStatus status) {
    _status = status;
    if (status != TagStatus.error) {
      _errorMessage = null;
    }
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    _status = TagStatus.error;
    notifyListeners();
  }
}