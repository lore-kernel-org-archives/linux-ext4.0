From: Jan Kara <jack@suse.cz>
Subject: [PATCH] Copy i_flags to ext4 inode flags on write
Date: Tue, 17 Apr 2007 12:41:00 +0200
Message-ID: <20070417104100.GC11815@duck.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="5/uDoXvLw7AC5HRs"
Cc: linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:34089 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753371AbXDQKci (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Apr 2007 06:32:38 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--5/uDoXvLw7AC5HRs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

  Hi,

  attached is a port of the previous patch for ext3 to ext4.

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs

--5/uDoXvLw7AC5HRs
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="ext4-2.6.21-rc6-propagate_flags.diff"

Propagate flags such as S_APPEND, S_IMMUTABLE, etc. from i_flags into
ext4-specific i_flags. Hence, when someone sets these flags via a different
interface than ioctl, they are stored correctly.

Signed-off-by: Jan Kara <jack@suse.cz>

diff -rupX /home/jack/.kerndiffexclude linux-2.6.21-rc6-1-ext3_flags_update/fs/ext4/inode.c linux-2.6.21-rc6-2-ext4_flags_update/fs/ext4/inode.c
--- linux-2.6.21-rc6-1-ext3_flags_update/fs/ext4/inode.c	2007-04-10 17:09:55.000000000 +0200
+++ linux-2.6.21-rc6-2-ext4_flags_update/fs/ext4/inode.c	2007-04-17 12:08:54.000000000 +0200
@@ -2584,6 +2584,25 @@ void ext4_set_inode_flags(struct inode *
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
@@ -2743,6 +2762,7 @@ static int ext4_do_update_inode(handle_t
 	if (ei->i_state & EXT4_STATE_NEW)
 		memset(raw_inode, 0, EXT4_SB(inode->i_sb)->s_inode_size);
 
+	ext4_get_inode_flags(ei);
 	raw_inode->i_mode = cpu_to_le16(inode->i_mode);
 	if(!(test_opt(inode->i_sb, NO_UID32))) {
 		raw_inode->i_uid_low = cpu_to_le16(low_16_bits(inode->i_uid));
diff -rupX /home/jack/.kerndiffexclude linux-2.6.21-rc6-1-ext3_flags_update/fs/ext4/ioctl.c linux-2.6.21-rc6-2-ext4_flags_update/fs/ext4/ioctl.c
--- linux-2.6.21-rc6-1-ext3_flags_update/fs/ext4/ioctl.c	2007-02-07 12:03:23.000000000 +0100
+++ linux-2.6.21-rc6-2-ext4_flags_update/fs/ext4/ioctl.c	2007-04-17 12:09:19.000000000 +0200
@@ -28,6 +28,7 @@ int ext4_ioctl (struct inode * inode, st
 
 	switch (cmd) {
 	case EXT4_IOC_GETFLAGS:
+ 		ext4_get_inode_flags(ei);
 		flags = ei->i_flags & EXT4_FL_USER_VISIBLE;
 		return put_user(flags, (int __user *) arg);
 	case EXT4_IOC_SETFLAGS: {
diff -rupX /home/jack/.kerndiffexclude linux-2.6.21-rc6-1-ext3_flags_update/include/linux/ext4_fs.h linux-2.6.21-rc6-2-ext4_flags_update/include/linux/ext4_fs.h
--- linux-2.6.21-rc6-1-ext3_flags_update/include/linux/ext4_fs.h	2007-04-10 17:09:58.000000000 +0200
+++ linux-2.6.21-rc6-2-ext4_flags_update/include/linux/ext4_fs.h	2007-04-17 12:10:02.000000000 +0200
@@ -855,6 +855,7 @@ extern int ext4_change_inode_journal_fla
 extern int ext4_get_inode_loc(struct inode *, struct ext4_iloc *);
 extern void ext4_truncate (struct inode *);
 extern void ext4_set_inode_flags(struct inode *);
+extern void ext4_get_inode_flags(struct ext4_inode_info *);
 extern void ext4_set_aops(struct inode *inode);
 extern int ext4_writepage_trans_blocks(struct inode *);
 extern int ext4_block_truncate_page(handle_t *handle, struct page *page,

--5/uDoXvLw7AC5HRs--
