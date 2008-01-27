From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH e2fsprogs] UPDATED: ignore "safe" flag differences when
	fsck compares superblocks
Date: Sat, 26 Jan 2008 23:22:16 -0500
Message-ID: <20080127042216.GB24842@mit.edu>
References: <479629DF.7090500@redhat.com> <479A2AA6.1020002@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:38208 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752846AbYA0EWW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 26 Jan 2008 23:22:22 -0500
Content-Disposition: inline
In-Reply-To: <479A2AA6.1020002@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is what I've checked in.  See the comment about why we can't
ignore a difference for the extended attribute feature.

          	     	  	       	       - Ted

commit a8cde73acbf6e0f9c0a3601e4f5fac2b01a27bd2
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Sat Jan 26 23:17:50 2008 -0500

    Ignore "safe" flag differences when e2fsck compares superblocks
    
    Recent e2fsprogs (1.40.3 and higher) fsck compares primary superblock to
    backups, and if things differ, it forces a full check.  However, the
    kernel has a penchant for updating flags the first time a feature is
    used - attributes, large files, etc.
    
    This is a bad idea, and we should break the kernel of this habit,
    especially for the ext4 feature flags.  But for now, let's make e2fsck
    avoid forcing a full check and backup except when absolutely
    necessary.
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/e2fsck/super.c b/e2fsck/super.c
index a4835f7..954783e 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -773,8 +773,26 @@ void check_super_block(e2fsck_t ctx)
 
 /*
  * Check to see if we should backup the master sb to the backup super
- * blocks.
+ * blocks.  Returns non-zero if the sb should be backed up.
  */
+
+/*
+ * A few flags are set on the fly by the kernel, but only in the
+ * primary superblock.  This is actually a bad thing, and we should
+ * try to discourage it in the future.  In particular, for the newer
+ * ext4 files, especially EXT4_FEATURE_RO_COMPAT_DIR_NLINK and
+ * EXT3_FEATURE_INCOMPAT_EXTENTS.  So some of these may go away in the
+ * future.
+ *
+ * The kernel will set EXT2_FEATURE_COMPAT_EXT_ATTR, but
+ * unfortunately, we shouldn't ignore it since if it's not set in the
+ * backup, the extended attributes in the filesystem will be stripped
+ * away.
+ */
+#define FEATURE_RO_COMPAT_IGNORE	(EXT2_FEATURE_RO_COMPAT_LARGE_FILE| \
+					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK)
+#define FEATURE_INCOMPAT_IGNORE		(EXT3_FEATURE_INCOMPAT_EXTENTS)
+
 int check_backup_super_block(e2fsck_t ctx)
 {
 	ext2_filsys	fs = ctx->fs;
@@ -814,10 +832,18 @@ int check_backup_super_block(e2fsck_t ctx)
 			continue;
 		}
 
-#define SUPER_DIFFERENT(x) (fs->super->x != tfs->super->x)
+#define SUPER_INCOMPAT_DIFFERENT(x)	\
+	(( fs->super->x & ~FEATURE_INCOMPAT_IGNORE) !=	\
+	 (tfs->super->x & ~FEATURE_INCOMPAT_IGNORE))
+#define SUPER_RO_COMPAT_DIFFERENT(x)	\
+	(( fs->super->x & ~FEATURE_RO_COMPAT_IGNORE) !=	\
+	 (tfs->super->x & ~FEATURE_RO_COMPAT_IGNORE))
+#define SUPER_DIFFERENT(x)		\
+	(fs->super->x != tfs->super->x)
+
 		if (SUPER_DIFFERENT(s_feature_compat) ||
-		    SUPER_DIFFERENT(s_feature_incompat) ||
-		    SUPER_DIFFERENT(s_feature_ro_compat) ||
+		    SUPER_INCOMPAT_DIFFERENT(s_feature_incompat) ||
+		    SUPER_RO_COMPAT_DIFFERENT(s_feature_ro_compat) ||
 		    SUPER_DIFFERENT(s_blocks_count) ||
 		    SUPER_DIFFERENT(s_inodes_count) ||
 		    memcmp(fs->super->s_uuid, tfs->super->s_uuid,
