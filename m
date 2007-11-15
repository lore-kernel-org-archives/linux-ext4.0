From: akpm@linux-foundation.org
Subject: [patch 022/120] Forbid user to change file flags on quota files
Date: Wed, 14 Nov 2007 16:58:56 -0800
Message-ID: <200711150058.lAF0wv41002605@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, jack@suse.cz,
	linux-ext4@vger.kernel.org, lioupayphone@gmail.com,
	reiserfs-dev@namesys.com, shaggy@austin.ibm.com
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35390 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751592AbXKOBIX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Nov 2007 20:08:23 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Jan Kara <jack@suse.cz>

Forbid user from changing file flags on quota files.  User has no bussiness
in playing with these flags when quota is on.  Furthermore there is a
remote possibility of deadlock due to a lock inversion between quota file's
i_mutex and transaction's start (i_mutex for quota file is locked only when
trasaction is started in quota operations) in ext3 and ext4.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: LIOU Payphone <lioupayphone@gmail.com>
Cc: <linux-ext4@vger.kernel.org>
Acked-by: Dave Kleikamp <shaggy@austin.ibm.com>
Cc: <reiserfs-dev@namesys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/ioctl.c     |    5 +++++
 fs/ext3/ioctl.c     |    5 +++++
 fs/ext4/ioctl.c     |    5 +++++
 fs/jfs/ioctl.c      |    3 +++
 fs/reiserfs/ioctl.c |    3 +++
 5 files changed, 21 insertions(+)

diff -puN fs/ext2/ioctl.c~forbid-user-to-change-file-flags-on-quota-files fs/ext2/ioctl.c
--- a/fs/ext2/ioctl.c~forbid-user-to-change-file-flags-on-quota-files
+++ a/fs/ext2/ioctl.c
@@ -47,6 +47,11 @@ int ext2_ioctl (struct inode * inode, st
 			flags &= ~EXT2_DIRSYNC_FL;
 
 		mutex_lock(&inode->i_mutex);
+		/* Is it quota file? Do not allow user to mess with it */
+		if (IS_NOQUOTA(inode)) {
+			mutex_unlock(&inode->i_mutex);
+			return -EPERM;
+		}
 		oldflags = ei->i_flags;
 
 		/*
diff -puN fs/ext3/ioctl.c~forbid-user-to-change-file-flags-on-quota-files fs/ext3/ioctl.c
--- a/fs/ext3/ioctl.c~forbid-user-to-change-file-flags-on-quota-files
+++ a/fs/ext3/ioctl.c
@@ -51,6 +51,11 @@ int ext3_ioctl (struct inode * inode, st
 			flags &= ~EXT3_DIRSYNC_FL;
 
 		mutex_lock(&inode->i_mutex);
+		/* Is it quota file? Do not allow user to mess with it */
+		if (IS_NOQUOTA(inode)) {
+			mutex_unlock(&inode->i_mutex);
+			return -EPERM;
+		}
 		oldflags = ei->i_flags;
 
 		/* The JOURNAL_DATA flag is modifiable only by root */
diff -puN fs/ext4/ioctl.c~forbid-user-to-change-file-flags-on-quota-files fs/ext4/ioctl.c
--- a/fs/ext4/ioctl.c~forbid-user-to-change-file-flags-on-quota-files
+++ a/fs/ext4/ioctl.c
@@ -51,6 +51,11 @@ int ext4_ioctl (struct inode * inode, st
 			flags &= ~EXT4_DIRSYNC_FL;
 
 		mutex_lock(&inode->i_mutex);
+		/* Is it quota file? Do not allow user to mess with it */
+		if (IS_NOQUOTA(inode)) {
+			mutex_unlock(&inode->i_mutex);
+			return -EPERM;
+		}
 		oldflags = ei->i_flags;
 
 		/* The JOURNAL_DATA flag is modifiable only by root */
diff -puN fs/jfs/ioctl.c~forbid-user-to-change-file-flags-on-quota-files fs/jfs/ioctl.c
--- a/fs/jfs/ioctl.c~forbid-user-to-change-file-flags-on-quota-files
+++ a/fs/jfs/ioctl.c
@@ -79,6 +79,9 @@ int jfs_ioctl(struct inode * inode, stru
 		if (!S_ISDIR(inode->i_mode))
 			flags &= ~JFS_DIRSYNC_FL;
 
+		/* Is it quota file? Do not allow user to mess with it */
+		if (IS_NOQUOTA(inode))
+			return -EPERM;
 		jfs_get_inode_flags(jfs_inode);
 		oldflags = jfs_inode->mode2;
 
diff -puN fs/reiserfs/ioctl.c~forbid-user-to-change-file-flags-on-quota-files fs/reiserfs/ioctl.c
--- a/fs/reiserfs/ioctl.c~forbid-user-to-change-file-flags-on-quota-files
+++ a/fs/reiserfs/ioctl.c
@@ -57,6 +57,9 @@ int reiserfs_ioctl(struct inode *inode, 
 			if (get_user(flags, (int __user *)arg))
 				return -EFAULT;
 
+			/* Is it quota file? Do not allow user to mess with it. */
+			if (IS_NOQUOTA(inode))
+				return -EPERM;
 			if (((flags ^ REISERFS_I(inode)->
 			      i_attrs) & (REISERFS_IMMUTABLE_FL |
 					  REISERFS_APPEND_FL))
_
