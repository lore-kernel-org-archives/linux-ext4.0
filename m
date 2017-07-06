From: Miao Xie <miaoxie@huawei.com>
Subject: [PATCH 2/4] ext4: restructure ext4_expand_extra_isize
Date: Fri, 7 Jul 2017 01:09:51 +0800
Message-ID: <1499360993-17130-2-git-send-email-miaoxie@huawei.com>
References: <1499360993-17130-1-git-send-email-miaoxie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <miaoxie@huawei.com>, <tytso@mit.edu>, <lixi@ddn.com>,
        <yi.zhang@huawei.com>, <adilger@dilger.ca>, <wshilong@ddn.com>,
        <sihara@ddn.com>
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([45.249.212.188]:9359 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750942AbdGFIoM (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Jul 2017 04:44:12 -0400
In-Reply-To: <1499360993-17130-1-git-send-email-miaoxie@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Current ext4_expand_extra_isize just tries to expand extra isize, if
someone is holding xattr lock or some check fails, it will give up.
So rename its name to ext4_try_to_expand_extra_isize.

Besides that, we clean up unnecessary check and move some relative checks
into it.

Signed-off-by: Miao Xie <miaoxie@huawei.com>
Reviewed-by: Wang Shilong <wshilong@ddn.com>
---
 fs/ext4/inode.c | 67 ++++++++++++++++++++++++---------------------------------
 fs/ext4/xattr.c | 11 +++++++++-
 2 files changed, 38 insertions(+), 40 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 4af3edc..01a9340 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5632,21 +5632,35 @@ ext4_reserve_inode_write(handle_t *handle, struct inode *inode,
  * Expand an inode by new_extra_isize bytes.
  * Returns 0 on success or negative error number on failure.
  */
-static int ext4_expand_extra_isize(struct inode *inode,
-				   unsigned int new_extra_isize,
-				   struct ext4_iloc iloc,
-				   handle_t *handle)
+static int ext4_try_to_expand_extra_isize(struct inode *inode,
+					  unsigned int new_extra_isize,
+					  struct ext4_iloc iloc,
+					  handle_t *handle)
 {
 	struct ext4_inode *raw_inode;
 	struct ext4_xattr_ibody_header *header;
 	int no_expand;
 	int error;
 
-	if (EXT4_I(inode)->i_extra_isize >= new_extra_isize)
-		return 0;
+	if (ext4_test_inode_state(inode, EXT4_STATE_NO_EXPAND))
+		return -EOVERFLOW;
+
+	/*
+	 * In nojournal mode, we can immediately attempt to expand
+	 * the inode.  When journaled, we first need to obtain extra
+	 * buffer credits since we may write into the EA block
+	 * with this same handle. If journal_extend fails, then it will
+	 * only result in a minor loss of functionality for that inode.
+	 * If this is felt to be critical, then e2fsck should be run to
+	 * force a large enough s_min_extra_isize.
+	 */
+	if (ext4_handle_valid(handle) &&
+	    jbd2_journal_extend(handle,
+				EXT4_DATA_TRANS_BLOCKS(inode->i_sb)) != 0)
+		return -ENOSPC;
 
 	if (ext4_write_trylock_xattr(inode, &no_expand) == 0)
-		return 0;
+		return -EBUSY;
 
 	raw_inode = ext4_raw_inode(&iloc);
 
@@ -5673,6 +5687,7 @@ static int ext4_expand_extra_isize(struct inode *inode,
 		no_expand = 1;
 	}
 	ext4_write_unlock_xattr(inode, &no_expand);
+
 	return error;
 }
 
@@ -5693,44 +5708,18 @@ int ext4_mark_inode_dirty(handle_t *handle, struct inode *inode)
 {
 	struct ext4_iloc iloc;
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
-	static unsigned int mnt_count;
-	int err, ret;
+	int err;
 
 	might_sleep();
 	trace_ext4_mark_inode_dirty(inode, _RET_IP_);
 	err = ext4_reserve_inode_write(handle, inode, &iloc);
 	if (err)
 		return err;
-	if (EXT4_I(inode)->i_extra_isize < sbi->s_want_extra_isize &&
-	    !ext4_test_inode_state(inode, EXT4_STATE_NO_EXPAND)) {
-		/*
-		 * In nojournal mode, we can immediately attempt to expand
-		 * the inode.  When journaled, we first need to obtain extra
-		 * buffer credits since we may write into the EA block
-		 * with this same handle. If journal_extend fails, then it will
-		 * only result in a minor loss of functionality for that inode.
-		 * If this is felt to be critical, then e2fsck should be run to
-		 * force a large enough s_min_extra_isize.
-		 */
-		if (!ext4_handle_valid(handle) ||
-		    jbd2_journal_extend(handle,
-			     EXT4_DATA_TRANS_BLOCKS(inode->i_sb)) == 0) {
-			ret = ext4_expand_extra_isize(inode,
-						      sbi->s_want_extra_isize,
-						      iloc, handle);
-			if (ret) {
-				if (mnt_count !=
-					le16_to_cpu(sbi->s_es->s_mnt_count)) {
-					ext4_warning(inode->i_sb,
-					"Unable to expand inode %lu. Delete"
-					" some EAs or run e2fsck.",
-					inode->i_ino);
-					mnt_count =
-					  le16_to_cpu(sbi->s_es->s_mnt_count);
-				}
-			}
-		}
-	}
+
+	if (EXT4_I(inode)->i_extra_isize < sbi->s_want_extra_isize)
+		ext4_try_to_expand_extra_isize(inode, sbi->s_want_extra_isize,
+					       iloc, handle);
+
 	return ext4_mark_iloc_dirty(handle, inode, &iloc);
 }
 
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 12ee5fb..3c6c225 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1465,12 +1465,14 @@ int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
 {
 	struct ext4_xattr_ibody_header *header;
 	struct buffer_head *bh = NULL;
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+	static unsigned int mnt_count;
 	size_t min_offs;
 	size_t ifree, bfree;
 	int total_ino;
 	void *base, *end;
 	int error = 0, tried_min_extra_isize = 0;
-	int s_min_extra_isize = le16_to_cpu(EXT4_SB(inode->i_sb)->s_es->s_min_extra_isize);
+	int s_min_extra_isize = le16_to_cpu(sbi->s_es->s_min_extra_isize);
 	int isize_diff;	/* How much do we need to grow i_extra_isize */
 
 retry:
@@ -1558,6 +1560,13 @@ int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
 
 cleanup:
 	brelse(bh);
+
+	if (mnt_count != le16_to_cpu(sbi->s_es->s_mnt_count)) {
+		ext4_warning(inode->i_sb, "Unable to expand inode %lu. Delete some EAs or run e2fsck.",
+			     inode->i_ino);
+		mnt_count = le16_to_cpu(sbi->s_es->s_mnt_count);
+	}
+
 	return error;
 }
 
-- 
2.5.0
