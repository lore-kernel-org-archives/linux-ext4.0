Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CDE8C43217
	for <linux-ext4@archiver.kernel.org>; Thu, 17 Nov 2022 03:42:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234730AbiKQDmZ (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 16 Nov 2022 22:42:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234067AbiKQDmX (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Nov 2022 22:42:23 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B3A4275E2;
        Wed, 16 Nov 2022 19:42:22 -0800 (PST)
Received: from dggpeml500021.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NCQcS1bgYzqSWR;
        Thu, 17 Nov 2022 11:38:32 +0800 (CST)
Received: from huawei.com (10.175.127.227) by dggpeml500021.china.huawei.com
 (7.185.36.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 17 Nov
 2022 11:42:20 +0800
From:   Baokun Li <libaokun1@huawei.com>
To:     <linux-ext4@vger.kernel.org>
CC:     <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <jack@suse.cz>,
        <ritesh.list@gmail.com>, <linux-kernel@vger.kernel.org>,
        <yi.zhang@huawei.com>, <yukuai3@huawei.com>, <libaokun1@huawei.com>
Subject: [PATCH v3 2/3] ext4: fix corrupt backup group descriptors after online resize
Date:   Thu, 17 Nov 2022 12:03:40 +0800
Message-ID: <20221117040341.1380702-3-libaokun1@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221117040341.1380702-1-libaokun1@huawei.com>
References: <20221117040341.1380702-1-libaokun1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500021.china.huawei.com (7.185.36.21)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

In commit 9a8c5b0d0615 ("ext4: update the backup superblock's at the end
of the online resize"), it is assumed that update_backups() only updates
backup superblocks, so each b_data is treated as a backupsuper block to
update its s_block_group_nr and s_checksum. However, update_backups()
also updates the backup group descriptors, which causes the backup group
descriptors to be corrupted.

The above commit fixes the problem of invalid checksum of the backup
superblock. The root cause of this problem is that the checksum of
ext4_update_super() is not set correctly. This problem has been fixed
in the previous patch ("ext4: fix bad checksum after online resize").

However, we do need to set block_group_nr for the backup superblock in
update_backups(). When a block is in a group that contains a backup
superblock, and the block is the first block in the group, the block is
definitely a superblock. We add a helper function that includes setting
s_block_group_nr and updating checksum, and then call it only when the
above conditions are met to prevent the backup group descriptors from
being incorrectly modified.

Fixes: 9a8c5b0d0615 ("ext4: update the backup superblock's at the end of the online resize")
Signed-off-by: Baokun Li <libaokun1@huawei.com>
---
V2->V3:
    Modify the scheme and retain s_block_group_nr.

 fs/ext4/resize.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index cb99b410c9fa..66ceabbd83ad 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1110,6 +1110,16 @@ static int reserve_backup_gdb(handle_t *handle, struct inode *inode,
 	return err;
 }
 
+static inline void ext4_set_block_group_nr(struct super_block *sb, char *data,
+					   ext4_group_t group)
+{
+	struct ext4_super_block *es = (struct ext4_super_block *) data;
+
+	es->s_block_group_nr = cpu_to_le16(group);
+	if (ext4_has_metadata_csum(sb))
+		es->s_checksum = ext4_superblock_csum(sb, es);
+}
+
 /*
  * Update the backup copies of the ext4 metadata.  These don't need to be part
  * of the main resize transaction, because e2fsck will re-write them if there
@@ -1158,7 +1168,8 @@ static void update_backups(struct super_block *sb, sector_t blk_off, char *data,
 	while (group < sbi->s_groups_count) {
 		struct buffer_head *bh;
 		ext4_fsblk_t backup_block;
-		struct ext4_super_block *es;
+		int has_super = ext4_bg_has_super(sb, group);
+		ext4_fsblk_t first_block = ext4_group_first_block_no(sb, group);
 
 		/* Out of journal space, and can't get more - abort - so sad */
 		err = ext4_resize_ensure_credits_batch(handle, 1);
@@ -1168,8 +1179,7 @@ static void update_backups(struct super_block *sb, sector_t blk_off, char *data,
 		if (meta_bg == 0)
 			backup_block = ((ext4_fsblk_t)group) * bpg + blk_off;
 		else
-			backup_block = (ext4_group_first_block_no(sb, group) +
-					ext4_bg_has_super(sb, group));
+			backup_block = first_block + has_super;
 
 		bh = sb_getblk(sb, backup_block);
 		if (unlikely(!bh)) {
@@ -1187,10 +1197,8 @@ static void update_backups(struct super_block *sb, sector_t blk_off, char *data,
 		memcpy(bh->b_data, data, size);
 		if (rest)
 			memset(bh->b_data + size, 0, rest);
-		es = (struct ext4_super_block *) bh->b_data;
-		es->s_block_group_nr = cpu_to_le16(group);
-		if (ext4_has_metadata_csum(sb))
-			es->s_checksum = ext4_superblock_csum(sb, es);
+		if (has_super && (backup_block == first_block))
+			ext4_set_block_group_nr(sb, bh->b_data, group);
 		set_buffer_uptodate(bh);
 		unlock_buffer(bh);
 		err = ext4_handle_dirty_metadata(handle, NULL, bh);
-- 
2.31.1

