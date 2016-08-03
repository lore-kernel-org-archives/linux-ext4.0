From: Jan Kara <jack@suse.cz>
Subject: [PATCH 04/11] ext4: Avoid deadlock when expanding inode size
Date: Wed,  3 Aug 2016 12:39:48 +0200
Message-ID: <1470220795-17045-5-git-send-email-jack@suse.cz>
References: <1470220795-17045-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
	Jan Kara <jack@suse.cz>, stable@vger.kernel.org#4.4.x-
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52212 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757563AbcHCKkZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Aug 2016 06:40:25 -0400
In-Reply-To: <1470220795-17045-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When we need to move xattrs into external xattr block, we call
ext4_xattr_block_set() from ext4_expand_extra_isize_ea(). That may end
up calling ext4_mark_inode_dirty() again which will recurse back into
the inode expansion code leading to deadlocks.

Protect from recursion using EXT4_STATE_NO_EXPAND inode flag and move
its management into ext4_expand_extra_isize_ea() since its manipulation
is safe there (due to xattr_sem) from possible races with
ext4_xattr_set_handle() which plays with it as well.

CC: <stable@vger.kernel.org> # 4.4.x-
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c |  2 --
 fs/ext4/xattr.c | 19 +++++++++++++------
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 3131747199e1..c6ea25a190f8 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5466,8 +5466,6 @@ int ext4_mark_inode_dirty(handle_t *handle, struct inode *inode)
 						      sbi->s_want_extra_isize,
 						      iloc, handle);
 			if (ret) {
-				ext4_set_inode_state(inode,
-						     EXT4_STATE_NO_EXPAND);
 				if (mnt_count !=
 					le16_to_cpu(sbi->s_es->s_mnt_count)) {
 					ext4_warning(inode->i_sb,
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index c893f00b6dc0..2eb935ca5d9e 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1358,12 +1358,14 @@ int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
 	int isize_diff;	/* How much do we need to grow i_extra_isize */
 
 	down_write(&EXT4_I(inode)->xattr_sem);
+	/*
+	 * Set EXT4_STATE_NO_EXPAND to avoid recursion when marking inode dirty
+	 */
+	ext4_set_inode_state(inode, EXT4_STATE_NO_EXPAND);
 retry:
 	isize_diff = new_extra_isize - EXT4_I(inode)->i_extra_isize;
-	if (EXT4_I(inode)->i_extra_isize >= new_extra_isize) {
-		up_write(&EXT4_I(inode)->xattr_sem);
-		return 0;
-	}
+	if (EXT4_I(inode)->i_extra_isize >= new_extra_isize)
+		goto out;
 
 	header = IHDR(inode, raw_inode);
 	entry = IFIRST(header);
@@ -1392,8 +1394,7 @@ retry:
 				(void *)header, total_ino,
 				inode->i_sb->s_blocksize);
 		EXT4_I(inode)->i_extra_isize = new_extra_isize;
-		error = 0;
-		goto cleanup;
+		goto out;
 	}
 
 	/*
@@ -1553,6 +1554,8 @@ retry:
 		kfree(bs);
 	}
 	brelse(bh);
+out:
+	ext4_clear_inode_state(inode, EXT4_STATE_NO_EXPAND);
 	up_write(&EXT4_I(inode)->xattr_sem);
 	return 0;
 
@@ -1564,6 +1567,10 @@ cleanup:
 	kfree(is);
 	kfree(bs);
 	brelse(bh);
+	/*
+	 * We deliberately leave EXT4_STATE_NO_EXPAND set here since inode
+	 * size expansion failed.
+	 */
 	up_write(&EXT4_I(inode)->xattr_sem);
 	return error;
 }
-- 
2.6.6

