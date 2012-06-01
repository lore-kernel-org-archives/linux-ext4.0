From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/4] e2fsck: handle an already recovered journal with a non-zero s_error field
Date: Thu, 31 May 2012 20:14:56 -0400
Message-ID: <1338509698-24349-2-git-send-email-tytso@mit.edu>
References: <1338509698-24349-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46857 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758733Ab2FAAPF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 May 2012 20:15:05 -0400
In-Reply-To: <1338509698-24349-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If a file system was remounted read-only after a file system
corruption is detected, and then that file system is mounted and
unmounted by the kernel, the journal would have been recovered, but
the kernel currently leaves the s_errno field still set.  This is
arguably a bug, since it has already propgated the non-zero s_errno
field to the file system superblock, where it will be retained until
e2fsck has been run.

However, e2fsck should handle this case for existing kernel by
checking the journal superblock's s_errno field even if journal
recovery is not required.

Without this commit, e2fsck would not notice anything wrong with the
file system, but a subsequent mount of the file system by the kernel
would mark the file system's superblock as needing checking (since the
journal's s_errno field would still be set), resulting an full e2fsck
run at the next reboot, which would find nothing wrong --- and then
when the file system was mounted, the whole cycle would repeat again.

I had seen reports of this in the past, but it wasn't until recently
that I realized exactly how this had come about, since normally e2fsck
would be run automatically before the file system is mounted again,
thus avoiding this problem.  However, a user using a rescue CD who
didn't run e2fsck before mounting the a file system in this condition
could trigger this situation, and unfortunately, with previous
versions of e2fsprogs and the kernel, there would be no way out no
matter what the user tried to do.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/journal.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/e2fsck/journal.c b/e2fsck/journal.c
index bada028..74b506b 100644
--- a/e2fsck/journal.c
+++ b/e2fsck/journal.c
@@ -803,6 +803,19 @@ no_has_journal:
 		 */
 	}
 
+	/*
+	 * If we don't need to do replay the journal, check to see if
+	 * the journal's errno is set; if so, we need to mark the file
+	 * system as being corrupt and clear the journal's s_errno.
+	 */
+	if (!(sb->s_feature_incompat & EXT3_FEATURE_INCOMPAT_RECOVER) &&
+	    journal->j_superblock->s_errno) {
+		ctx->fs->super->s_state |= EXT2_ERROR_FS;
+		ext2fs_mark_super_dirty(ctx->fs);
+		journal->j_superblock->s_errno = 0;
+		mark_buffer_dirty(journal->j_sb_buffer);
+	}
+
 	e2fsck_journal_release(ctx, journal, reset, 0);
 	return retval;
 }
-- 
1.7.10.2.552.gaa3bb87

