library kmark_auto_linker;
import 'dart:html';
import 'dart:math' as Math;
import 'package:kaif_web/util.dart';


class KmarkAutoLinker {

  final TextAreaElement contentInput;

  static final RegExp _PURE_LINK_REGEX = new RegExp(r'^\s*(https?://[^\s]+)\s*$',
  caseSensitive:false);

  KmarkAutoLinker(this.contentInput) {
    contentInput.onPaste.listen(_onPasted);
  }

  void _onPasted(Event e) {
    //chrome/firefox/safari supported
    var items = e.clipboardData.items;
    for (var i = 0; i < items.length; i++) {
      var item = items[i];
      // debug
      // print("type: ${item.type}, kind: ${item.kind}");

      if (item.type == 'text/plain') {
        item.getAsString().then(_onTextPasted);
        break;
      }
    }
  }

  void _onTextPasted(String text) {
    //detect only pure link text
    var match = _PURE_LINK_REGEX.firstMatch(text);
    if (match == null) {
      return;
    }
    var link = match.group(1);
    if (_isLinkWithinCodeBlock(contentInput.value, link)) {
      return;
    }

    _applyAutoLink(link);
  }

  /**
   * detect pasted link is within <code> or <pre>, we count number of `fence` syntax before link text.
   * if count is odd, it means user is editing within the block. the same apply to `code` syntax
   */
  bool _isLinkWithinCodeBlock(String fullText, String link) {
    var position = fullText.indexOf(link);
    if (position < 0) {
      return false;
    }
    String textBeforeLink = fullText.substring(0, fullText.indexOf(link));
    const fence = '```';
    int fenceCount = fence.allMatches(textBeforeLink).length;
    print(fenceCount.toString());
    if (fenceCount % 2 == 1) {
      // odd number of fence, it means the link within fence block, so we won't trigger it;
      return true;
    }
    String textWithoutFence = textBeforeLink.replaceAll(fence, '');
    const code = '`';
    int codeCount = code.allMatches(textWithoutFence).length;
    if (codeCount % 2 == 1) {
      // same as fence rule
      return true;
    }
    return false;
  }

  void _applyAutoLink(String link) {
    // note that contentInput.value now include pasted text.

    // compute next appendix index
    var existRefs = ReferenceAppendix.tryParse(contentInput.value);
    // print("exist: $existRefs");
    int nextIndex = ReferenceAppendix.nextIndex(existRefs);

    // replace with placeholder and append appendix
    // note that we only search first occurrence of link, so if multiple link present.
    // the replace will be problematic.
    var placeholder = i18n("kmark.auto-link-placeholder");
    var replacedText = " [$placeholder][$nextIndex] ";
    contentInput.value = contentInput.value.replaceFirst(link, replacedText);
    if (existRefs.isEmpty) {
      contentInput.value += "\n";
    }
    contentInput.value += "\n${new ReferenceAppendix(nextIndex.toString(), link)}";

    // apply placeholder selection:
    var start = contentInput.value.indexOf(replacedText) + 2; // 2 is `space+[`
    contentInput.selectionStart = start;
    contentInput.selectionEnd = start + placeholder.length;
  }
}

/**
 * the parser support index is not number, (because server allow non-number index).
 */
class ReferenceAppendix {
  static final RegExp _LINE_PATTERN = new RegExp(r'^\s*\[([^\]]+)\]:\s*(http.+)\s*$',
  multiLine:true);
  final String index;
  final String url;

  static int nextIndex(List<ReferenceAppendix> appendixes) {
    int maxNumericIndex = appendixes.map((apx) => apx.index).map((index) {
      return int.parse(index, onError:(s) => 0);
    }).fold(0, (left, right) => Math.max(left, right));

    int maxIndex = Math.max(maxNumericIndex, appendixes.length);
    return maxIndex + 1;
  }

  static List<ReferenceAppendix> tryParse(String rawLines) {
    if (rawLines == null) {
      return [];
    }
    return _LINE_PATTERN.allMatches(rawLines).map((match) {
      return new ReferenceAppendix(match.group(1), match.group(2));
    }).toList();
  }

  ReferenceAppendix(this.index, this.url);

  String toString() => "[$index]: $url";
}