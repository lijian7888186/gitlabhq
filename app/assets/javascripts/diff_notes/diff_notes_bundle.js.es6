//= require vue
//= require vue-resource
//= require_directory ./models
//= require_directory ./stores
//= require_directory ./services
//= require_directory ./mixins
//= require_directory ./components

$(() => {
  window.DiffNotesApp = new Vue({
    el: '#diff-notes-app',
    components: {
      'resolve-btn': ResolveBtn,
      'resolve-discussion-btn': ResolveDiscussionBtn,
      'resolve-comment-btn': ResolveCommentBtn
    }
  });

  new Vue({
    el: '#resolve-count-app',
    components: {
      'resolve-count': ResolveCount
    }
  });

  window.compileVueComponentsForDiffNotes = function () {
    const $components = $('resolve-btn, resolve-discussion-btn, jump-to-discussion');
    if ($components.length) {
      $components.each(function () {
        DiffNotesApp.$compile($(this).get(0));
      });
    }
  }
});
