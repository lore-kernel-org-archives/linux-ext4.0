Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795115856;
	b=zX1Als4uiKdXuQ2HmIxrdjl8zANmLd9aEw6Ld0tFfl+DINOU1/q75zjJitnOEFNCU1up
	 UnWGSmYgIiYmkn2vVtzfeOlLwe6xWmV6YNcPmwEgtBTt6T0tQw/CAodd2NcR8lZzGd6id
	 hF7Pgk0vq036O1dTG70qEi99fbm1kZc//lUAwvCnOyCT3mqWXtSsME63Vq34vFYizQAon
	 EPQkaFWE2wUtHwqPLuW9zMKtBrGqMzecxijAX+AHyCQOD3UAIu56Lvy6Z6UuZjcB1HlCA
	 hObDGYfK85NrhZOef0EzhRlXU+AsTntxmVmK1Dz6eQY5enp38YOo4je4d8VLM7Aom4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795115856;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=jUlW+f9+z/blNJC9YONrfV7fewSTS2RZOd/1NhhCW3I=;
	b=gBf5UPIT0U7g8coj2osXJwVq0QDqYU11hQtbfVHELuS7QY3pwOx5vbsHJz4zXpYXpuM7
	 zTX8mnOU44i/5y55HeRdsNyLkglrSlDeb0tM3p2tEcUAwHnp2PyhajlMKCJIpJSraHe0O
	 XcUEA4nqHEgCHFfmQfKJO/GJ82qmPQ/mtiQg6xrcZ8O4XhhhiNHZfn8x4fG7ZAUNkuUrh
	 qxfRA5v2wJ5LrlUHS9SBjHrH1CMok+1WX2wwn6Mrp9tmqEr2D5duITLugZ8pg8TEn02mP
	 d2vEbhFce+sMUPx1Qgf2f4/eNzw6fxJpDklX2hE/DfUAwKO3YP+1TGf7/l2+Z+TEVNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=cu1WkYYd;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34124606A33B
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 19:17:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 34124606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=cu1WkYYd
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJJHWro029866
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 14:17:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795115853; bh=jUlW+f9+z/blNJC9YONrfV7fewSTS2RZOd/1NhhCW3I=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=cu1WkYYdQ32+Zw9tBHuyydycpWEthLArcoxBgOxnPSzHlcTL/wviqkCLWgsp9CXxw
	 ew1Zeer6MLs+U3PvGi16U6O6hAaIVfuTZCtaeFOUuVF50RuZixI18acQWEo4SdIj0s
	 hMbQ/U5QgcoVeWzha+Z2M4lioDsAeFdkUibuhpeo1n+XCd8l6p+hMQ47JjuIXG31Ct
	 4NwpMjt0OOBMHQ4ejsBJxiA/UdLc9ttJsRccau/sa+KaMNVlKega9It/rL1LePHEF1
	 KcqMawZMABQ0qO743YJOQz/82NmuG4NkyVBmH1zVTp8DylcTZoxGeNG6KFDKak+47o
	 /lINuCMNgKxNw==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 29F0C2E014A; Thu, 19 Nov 2026 14:17:31 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH -v2 08/32] ext4: fix inverted err_report_sec check in ext4_update_super()
Date: Thu, 19 Nov 2026 14:16:55 -0500
Message-ID: <20261119191719.1943298-9-tytso@mit.edu>
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

When the first error is copied into the on-disk superblock,
ext4_update_super() is supposed to start the periodic error reporting
timer if it is not already running and err_report_sec is non-zero, as
the comment above the code says.  However, the check was inverted:

	if (!es->s_error_count && !sbi->s_err_report_sec)

With the default err_report_sec of 86400 the timer is therefore never
started when a clean file system records its first error, so the
"error count since last fsck" messages are not printed until the file
system is remounted.  Conversely, if the administrator disabled the
report by writing 0 to /sys/fs/ext4/<dev>/err_report_sec, the first
error arms the timer to fire immediately.

Drop the stray negation.  Also read s_err_report_sec only once, with
READ_ONCE(), since it can be changed concurrently via sysfs, so that
the value tested is the value used to arm the timer.

Fixes: d518215c2719 ("ext4: add sysfs attribute err_report_sec to control s_err_report timer")
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/super-test.c | 12 ++++++++++++
 fs/ext4/super.c      |  6 ++++--
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/super-test.c b/fs/ext4/super-test.c
index 606798ef0258..5f34a56fc219 100644
--- a/fs/ext4/super-test.c
+++ b/fs/ext4/super-test.c
@@ -1308,6 +1308,18 @@ static void test_error_recording_and_update_super(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, le32_to_cpu(es->s_checksum),
 			le32_to_cpu(ext4_superblock_csum(es)));
 
+	/* First recorded error arms the periodic error report timer */
+	KUNIT_EXPECT_TRUE(test, timer_pending(&sbi->s_err_report));
+
+	/* err_report_sec == 0 disables the timer even for a first error */
+	timer_delete_sync(&sbi->s_err_report);
+	es->s_error_count = 0;
+	sbi->s_err_report_sec = 0;
+	ext4_save_error_info_test(sb, EIO, 31, 4096, "third_fn", 333);
+	ext4_update_super_test(sb);
+	KUNIT_EXPECT_EQ(test, le32_to_cpu(es->s_error_count), 1U);
+	KUNIT_EXPECT_FALSE(test, timer_pending(&sbi->s_err_report));
+
 	/* Read-only superblock update must not touch s_wtime */
 	es->s_wtime = cpu_to_le32(123456U);
 	saved_wtime = es->s_wtime;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 880f664d6c04..6a3079c29988 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -6370,6 +6370,7 @@ static void ext4_update_super(struct super_block *sb)
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_super_block *es = sbi->s_es;
 	struct buffer_head *sbh = sbi->s_sbh;
+	unsigned long err_report_sec;
 
 	lock_buffer(sbh);
 	/*
@@ -6428,9 +6429,10 @@ static void ext4_update_super(struct super_block *sb)
 		 * Start the daily error reporting function if it hasn't been
 		 * started already and sbi->s_err_report_sec is not zero
 		 */
-		if (!es->s_error_count && !sbi->s_err_report_sec)
+		err_report_sec = READ_ONCE(sbi->s_err_report_sec);
+		if (!es->s_error_count && err_report_sec)
 			mod_timer(&sbi->s_err_report,
-					  jiffies + secs_to_jiffies(sbi->s_err_report_sec));
+				  jiffies + secs_to_jiffies(err_report_sec));
 		le32_add_cpu(&es->s_error_count, sbi->s_add_error_count);
 		sbi->s_add_error_count = 0;
 	}
-- 
2.56.1.708.g77570a6a1d-goog

