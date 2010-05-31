From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH v2.6.32.y 24/53] ext4: Code cleanup for EXT4_IOC_MOVE_EXT ioctl
Date: Sun, 30 May 2010 22:49:37 -0400
Message-ID: <1275274206-3900-24-git-send-email-tytso@mit.edu>
References: <1275274206-3900-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Akira Fujita <a-fujita@rs.jp.nec.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:44723 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755530Ab0EaCu3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 30 May 2010 22:50:29 -0400
In-Reply-To: <1275274206-3900-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Akira Fujita <a-fujita@rs.jp.nec.com>

commit c437b2733520599a2c6e0dbcdeae611319f84707 upstream (as of v2.6.33-git11)

a) Fix sparse warning in ext4_ioctl()
b) Remove unneeded variable in mext_leaf_block()
c) Fix spelling typo in mext_check_arguments()

Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/ioctl.c       |    3 ++-
 fs/ext4/move_extent.c |    4 +---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 2220feb..016d024 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -258,7 +258,8 @@ setversion_out:
 		if (me.moved_len > 0)
 			file_remove_suid(donor_filp);
 
-		if (copy_to_user((struct move_extent *)arg, &me, sizeof(me)))
+		if (copy_to_user((struct move_extent __user *)arg, 
+				 &me, sizeof(me)))
 			err = -EFAULT;
 mext_out:
 		fput(donor_filp);
diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index 2a7bb53..0362cfb 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -477,7 +477,6 @@ mext_leaf_block(handle_t *handle, struct inode *orig_inode,
 	struct ext4_extent *oext, *o_start, *o_end, *prev_ext;
 	struct ext4_extent new_ext, start_ext, end_ext;
 	ext4_lblk_t new_ext_end;
-	ext4_fsblk_t new_phys_end;
 	int oext_alen, new_ext_alen, end_ext_alen;
 	int depth = ext_depth(orig_inode);
 	int ret;
@@ -491,7 +490,6 @@ mext_leaf_block(handle_t *handle, struct inode *orig_inode,
 	new_ext.ee_len = dext->ee_len;
 	new_ext_alen = ext4_ext_get_actual_len(&new_ext);
 	new_ext_end = le32_to_cpu(new_ext.ee_block) + new_ext_alen - 1;
-	new_phys_end = ext_pblock(&new_ext) + new_ext_alen - 1;
 
 	/*
 	 * Case: original extent is first
@@ -932,7 +930,7 @@ out2:
 }
 
 /**
- * mext_check_argumants - Check whether move extent can be done
+ * mext_check_arguments - Check whether move extent can be done
  *
  * @orig_inode:		original inode
  * @donor_inode:	donor inode
-- 
1.6.6.1.1.g974db.dirty

