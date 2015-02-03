library debate_form;

import 'dart:html';
import 'package:kaif_web/util.dart';
import 'package:kaif_web/model.dart';

class DebateForm {

  final ArticleService _articleService;

  Element _elem;
  Alert _alert;

  Element get elem => _elem;

  String parentDebateId;

  DebateForm.placeHolder(Element placeHolderElem,
                         ArticleService _articleService) :
  this._(placeHolderElem, _articleService);

  DebateForm._(Element placeHolderElem, this._articleService) {
    _elem = new ComponentTemplate('debate-form').createElement();
    placeHolderElem.replaceWith(_elem);

    _alert = new Alert.append(_elem);
    _elem.onSubmit.listen(_onSubmit);
  }

  void _onSubmit(Event e) {
    e
      ..preventDefault()
      ..stopPropagation();

    //TODO prompt login/registration if not login

    _alert.hide();
    TextInputElement contentInput = elem.querySelector('textarea[name=contentInput]');
    HiddenInputElement articleInput = elem.querySelector('input[name=articleInput]');
    HiddenInputElement zoneInput = elem.querySelector('input[name=zoneInput]');
    contentInput.value = contentInput.value.trim();

    //check Debate.CONTENT_MIN in java
    if (contentInput.value.length < 10) {
      _alert.renderError(i18n('debate.min-content', [10]));
      return;
    }

    SubmitButtonInputElement submit = elem.querySelector('[type=submit]');
    submit.disabled = true;

    var loading = new Loading.small()
      ..renderAfter(submit);
    _articleService.debate(zoneInput.value,
    articleInput.value,
    parentDebateId,
    contentInput.value)
    .then((_) {
      contentInput.value = '';
      elem.remove();
      new Toast.success(i18n('debate.create-success'), seconds:2).render().then((_) {
        route.reload();
      });
    }).catchError((e) {
      _alert.renderError('${e}');
    }).whenComplete(() {
      submit.disabled = false;
      loading.remove();
    });
  }

}