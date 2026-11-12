Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794458845;
	b=e+uQj1pZSgnq0tYl/dNZoN3qfJMAZvqdIoEsHIXJCc4kZp07gEe0byeDxcQYGlgoQdBe
	 b8gZnnyJ4TeS7zNJxiZ6YnDclK5+DdmhUYOXofKYXy0m1WeoIjU6IdHyMHe9AB8QaqgnG
	 Jdp3HtOVdV3FQjlChbJ0FB15LC+eQ/rtzWMJLt9BUg8xthT8IRtUVutcUPAom5cFpvsXd
	 4qGr5vqSEQfmq4aIheK2fCcCpbmZCqbcfD+5A4Bk6shPHfRAPB66hFkbiTWJgdraiwlH7
	 o/RsKjs7Q6f0WTaBtY/i5cG3zw4RAWtSbcUE/9YS7RL5vjejA177rzfa+pZyR8/djrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794458845;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=K7dgkiCb1Gt7wKOmEVhssLryrd31Lyy1dkkLE17iyZU=;
	b=TpHIw3WhLQrb9NnCACMZzL1zGnBqQgzUEjxJ/gLaW7/0Uoeeo2anDfXFpGmrgvwrSOsX
	 50Je++cwFgMyWNpvDLBCz18I0oRN5FpMh0OwpNInyLOMelFuQD2UUHopabMWPifrTcGmH
	 wM9u8XzVB+oggmmMDrpG44s5Q6x46BTjbK5F4MZ0nBCI8DkIXSxHu4mHvAqJ9ZCKEZI/c
	 xJ4wzxkYHipR5hbdEK/EOO8S1EwNYjZvKqmfLPchrVsOY7faKpe0SuWEc1FSqGkZpgq+b
	 TxVRrlt4LxmH/YfP7pDXHn1qDOcXcbNUF/e9brh0t9I1B3MQq+Q8MKx0orhvPK0EuVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=Izr4d4bZ;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36F460A2611
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:47:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C36F460A2611
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=Izr4d4bZ
Received: from trampoline.thunk.org (pool-173-48-111-191.bstnma.fios.verizon.net [173.48.111.191])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AC4lK5n031190
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Nov 2026 23:47:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1794458842; bh=K7dgkiCb1Gt7wKOmEVhssLryrd31Lyy1dkkLE17iyZU=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=Izr4d4bZCZY8LBzVaFvKG2sA6rB8rXmd9WoXhd2K508gp3AJw4niFF84d9r8mfQ8U
	 a2g/lmEuedpFO9F8i0to8KPB7LBZCKbfphjO9PtMQhRr35YDuT743AIEenBxXkSXz6
	 FjX3eGp3/2/zfOtSe4IdKZnS2xMlDVUdN5ztylPmOK/GgRg5FgKUVC56iG0lh4EtoL
	 Ws+1l1yAPJH+XsxE+ITR4PEZeetUoeUsCd3+452UTE4MmVCVlNuPopn4kOhHLe4Ass
	 j+/Z1lo5IsSSI1/KUayPiwYQdrlse7acF2aIvCSxLthcBJGjqlQmHUbsjj9Bpfx3bI
	 IXSYK+biK+WFQ==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 395FA2E014A; Wed, 11 Nov 2026 23:47:19 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 08/23] ext4: fix inverted err_report_sec check in ext4_update_super()
Date: Wed, 11 Nov 2026 23:46:57 -0500
Message-ID: <20261112044712.1577296-9-tytso@mit.edu>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261112044712.1577296-1-tytso@mit.edu>
References: <20261112044712.1577296-1-tytso@mit.edu>
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
index 3fd7a4d86f31..abd844c8c29f 100644
--- a/fs/ext4/super-test.c
+++ b/fs/ext4/super-test.c
@@ -1305,6 +1305,18 @@ static void test_error_recording_and_update_super(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, le64_to_cpu(es->s_kbytes_written), 100ULL);
 	KUNIT_EXPECT_EQ(test, es->s_checksum, ext4_superblock_csum(es));
 
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
index 6cdcae00d569..5f704c43c901 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -6302,6 +6302,7 @@ static void ext4_update_super(struct super_block *sb)
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_super_block *es = sbi->s_es;
 	struct buffer_head *sbh = sbi->s_sbh;
+	unsigned long err_report_sec;
 
 	lock_buffer(sbh);
 	/*
@@ -6360,9 +6361,10 @@ static void ext4_update_super(struct super_block *sb)
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
2.56.0.542.g3ef89b7020-goog

