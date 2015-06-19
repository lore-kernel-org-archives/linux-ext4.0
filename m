From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] e2fsck: skip checking the journal fields if the file system is mounted
Date: Fri, 19 Jun 2015 19:54:14 -0400
Message-ID: <1434758054-26774-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45973 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391AbbFSXyU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Jun 2015 19:54:20 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When a file system with journal checksums is mounted, the journal
checksum is only updated when the journal superblock is actually
written to disk.  But when a root file system is mounted read-only,
e2fsck will get the in-memory version of the journal superblock, and
the checksum is not necessarily going to be correct.  Since we only
allow the root file system to be checked while it is mounted
read-only, and we won't be trying to replay the journal anyway.  So we
can skip the checking the journal superblock fields for mounted file
systems.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 e2fsck/unix.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 9ef4b1e..f75d90d 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1640,12 +1640,14 @@ failure:
 	/*
 	 * Make sure the ext3 superblock fields are consistent.
 	 */
-	retval = e2fsck_check_ext3_journal(ctx);
-	if (retval) {
-		com_err(ctx->program_name, retval,
-			_("while checking ext3 journal for %s"),
-			ctx->device_name);
-		fatal_error(ctx, 0);
+	if ((ctx->mount_flags & (EXT2_MF_MOUNTED | EXT2_MF_BUSY)) == 0) {
+		retval = e2fsck_check_ext3_journal(ctx);
+		if (retval) {
+			com_err(ctx->program_name, retval,
+				_("while checking ext3 journal for %s"),
+				ctx->device_name);
+			fatal_error(ctx, 0);
+		}
 	}
 
 	/*
-- 
2.3.0

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
