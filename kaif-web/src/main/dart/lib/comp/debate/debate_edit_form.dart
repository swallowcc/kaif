library debate_edit_form;

import 'dart:html';
import 'package:kaif_web/util.dart';
import 'package:kaif_web/model.dart';
import 'package:kaif_web/comp/comp_template.dart';

/**
 * final field in library scope is lazy in dart. so the template only loaded when we
 * actually use [_debateFormTemplate]
 */
final ComponentTemplate _editDebateFormTemplate = new ComponentTemplate.take('edit-debate-form');

class DebateEditForm {

  final ArticleService _articleService;
  TextInputElement _contentInput;
  Element _elem;
  Element _contentElement;
  Element _previewer;
  Element _contentEditElem;
  Alert _alert;
  String articleId;
  String debateId;
  bool _opened = false;
  bool _previewVisible = false;

  Element get elem => _elem;

  set content(String content) {
    _contentInput.setInnerHtml(content);
  }

  DebateEditForm.placeHolder (Element contentEditElem, Element contentElement,
                              ArticleService _articleService) :
  this._(contentEditElem, contentElement, _articleService);

  DebateEditForm._ (this._contentEditElem, this._contentElement, this._articleService) {
    _elem = _editDebateFormTemplate.createElement();
    _elem.querySelector('[kmark-preview]').onClick.listen(_onPreview);
    _contentInput = _elem.querySelector('textarea[name=contentInput]');
    _previewer = elem.querySelector('[kmark-previewer]');

    _alert = new Alert.append(_elem);
    _elem.onSubmit.listen(_onSubmit);
  }

  void _onPreview(Event e) {
    e
      ..preventDefault()
      ..stopPropagation();


    if (_previewVisible) {
      _updatePreviewVisibility(false);
      _previewer.setInnerHtml('');
      return;
    }

    ButtonElement previewBtn = elem.querySelector('[kmark-preview]');
    previewBtn.disabled = true;
    var loading = new Loading.small()
      ..renderAfter(previewBtn);
    _articleService.previewDebateContent(_contentInput.value.trim())
    .then((preview) {
      _updatePreviewVisibility(true);
      unSafeInnerHtml(_previewer, preview);
    }).catchError((e) {
      _alert.renderError('${e}');
    }).whenComplete(() {
      previewBtn.disabled = false;
      loading.remove();
    });
  }

  void _onSubmit(Event e) {
    e
      ..preventDefault()
      ..stopPropagation();

    _alert.hide();
    _contentInput.value = _contentInput.value.trim();

    //check Debate.CONTENT_MIN in java
    if (_contentInput.value.length < 10) {
      _alert.renderError(i18n('debate.min-content', [10]));
      return;
    }

    SubmitButtonInputElement submit = elem.querySelector('[type=submit]');
    submit.disabled = true;

    var loading = new Loading.small()
      ..renderAfter(submit);
    _articleService.updateDebateContent(
        articleId,
        debateId,
        _contentInput.value)
    .then((content) {
      toggleShow();
      unSafeInnerHtml(_contentElement, content);
      _contentInput.setInnerHtml('');
      new Toast.success(i18n('debate.edits-success'), seconds:2).render();
    }).catchError((e) {
      _alert.renderError('${e}');
    }).whenComplete(() {
      submit.disabled = false;
      loading.remove();
    });
  }

  void toggleShow() {
    if (_opened) {
      _elem.remove();
    } else {
      _contentInput
        ..style.width = _contentElement.clientWidth.toString() + 'px'
        ..style.height = _contentElement.clientHeight.toString() + 'px';
      _contentEditElem.append(_elem);
      _updatePreviewVisibility(false);
    }
    _contentEditElem.classes.toggle('hidden', _opened);
    _contentElement.classes.toggle('hidden', !_opened);
    _opened = !_opened;
  }


  void _updatePreviewVisibility(bool previewVisible) {
    _previewVisible = previewVisible;
    _contentInput.classes.toggle('hidden', _previewVisible);
    _previewer.classes.toggle('hidden', !_previewVisible);
  }
}