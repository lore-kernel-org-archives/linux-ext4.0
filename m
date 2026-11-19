Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795115857;
	b=JiP9ahf0dDVvUutmFBWn/KTvSrxWOT8l/BkmIusg0Zhogms7mlbtljDXUGIis0WAjnOH
	 0VzDzvg5i71W7OsaZoKJzmPr7fIJGPl1Y7k9Z8RfGZ6w+dtoql7MdIdFYGMr4MPP2VHhe
	 Sw8q1NPCcujTjVHv5PvwzTgN7Clolv6ZFchxOvaSQt8Shq4Qb1CrowUIU98EqvpYlXFLs
	 61T8diW1tYzsNrOfXTYzIv0fJXIHXDakm0Hjvv20peI/JfWfBh0xs9AX64QkmFenS/CjN
	 wFMqar1JH+8siNucAZ2s3x2TXVbdnR449OXGe2byRjEjBzV+CqJtI3FV9JDrWypZ31g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795115857;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=1WtDyToimM4fv1UejkHsSZcfKFJA/qoSr5B/XDL1ia4=;
	b=wXH1L6d70Iu7bcqUIz8EZ8FCSKBcZr2XxX5hR5jxioysbp3vHQ7LyrMdkxCFcLogCCWy
	 HopyRhUz71V0246X5zkvL9lTHTkAgrJt6s62Zf8N6xsO2aMGTRTxPUayEg+JWqO6EdKhH
	 NeVrkP+6niLwvEhkCZX55l4n9HjmHWzwKDH6ANfUk5RUS0C5f2GSKEPIbAFXWe5pmxt0M
	 ReiPFMs5lQz1SMAjllw32cRnWl6u5UIi0Fla4uoX3N7x+MNEogad1xINyJ3R0uVqUF15k
	 sRBBr8qvLDV7EKvTrqBga6w3o+6ZDql5MKZ8C1k9rVEp7RdNltk6GAbTyFflNtfSQXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b="GBAf/7vQ";
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3396A60A2612
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 19:17:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3396A60A2612
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=GBAf/7vQ
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJJHYU9030001
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 14:17:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795115855; bh=1WtDyToimM4fv1UejkHsSZcfKFJA/qoSr5B/XDL1ia4=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=GBAf/7vQHboKh0k8KcEgMk4ulDLHcasGijQa9yIxdoPRZiwae8CrRLRD+kjco5G23
	 nxOCvqUnpJTnU1vrfDGJDvRxuprd72VzO6rMRBVQLua3IzPUjEEk8vXcRDCblzTlo/
	 RMsVk/7n+THiJn41M5eW2FHkVnqMHkj2PofkoQkGRMpaofJueg1A4Of9Mdg9q3+dNH
	 yAgMCtELP2HdIn/y3300cX0ZX4sSIEEMnx+pq6rL3FWYNHKRKXaRru+TF7JJOSokgl
	 b9erT7BMmsL0uEeQaS9CCvuV2VK44Ys3tQmcXQ4MAylN3xB3iz9X34LAvg/jwZWUE1
	 Nma9G/bfK0o0Q==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 781A62E0185; Thu, 19 Nov 2026 14:17:31 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH -v2 32/32] ext4: avoid zero i_dtime wrap in ialloc-test on RTC-less VMs
Date: Thu, 19 Nov 2026 14:17:19 -0500
Message-ID: <20261119191719.1943298-33-tytso@mit.edu>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261119191719.1943298-1-tytso@mit.edu>
References: <20261119191719.1943298-1-tytso@mit.edu>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On RTC-less virtual machines such as QEMU arm64, ktime_get_real_seconds()
starts at 0 on boot.  In ialloc_test_find_inode_bit() and
ialloc_test_recently_deleted(), computing (now - age) for age = 10/20/120
can evaluate to 0 if the test runs at that exact uptime second.  Because
recently_deleted() treats i_dtime == 0 as "never deleted", the test
spuriously fails when now == 10.

Add a small helper ialloc_test_past_dtime() that bumps the age by 1
second (wrapping to 0xffffffff) whenever (now - age) == 0, keeping the
timestamp in the same wrap-safe time_before32() window while guaranteeing
a non-zero on-disk i_dtime.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/ialloc-test.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/ialloc-test.c b/fs/ext4/ialloc-test.c
index fede9fd0772d..44b7d4c5bacf 100644
--- a/fs/ext4/ialloc-test.c
+++ b/fs/ext4/ialloc-test.c
@@ -1792,6 +1792,21 @@ static void ialloc_test_find_group_other_flex_bg(struct kunit *test)
  * =========================================================================
  */
 
+/*
+ * Compute a non-zero on-disk i_dtime @age seconds before @now.
+ * On RTC-less VMs (e.g., QEMU arm64) ktime_get_real_seconds() starts at 0,
+ * so (now - age) can land on 0, which recently_deleted() treats as "never
+ * deleted".  Bumping age by 1s in that case keeps it in the same window.
+ */
+static __le32 ialloc_test_past_dtime(u32 now, u32 age)
+{
+	u32 dtime = now - age;
+
+	if (!dtime)
+		dtime--;
+	return cpu_to_le32(dtime);
+}
+
 static void ialloc_test_recently_deleted(struct kunit *test)
 {
 	struct ialloc_test_ctx *ctx = test->priv;
@@ -1816,7 +1831,7 @@ static void ialloc_test_recently_deleted(struct kunit *test)
 	raw = (struct ext4_inode *)(it_slot->cache_buf +
 				    2 * IALLOC_TEST_INODE_SIZE);
 	now = ktime_get_real_seconds();
-	raw->i_dtime = cpu_to_le32(now - 10);
+	raw->i_dtime = ialloc_test_past_dtime(now, 10);
 	KUNIT_EXPECT_EQ(test, ext4_recently_deleted_test(sb, 1, 2), 0);
 
 	/* 4. Cached but !buffer_uptodate -> returns 0 */
@@ -1831,16 +1846,16 @@ static void ialloc_test_recently_deleted(struct kunit *test)
 
 	/* 6. Clean buffer uses 60s window; dirty buffer extends to 360s */
 	now = ktime_get_real_seconds();
-	raw->i_dtime = cpu_to_le32(now - 20);
+	raw->i_dtime = ialloc_test_past_dtime(now, 20);
 	KUNIT_EXPECT_EQ(test, ext4_recently_deleted_test(sb, 1, 2), 1);
 
-	raw->i_dtime = cpu_to_le32(now - 120);
+	raw->i_dtime = ialloc_test_past_dtime(now, 120);
 	KUNIT_EXPECT_EQ(test, ext4_recently_deleted_test(sb, 1, 2), 0);
 
 	set_buffer_dirty(&it_slot->bh);
 	KUNIT_EXPECT_EQ(test, ext4_recently_deleted_test(sb, 1, 2), 1);
 
-	raw->i_dtime = cpu_to_le32(now - 400);
+	raw->i_dtime = ialloc_test_past_dtime(now, 400);
 	KUNIT_EXPECT_EQ(test, ext4_recently_deleted_test(sb, 1, 2), 0);
 	clear_buffer_dirty(&it_slot->bh);
 }
@@ -1868,7 +1883,7 @@ static void ialloc_test_find_inode_bit(struct kunit *test)
 					true, true);
 	KUNIT_ASSERT_NOT_NULL(test, it_slot);
 	raw1 = (struct ext4_inode *)(it_slot->cache_buf + IALLOC_TEST_INODE_SIZE);
-	raw1->i_dtime = cpu_to_le32((u32)ktime_get_real_seconds() - 10);
+	raw1->i_dtime = ialloc_test_past_dtime(ktime_get_real_seconds(), 10);
 
 	/* No-journal mode skips recently deleted bit 1 in favor of bit 6 */
 	ino = 0;
-- 
2.56.1.708.g77570a6a1d-goog

