From: Jan Kara <jack@suse.cz>
Subject: [PATCH] Copy i_flags to ext3 inode flags on write
Date: Mon, 16 Apr 2007 19:05:04 +0200
Message-ID: <20070416170504.GH25785@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="mP3DRpeJDSE+ciuQ"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:36480 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030894AbXDPRFF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Apr 2007 13:05:05 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

  Hello,

  attached is a patch that stores inode flags such as S_IMMUTABLE,
S_APPEND, etc. from i_flags to EXT3_I(inode)->i_flags when inode is
written to disk. The same thing is done on GETFLAGS ioctl.
  Quota code changes these flags on quota files (to make it harder for
sysadmin to screw himself) and these changes were not correctly
propagated into the filesystem (especially, lsattr did not show them and
users were wondering...).
  If people agree that this patch is fine, I can also rediff it for
ext4.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs

--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="ext3-2.6.21-rc6-propagate_flags.diff"

Propagate flags such as S_APPEND, S_IMMUTABLE, etc. from i_flags into
ext3-specific i_flags. Hence, when someone sets these flags via a different
interface than ioctl, they are stored correctly.

Signed-off-by: Jan Kara <jack@suse.cz>

diff -rupX /home/jack/.kerndiffexclude linux-2.6.21-rc6/fs/ext3/inode.c linux-2.6.21-rc6-1-ext3_flags_update/fs/ext3/inode.c
--- linux-2.6.21-rc6/fs/ext3/inode.c	2007-04-10 17:09:55.000000000 +0200
+++ linux-2.6.21-rc6-1-ext3_flags_update/fs/ext3/inode.c	2007-04-12 18:19:29.000000000 +0200
@@ -2581,6 +2581,25 @@ void ext3_set_inode_flags(struct inode *
 		inode->i_flags |= S_DIRSYNC;
 }
 
+/* Propagate flags from i_flags to EXT3_I(inode)->i_flags */
+void ext3_get_inode_flags(struct inode *inode)
+{
+	unsigned int flags = inode->i_flags;
+
+	EXT3_I(inode)->i_flags &= ~(EXT3_SYNC_FL|EXT3_APPEND_FL|
+			EXT3_IMMUTABLE_FL|EXT3_NOATIME_FL|EXT3_DIRSYNC_FL);
+	if (flags & S_SYNC)
+		EXT3_I(inode)->i_flags |= EXT3_SYNC_FL;
+	if (flags & S_APPEND)
+		EXT3_I(inode)->i_flags |= EXT3_APPEND_FL;
+	if (flags & S_IMMUTABLE)
+		EXT3_I(inode)->i_flags |= EXT3_IMMUTABLE_FL;
+	if (flags & S_NOATIME)
+		EXT3_I(inode)->i_flags |= EXT3_NOATIME_FL;
+	if (flags & S_DIRSYNC)
+		EXT3_I(inode)->i_flags |= EXT3_DIRSYNC_FL;
+}
+
 void ext3_read_inode(struct inode * inode)
 {
 	struct ext3_iloc iloc;
@@ -2736,6 +2755,7 @@ static int ext3_do_update_inode(handle_t
 	if (ei->i_state & EXT3_STATE_NEW)
 		memset(raw_inode, 0, EXT3_SB(inode->i_sb)->s_inode_size);
 
+	ext3_get_inode_flags(inode);
 	raw_inode->i_mode = cpu_to_le16(inode->i_mode);
 	if(!(test_opt(inode->i_sb, NO_UID32))) {
 		raw_inode->i_uid_low = cpu_to_le16(low_16_bits(inode->i_uid));
diff -rupX /home/jack/.kerndiffexclude linux-2.6.21-rc6/fs/ext3/ioctl.c linux-2.6.21-rc6-1-ext3_flags_update/fs/ext3/ioctl.c
--- linux-2.6.21-rc6/fs/ext3/ioctl.c	2007-02-07 12:03:23.000000000 +0100
+++ linux-2.6.21-rc6-1-ext3_flags_update/fs/ext3/ioctl.c	2007-04-12 18:22:54.000000000 +0200
@@ -28,6 +28,7 @@ int ext3_ioctl (struct inode * inode, st
 
 	switch (cmd) {
 	case EXT3_IOC_GETFLAGS:
+		ext3_get_inode_flags(inode);
 		flags = ei->i_flags & EXT3_FL_USER_VISIBLE;
 		return put_user(flags, (int __user *) arg);
 	case EXT3_IOC_SETFLAGS: {

--mP3DRpeJDSE+ciuQ--
