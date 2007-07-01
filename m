From: Mingming Cao <cmm@us.ibm.com>
Subject: [EXT4 set 4][PATCH 4/5] i_version:ext4 inode version update
Date: Sun, 01 Jul 2007 03:37:45 -0400
Message-ID: <1183275465.4010.130.camel@localhost.localdomain>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, nfsv4@linux-nfs.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:36398 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756260AbXGAHhr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 1 Jul 2007 03:37:47 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch is on top of i_version_update_vfs.
The i_version field of the inode is set on inode creation and incremented when
the inode is being modified.

Signed-off-by: Jean Noel Cordenner <jean-noel.cordenner@bull.net>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>

Index: linux-2.6.22-rc4/fs/ext4/ialloc.c
===================================================================
--- linux-2.6.22-rc4.orig/fs/ext4/ialloc.c	2007-06-13 17:16:28.000000000 -0700
+++ linux-2.6.22-rc4/fs/ext4/ialloc.c	2007-06-13 17:24:45.000000000 -0700
@@ -565,6 +565,7 @@ got:
 	inode->i_blocks = 0;
 	inode->i_mtime = inode->i_atime = inode->i_ctime = ei->i_crtime =
 						       ext4_current_time(inode);
+	inode->i_version = 1;
 
 	memset(ei->i_data, 0, sizeof(ei->i_data));
 	ei->i_dir_start_lookup = 0;
Index: linux-2.6.22-rc4/fs/ext4/inode.c
===================================================================
--- linux-2.6.22-rc4.orig/fs/ext4/inode.c	2007-06-13 17:21:29.000000000 -0700
+++ linux-2.6.22-rc4/fs/ext4/inode.c	2007-06-13 17:24:45.000000000 -0700
@@ -3082,6 +3082,7 @@ int ext4_mark_iloc_dirty(handle_t *handl
 {
 	int err = 0;
 
+	inode->i_version++;
 	/* the do_update_inode consumes one bh->b_count */
 	get_bh(iloc->bh);
 
Index: linux-2.6.22-rc4/fs/ext4/super.c
===================================================================
--- linux-2.6.22-rc4.orig/fs/ext4/super.c	2007-06-13 17:19:11.000000000 -0700
+++ linux-2.6.22-rc4/fs/ext4/super.c	2007-06-13 17:24:45.000000000 -0700
@@ -2846,8 +2846,8 @@ out:
 		i_size_write(inode, off+len-towrite);
 		EXT4_I(inode)->i_disksize = inode->i_size;
 	}
-	inode->i_version++;
 	inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+	inode->i_version = 1;
 	ext4_mark_inode_dirty(handle, inode);
 	mutex_unlock(&inode->i_mutex);
 	return len - towrite;
