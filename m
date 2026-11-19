Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795115856;
	b=Hepp+6SRDbx83l89Ex7UOnhed9svI+CkY5IeD8pFmw7N54fTI0HwA5x6/8JnFBqtrd2M
	 TqJnUx47Eg57B+1xMYtn+OxjVsAOPwRKR/TviAvnCuVEJBAdf3zL0zHgPA1UzgZBwwV+m
	 d6Dtr74oYo/yO2HbBMx0vVC1Iy6SG0ODw7ia6GGM4VyrsaOH9hlvLdGAlu5GjNk7z/iP9
	 GdFLbsYTBOR1bzayETNzS8eo5jg1grK8mno8NDDzEYavm6DYPbWMtxXx89Eqgoq2XUUpQ
	 I/ItuWcb/1sPSjdDWYyy/Ix74VI08RCDuGKVe0hIQq8+7yW7hIkyTwMXBz4DU5rvolQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795115856;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=rdT2aGVsijitO/9ca6lbPYERUZnHpj6PMn72bD9xCS4=;
	b=f5nFuzfeugTdiRmgIPfaLzYTmgj4y7Ud/2xHm67FAg4wzpBfo74TXRzWAm6FQ1yDoR4e
	 nAj6Kycv4UQowwplCepN2Tp1BDFaIdPAN0faBMoiCRHPPSBbWDF7Pw/WHj5ZV6IPBC0Cv
	 9sSM8WIEmrzfW8KrkKt9eBUR5IsqFA4JcMeA9lTjHAwlX/wZQa6xxnhjqDZV20sMugt7U
	 SyVxVm6KR2Qwe16B3pToR2g9ptqG6agwHrT2hAPx1TuHON+TqyypoL6PtlUYFYCNdW513
	 8ZwMTKNa236PUaonOYXqpkXuZ271ag0VuWegi/SH57BZo28Fj4KoeYgoCFcQVekOrCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=aU9Xvqru;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECEDD606A337
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 19:17:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ECEDD606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=aU9Xvqru
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJJHWVt029861
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 14:17:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795115853; bh=rdT2aGVsijitO/9ca6lbPYERUZnHpj6PMn72bD9xCS4=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=aU9XvqruTrUqssYYxmrJQttJHTt6ZZMg61mmlv5ho34ZeT/Oy4Uabg3fY6OVLescq
	 Fo46sdR8Amu60zywYA0gqnVE518KXopk4l4h4aXbJrR63j1v9GBMCYVDQVc81AD0nt
	 EfoHcrkXMQty+/myyEzuXiixXPqUOluR3J3dgzrJsh0idAUN/PbgNfzfVhpgmTTC6Y
	 wfdFZgUtozbUHzD4ps9bc913xpQwKT4mpyiwDXYdHiMfcP574g3vcgB9PtvXZyjJgs
	 n6t90TJryUPxIwhzoFHVPzLhdZaNb5A3l5++SMeMu146CRaXzfhK14MUPMliRbYpGz
	 4p3aM2ZPahgNw==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 2FCD62E014F; Thu, 19 Nov 2026 14:17:31 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH -v2 10/32] ext4: fix inode table accounting in count_overhead()
Date: Thu, 19 Nov 2026 14:16:57 -0500
Message-ID: <20261119191719.1943298-11-tytso@mit.edu>
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
index 5f34a56fc219..d64e0551ac46 100644
--- a/fs/ext4/super-test.c
+++ b/fs/ext4/super-test.c
@@ -1079,6 +1079,31 @@ static void test_overhead_and_statfs(struct kunit *test)
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
index f54b02650de6..3fc6c08528bd 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4309,12 +4309,23 @@ static int count_overhead(struct super_block *sb, ext4_group_t grp,
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
2.56.1.708.g77570a6a1d-goog

