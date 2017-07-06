From: Miao Xie <miaoxie@huawei.com>
Subject: [PATCH 3/4] ext4: cleanup ext4_expand_extra_isize_ea()
Date: Fri, 7 Jul 2017 01:09:52 +0800
Message-ID: <1499360993-17130-3-git-send-email-miaoxie@huawei.com>
References: <1499360993-17130-1-git-send-email-miaoxie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <miaoxie@huawei.com>, <tytso@mit.edu>, <lixi@ddn.com>,
        <yi.zhang@huawei.com>, <adilger@dilger.ca>, <wshilong@ddn.com>,
        <sihara@ddn.com>
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([45.249.212.187]:9285 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750942AbdGFIlu (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Jul 2017 04:41:50 -0400
In-Reply-To: <1499360993-17130-1-git-send-email-miaoxie@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Clean up some goto statement, make ext4_expand_extra_isize_ea() clearer.

Signed-off-by: Miao Xie <miaoxie@huawei.com>
Reviewed-by: Wang Shilong <wshilong@ddn.com>
---
 fs/ext4/xattr.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 3c6c225..73fbe4a 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1464,7 +1464,7 @@ int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
 			       struct ext4_inode *raw_inode, handle_t *handle)
 {
 	struct ext4_xattr_ibody_header *header;
-	struct buffer_head *bh = NULL;
+	struct buffer_head *bh;
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	static unsigned int mnt_count;
 	size_t min_offs;
@@ -1478,7 +1478,7 @@ int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
 retry:
 	isize_diff = new_extra_isize - EXT4_I(inode)->i_extra_isize;
 	if (EXT4_I(inode)->i_extra_isize >= new_extra_isize)
-		goto out;
+		return 0;
 
 	header = IHDR(inode, raw_inode);
 
@@ -1513,6 +1513,7 @@ int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
 			EXT4_ERROR_INODE(inode, "bad block %llu",
 					 EXT4_I(inode)->i_file_acl);
 			error = -EFSCORRUPTED;
+			brelse(bh);
 			goto cleanup;
 		}
 		base = BHDR(bh);
@@ -1520,11 +1521,11 @@ int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
 		min_offs = end - base;
 		bfree = ext4_xattr_free_space(BFIRST(bh), &min_offs, base,
 					      NULL);
+		brelse(bh);
 		if (bfree + ifree < isize_diff) {
 			if (!tried_min_extra_isize && s_min_extra_isize) {
 				tried_min_extra_isize++;
 				new_extra_isize = s_min_extra_isize;
-				brelse(bh);
 				goto retry;
 			}
 			error = -ENOSPC;
@@ -1542,7 +1543,6 @@ int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
 		    s_min_extra_isize) {
 			tried_min_extra_isize++;
 			new_extra_isize = s_min_extra_isize;
-			brelse(bh);
 			goto retry;
 		}
 		goto cleanup;
@@ -1554,14 +1554,9 @@ int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
 			EXT4_GOOD_OLD_INODE_SIZE + new_extra_isize,
 			(void *)header, total_ino);
 	EXT4_I(inode)->i_extra_isize = new_extra_isize;
-	brelse(bh);
-out:
-	return 0;
 
 cleanup:
-	brelse(bh);
