From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] ext4: introduce per-inode DAX flag
Date: Wed,  2 Aug 2017 18:09:46 +0200
Message-ID: <1501690186-17607-1-git-send-email-lczerner@redhat.com>
Cc: Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58590 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752428AbdHBQJv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 2 Aug 2017 12:09:51 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 89C23C0587F5
        for <linux-ext4@vger.kernel.org>; Wed,  2 Aug 2017 16:09:50 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently it's only possible to enable, or disable DAX via mount option
on ext4. However some applications may only want to enable DAX for
certain files on a file system.

This patch introduces new user visible and user modifiable ext4 inode
flag EXT4_DAX_FL. This flag is also added into EXT4_FL_INHERITED which
means that new inodes created in a directory with EXT4_DAX_FL set will
automatically inherit the inode flag.

With this patch ext4 is on par with xfs when it comes to per inode DAX
enablement.

Note that there are some changes due to this patch to consider. Regural
users are now able to set up their files to use DAX which was previously
only possible by mounting the file system with -o dax option. Any IO
done to the file with the flag se will fail in case the block device is
not DAX enabled.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/ext4.h  | 10 ++++++----
 fs/ext4/inode.c |  6 +++---
 fs/ext4/ioctl.c |  7 ++++++-
 3 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 9ebde0c..689d003 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -395,14 +395,15 @@ struct flex_groups {
 #define EXT4_TOPDIR_FL			0x00020000 /* Top of directory hierarchies*/
 #define EXT4_HUGE_FILE_FL               0x00040000 /* Set to each huge file */
 #define EXT4_EXTENTS_FL			0x00080000 /* Inode uses extents */
+#define EXT4_DAX_FL			0x00100000 /* Use DAX for IO */
 #define EXT4_EA_INODE_FL	        0x00200000 /* Inode used for large EA */
 #define EXT4_EOFBLOCKS_FL		0x00400000 /* Blocks allocated beyond EOF */
 #define EXT4_INLINE_DATA_FL		0x10000000 /* Inode has inline data. */
 #define EXT4_PROJINHERIT_FL		0x20000000 /* Create with parents projid */
 #define EXT4_RESERVED_FL		0x80000000 /* reserved for ext4 lib */
 
-#define EXT4_FL_USER_VISIBLE		0x304BDFFF /* User visible flags */
-#define EXT4_FL_USER_MODIFIABLE		0x204BC0FF /* User modifiable flags */
+#define EXT4_FL_USER_VISIBLE		0x305BDFFF /* User visible flags */
+#define EXT4_FL_USER_MODIFIABLE		0x205BC0FF /* User modifiable flags */
 
 /* Flags we can manipulate with through EXT4_IOC_FSSETXATTR */
 #define EXT4_FL_XFLAG_VISIBLE		(EXT4_SYNC_FL | \
@@ -410,14 +411,15 @@ struct flex_groups {
 					 EXT4_APPEND_FL | \
 					 EXT4_NODUMP_FL | \
 					 EXT4_NOATIME_FL | \
-					 EXT4_PROJINHERIT_FL)
+					 EXT4_PROJINHERIT_FL |\
+					 EXT4_DAX_FL)
 
 /* Flags that should be inherited by new inodes from their parent. */
 #define EXT4_FL_INHERITED (EXT4_SECRM_FL | EXT4_UNRM_FL | EXT4_COMPR_FL |\
 			   EXT4_SYNC_FL | EXT4_NODUMP_FL | EXT4_NOATIME_FL |\
 			   EXT4_NOCOMPR_FL | EXT4_JOURNAL_DATA_FL |\
 			   EXT4_NOTAIL_FL | EXT4_DIRSYNC_FL |\
-			   EXT4_PROJINHERIT_FL)
+			   EXT4_PROJINHERIT_FL | EXT4_DAX_FL)
 
 /* Flags that are appropriate for regular files (all but dir-specific ones). */
 #define EXT4_REG_FLMASK (~(EXT4_DIRSYNC_FL | EXT4_TOPDIR_FL))
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 3c600f0..051c4db5 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4555,9 +4555,9 @@ void ext4_set_inode_flags(struct inode *inode)
 		new_fl |= S_NOATIME;
 	if (flags & EXT4_DIRSYNC_FL)
 		new_fl |= S_DIRSYNC;
-	if (test_opt(inode->i_sb, DAX) && S_ISREG(inode->i_mode) &&
-	    !ext4_should_journal_data(inode) && !ext4_has_inline_data(inode) &&
-	    !ext4_encrypted_inode(inode))
+	if ((test_opt(inode->i_sb, DAX) || flags & EXT4_DAX_FL) &&
+	    S_ISREG(inode->i_mode) && !ext4_should_journal_data(inode) &&
+	    !ext4_has_inline_data(inode) && !ext4_encrypted_inode(inode))
 		new_fl |= S_DAX;
 	inode_set_flags(inode, new_fl,
 			S_SYNC|S_APPEND|S_IMMUTABLE|S_NOATIME|S_DIRSYNC|S_DAX);
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 42b3a73..a46b606 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -424,12 +424,15 @@ static inline __u32 ext4_iflags_to_xflags(unsigned long iflags)
 		xflags |= FS_XFLAG_NOATIME;
 	if (iflags & EXT4_PROJINHERIT_FL)
 		xflags |= FS_XFLAG_PROJINHERIT;
+	if (iflags & EXT4_DAX_FL)
+		xflags |= FS_XFLAG_DAX;
 	return xflags;
 }
 
 #define EXT4_SUPPORTED_FS_XFLAGS (FS_XFLAG_SYNC | FS_XFLAG_IMMUTABLE | \
 				  FS_XFLAG_APPEND | FS_XFLAG_NODUMP | \
-				  FS_XFLAG_NOATIME | FS_XFLAG_PROJINHERIT)
+				  FS_XFLAG_NOATIME | FS_XFLAG_PROJINHERIT | \
+				  FS_XFLAG_DAX)
 
 /* Transfer xflags flags to internal */
 static inline unsigned long ext4_xflags_to_iflags(__u32 xflags)
@@ -448,6 +451,8 @@ static inline unsigned long ext4_xflags_to_iflags(__u32 xflags)
 		iflags |= EXT4_NOATIME_FL;
 	if (xflags & FS_XFLAG_PROJINHERIT)
 		iflags |= EXT4_PROJINHERIT_FL;
+	if (xflags & FS_XFLAG_DAX)
+		iflags |= EXT4_DAX_FL;
 
 	return iflags;
 }
-- 
2.7.5
