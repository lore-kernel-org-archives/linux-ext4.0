From: Tao Ma <tm@tao.ma>
Subject: [PATCH] ext4: Use proper csum calculation in ext4_rename.
Date: Fri, 22 Jun 2012 23:38:34 +0800
Message-ID: <1340379514-2838-1-git-send-email-tm@tao.ma>
Cc: "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:45450 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933193Ab2FVPix (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Jun 2012 11:38:53 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

In ext4_rename, when the old name is a dir, we need to
change ".." to its new parent and journal the change, so
with metadata_csum enabled, we have to re-calc the csum.

As the first block of the dir can be either a htree root
or a normal directory block and we have different csum
calculation for these 2 types, we have to choose the right
one in ext4_rename.

btw, it is found by xfstests 013.

Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/namei.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 5845cd9..0edaf18 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2918,8 +2918,15 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 		PARENT_INO(dir_bh->b_data, new_dir->i_sb->s_blocksize) =
 						cpu_to_le32(new_dir->i_ino);
 		BUFFER_TRACE(dir_bh, "call ext4_handle_dirty_metadata");
-		retval = ext4_handle_dirty_dirent_node(handle, old_inode,
-						       dir_bh);
+		if (is_dx(old_inode)) {
+			retval = ext4_handle_dirty_dx_node(handle,
+							   old_inode,
+							   dir_bh);
+		} else {
+			retval = ext4_handle_dirty_dirent_node(handle,
+							       old_inode,
+							       dir_bh);
+		}
 		if (retval) {
 			ext4_std_error(old_dir->i_sb, retval);
 			goto end_rename;
-- 
1.7.1

