From: Tao Ma <tm@tao.ma>
Subject: [PATCH] ext4: Save and restore state flags in EXT4_IOC_SETFLAGS.
Date: Fri,  4 May 2012 23:37:49 +0800
Message-ID: <1336145869-4120-1-git-send-email-tm@tao.ma>
Cc: "Theodore Ts'o" <tytso@mit.edu>, stable <stable@vger.kernel.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy9.bluehost.com ([69.89.24.6]:48437 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751227Ab2EDPiH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 May 2012 11:38:07 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

In commit 353eb83c we removes i_state_flags with 64-bit longs,
But in case we call EXT4_IOC_SETFLAGS, we fail to save the
high 32-bit state flags and only stores the low 32-bit back
to ei->i_flags. So the state flags are missing now in 64-bit
long architecture.

Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/ext4.h  |   21 +++++++++++++++++++++
 fs/ext4/ioctl.c |    3 +++
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index ebec24a..855ddba 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1345,6 +1345,16 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
 {
 	(ei)->i_state_flags = 0;
 }
+
+static inline unsigned long ext4_save_state_flags(struct ext4_inode_info *ei)
+{
+	return (ei)->i_state_flags;
+}
+
+static inline void ext4_restore_state_flags(struct ext4_inode_info *ei,
+					    unsigned long state)
+{
+}
 #else
 EXT4_INODE_BIT_FNS(state, flags, 32)
 
@@ -1352,6 +1362,17 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
 {
 	/* We depend on the fact that callers will set i_flags */
 }
+
+static inline unsigned long ext4_save_state_flags(struct ext4_inode_info *ei)
+{
+	return (ei)->i_flags >> 32;
+}
+
+static inline void ext4_restore_state_flags(struct ext4_inode_info *ei,
+					    unsigned long state)
+{
+	(ei)->i_flags |= state << 32;
+}
 #endif
 #else
 /* Assume that user mode programs are passing in an ext4fs superblock, not
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 6eee255..a2cc254 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -40,6 +40,7 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		struct ext4_iloc iloc;
 		unsigned int oldflags;
 		unsigned int jflag;
+		unsigned long state_flags;
 
 		if (!inode_owner_or_capable(inode))
 			return -EACCES;
@@ -60,6 +61,7 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			goto flags_out;
 
 		oldflags = ei->i_flags;
+		state_flags = ext4_save_state_flags(ei);
 
 		/* The JOURNAL_DATA flag is modifiable only by root */
 		jflag = flags & EXT4_JOURNAL_DATA_FL;
@@ -118,6 +120,7 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		flags = flags & EXT4_FL_USER_MODIFIABLE;
 		flags |= oldflags & ~EXT4_FL_USER_MODIFIABLE;
 		ei->i_flags = flags;
+		ext4_restore_state_flags(ei, state_flags);
 
 		ext4_set_inode_flags(inode);
 		inode->i_ctime = ext4_current_time(inode);
-- 
1.7.1

