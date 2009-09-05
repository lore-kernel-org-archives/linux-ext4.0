From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/2] ext4: Remove journal_checksum mount option and enable it by default
Date: Sat,  5 Sep 2009 18:32:42 -0400
Message-ID: <1252189963-23868-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:35493 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753392AbZIEWco (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 5 Sep 2009 18:32:44 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There's no real cost for the journal checksum feature, and we should
make sure it is enabled all the time.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 Documentation/filesystems/ext4.txt |    8 +-------
 fs/ext4/ext4.h                     |    1 -
 fs/ext4/super.c                    |   20 ++++++--------------
 3 files changed, 7 insertions(+), 22 deletions(-)

diff --git a/Documentation/filesystems/ext4.txt b/Documentation/filesystems/ext4.txt
index 7be02ac..3e329db 100644
--- a/Documentation/filesystems/ext4.txt
+++ b/Documentation/filesystems/ext4.txt
@@ -134,15 +134,9 @@ ro                   	Mount filesystem read only. Note that ext4 will
                      	mount options "ro,noload" can be used to prevent
 		     	writes to the filesystem.
 
-journal_checksum	Enable checksumming of the journal transactions.
-			This will allow the recovery code in e2fsck and the
-			kernel to detect corruption in the kernel.  It is a
-			compatible change and will be ignored by older kernels.
-
 journal_async_commit	Commit block can be written to disk without waiting
 			for descriptor blocks. If enabled older kernels cannot
-			mount the device. This will enable 'journal_checksum'
-			internally.
+			mount the device.
 
 journal=update		Update the ext4 file system's journal to the current
 			format.
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 815a804..c187b08 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -711,7 +711,6 @@ struct ext4_inode_info {
 #define EXT4_MOUNT_QUOTA		0x80000 /* Some quota option set */
 #define EXT4_MOUNT_USRQUOTA		0x100000 /* "old" user quota */
 #define EXT4_MOUNT_GRPQUOTA		0x200000 /* "old" group quota */
-#define EXT4_MOUNT_JOURNAL_CHECKSUM	0x800000 /* Journal checksums */
 #define EXT4_MOUNT_JOURNAL_ASYNC_COMMIT	0x1000000 /* Journal Async Commit */
 #define EXT4_MOUNT_I_VERSION            0x2000000 /* i_version support */
 #define EXT4_MOUNT_DELALLOC		0x8000000 /* Delalloc support */
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 4037fe0..f1815d3 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1280,11 +1280,9 @@ static int parse_options(char *options, struct super_block *sb,
 			*journal_devnum = option;
 			break;
 		case Opt_journal_checksum:
-			set_opt(sbi->s_mount_opt, JOURNAL_CHECKSUM);
-			break;
+			break;	/* Kept for backwards compatibility */
 		case Opt_journal_async_commit:
 			set_opt(sbi->s_mount_opt, JOURNAL_ASYNC_COMMIT);
-			set_opt(sbi->s_mount_opt, JOURNAL_CHECKSUM);
 			break;
 		case Opt_noload:
 			set_opt(sbi->s_mount_opt, NOLOAD);
@@ -2751,20 +2749,14 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		goto failed_mount4;
 	}
 
-	if (test_opt(sb, JOURNAL_ASYNC_COMMIT)) {
-		jbd2_journal_set_features(sbi->s_journal,
-				JBD2_FEATURE_COMPAT_CHECKSUM, 0,
+	jbd2_journal_set_features(sbi->s_journal,
+				  JBD2_FEATURE_COMPAT_CHECKSUM, 0, 0);
+	if (test_opt(sb, JOURNAL_ASYNC_COMMIT))
+		jbd2_journal_set_features(sbi->s_journal, 0, 0,
 				JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT);
-	} else if (test_opt(sb, JOURNAL_CHECKSUM)) {
-		jbd2_journal_set_features(sbi->s_journal,
-				JBD2_FEATURE_COMPAT_CHECKSUM, 0, 0);
+	else
 		jbd2_journal_clear_features(sbi->s_journal, 0, 0,
 				JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT);
-	} else {
-		jbd2_journal_clear_features(sbi->s_journal,
-				JBD2_FEATURE_COMPAT_CHECKSUM, 0,
-				JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT);
-	}
 
 	/* We have now updated the journal if required, so we can
 	 * validate the data journaling mode. */
-- 
1.6.3.2.1.gb9f7d.dirty

