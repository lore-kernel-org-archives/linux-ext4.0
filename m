Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 014172C3266;
	Sun,  1 Mar 2026 01:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772328802; cv=none; b=mgzkfXzsXXKC99nGzs/+vGT8Zy3U/D1F3cFhqWwvEDwf0CtJxCEcGJDhm9/TbK9YjBswvbSG/edGxjQrFz4fMx5HjfXnfnDbdfVYxsuIhP+OmtPuXLXrbpDqVdioTIhCsiKoKJIvGCAd2F5eILTD/E2JX1FNB4GAfS3CkHJ+nts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772328802; c=relaxed/simple;
	bh=ora53zNAF1kww3FywVfYNYV1pDzlYcuc+wG8cHYN6YY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VCy89vRIWf7S15lv0S2PfOvyFWXNmWkQ3hYgJdxJPY7j6jvEMp2S5I9dWtcBPWOvXbQ6zsPfSCPXecVM876LlldpkXl+HEKVlgr+qaEg92440r45JFF2v6KTgPRmdYX+oZ9CIdoAjQDwLvyN8/LKLjZk0V2iTLosmPUn4eT+j0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TAb1JGN4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TAb1JGN4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E209C19421;
	Sun,  1 Mar 2026 01:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772328801;
	bh=ora53zNAF1kww3FywVfYNYV1pDzlYcuc+wG8cHYN6YY=;
	h=From:To:Cc:Subject:Date:From;
	b=TAb1JGN4bOGKe6Fs58QcnDZ90TiVtq97ciAymfUusFzF4tmrwjMX3Q4dMGgs814Ye
	 2u2GotQyUXBGQJnkQ33dVSOQcFI1ENarkgxmuDZ6Gh16uiB6tvqxTSGu9crYqSjYQi
	 XAQg0zFPZqz/D/oWjt5/ineRGIK/+o8NMSKFwm3XurQ5FK6X2lMZZKarse/5lCoWDH
	 ti+mH1Rvw/7TI5gUhyCQMJgUYdlLiSrNRAiQ3MP52TYpVb8c2zgJ3oYMOgWYIX/Khh
	 bTV4Odguzu+aqNFZPXPftnFKs5xX+PqRRDjzshaojZRMvvuy2U26CHLqDRXtCTA9xA
	 nrsfc+aemkALw==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	jack@suse.cz
Cc: Baokun Li <libaokun1@huawei.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Pedro Falcato <pfalcato@suse.de>,
	stable@kernel.org,
	Theodore Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
Subject: FAILED: Patch "ext4: always allocate blocks only from groups inode can use" failed to apply to 6.6-stable tree
Date: Sat, 28 Feb 2026 20:33:19 -0500
Message-ID: <20260301013319.1692545-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

The patch below does not apply to the 6.6-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 4865c768b563deff1b6a6384e74a62f143427b42 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Wed, 14 Jan 2026 19:28:18 +0100
Subject: [PATCH] ext4: always allocate blocks only from groups inode can use

For filesystems with more than 2^32 blocks inodes using indirect block
based format cannot use blocks beyond the 32-bit limit.
ext4_mb_scan_groups_linear() takes care to not select these unsupported
groups for such inodes however other functions selecting groups for
allocation don't. So far this is harmless because the other selection
functions are used only with mb_optimize_scan and this is currently
disabled for inodes with indirect blocks however in the following patch
we want to enable mb_optimize_scan regardless of inode format.

Reviewed-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Acked-by: Pedro Falcato <pfalcato@suse.de>
Cc: stable@kernel.org
Link: https://patch.msgid.link/20260114182836.14120-3-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/mballoc.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index dd29558ad753b..910b454b4a21e 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -892,6 +892,21 @@ mb_update_avg_fragment_size(struct super_block *sb, struct ext4_group_info *grp)
 	}
 }
 
+static ext4_group_t ext4_get_allocation_groups_count(
+				struct ext4_allocation_context *ac)
+{
+	ext4_group_t ngroups = ext4_get_groups_count(ac->ac_sb);
+
+	/* non-extent files are limited to low blocks/groups */
+	if (!(ext4_test_inode_flag(ac->ac_inode, EXT4_INODE_EXTENTS)))
+		ngroups = EXT4_SB(ac->ac_sb)->s_blockfile_groups;
+
+	/* Pairs with smp_wmb() in ext4_update_super() */
+	smp_rmb();
+
+	return ngroups;
+}
+
 static int ext4_mb_scan_groups_xa_range(struct ext4_allocation_context *ac,
 					struct xarray *xa,
 					ext4_group_t start, ext4_group_t end)
@@ -899,7 +914,7 @@ static int ext4_mb_scan_groups_xa_range(struct ext4_allocation_context *ac,
 	struct super_block *sb = ac->ac_sb;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	enum criteria cr = ac->ac_criteria;
-	ext4_group_t ngroups = ext4_get_groups_count(sb);
+	ext4_group_t ngroups = ext4_get_allocation_groups_count(ac);
 	unsigned long group = start;
 	struct ext4_group_info *grp;
 
@@ -951,7 +966,7 @@ static int ext4_mb_scan_groups_p2_aligned(struct ext4_allocation_context *ac,
 	ext4_group_t start, end;
 
 	start = group;
-	end = ext4_get_groups_count(ac->ac_sb);
+	end = ext4_get_allocation_groups_count(ac);
 wrap_around:
 	for (i = ac->ac_2order; i < MB_NUM_ORDERS(ac->ac_sb); i++) {
 		ret = ext4_mb_scan_groups_largest_free_order_range(ac, i,
@@ -1001,7 +1016,7 @@ static int ext4_mb_scan_groups_goal_fast(struct ext4_allocation_context *ac,
 	ext4_group_t start, end;
 
 	start = group;
-	end = ext4_get_groups_count(ac->ac_sb);
+	end = ext4_get_allocation_groups_count(ac);
 wrap_around:
 	i = mb_avg_fragment_size_order(ac->ac_sb, ac->ac_g_ex.fe_len);
 	for (; i < MB_NUM_ORDERS(ac->ac_sb); i++) {
@@ -1083,7 +1098,7 @@ static int ext4_mb_scan_groups_best_avail(struct ext4_allocation_context *ac,
 		min_order = fls(ac->ac_o_ex.fe_len);
 
 	start = group;
-	end = ext4_get_groups_count(ac->ac_sb);
+	end = ext4_get_allocation_groups_count(ac);
 wrap_around:
 	for (i = order; i >= min_order; i--) {
 		int frag_order;
@@ -1182,11 +1197,7 @@ static int ext4_mb_scan_groups(struct ext4_allocation_context *ac)
 	int ret = 0;
 	ext4_group_t start;
 	struct ext4_sb_info *sbi = EXT4_SB(ac->ac_sb);
-	ext4_group_t ngroups = ext4_get_groups_count(ac->ac_sb);
-
-	/* non-extent files are limited to low blocks/groups */
-	if (!(ext4_test_inode_flag(ac->ac_inode, EXT4_INODE_EXTENTS)))
-		ngroups = sbi->s_blockfile_groups;
+	ext4_group_t ngroups = ext4_get_allocation_groups_count(ac);
 
 	/* searching for the right group start from the goal value specified */
 	start = ac->ac_g_ex.fe_group;
-- 
2.51.0




