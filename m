From: Jan Kara <jack@suse.cz>
Subject: [PATCH] Copy i_flags to ext2 inode flags on write
Date: Mon, 23 Apr 2007 20:35:54 +0200
Message-ID: <20070423183554.GB6029@duck.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="pWyiEgJYm5f9v55/"
Cc: linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:52097 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161276AbXDWS1D (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Apr 2007 14:27:03 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

  Hi,

  attached is a patch that stores i_flags to ext2 specific inode flags on
write / IOC_GETFLAGS ioctl for ext2.

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs

--pWyiEgJYm5f9v55/
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="ext2-2.6.21-rc6-propagate_flags.diff"

Propagate flags such as S_APPEND, S_IMMUTABLE, etc. from i_flags into
ext2-specific i_flags. Hence, when someone sets these flags via a different
interface than ioctl, they are stored correctly.

Signed-off-by: Jan Kara <jack@suse.cz>

diff -rupX /home/jack/.kerndiffexclude linux-2.6.21-rc6-2-ext4_flags_update/fs/ext2/ext2.h linux-2.6.21-rc6-3-ext2_flags_update/fs/ext2/ext2.h
--- linux-2.6.21-rc6-2-ext4_flags_update/fs/ext2/ext2.h	2007-04-23 18:30:41.000000000 +0200
+++ linux-2.6.21-rc6-3-ext2_flags_update/fs/ext2/ext2.h	2007-04-23 18:30:00.000000000 +0200
@@ -133,6 +133,7 @@ extern int ext2_get_block(struct inode *
 extern void ext2_truncate (struct inode *);
 extern int ext2_setattr (struct dentry *, struct iattr *);
 extern void ext2_set_inode_flags(struct inode *inode);
+extern void ext2_get_inode_flags(struct ext2_inode_info *);
 
 /* ioctl.c */
 extern int ext2_ioctl (struct inode *, struct file *, unsigned int,
diff -rupX /home/jack/.kerndiffexclude linux-2.6.21-rc6-2-ext4_flags_update/fs/ext2/inode.c linux-2.6.21-rc6-3-ext2_flags_update/fs/ext2/inode.c
--- linux-2.6.21-rc6-2-ext4_flags_update/fs/ext2/inode.c	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6.21-rc6-3-ext2_flags_update/fs/ext2/inode.c	2007-04-23 19:09:06.000000000 +0200
@@ -1055,6 +1055,25 @@ void ext2_set_inode_flags(struct inode *
 		inode->i_flags |= S_DIRSYNC;
 }
 
+/* Propagate flags from i_flags to EXT2_I(inode)->i_flags */
+void ext2_get_inode_flags(struct ext2_inode_info *ei)
+{
+	unsigned int flags = ei->vfs_inode.i_flags;
+
+	ei->i_flags &= ~(EXT2_SYNC_FL|EXT2_APPEND_FL|
+			EXT2_IMMUTABLE_FL|EXT2_NOATIME_FL|EXT2_DIRSYNC_FL);
+	if (flags & S_SYNC)
+		ei->i_flags |= EXT2_SYNC_FL;
+	if (flags & S_APPEND)
+		ei->i_flags |= EXT2_APPEND_FL;
+	if (flags & S_IMMUTABLE)
+		ei->i_flags |= EXT2_IMMUTABLE_FL;
+	if (flags & S_NOATIME)
+		ei->i_flags |= EXT2_NOATIME_FL;
+	if (flags & S_DIRSYNC)
+		ei->i_flags |= EXT2_DIRSYNC_FL;
+}
+
 void ext2_read_inode (struct inode * inode)
 {
 	struct ext2_inode_info *ei = EXT2_I(inode);
@@ -1188,6 +1207,7 @@ static int ext2_update_inode(struct inod
 	if (ei->i_state & EXT2_STATE_NEW)
 		memset(raw_inode, 0, EXT2_SB(sb)->s_inode_size);
 
+	ext2_get_inode_flags(ei);
 	raw_inode->i_mode = cpu_to_le16(inode->i_mode);
 	if (!(test_opt(sb, NO_UID32))) {
 		raw_inode->i_uid_low = cpu_to_le16(low_16_bits(uid));
diff -rupX /home/jack/.kerndiffexclude linux-2.6.21-rc6-2-ext4_flags_update/fs/ext2/ioctl.c linux-2.6.21-rc6-3-ext2_flags_update/fs/ext2/ioctl.c
--- linux-2.6.21-rc6-2-ext4_flags_update/fs/ext2/ioctl.c	2007-02-07 12:03:23.000000000 +0100
+++ linux-2.6.21-rc6-3-ext2_flags_update/fs/ext2/ioctl.c	2007-04-23 18:27:08.000000000 +0200
@@ -27,6 +27,7 @@ int ext2_ioctl (struct inode * inode, st
 
 	switch (cmd) {
 	case EXT2_IOC_GETFLAGS:
+		ext2_get_inode_flags(ei);
 		flags = ei->i_flags & EXT2_FL_USER_VISIBLE;
 		return put_user(flags, (int __user *) arg);
 	case EXT2_IOC_SETFLAGS: {

--pWyiEgJYm5f9v55/--
