From: akpm@linux-foundation.org
Subject: - ext3-ensure-link-targets-are-null-terminated.patch removed from -mm tree
Date: Mon, 15 Dec 2008 16:09:47 -0800
Message-ID: <200812160009.mBG09lC0000695@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
To: duaneg@dghda.com, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext3: ensure link targets are NULL-terminated
has been removed from the -mm tree.  Its filename was
     ext3-ensure-link-targets-are-null-terminated.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext3: ensure link targets are NULL-terminated
From: "Duane Griffin" <duaneg@dghda.com>

Ensure link targets are NUL-terminated, even if corrupted on-disk.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/inode.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/ext3/inode.c~ext3-ensure-link-targets-are-null-terminated fs/ext3/inode.c
--- a/fs/ext3/inode.c~ext3-ensure-link-targets-are-null-terminated
+++ a/fs/ext3/inode.c
@@ -2817,9 +2817,10 @@ struct inode *ext3_iget(struct super_blo
 		inode->i_op = &ext3_dir_inode_operations;
 		inode->i_fop = &ext3_dir_operations;
 	} else if (S_ISLNK(inode->i_mode)) {
-		if (ext3_inode_is_fast_symlink(inode))
+		if (ext3_inode_is_fast_symlink(inode)) {
 			inode->i_op = &ext3_fast_symlink_inode_operations;
-		else {
+			((char *) ei->i_data)[inode->i_size] = '\0';
+		} else {
 			inode->i_op = &ext3_symlink_inode_operations;
 			ext3_set_aops(inode);
 		}
_

Patches currently in -mm which might be from duaneg@dghda.com are

ext4-dont-inherit-inappropriate-inode-flags-from-parent.patch
ext4-tighten-restrictions-on-inode-flags.patch
ext2-dont-inherit-inappropriate-inode-flags-from-parent.patch
ext2-tighten-restrictions-on-inode-flags.patch
ext3-dont-inherit-inappropriate-inode-flags-from-parent.patch
ext3-tighten-restrictions-on-inode-flags.patch
ext3-ensure-link-targets-are-null-terminated.patch

