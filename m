From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: Remove failed journal checksum check
Date: Sun, 15 Nov 2009 15:28:20 -0500
Message-ID: <1258316900-20808-1-git-send-email-tytso@mit.edu>
References: <20091114202755.GC4221@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:50847 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753626AbZKOU2R (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 15 Nov 2009 15:28:17 -0500
In-Reply-To: <20091114202755.GC4221@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Now that we are checking for failed journal checksums in the jbd2
layer, we don't need to check in the ext4 mount path --- since a
checksum fail will result in ext4_load_journal() returning an error,
causing the file system to refuse to be mounted until e2fsck can deal
with the problem.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/super.c |   20 --------------------
 1 files changed, 0 insertions(+), 20 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 8662b2e..04c6690 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2721,26 +2721,6 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	    EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL)) {
 		if (ext4_load_journal(sb, es, journal_devnum))
 			goto failed_mount3;
-		if (!(sb->s_flags & MS_RDONLY) &&
-		    EXT4_SB(sb)->s_journal->j_failed_commit) {
-			ext4_msg(sb, KERN_CRIT, "error: "
-			       "ext4_fill_super: Journal transaction "
-			       "%u is corrupt",
-			       EXT4_SB(sb)->s_journal->j_failed_commit);
-			if (test_opt(sb, ERRORS_RO)) {
-				ext4_msg(sb, KERN_CRIT,
-				       "Mounting filesystem read-only");
-				sb->s_flags |= MS_RDONLY;
-				EXT4_SB(sb)->s_mount_state |= EXT4_ERROR_FS;
-				es->s_state |= cpu_to_le16(EXT4_ERROR_FS);
-			}
-			if (test_opt(sb, ERRORS_PANIC)) {
-				EXT4_SB(sb)->s_mount_state |= EXT4_ERROR_FS;
-				es->s_state |= cpu_to_le16(EXT4_ERROR_FS);
-				ext4_commit_super(sb, 1);
-				goto failed_mount4;
-			}
-		}
 	} else if (test_opt(sb, NOLOAD) && !(sb->s_flags & MS_RDONLY) &&
 	      EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER)) {
 		ext4_msg(sb, KERN_ERR, "required journal recovery "
-- 
1.6.5.216.g5288a.dirty

