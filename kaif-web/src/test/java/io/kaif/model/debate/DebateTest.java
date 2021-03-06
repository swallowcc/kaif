package io.kaif.model.debate;

import static org.junit.Assert.*;

import java.time.Instant;

import org.junit.Test;

import io.kaif.flake.FlakeId;
import io.kaif.model.article.Article;
import io.kaif.model.zone.Zone;
import io.kaif.test.ModelFixture;

public class DebateTest implements ModelFixture {

  @Test
  public void debate_escape_content() throws Exception {

    Article article = article(Zone.valueOf("foo"), "long t1");

    String content = "pixel art is better<evil>hi</evil>";
    Debate debate = Debate.create(article,
        FlakeId.fromString("aabbccdd"),
        null,
        content,
        accountCitizen("debater1"),
        Instant.now());

    assertEquals(DebateContentType.MARK_DOWN, debate.getContentType());
    assertEquals("pixel art is better<evil>hi</evil>", debate.getContent());
    assertEquals("<p>pixel art is better&lt;evil&gt;hi&lt;/evil&gt;</p>\n",
        debate.getRenderContent());
  }

  @Test
  public void debateWithLink() throws Exception {
    Article article = article(Zone.valueOf("foo"), "title xyz");

    String content = "pixel art is better at [9gaga][1]\n\n[1]: http://www.google.com";
    Debate debate = Debate.create(article,
        FlakeId.fromString("aabbccdd"),
        null,
        content,
        accountCitizen("debater1"),
        Instant.now());

    assertEquals(
        "<p>pixel art is better at <a href=\"http://www.google.com\" class=\"reference-link\" rel=\"nofollow\" target=\"_blank\">9gaga</a><span class=\"reference-link-index\">1</span></p>\n"
            + "<div class=\"reference-appendix-block\"><div class=\"reference-appendix-index\">1</div><div  class=\"reference-appendix-wrap\"><a href=\"http://www.google.com\" rel=\"nofollow\" target=\"_blank\">http://www.google.com</a></div>\n"
            + "</div>",
        debate.getRenderContent());
  }

  @Test
  public void getShortUrlPath() throws Exception {
    Article article = article(Zone.valueOf("foo"), "title xyz");
    Debate debate = Debate.create(article,
        FlakeId.fromString("fromSum"),
        null,
        "not used",
        accountCitizen("debater1"),
        Instant.now());

    assertEquals("/d/fromSum", debate.getShortUrlPath());
  }

  @Test
  public void preview() throws Exception {
    String content = "pixel art is better at [9gaga][1]\n\n[1]: http://www.google.com";
    assertEquals(
        "<p>pixel art is better at <a href=\"http://www.google.com\" class=\"reference-link\" rel=\"nofollow\" target=\"_blank\">9gaga</a><span class=\"reference-link-index\">1</span></p>\n"
            + "<div class=\"reference-appendix-block\"><div class=\"reference-appendix-index\">1</div><div  class=\"reference-appendix-wrap\"><a href=\"http://www.google.com\" rel=\"nofollow\" target=\"_blank\">http://www.google.com</a></div>\n"
            + "</div>",
        Debate.renderContentPreview(content));
  }
}