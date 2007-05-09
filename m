From: akpm@linux-foundation.org
Subject: - ext3-copy-i_flags-to-inode-flags-on-write.patch removed from -mm tree
Date: Tue, 08 May 2007 19:50:50 -0700
Message-ID: <200705090250.l492ooMj009394@shell0.pdx.osdl.net>
To: jack@suse.cz, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57664 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S970031AbXEICuz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 May 2007 22:50:55 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext3: copy i_flags to inode flags on write
has been removed from the -mm tree.  Its filename was
     ext3-copy-i_flags-to-inode-flags-on-write.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ext3: copy i_flags to inode flags on write
From: Jan Kara <jack@suse.cz>

A patch that stores inode flags such as S_IMMUTABLE, S_APPEND, etc.  from
i_flags to EXT3_I(inode)->i_flags when inode is written to disk.  The same
thing is done on GETFLAGS ioctl.

Quota code changes these flags on quota files (to make it harder for
sysadmin to screw himself) and these changes were not correctly propagated
into the filesystem (especially, lsattr did not show them and users were
wondering...).


Propagate flags such as S_APPEND, S_IMMUTABLE, etc.  from i_flags into
ext3-specific i_flags.  Hence, when someone sets these flags via a
different interface than ioctl, they are stored correctly.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/inode.c         |   20 ++++++++++++++++++++
 fs/ext3/ioctl.c         |    1 +
 include/linux/ext3_fs.h |    1 +
 3 files changed, 22 insertions(+)

diff -puN fs/ext3/inode.c~ext3-copy-i_flags-to-inode-flags-on-write fs/ext3/inode.c
--- a/fs/ext3/inode.c~ext3-copy-i_flags-to-inode-flags-on-write
+++ a/fs/ext3/inode.c
@@ -2580,6 +2580,25 @@ void ext3_set_inode_flags(struct inode *
 		inode->i_flags |= S_DIRSYNC;
 }
 
+/* Propagate flags from i_flags to EXT3_I(inode)->i_flags */
+void ext3_get_inode_flags(struct ext3_inode_info *ei)
+{
+	unsigned int flags = ei->vfs_inode.i_flags;
+
+	ei->i_flags &= ~(EXT3_SYNC_FL|EXT3_APPEND_FL|
+			EXT3_IMMUTABLE_FL|EXT3_NOATIME_FL|EXT3_DIRSYNC_FL);
+	if (flags & S_SYNC)
+		ei->i_flags |= EXT3_SYNC_FL;
+	if (flags & S_APPEND)
+		ei->i_flags |= EXT3_APPEND_FL;
+	if (flags & S_IMMUTABLE)
+		ei->i_flags |= EXT3_IMMUTABLE_FL;
+	if (flags & S_NOATIME)
+		ei->i_flags |= EXT3_NOATIME_FL;
+	if (flags & S_DIRSYNC)
+		ei->i_flags |= EXT3_DIRSYNC_FL;
+}
+
 void ext3_read_inode(struct inode * inode)
 {
 	struct ext3_iloc iloc;
@@ -2735,6 +2754,7 @@ static int ext3_do_update_inode(handle_t
 	if (ei->i_state & EXT3_STATE_NEW)
 		memset(raw_inode, 0, EXT3_SB(inode->i_sb)->s_inode_size);
 
+	ext3_get_inode_flags(ei);
 	raw_inode->i_mode = cpu_to_le16(inode->i_mode);
 	if(!(test_opt(inode->i_sb, NO_UID32))) {
 		raw_inode->i_uid_low = cpu_to_le16(low_16_bits(inode->i_uid));
diff -puN fs/ext3/ioctl.c~ext3-copy-i_flags-to-inode-flags-on-write fs/ext3/ioctl.c
--- a/fs/ext3/ioctl.c~ext3-copy-i_flags-to-inode-flags-on-write
+++ a/fs/ext3/ioctl.c
@@ -28,6 +28,7 @@ int ext3_ioctl (struct inode * inode, st
 
 	switch (cmd) {
 	case EXT3_IOC_GETFLAGS:
+		ext3_get_inode_flags(ei);
 		flags = ei->i_flags & EXT3_FL_USER_VISIBLE;
 		return put_user(flags, (int __user *) arg);
 	case EXT3_IOC_SETFLAGS: {
diff -puN include/linux/ext3_fs.h~ext3-copy-i_flags-to-inode-flags-on-write include/linux/ext3_fs.h
--- a/include/linux/ext3_fs.h~ext3-copy-i_flags-to-inode-flags-on-write
+++ a/include/linux/ext3_fs.h
@@ -824,6 +824,7 @@ extern int ext3_change_inode_journal_fla
 extern int ext3_get_inode_loc(struct inode *, struct ext3_iloc *);
 extern void ext3_truncate (struct inode *);
 extern void ext3_set_inode_flags(struct inode *);
+extern void ext3_get_inode_flags(struct ext3_inode_info *);
 extern void ext3_set_aops(struct inode *inode);
 
 /* ioctl.c */
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
ext4-copy-i_flags-to-inode-flags-on-write.patch
