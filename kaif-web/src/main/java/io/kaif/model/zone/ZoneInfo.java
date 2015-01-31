package io.kaif.model.zone;

import java.time.Instant;
import java.util.Collections;
import java.util.List;
import java.util.UUID;
import java.util.regex.Pattern;

import com.google.common.base.Preconditions;

import io.kaif.model.account.Authority;

public class ZoneInfo {

  public static final String THEME_DEFAULT = "z-theme-default";

  // theme used in site related zone, like Blog or FAQ
  public static final String THEME_KAIF = "z-theme-kaif";

  //TODO unit test
  private static final Pattern ZONE_PATTERN = Pattern.compile("^[a-z0-9\\-]{3,30}$");

  public static ZoneInfo create(String zone,
      String aliasName,
      String theme,
      Authority read,
      Authority write,
      Instant now) {
    Preconditions.checkArgument(zone != null && ZONE_PATTERN.matcher(zone).matches());
    return new ZoneInfo(zone, aliasName, theme, read, write, Collections.emptyList(), now);
  }

  //zone are always lowercase and URL friendly
  private final String zone;
  //display name of zone, may include Upper case or even Chinese
  private final String aliasName;
  // css theme class name
  private final String theme;
  // which authority can see this zone
  private final Authority readAuthority;
  // which authority can write article in this zone
  private final Authority writeAuthority;
  // ZONE_ADMIN accountId
  private final List<UUID> adminAccountIds;
  private final Instant createTime;

  ZoneInfo(String zone,
      String aliasName,
      String theme,
      Authority readAuthority,
      Authority writeAuthority,
      List<UUID> adminAccountIds,
      Instant createTime) {
    this.zone = zone;
    this.aliasName = aliasName;
    this.theme = theme;
    this.readAuthority = readAuthority;
    this.writeAuthority = writeAuthority;
    this.adminAccountIds = adminAccountIds;
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

  public String getZone() {
    return zone;
  }

  public String getAliasName() {
    return aliasName;
  }

  public Authority getReadAuthority() {
    return readAuthority;
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
}
