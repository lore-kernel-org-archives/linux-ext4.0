From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/3] ext4: Be more strict when verifying flags set via SETFLAGS ioctls
Date: Thu,  6 Oct 2016 13:04:33 +0200
Message-ID: <1475751874-32114-3-git-send-email-jack@suse.cz>
References: <1475751874-32114-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53650 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752869AbcJFLEi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 6 Oct 2016 07:04:38 -0400
In-Reply-To: <1475751874-32114-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently we just silently ignore flags that we don't understand (or
that cannot be manipulated) through EXT4_IOC_SETFLAGS and
EXT4_IOC_FSSETXATTR ioctls. This makes it problematic for the unused
flags to be used in future (some app may be inadvertedly setting them
and we won't notice until the flag gets used). Also this is inconsistent
with other filesystems like XFS or BTRFS which return EOPNOTSUPP when
they see a flag they cannot set.

ext4 has the additional problem that there are flags which are returned
by EXT4_IOC_GETFLAGS ioctl but which cannot be modified via
EXT4_IOC_SETFLAGS. So we have to be careful to ignore value of these
flags and not fail the ioctl when they are set (as e.g. chattr(1) passes
flags returned from EXT4_IOC_GETFLAGS to EXT4_IOC_SETFLAGS without any
masking and thus we'd break this utility).

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4.h  |  1 +
 fs/ext4/ioctl.c | 28 +++++++++++++++++++++++-----
 2 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 0814c9570bf1..2874957e3ee2 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -395,6 +395,7 @@ struct flex_groups {
 #define EXT4_FL_USER_VISIBLE		0x304BDFFF /* User visible flags */
 #define EXT4_FL_USER_MODIFIABLE		0x204BC0FF /* User modifiable flags */
 
+/* Flags we can manipulate with through EXT4_IOC_FSSETXATTR */
 #define EXT4_FL_XFLAG_VISIBLE		(EXT4_SYNC_FL | \
 					 EXT4_IMMUTABLE_FL | \
 					 EXT4_APPEND_FL | \
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index e9433c155454..33af924fa7c4 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -415,6 +415,10 @@ static inline __u32 ext4_iflags_to_xflags(unsigned long iflags)
 	return xflags;
 }
 
+#define EXT4_SUPPORTED_FS_XFLAGS (FS_XFLAG_SYNC | FS_XFLAG_IMMUTABLE | \
+				  FS_XFLAG_APPEND | FS_XFLAG_NODUMP | \
+				  FS_XFLAG_NOATIME | FS_XFLAG_PROJINHERIT)
+
 /* Transfer xflags flags to internal */
 static inline unsigned long ext4_xflags_to_iflags(__u32 xflags)
 {
@@ -459,12 +463,22 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		if (get_user(flags, (int __user *) arg))
 			return -EFAULT;
 
+		if (flags & ~EXT4_FL_USER_VISIBLE)
+			return -EOPNOTSUPP;
+		/*
+		 * chattr(1) grabs flags via GETFLAGS, modifies the result and
+		 * passes that to SETFLAGS. So we cannot easily make SETFLAGS
+		 * more restrictive than just silently masking off visible but
+		 * not settable flags as we always did.
+		 */
+		flags &= EXT4_FL_USER_MODIFIABLE;
+		if (ext4_mask_flags(inode->i_mode, flags) != flags)
+			return -EOPNOTSUPP;
+
 		err = mnt_want_write_file(filp);
 		if (err)
 			return err;
 
-		flags = ext4_mask_flags(inode->i_mode, flags);
-
 		inode_lock(inode);
 		err = ext4_ioctl_setflags(inode, flags);
 		inode_unlock(inode);
@@ -869,13 +883,17 @@ resizefs_out:
 		if (!inode_owner_or_capable(inode))
 			return -EACCES;
 
+		if (fa.fsx_xflags & ~EXT4_SUPPORTED_FS_XFLAGS)
+			return -EOPNOTSUPP;
+
+		flags = ext4_xflags_to_iflags(fa.fsx_xflags);
+		if (ext4_mask_flags(inode->i_mode, flags) != flags)
+			return -EOPNOTSUPP;
+
 		err = mnt_want_write_file(filp);
 		if (err)
 			return err;
 
-		flags = ext4_xflags_to_iflags(fa.fsx_xflags);
-		flags = ext4_mask_flags(inode->i_mode, flags);
