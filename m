Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795115855;
	b=wbtalRIsEHL6whsodoXNgmgEFuD1zeoN5RiGHf0KKoHWnkVKm9mg52hLtqZumVDTSGIR
	 EWWNX1uoVbycw84QvvmmUEbWyy0DDeQushlbZTBx4xXba/c3I7AjX1QqNmQpkWOgqVaWe
	 jgSTxMTLlR+K3zlaIwMs8SI7r2mYOO0Ifa89VMSU4Z7T5TqhiTu+JPCfCSp9WZLsQHz3u
	 boIORkfatLTfTmprse4KXXcUUUT5npBQbiAYyB0coOrNcOhX2GHmLSyf49iEqsKBo98r8
	 x9Vx16rAGpQGBlZRim4mj7v2pbvgEjbibTlP8PXa/RU/5Wqv703P0pyyOxxihPi3SKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795115855;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=xsa3NBf+StO4KgRcrMdpyZqcZZS54McpmDNwT+7yPI4=;
	b=SLUNvZJfRDTr/qg2x6WsHfSjRiy9RoDzoynuDr+hRSaba9rsnTKxz21agC7cgT6U0MV+
	 OqAoZA6z1PgIJpl+PZ1FRTWFF+DOCMpl1jIqqxLhM403jr4r49yUdF51f9jwEt7LT+Zes
	 WHATUYdLx8O+OtbGKyhbPki6ZWqlmyqRDMXQqRVIoxNupK6fFsLAeKXfariEJ3gq8fWcO
	 u47yPGc/VNEjABuU0GKDIylh3ydZRuDRLA8YB2GU/2b2waoyHhGZAt/a9YTaZHxKiqRjC
	 nBcHuxpxXtY+TpvnnW/+bkVTN0CYH6d95kUWmhe0WE2hDq9LNOBjs/ZBqj/zxuHj1Hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=fg+hRAoT;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E93C9606A325
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 19:17:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E93C9606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=fg+hRAoT
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJJHV0D029802
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 14:17:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795115852; bh=xsa3NBf+StO4KgRcrMdpyZqcZZS54McpmDNwT+7yPI4=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=fg+hRAoTOXS9mybBKLZhGEY8uEO565nV0WTl5w6gk9jEXwYgXGe9c4a3NH04kX5RW
	 q8EovcHWE8pmX0Mq9MgIzxK9t+KQfEcTwzK/CQVoQHPJoqZY6zgp6dqx52ZN8Y0ARV
	 nttSJA9N9aY4q78ypP1Chi+L6gODvRM3I5ZR6exmY1LduwkRgZwqjdDTU/j3DSbBSD
	 EkYZGGKs/bxRx/h9KK6VKccMWhKeNL//2qY91i6Rf+K/y8RncCp8P44nniHaOAwTmE
	 kjfgNnVvxz7Oe8GMrQF9iSJ/uM5aICUfAP80Ec+zQ4nwXGJ28Gq094DRGPg40jS9jK
	 UvQzEo/zIdj4w==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 1728F2E013B; Thu, 19 Nov 2026 14:17:31 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH -v2 02/32] ext4: return -EFSBADCRC when skipping a corrupt backup superblock
Date: Thu, 19 Nov 2026 14:16:49 -0500
Message-ID: <20261119191719.1943298-3-tytso@mit.edu>
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
index a95388a215a0..bc5e4f26ee14 100644
--- a/fs/ext4/ioctl-test.c
+++ b/fs/ext4/ioctl-test.c
@@ -829,6 +829,52 @@ static void test_update_superblocks_and_overhead(struct kunit *test)
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
@@ -1220,6 +1266,7 @@ static struct kunit_case ioctl_test_cases[] = {
 	KUNIT_CASE(test_validate_tune_sb_params),
 	KUNIT_CASE(test_tune_sb_mount_opts_guard),
 	KUNIT_CASE(test_update_superblocks_and_overhead),
+	KUNIT_CASE(test_update_backup_sb_bad_csum),
 	KUNIT_CASE(test_swap_inode_data_and_seed),
 	KUNIT_CASE(test_immutable_dax_and_fileattr),
 	KUNIT_CASE(test_force_shutdown_and_ioctl_dispatch),
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 5fdbb5133b27..78be111606e7 100644
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
2.56.1.708.g77570a6a1d-goog

