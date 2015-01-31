package io.kaif.model.account;

import static io.kaif.model.account.Authority.CITIZEN;
import static io.kaif.model.account.Authority.SYSOP;
import static org.junit.Assert.*;

import java.time.Duration;
import java.time.Instant;
import java.util.EnumSet;
import java.util.UUID;

import org.junit.Test;

public class AccountAccessTokenTest {

  @Test
  public void codec() throws Exception {
    AccountAccessToken accountAccessToken = new AccountAccessToken(UUID.randomUUID(),
        "pw123412356121",
        EnumSet.of(CITIZEN, SYSOP));

    AccountSecret secret = new AccountSecret();
    secret.setKey("KbKouubC8Zg8P2jsy19SMQ");
    secret.setMac("dpLIWEdghZS4XnBsHqHzRQ");
    String token = accountAccessToken.encode(Instant.now().plus(Duration.ofDays(1)), secret);
    assertTrue(token.length() > 100);
    AccountAccessToken decoded = AccountAccessToken.tryDecode(token, secret).get();
    assertEquals(accountAccessToken, decoded);
    assertEquals(EnumSet.of(SYSOP, CITIZEN), decoded.getAuthorities());

    assertFalse(AccountAccessToken.tryDecode("bad", secret).isPresent());
  }

  @Test
  public void match() throws Exception {
    AccountAccessToken accountAccessToken = new AccountAccessToken(UUID.randomUUID(),
        "pw1",
        EnumSet.of(CITIZEN, SYSOP));

    assertTrue(accountAccessToken.matches("pw1", EnumSet.of(CITIZEN, SYSOP)));
    assertTrue(accountAccessToken.matches("pw1", EnumSet.of(SYSOP, CITIZEN)));
    assertFalse(accountAccessToken.matches("pw1", EnumSet.of(CITIZEN)));
    assertFalse(accountAccessToken.matches("wrongpw1", EnumSet.of(SYSOP, CITIZEN)));
  }
}