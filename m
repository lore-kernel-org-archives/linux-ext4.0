From: Mingming Cao <cmm@us.ibm.com>
Subject: [EXT4 set 2][PATCH 1/5] cleanups: Propagate some i_flags to disk
Date: Sun, 01 Jul 2007 03:36:12 -0400
Message-ID: <1183275372.4010.120.camel@localhost.localdomain>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:57610 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756599AbXGAHgO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 1 Jul 2007 03:36:14 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Propagate flags such as S_APPEND, S_IMMUTABLE, etc. from i_flags into
ext4-specific i_flags. Hence, when someone sets these flags via a different
interface than ioctl, they are stored correctly.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>

Index: linux-2.6.22-rc4/fs/ext4/inode.c
===================================================================
--- linux-2.6.22-rc4.orig/fs/ext4/inode.c	2007-06-11 17:24:01.000000000 -0700
+++ linux-2.6.22-rc4/fs/ext4/inode.c	2007-06-11 17:24:28.000000000 -0700
@@ -2583,6 +2583,25 @@
 		inode->i_flags |= S_DIRSYNC;
 }
 
+/* Propagate flags from i_flags to EXT4_I(inode)->i_flags */
+void ext4_get_inode_flags(struct ext4_inode_info *ei)
+{
+	unsigned int flags = ei->vfs_inode.i_flags;
+
+	ei->i_flags &= ~(EXT4_SYNC_FL|EXT4_APPEND_FL|
+			EXT4_IMMUTABLE_FL|EXT4_NOATIME_FL|EXT4_DIRSYNC_FL);
+	if (flags & S_SYNC)
+		ei->i_flags |= EXT4_SYNC_FL;
+	if (flags & S_APPEND)
+		ei->i_flags |= EXT4_APPEND_FL;
+	if (flags & S_IMMUTABLE)
+		ei->i_flags |= EXT4_IMMUTABLE_FL;
+	if (flags & S_NOATIME)
+		ei->i_flags |= EXT4_NOATIME_FL;
+	if (flags & S_DIRSYNC)
+		ei->i_flags |= EXT4_DIRSYNC_FL;
+}
+
 void ext4_read_inode(struct inode * inode)
 {
 	struct ext4_iloc iloc;
@@ -2742,6 +2761,7 @@
 	if (ei->i_state & EXT4_STATE_NEW)
 		memset(raw_inode, 0, EXT4_SB(inode->i_sb)->s_inode_size);
 
+	ext4_get_inode_flags(ei);
 	raw_inode->i_mode = cpu_to_le16(inode->i_mode);
 	if(!(test_opt(inode->i_sb, NO_UID32))) {
 		raw_inode->i_uid_low = cpu_to_le16(low_16_bits(inode->i_uid));
Index: linux-2.6.22-rc4/fs/ext4/ioctl.c
===================================================================
--- linux-2.6.22-rc4.orig/fs/ext4/ioctl.c	2007-06-11 17:24:01.000000000 -0700
+++ linux-2.6.22-rc4/fs/ext4/ioctl.c	2007-06-11 17:25:11.000000000 -0700
@@ -28,6 +28,7 @@
 
 	switch (cmd) {
 	case EXT4_IOC_GETFLAGS:
+		ext4_get_inode_flags(ei);
 		flags = ei->i_flags & EXT4_FL_USER_VISIBLE;
 		return put_user(flags, (int __user *) arg);
 	case EXT4_IOC_SETFLAGS: {
Index: linux-2.6.22-rc4/include/linux/ext4_fs.h
===================================================================
--- linux-2.6.22-rc4.orig/include/linux/ext4_fs.h	2007-06-11 17:24:01.000000000 -0700
+++ linux-2.6.22-rc4/include/linux/ext4_fs.h	2007-06-11 17:24:28.000000000 -0700
@@ -862,6 +862,7 @@
 extern int ext4_get_inode_loc(struct inode *, struct ext4_iloc *);
 extern void ext4_truncate (struct inode *);
 extern void ext4_set_inode_flags(struct inode *);
+extern void ext4_get_inode_flags(struct ext4_inode_info *);
 extern void ext4_set_aops(struct inode *inode);
 extern int ext4_writepage_trans_blocks(struct inode *);
 extern int ext4_block_truncate_page(handle_t *handle, struct page *page,
