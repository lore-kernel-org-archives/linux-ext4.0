From: Jan Kara <jack@suse.cz>
Subject: [PATCH] Copy i_flags to ext3 inode flags on write (version 2)
Date: Tue, 17 Apr 2007 12:38:55 +0200
Message-ID: <20070417103855.GB11815@duck.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="k+w/mQv8wyuph6w0"
Cc: linux-ext4@vger.kernel.org
To: akpm@osdl.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:34086 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753362AbXDQKad (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Apr 2007 06:30:33 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

  Hi,

  attached is a second version of a patch that stores inode flags such as
S_IMMUTABLE, S_APPEND, etc. from i_flags to EXT3_I(inode)->i_flags when
inode is written to disk. The same thing is done on GETFLAGS ioctl.
  Quota code changes these flags on quota files (to make it harder for
sysadmin to screw himself) and these changes were not correctly
propagated into the filesystem (especially, lsattr did not show them and
users were wondering...). Andrew, could you please put the patch into your
queue? Thanks.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs

--k+w/mQv8wyuph6w0
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="ext3-2.6.21-rc6-propagate_flags.diff"

Propagate flags such as S_APPEND, S_IMMUTABLE, etc. from i_flags into
ext3-specific i_flags. Hence, when someone sets these flags via a different
interface than ioctl, they are stored correctly.

Signed-off-by: Jan Kara <jack@suse.cz>

diff -rupX /home/jack/.kerndiffexclude linux-2.6.21-rc6/fs/ext3/inode.c linux-2.6.21-rc6-1-ext3_flags_update/fs/ext3/inode.c
--- linux-2.6.21-rc6/fs/ext3/inode.c	2007-04-10 17:09:55.000000000 +0200
+++ linux-2.6.21-rc6-1-ext3_flags_update/fs/ext3/inode.c	2007-04-17 11:24:28.000000000 +0200
@@ -2581,6 +2581,25 @@ void ext3_set_inode_flags(struct inode *
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
@@ -2736,6 +2755,7 @@ static int ext3_do_update_inode(handle_t
 	if (ei->i_state & EXT3_STATE_NEW)
 		memset(raw_inode, 0, EXT3_SB(inode->i_sb)->s_inode_size);
 
+	ext3_get_inode_flags(ei);
 	raw_inode->i_mode = cpu_to_le16(inode->i_mode);
 	if(!(test_opt(inode->i_sb, NO_UID32))) {
 		raw_inode->i_uid_low = cpu_to_le16(low_16_bits(inode->i_uid));
diff -rupX /home/jack/.kerndiffexclude linux-2.6.21-rc6/fs/ext3/ioctl.c linux-2.6.21-rc6-1-ext3_flags_update/fs/ext3/ioctl.c
--- linux-2.6.21-rc6/fs/ext3/ioctl.c	2007-02-07 12:03:23.000000000 +0100
+++ linux-2.6.21-rc6-1-ext3_flags_update/fs/ext3/ioctl.c	2007-04-17 11:24:39.000000000 +0200
@@ -28,6 +28,7 @@ int ext3_ioctl (struct inode * inode, st
 
 	switch (cmd) {
 	case EXT3_IOC_GETFLAGS:
+		ext3_get_inode_flags(ei);
 		flags = ei->i_flags & EXT3_FL_USER_VISIBLE;
 		return put_user(flags, (int __user *) arg);
 	case EXT3_IOC_SETFLAGS: {
diff -rupX /home/jack/.kerndiffexclude linux-2.6.21-rc6/include/linux/ext3_fs.h linux-2.6.21-rc6-1-ext3_flags_update/include/linux/ext3_fs.h
--- linux-2.6.21-rc6/include/linux/ext3_fs.h	2007-04-10 17:09:58.000000000 +0200
+++ linux-2.6.21-rc6-1-ext3_flags_update/include/linux/ext3_fs.h	2007-04-17 11:25:23.000000000 +0200
@@ -824,6 +824,7 @@ extern int ext3_change_inode_journal_fla
 extern int ext3_get_inode_loc(struct inode *, struct ext3_iloc *);
 extern void ext3_truncate (struct inode *);
 extern void ext3_set_inode_flags(struct inode *);
+extern void ext3_get_inode_flags(struct ext3_inode_info *);
 extern void ext3_set_aops(struct inode *inode);
 
 /* ioctl.c */

--k+w/mQv8wyuph6w0--
