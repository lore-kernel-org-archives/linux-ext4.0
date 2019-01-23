Return-Path: <SRS0=JWl4=P7=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EAB7C282C2
	for <linux-ext4@archiver.kernel.org>; Wed, 23 Jan 2019 13:10:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD2B420855
	for <linux-ext4@archiver.kernel.org>; Wed, 23 Jan 2019 13:10:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726277AbfAWNKh (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 23 Jan 2019 08:10:37 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:2731 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726100AbfAWNKh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 23 Jan 2019 08:10:37 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 21B8394BD78F66EDF685
        for <linux-ext4@vger.kernel.org>; Wed, 23 Jan 2019 21:10:35 +0800 (CST)
Received: from RH5885H-V3.huawei.com (10.90.53.225) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.408.0; Wed, 23 Jan 2019 21:10:24 +0800
From:   yangerkun <yangerkun@huawei.com>
To:     <jack@suse.cz>
CC:     <miaoxie@huawei.com>, <yi.zhang@huawei.com>, <houtao1@huawei.com>,
        <yangerkun@huawei.com>, <linux-ext4@vger.kernel.org>
Subject: [PATCH 1/2] ext2: remove static of ext2_block_to_path
Date:   Wed, 23 Jan 2019 21:14:08 +0800
Message-ID: <20190123131409.126156-2-yangerkun@huawei.com>
X-Mailer: git-send-email 2.9.5
In-Reply-To: <20190123131409.126156-1-yangerkun@huawei.com>
References: <20190123131409.126156-1-yangerkun@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

This function will be used to get exact size in ext2_max_size future.

Signed-off-by: yangerkun <yangerkun@huawei.com>
---
 fs/ext2/ext2.h  |  1 +
 fs/ext2/inode.c | 16 ++++++++--------
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index e770cd1..86d5be1 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -772,6 +772,7 @@ extern unsigned long ext2_count_free (struct buffer_head *, unsigned);
 extern struct inode *ext2_iget (struct super_block *, unsigned long);
 extern int ext2_write_inode (struct inode *, struct writeback_control *);
 extern void ext2_evict_inode(struct inode *);
+extern int ext2_block_to_path(struct super_block *sb, long i_block, int offsets[4], int *boundary);
 extern int ext2_get_block(struct inode *, sector_t, struct buffer_head *, int);
 extern int ext2_setattr (struct dentry *, struct iattr *);
 extern void ext2_set_inode_flags(struct inode *inode);
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index e4bb938..f2833245 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -132,7 +132,6 @@ static inline int verify_chain(Indirect *from, Indirect *to)
 
 /**
  *	ext2_block_to_path - parse the block number into array of offsets
- *	@inode: inode in question (we are only interested in its superblock)
  *	@i_block: block number to be parsed
  *	@offsets: array to store the offsets in
  *      @boundary: set this non-zero if the referred-to block is likely to be
@@ -160,11 +159,11 @@ static inline int verify_chain(Indirect *from, Indirect *to)
  * get there at all.
  */
 
-static int ext2_block_to_path(struct inode *inode,
+int ext2_block_to_path(struct super_block *sb,
 			long i_block, int offsets[4], int *boundary)
 {
-	int ptrs = EXT2_ADDR_PER_BLOCK(inode->i_sb);
-	int ptrs_bits = EXT2_ADDR_PER_BLOCK_BITS(inode->i_sb);
+	int ptrs = EXT2_ADDR_PER_BLOCK(sb);
+	int ptrs_bits = EXT2_ADDR_PER_BLOCK_BITS(sb);
 	const long direct_blocks = EXT2_NDIR_BLOCKS,
 		indirect_blocks = ptrs,
 		double_blocks = (1 << (ptrs_bits * 2));
@@ -172,7 +171,7 @@ static int ext2_block_to_path(struct inode *inode,
 	int final = 0;
 
 	if (i_block < 0) {
-		ext2_msg(inode->i_sb, KERN_WARNING,
+		ext2_msg(sb, KERN_WARNING,
 			"warning: %s: block < 0", __func__);
 	} else if (i_block < direct_blocks) {
 		offsets[n++] = i_block;
@@ -193,7 +192,7 @@ static int ext2_block_to_path(struct inode *inode,
 		offsets[n++] = i_block & (ptrs - 1);
 		final = ptrs;
 	} else {
-		ext2_msg(inode->i_sb, KERN_WARNING,
+		ext2_msg(sb, KERN_WARNING,
 			"warning: %s: block is too big", __func__);
 	}
 	if (boundary)
@@ -637,7 +636,8 @@ static int ext2_get_blocks(struct inode *inode,
 
 	BUG_ON(maxblocks == 0);
 
-	depth = ext2_block_to_path(inode,iblock,offsets,&blocks_to_boundary);
+	depth = ext2_block_to_path(inode->i_sb, iblock,
+				offsets, &blocks_to_boundary);
 
 	if (depth == 0)
 		return -EIO;
@@ -1194,7 +1194,7 @@ static void __ext2_truncate_blocks(struct inode *inode, loff_t offset)
 	WARN_ON(!rwsem_is_locked(&ei->dax_sem));
 #endif
 
-	n = ext2_block_to_path(inode, iblock, offsets, NULL);
+	n = ext2_block_to_path(inode->i_sb, iblock, offsets, NULL);
 	if (n == 0)
 		return;
 
-- 
2.9.5

