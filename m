Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794458844;
	b=jpEmSlUjb48cepL9DcPZ/NkL7tm+9DY1CPqdvF+JT7Gq5eQqgjU6ksahwcS1CFWyKzdP
	 WMN7/tnszfk11OwyUgAH9mS/Z+sXNALayV5epJEkGjbCYUUlr7ayoT+jobilwnRxwNJ3Z
	 d4SX95a3j8e/G0Il8yozUmKj7lS+QgEzuQaZaAoz49yuyZRz5K8nluk/ODTGvKUNyAeDd
	 t1Ozu9hY/Mci+IcYDGCf64X9cUchNnV0bNvrEv7XNtFI/eYfX/F+UCmeqFpRyPlcMQgAx
	 p04khHETkJRRgWioyqAaBPWiB1Hgi4hFkcMG5gNht3YI41wZ8e/fp4wmYdbDlESZtJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794458844;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=cfkBvm5oX4zF11M63v5qm8AzQHPwbop9sORuXDZDCqI=;
	b=vE56YPCVB+4x7eIBKMGBo0H7XotpinnQl8hwYOdGoOAEJv2YiiuM+F3xsBXAhYVvWGTR
	 nla+2pIwjDTPscCOW+eJWx1was9P1CpiGXbBMpOCfrgAomuGXJpQgSD/QN3T7DMwe6x6v
	 6NoihbIVd/PFMzKGZDacbWoJfnBtum4gT/NqxcfwWZT6N9bbuGE+g/FjA/a1edj+U9wVJ
	 RZskCtUGsA3kJaFM+JpLcYVgVPhe6EpSVIbq/jOrgU17k9jfvW+ohgma2hBLUVGhyT4xO
	 QdSeqWwkincC5DEn+Uib5eexEMrnGRCb8yQsxLzTX2FIVTRxWE7nDg5WvKootc9I4nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=MnhiCu3U;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 413DA60A260C
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:47:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 413DA60A260C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=MnhiCu3U
Received: from trampoline.thunk.org (pool-173-48-111-191.bstnma.fios.verizon.net [173.48.111.191])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AC4lKjv031191
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Nov 2026 23:47:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1794458842; bh=cfkBvm5oX4zF11M63v5qm8AzQHPwbop9sORuXDZDCqI=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=MnhiCu3UsTMXHAKE0FRp8Ax6HqRVtY3qxW5OJMOIYvRHim95C+FkXDMR/m7q3YKqj
	 +xIaRjYe8J3VUBfh7aAW2ol7iEJWsgH50itP4N9gXFjMHc7ByZj5wNlBLWwkVm4Il5
	 rsDclVgjomx4V66co5m8JDjwhg2NLdBCBsXK4dPVu66mfQ3sc2zoYhj/SExnYS//Zt
	 namR0CcZA21n6JxpFm3u645x6b3yNDb3eeK6av+6ozx7RgD0Eszzi9+h5PNhsCV6pF
	 h28beK1NUnRsrMtxU8D+otBXfaqOYePC18b6XRhXv0Kz6MzHuMvMDIQv8yPNLyMV9O
	 ZumYfnhI0FBqw==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 3F9C52E014F; Wed, 11 Nov 2026 23:47:19 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 10/23] ext4: fix inode table accounting in count_overhead()
Date: Wed, 11 Nov 2026 23:46:59 -0500
Message-ID: <20261112044712.1577296-11-tytso@mit.edu>
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

count_overhead() computes the per-group overhead of bigalloc file
systems which do not have s_overhead_clusters set in the superblock.
It only counts a group's inode table if the whole table lies inside
the block group being examined, using

	b >= first_block && b + sbi->s_itb_per_group <= last_block

where last_block is the (inclusive) last block of the group.  This
has two problems:

 - The end check is off by one: an inode table occupying the last
   s_itb_per_group blocks of the group is not counted at all.

 - With flex_bg, mke2fs and online resize pack the inode tables of a
   flex group back to back, so an inode table can straddle the
   boundary between two block groups.  Such a table is not entirely
   contained in either group and so is not counted in either.

In both cases the overhead is underestimated, so statfs(2) reports
f_blocks (and thus the file system size and used space shown by df)
as larger than it should be.

Fix this by counting the intersection of the inode table with the
block group, which handles both cases.

Fixes: 952fc18ef9ec ("ext4: fix overhead calculation used by ext4_statfs()")
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/super-test.c | 25 +++++++++++++++++++++++++
 fs/ext4/super.c      | 15 +++++++++++++--
 2 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/super-test.c b/fs/ext4/super-test.c
index abd844c8c29f..72115c141986 100644
--- a/fs/ext4/super-test.c
+++ b/fs/ext4/super-test.c
@@ -1077,6 +1077,31 @@ static void test_overhead_and_statfs(struct kunit *test)
 	/* Cluster 0 holds super+gdb+bbitmap+ibitmap; clusters 1..2 hold itb */
 	KUNIT_EXPECT_EQ(test, ext4_count_overhead_test(sb, 0, buf), 3);
 
+	/* Inode table ending on the group's last block: clusters 254..255 */
+	ext4_inode_table_set(sb, &ctx->gdps[0], SUPER_TEST_BLOCKS_PER_GRP - 8);
+	memset(buf, 0, SUPER_TEST_BLK_SIZE);
+	KUNIT_EXPECT_EQ(test, ext4_count_overhead_test(sb, 0, buf), 3);
+
+	/*
+	 * flex_bg style layout where group 1's inode table (2044..2051)
+	 * straddles the boundary between group 1 (1024..2047) and group 2
+	 * (2048..3071); each group must count its own part of it.
+	 */
+	sbi->s_groups_count = 3;
+	ext4_inode_table_set(sb, &ctx->gdps[0], 4);
+	ext4_block_bitmap_set(sb, &ctx->gdps[1], 1028);
+	ext4_inode_bitmap_set(sb, &ctx->gdps[1], 1029);
+	ext4_inode_table_set(sb, &ctx->gdps[1], 2044);
+	ext4_block_bitmap_set(sb, &ctx->gdps[2], 2056);
+	ext4_inode_bitmap_set(sb, &ctx->gdps[2], 2057);
+	ext4_inode_table_set(sb, &ctx->gdps[2], 2060);
+	/* Group 1: super+gdb, bitmaps, and the head of its inode table */
+	memset(buf, 0, SUPER_TEST_BLK_SIZE);
+	KUNIT_EXPECT_EQ(test, ext4_count_overhead_test(sb, 1, buf), 3);
+	/* Group 2: tail of group 1's inode table, bitmaps, own inode table */
+	memset(buf, 0, SUPER_TEST_BLK_SIZE);
+	KUNIT_EXPECT_EQ(test, ext4_count_overhead_test(sb, 2, buf), 4);
+
 	/* Restore 1:1 geometry and verify ext4_statfs accounting & clamping */
 	ext4_clear_feature_bigalloc(sb);
 	ctx->es.s_first_data_block = cpu_to_le32(SUPER_TEST_FIRST_DATA_BLK);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index e89f37419266..00d430e6e794 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4266,12 +4266,23 @@ static int count_overhead(struct super_block *sb, ext4_group_t grp,
 			count++;
 		}
 		b = ext4_inode_table(sb, gdp);
-		if (b >= first_block && b + sbi->s_itb_per_group <= last_block)
-			for (j = 0; j < sbi->s_itb_per_group; j++, b++) {
+		/*
+		 * The inode table is s_itb_per_group blocks long and, with
+		 * flex_bg, may straddle a block group boundary.  Only count
+		 * the part of it which lies inside this block group.
+		 */
+		if (b <= last_block &&
+		    b + sbi->s_itb_per_group - 1 >= first_block) {
+			ext4_fsblk_t start = max(b, first_block);
+			ext4_fsblk_t end = min(b + sbi->s_itb_per_group - 1,
+					       last_block);
+
+			for (b = start; b <= end; b++) {
 				int c = EXT4_B2C(sbi, b - first_block);
 				ext4_set_bit(c, buf);
 				count++;
 			}
+		}
 		if (i != grp)
 			continue;
 		s = 0;
-- 
2.56.0.542.g3ef89b7020-goog

