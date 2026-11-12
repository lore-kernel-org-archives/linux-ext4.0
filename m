Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794458844;
	b=OXEDHjPBQvj6bEMGKW0WH9sjohlVe2Mx8tjaZ22D1NVMp0MoObYpU0pf43lSIa6Gifji
	 MCuRC9GLI/YvfWlyfHfl5jJbXfOZQBDR9PAlPQOGGKB8oGOCDGd3Wb3CmagGYudsNXXir
	 DRE0Yd7aUUUnmzir4jmCQTy/xA5O9g0o7bubmuZMC7njSuYGv5wGZdaACyUhvFP1hmNsg
	 zeCdios3nIiSQAOuLt6w5RwyRj76l+Qbqu7MII/RVjR0qPcO9iSdcYhglat4rIsb7xxn7
	 4I0Uyu9qLScM5cAro/8SGMe5KsuKloq5aNSAnemTBXbKDn5YnI1taHAcamv21C7EI6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794458844;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=WCdOdIPVIDRbB7zs5S0BxDq95dJdRjePOmootpL7sQE=;
	b=WVhUfXRhlXyxjLK8eqZg5i29cu3lkpCgDw89gkMcr1WEsS8TTv5a6zexcCuRE2Y9aTEA
	 6OtECgyqNZM4eE+T3NCktNOlrN+frFOkbPVtZaAxHQwpd7dWU0dKj9RLGl6i1ZAdCuTQi
	 xJsmPoIDYVrVxowqBPwpjxBehkZvcTCOJKhYMp6sMB5ut1EIvd5h2Agg2114oEEq34utt
	 MgDDoh7ob4hS79DdASbeAGAOOulZuLX4TzH6O+FVt0en4JvyCu63x9B2nQvqEUkTHTQ+U
	 TRYnOGdCkRLJS5HqrPFZrMXY+m46iN+Ps5OvlWaoXNe2j4fdHunHygB5rsIzpAYN04g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=TfTjNL4Y;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E93606A88F
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:47:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B3E93606A88F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=TfTjNL4Y
Received: from trampoline.thunk.org (pool-173-48-111-191.bstnma.fios.verizon.net [173.48.111.191])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AC4lJFW031128
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Nov 2026 23:47:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1794458840; bh=WCdOdIPVIDRbB7zs5S0BxDq95dJdRjePOmootpL7sQE=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=TfTjNL4YBMPyk6zxULHsM/urCMS2z1pTxM/850hqrWR4WEiXGUzxalNcmM5pM/q6V
	 sbMEr+YeIMZTIDFW8x1etibny+1u6bpl/B4br+TLB4aZNG/Kvvv48uLmpWOqVeg41k
	 eVR5RCAOQP1ALrWPkvLSMBlLCPYbHv7UzmmxVChuSGhp6W1NFeQHlM7g0RQELXz9+w
	 i7wVSjGUvQkc7SoRXBGIWM1gFDkOzz6Eh9Y0/sdU27RhwGuVao1xjQHsjkwEDMfA7/
	 bMJgi0oLnk2nyP6cYbJWXSc2RxGxh7ijycUim2emWYjsLDIKLw0qqu54zTGGtYWhuu
	 tUTMaJJ5rPhBA==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 2744B2E013B; Wed, 11 Nov 2026 23:47:19 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 02/23] ext4: return -EFSBADCRC when skipping a corrupt backup superblock
Date: Wed, 11 Nov 2026 23:46:51 -0500
Message-ID: <20261112044712.1577296-3-tytso@mit.edu>
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

Commit 9a8c5b0d0615 ("ext4: update the backup superblock's at the end
of the online resize") stopped setting err = -EFSBADCRC when
ext4_update_backup_sb() finds a backup superblock with an invalid
checksum, so that ext4_std_error() would not mark the file system as
corrupted.  However, it left err at 0, so the function now returns 1,
claiming that the backup superblock was successfully updated.

This makes the "Ignore bad checksum; try to update next sb" check in
ext4_update_superblocks_fn() dead code, and the skipped backup is
counted towards the two backup superblocks which are supposed to be
updated through the journal.  If one of the first backups is corrupt,
fewer than two backup superblocks get journalled updates.

Release the buffer and return -EFSBADCRC directly, bypassing
ext4_std_error(), so the caller skips the corrupt backup without
counting it and without aborting the update.

Fixes: 9a8c5b0d0615 ("ext4: update the backup superblock's at the end of the online resize")
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/ioctl-test.c | 47 ++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/ioctl.c      | 10 ++++++++--
 2 files changed, 55 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ioctl-test.c b/fs/ext4/ioctl-test.c
index ebe4a87f17e1..c3eee774bcfa 100644
--- a/fs/ext4/ioctl-test.c
+++ b/fs/ext4/ioctl-test.c
@@ -817,6 +817,52 @@ static void test_update_superblocks_and_overhead(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, ctx->sync_bh_calls, 5);
 }
 
+/*
+ * Verify that a backup superblock with an invalid checksum is reported as
+ * -EFSBADCRC (and left untouched) rather than counted as updated, and that
+ * ext4_update_superblocks_fn still updates the remaining backups.
+ */
+static void test_update_backup_sb_bad_csum(struct kunit *test)
+{
+	struct ioctl_test_ctx *ctx = test->priv;
+	struct super_block *sb = ctx->sb;
+	static const ext4_group_t good_grps[] = { 1, 5, 7 };
+	char new_label[EXT4_LABEL_MAX] = "csum_label";
+	struct ext4_super_block *bad;
+	int i;
+
+	bad = (struct ext4_super_block *)ctx->backup_sb_bufs[3];
+	bad->s_checksum = cpu_to_le32(~le32_to_cpu(bad->s_checksum));
+
+	ctx->sync_bh_calls = 0;
+	KUNIT_EXPECT_EQ(test,
+			ext4_update_backup_sb_test(sb, NULL, 3,
+						   ext4_sb_setlabel_test,
+						   new_label),
+			-EFSBADCRC);
+	KUNIT_EXPECT_EQ(test, ctx->sync_bh_calls, 0);
+	KUNIT_EXPECT_MEMNEQ(test, bad->s_volume_name, new_label,
+			    EXT4_LABEL_MAX);
+
+	/* Primary + backups 1, 5 and 7 are updated; backup 3 is skipped */
+	KUNIT_EXPECT_EQ(test,
+			ext4_update_superblocks_fn_test(sb,
+							ext4_sb_setlabel_test,
+							new_label),
+			0);
+	KUNIT_EXPECT_EQ(test, ctx->sync_bh_calls, 4);
+	KUNIT_EXPECT_MEMNEQ(test, bad->s_volume_name, new_label,
+			    EXT4_LABEL_MAX);
+	for (i = 0; i < ARRAY_SIZE(good_grps); i++) {
+		struct ext4_super_block *bes;
+
+		bes = (struct ext4_super_block *)
+			ctx->backup_sb_bufs[good_grps[i]];
+		KUNIT_EXPECT_MEMEQ(test, bes->s_volume_name, new_label,
+				   EXT4_LABEL_MAX);
+	}
+}
+
 /*
  * Verify swap_inode_data swaps i_data, i_disksize, i_size, i_version,
  * atime/mtime, and EXT4_FL_SHOULD_SWAP flags while preserving non-swapped
@@ -1191,6 +1237,7 @@ static struct kunit_case ioctl_test_cases[] = {
 	KUNIT_CASE(test_validate_tune_sb_params),
 	KUNIT_CASE(test_tune_sb_mount_opts_guard),
 	KUNIT_CASE(test_update_superblocks_and_overhead),
+	KUNIT_CASE(test_update_backup_sb_bad_csum),
 	KUNIT_CASE(test_swap_inode_data_and_seed),
 	KUNIT_CASE(test_immutable_dax_and_fileattr),
 	KUNIT_CASE(test_force_shutdown_and_ioctl_dispatch),
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 286f4a3e459a..37ad549ad693 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -110,7 +110,8 @@ int ext4_update_primary_sb(struct super_block *sb, handle_t *handle,
  *
  * Returns: 0 when no modification was done (no superblock in the group)
  *	    1 when the modification was successful
- *	   <0 on error
+ *	   <0 on error (-EFSBADCRC if the backup superblock has an invalid
+ *	      checksum and was skipped)
  */
 static int ext4_update_backup_sb(struct super_block *sb,
 				 handle_t *handle, ext4_group_t grp,
@@ -159,7 +160,12 @@ static int ext4_update_backup_sb(struct super_block *sb,
 		ext4_msg(sb, KERN_ERR, "Invalid checksum for backup "
 		"superblock %llu", sb_block);
 		unlock_buffer(bh);
-		goto out_bh;
+		/*
+		 * Let the caller skip this backup; don't report it via
+		 * ext4_std_error() since it must not abort the update.
+		 */
+		brelse(bh);
+		return -EFSBADCRC;
 	}
 	func(EXT4_SB(sb), es, arg);
 	if (ext4_has_feature_metadata_csum(sb))
-- 
2.56.0.542.g3ef89b7020-goog

