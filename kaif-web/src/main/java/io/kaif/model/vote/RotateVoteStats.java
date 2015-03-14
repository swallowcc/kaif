package io.kaif.model.vote;

import java.time.YearMonth;
import java.util.UUID;

import io.kaif.model.zone.Zone;

public class RotateVoteStats {
  /**
   * create monthly ranking now
   */
  public static RotateVoteStats zero(UUID accountId,
      Zone zone,
      YearMonth yearMonth,
      String username) {
    return new RotateVoteStats(accountId,
        zone,
        yearMonth.atDay(1).toString(),
        username,
        0,
        0,
        0,
        0,
        0);
  }

  private final UUID accountId;

  private final Zone zone;

  private final String bucket;

  private final String username;

  private final long debateCount;

  private final long articleCount;

  private final long articleUpVoted;

  private final long debateUpVoted;

  private final long debateDownVoted;
  private String score;

  RotateVoteStats(UUID accountId,
      Zone zone,
      String bucket,
      String username,
      long debateCount,
      long articleCount, long articleUpVoted, long debateUpVoted, long debateDownVoted) {
    this.accountId = accountId;
    this.zone = zone;
    this.bucket = bucket;
    this.username = username;
    this.debateCount = debateCount;
    this.articleCount = articleCount;
    this.articleUpVoted = articleUpVoted;
    this.debateUpVoted = debateUpVoted;
    this.debateDownVoted = debateDownVoted;
  }

  @Override
  public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (o == null || getClass() != o.getClass()) {
      return false;
    }

    RotateVoteStats that = (RotateVoteStats) o;

    if (debateCount != that.debateCount) {
      return false;
    }
    if (articleCount != that.articleCount) {
      return false;
    }
    if (articleUpVoted != that.articleUpVoted) {
      return false;
    }
    if (debateUpVoted != that.debateUpVoted) {
      return false;
    }
    if (debateDownVoted != that.debateDownVoted) {
      return false;
    }
    if (!accountId.equals(that.accountId)) {
      return false;
    }
    if (!zone.equals(that.zone)) {
      return false;
    }
    if (!bucket.equals(that.bucket)) {
      return false;
    }
    return username.equals(that.username);

  }

  @Override
  public int hashCode() {
    int result = accountId.hashCode();
    result = 31 * result + zone.hashCode();
    result = 31 * result + bucket.hashCode();
    result = 31 * result + username.hashCode();
    result = 31 * result + (int) (debateCount ^ (debateCount >>> 32));
    result = 31 * result + (int) (articleCount ^ (articleCount >>> 32));
    result = 31 * result + (int) (articleUpVoted ^ (articleUpVoted >>> 32));
    result = 31 * result + (int) (debateUpVoted ^ (debateUpVoted >>> 32));
    result = 31 * result + (int) (debateDownVoted ^ (debateDownVoted >>> 32));
    return result;
  }

  public UUID getAccountId() {
    return accountId;
  }

  public Zone getZone() {
    return zone;
  }

  public String getBucket() {
    return bucket;
  }

  public String getUsername() {
    return username;
  }

  public long getDebateCount() {
    return debateCount;
  }

  public long getArticleCount() {
    return articleCount;
  }

  public long getArticleUpVoted() {
    return articleUpVoted;
  }

  public long getDebateUpVoted() {
    return debateUpVoted;
  }

  public long getDebateDownVoted() {
    return debateDownVoted;
  }

  public long getScore() {
    return articleUpVoted + debateUpVoted - debateDownVoted;
  }
}