From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/2] ext4: use proper csum calculation in ext4_rename
Date: Tue, 31 Jul 2012 13:27:03 -0400
Message-ID: <1343755624-26583-1-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, Tao Ma <boyu.mt@taobao.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42314 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752353Ab2GaR1I (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 31 Jul 2012 13:27:08 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

commit ef58f69c3c34f6377f1e21d3533c806dbd980ad0 upstream.

In ext4_rename, when the old name is a dir, we need to
change ".." to its new parent and journal the change, so
with metadata_csum enabled, we have to re-calc the csum.

As the first block of the dir can be either a htree root
or a normal directory block and we have different csum
calculation for these 2 types, we have to choose the right
one in ext4_rename.

btw, it is found by xfstests 013.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Acked-by: Darrick J. Wong <djwong@us.ibm.com>
---
[ Sorry, I forgot to tag these with stable@vger.kernel.org -- Ted ]

 fs/ext4/namei.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

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
1.7.12.rc0.22.gcdd159b

