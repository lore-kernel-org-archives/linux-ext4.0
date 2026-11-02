Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.112
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793593498;
	b=375JWCBze+yeMzT2KXcrn3c0EFZbgAaOQPbyFzK/UDHA/s8qmUeiB0MKWYN9zTrDSaNJ
	 e5DyrqcpPriHORRR6DMcQvlJCbK8L7N5C4yyzBjRUwYNt1jOFNWQLF9yAYEc6Sz/VdHOG
	 7HpPwXb+AaTaEr1BLrDiAkePT0NwHmdn9n9sZqzc2l/e8PbF/khaQ6C/F4sgzkCEURmqB
	 FLb+ZrL23SX4Lzfo74nKbRFc1J7D82rjyG5oscILwBl7slUAp9Rx1YYMu5W/NiJyrAvle
	 N/yAlJmpUrBe7gaaxQ3bk0xpbCI8DcewRfaYy0XTs4miXW5CbI2vllByAD2Ig5EIYXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793593498;
	h=DMARC-Filter:DKIM-Signature:Mime-Version:X-Mailer:Cc:From:Date:
	 Content-Transfer-Encoding:To:Subject:Message-Id:X-Lms-Return-Path:
	 X-Original-From:Content-Type;
	bh=1SQYaIK5/066ofaBlaOZi9a4vZOf9xISb8HFkbssnA8=;
	b=ylWPl2NV0Cjrao4gQnl0lIsZFr6ptfOjIhpcdhD+noDSVM6Jzl861mhzOB/I9QlLQsgu
	 ewo1t/Rv7tFrFScliUnE6RsR4E313i6iPrM8AVFChqDYrQqzu6odUOrj/J0Egf18/5lY+
	 H4yw8F7KMqw4eNX8y4RYSn+tKrS47bFN3yAsvnb6sDTGzybp5Ske/fTqq55whyo32ThJ3
	 pFWl5E3aJJR7BVgF20GsZ3tbRwTpTuLX16mfPEdK9oO7BcWKM1n9zqH+R0OC1SoZVY2Tx
	 2hYdZ8uooQbZh9uD6AjYcdKSktuezPwERaKt3iUV5NH9Y+Navc6UWpk4prz5gTmXgJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bytedance.com;
	spf=pass smtp.mailfrom=bytedance.com;
	dkim=pass header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b="b07/MHzm";
	arc=none smtp.remote-ip=209.127.231.112
Received: from va-2-112.ptr.blmpb.com (va-2-112.ptr.blmpb.com [209.127.231.112])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A25606A324
	for <linux-ext4@vger.kernel.org>; Mon,  2 Nov 2026 04:24:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A8A25606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=b07/MHzm
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1793593491; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=1SQYaIK5/066ofaBlaOZi9a4vZOf9xISb8HFkbssnA8=;
 b=b07/MHzmsTvzq2au67LMwlLBJPxHp2RKuik0AUdtCjyqewe82q9iqTHetzbJGfaeC2qeRh
 NqsxJql+GeVVpdGTLigs76WCg9RqXiJ8dMaE0BShVL3WM0ulC1u5vCJCR+kl02QPqgujIh
 siyUHELMVZu2rtKXSB9+ImJANLNN4g6SDc3iMmWFg2ObTIMGf0htcChuFhm2kEjCKcu3Ay
 zyrJOr0cD4/gzNWkFWcKh9G7aBchDVd74uPtJT5ixiWswZfMYe72KDTMRkGJAlrzjpc2jg
 bNqsAz9FUZrJkRuAfgXTRShB6JFHArGS2z7MQ8/8GJoNAWXfptgTAC8n2spliA==
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Cc: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, 
	<libaokun@linux.alibaba.com>, <jack@suse.cz>, <ojaswin@linux.ibm.com>, 
	<ritesh.list@gmail.com>, <yi.zhang@huawei.com>, 
	<linux-kernel@vger.kernel.org>, "Zhao Gongyi" <zhaogongyi@bytedance.com>
From: "Zhao Gongyi" <zhaogongyi@bytedance.com>
Date: Mon,  2 Nov 2026 12:24:28 +0800
Content-Transfer-Encoding: 7bit
To: <linux-ext4@vger.kernel.org>
Subject: [PATCH] ext4: reject impossible group free cluster counts
Message-Id: <20261102042428.65204-1-zhaogongyi@bytedance.com>
X-Lms-Return-Path: <lba+26ae81092+dc465e+vger.kernel.org+zhaogongyi@bytedance.com>
X-Original-From: Zhao Gongyi <zhaogongyi@bytedance.com>
Content-Type: text/plain; charset=UTF-8

ext4_count_free_clusters() initializes global free-space accounting from
group descriptors. A corrupt bigalloc image advertises 201327130 free
clusters in a 32-cluster group. The mount succeeds and delayed
allocation later sees an impossible free-space total.

Reject counts above the group's cluster capacity during descriptor
validation. Reuse the existing capacity calculation so bigalloc and
short final groups use the same bound as the block bitmap.

Journal replay can overwrite a descriptor after the initial check. A
crafted transaction changes a valid count to 32769 in a 32768-cluster
group; a pre-replay-only check lets both read-only and read-write mounts
succeed. Recheck after recovery, before initializing free-space
counters. Limit the second scan to mounts needing recovery.

Apply the bound to read-only mounts too, since they use the descriptor
count for in-memory accounting.

Signed-off-by: Zhao Gongyi <zhaogongyi@bytedance.com>
---
 fs/ext4/balloc.c | 10 +++++-----
 fs/ext4/ext4.h   |  2 ++
 fs/ext4/super.c  | 38 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 45 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 778fe87..0f36630 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -159,8 +159,8 @@ static unsigned ext4_num_overhead_clusters(struct super_block *sb,
 	return num_clusters;
 }
 
-static unsigned int num_clusters_in_group(struct super_block *sb,
-					  ext4_group_t block_group)
+unsigned int ext4_num_clusters_in_group(struct super_block *sb,
+					ext4_group_t block_group)
 {
 	unsigned int blocks;
 
@@ -228,7 +228,7 @@ static int ext4_init_block_bitmap(struct super_block *sb,
 	 * the blocksize * 8 ( which is the size of bitmap ), set rest
 	 * of the block bitmap to 1
 	 */
-	ext4_mark_bitmap_end(num_clusters_in_group(sb, block_group),
+	ext4_mark_bitmap_end(ext4_num_clusters_in_group(sb, block_group),
 			     sb->s_blocksize * 8, bh->b_data);
 	return 0;
 }
@@ -240,7 +240,7 @@ unsigned ext4_free_clusters_after_init(struct super_block *sb,
 				       ext4_group_t block_group,
 				       struct ext4_group_desc *gdp)
 {
-	return num_clusters_in_group(sb, block_group) -
+	return ext4_num_clusters_in_group(sb, block_group) -
 		ext4_num_overhead_clusters(sb, block_group, gdp);
 }
 
@@ -313,7 +313,7 @@ static ext4_fsblk_t ext4_valid_block_bitmap_padding(struct super_block *sb,
 {
 	ext4_grpblk_t next_zero_bit;
 	unsigned long bitmap_size = sb->s_blocksize * 8;
-	unsigned int offset = num_clusters_in_group(sb, block_group);
+	unsigned int offset = ext4_num_clusters_in_group(sb, block_group);
 
 	if (bitmap_size <= offset)
 		return 0;
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 8d3af06..3956545 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3468,6 +3468,8 @@ extern ext4_fsblk_t ext4_inode_bitmap(struct super_block *sb,
 				      struct ext4_group_desc *bg);
 extern ext4_fsblk_t ext4_inode_table(struct super_block *sb,
 				     struct ext4_group_desc *bg);
+unsigned int ext4_num_clusters_in_group(struct super_block *sb,
+					ext4_group_t block_group);
 extern __u32 ext4_free_group_clusters(struct super_block *sb,
 				      struct ext4_group_desc *bg);
 extern __u32 ext4_free_inodes_count(struct super_block *sb,
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 7d8aedf..83e4ef6 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3355,6 +3355,36 @@ void ext4_group_desc_csum_set(struct super_block *sb, __u32 block_group,
 	gdp->bg_checksum = ext4_group_desc_csum(sb, block_group, gdp);
 }
 
+static bool ext4_check_group_free_clusters(struct super_block *sb,
+					   ext4_group_t group,
+					  struct ext4_group_desc *gdp)
+{
+	unsigned int free_clusters = ext4_free_group_clusters(sb, gdp);
+	unsigned int group_clusters = ext4_num_clusters_in_group(sb, group);
+
+	if (free_clusters > group_clusters) {
+		ext4_msg(sb, KERN_ERR,
+			 "%s: group %u has invalid free clusters count %u > %u",
+			 __func__, group, free_clusters, group_clusters);
+		return false;
+	}
+	return true;
+}
+
+static int ext4_check_replayed_free_clusters(struct super_block *sb)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	ext4_group_t group;
+
+	for (group = 0; group < sbi->s_groups_count; group++) {
+		struct ext4_group_desc *gdp = ext4_get_group_desc(sb, group, NULL);
+
+		if (!ext4_check_group_free_clusters(sb, group, gdp))
+			return -EFSCORRUPTED;
+	}
+	return 0;
+}
+
 /* Called at mount-time, super-block is locked */
 static int ext4_check_descriptors(struct super_block *sb,
 				  ext4_fsblk_t sb_block,
@@ -3467,6 +3497,8 @@ static int ext4_check_descriptors(struct super_block *sb,
 			}
 		}
 		ext4_unlock_group(sb, i);
+		if (!ext4_check_group_free_clusters(sb, i, gdp))
+			return 0;
 		if (!flexbg_flag)
 			first_block += EXT4_BLOCKS_PER_GROUP(sb);
 	}
@@ -5567,6 +5599,12 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 		err = ext4_load_and_init_journal(sb, es, ctx);
 		if (err)
 			goto failed_mount3a;
+		/* Journal replay may change descriptors after the initial check. */
+		if (needs_recovery) {
+			err = ext4_check_replayed_free_clusters(sb);
+			if (err)
+				goto failed_mount_wq;
+		}
 		if (bdev_read_only(sb->s_bdev))
 		    needs_recovery = 0;
 	} else if (test_opt(sb, NOLOAD) && !sb_rdonly(sb) &&

base-commit: 8c4f6e3376348fc3162eed86a05b933921c8f9ed
-- 
2.39.5 (Apple Git-154)
