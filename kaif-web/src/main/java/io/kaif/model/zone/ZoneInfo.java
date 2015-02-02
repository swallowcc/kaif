package io.kaif.model.zone;

import java.time.Instant;
import java.util.Collections;
import java.util.List;
import java.util.Set;
import java.util.UUID;

import com.google.common.collect.ImmutableList;

import io.kaif.model.account.Authority;

/**
 * Although authorities has lots of combination, but valid cases are:
 * <p>
 * 1) default --  CITIZEN allow: upVote, downVote, write, debate
 * <p>
 * 2) kaif    --  CITIZEN allow: upVote, downVote, debate, zoneAdmin allow write
 * <p>
 * 3) kVoting --  CITIZEN allow: debate, SUFFRAGE allow upVote, zoneAdmins allow write, no downVote
 * <p>
 * 4) vote    --  CITIZEN allow: upVote, debate, zoneAdmins allow write, no downVote
 * <p>
 * CITIZEN allow up/down vote on PEOPLE, regardless ZoneInfo settings
 */
public class ZoneInfo {

  public static final String THEME_DEFAULT = "z-theme-default";

  // theme used in site related zone, like Blog or FAQ
  public static final String THEME_KAIF = "z-theme-kaif";

  public static ZoneInfo createKaif(String zoneValue, String aliasName, Instant now) {
    boolean allowDownVote = true;
    boolean hideFromTopRanking = true;
    return new ZoneInfo(Zone.valueOf(zoneValue),
        aliasName,
        THEME_KAIF,
        Authority.CITIZEN,
        Authority.CITIZEN,
        Authority.SYSOP,
        Collections.emptyList(),
        allowDownVote,
        hideFromTopRanking,
        now);
  }

  public static ZoneInfo createDefault(String zoneValue, String aliasName, Instant now) {
    boolean allowDownVote = true;
    boolean hideFromTopRanking = false;
    return new ZoneInfo(Zone.valueOf(zoneValue),
        aliasName,
        THEME_DEFAULT,
        Authority.CITIZEN,
        Authority.CITIZEN,
        Authority.CITIZEN,
        Collections.emptyList(),
        allowDownVote,
        hideFromTopRanking,
        now);
  }

  /**
   * zone are always lowercase and URL friendly
   */
  private final Zone zone;

  /**
   * display name of zone, may include Upper case or even Chinese
   */
  private final String aliasName;

  /**
   * css theme class name
   */
  private final String theme;

  /**
   * which authority can vote on this zone
   */
  private final Authority voteAuthority;

  /**
   * which authority can debate on this zone
   */
  private final Authority debateAuthority;

  /**
   * which authority can write article in this zone
   */
  private final Authority writeAuthority;

  /**
   * accountId can do everything about this zone, he ignore all authority check
   */
  private final List<UUID> adminAccountIds;

  /**
   * specify the zone is up vote only
   */
  private final boolean allowDownVote;

  /**
   * hide this zone in home page top ranking
   */
  private final boolean hideFromTop;

  private final Instant createTime;

  ZoneInfo(Zone zone,
      String aliasName,
      String theme,
      Authority voteAuthority,
      Authority debateAuthority,
      Authority writeAuthority,
      List<UUID> adminAccountIds,
      boolean allowDownVote,
      boolean hideFromTop,
      Instant createTime) {
    this.zone = zone;
    this.aliasName = aliasName;
    this.theme = theme;
    this.voteAuthority = voteAuthority;
    this.debateAuthority = debateAuthority;
    this.writeAuthority = writeAuthority;
    this.adminAccountIds = adminAccountIds;
    this.allowDownVote = allowDownVote;
    this.hideFromTop = hideFromTop;
    this.createTime = createTime;
  }

  @Override
  public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (o == null || getClass() != o.getClass()) {
      return false;
    }

    ZoneInfo zoneInfo = (ZoneInfo) o;

    if (zone != null ? !zone.equals(zoneInfo.zone) : zoneInfo.zone != null) {
      return false;
    }

    return true;
  }

  @Override
  public int hashCode() {
    return zone != null ? zone.hashCode() : 0;
  }

  public Zone getZone() {
    return zone;
  }

  public String getAliasName() {
    return aliasName;
  }

  public Authority getVoteAuthority() {
    return voteAuthority;
  }

  public String getTheme() {
    return theme;
  }

  public Authority getWriteAuthority() {
    return writeAuthority;
  }

  public List<UUID> getAdminAccountIds() {
    return adminAccountIds;
  }

  public Instant getCreateTime() {
    return createTime;
  }

  public Authority getDebateAuthority() {
    return debateAuthority;
  }

  public boolean canUpVote(UUID accountId, Set<Authority> authorities) {
    if (adminAccountIds.contains(accountId)) {
      return true;
    }
    return authorities.contains(voteAuthority);
  }

  public boolean canDebate(UUID accountId, Set<Authority> authorities) {
    if (adminAccountIds.contains(accountId)) {
      return true;
    }
    return authorities.contains(debateAuthority);
  }

  public boolean canDownVote(UUID accountId, Set<Authority> authorities) {
    if (!allowDownVote) {
      return false;
    }
    if (adminAccountIds.contains(accountId)) {
      return true;
    }
    return authorities.contains(voteAuthority);
  }

  public boolean canWriteArticle(UUID accountId, Set<Authority> authorities) {
    if (adminAccountIds.contains(accountId)) {
      return true;
    }
    return authorities.contains(writeAuthority);
  }

  public boolean isAllowDownVote() {
    return allowDownVote;
  }

  public boolean isHideFromTop() {
    return hideFromTop;
  }

  public ZoneInfo withAdmins(List<UUID> accountIds) {
    return new ZoneInfo(zone,
        aliasName,
        theme,
        voteAuthority,
        debateAuthority,
        writeAuthority,
        ImmutableList.copyOf(accountIds),
        allowDownVote,
        hideFromTop,
        createTime);
  }

  public ZoneInfo withAllowDownVote(boolean allow) {
    return new ZoneInfo(zone,
        aliasName,
        theme,
        voteAuthority,
        debateAuthority,
        writeAuthority,
        adminAccountIds,
        allow,
        hideFromTop,
        createTime);
  }

  /**
   * shortcut to zone.value()
   */
  public String getName() {
    return zone.value();
  }
}

