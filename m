From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 4/4] e2fsck: don't abort if the journal is corrupted due to checksum errors
Date: Fri, 15 Apr 2016 21:13:45 -0400
Message-ID: <1460769225-31398-4-git-send-email-tytso@mit.edu>
References: <1460769225-31398-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34966 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750916AbcDPBNu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 Apr 2016 21:13:50 -0400
In-Reply-To: <1460769225-31398-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If e2fsck_run_ext3_journal() returns an error indicating that a CRC
error was detected, we shouldn't abort, but instead proceed so the
file system can be fixed.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 e2fsck/unix.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 959b4dd..cfd33e4 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -53,6 +53,7 @@ extern int optind;
 #include "support/plausible.h"
 #include "e2fsck.h"
 #include "problem.h"
+#include "jfs_user.h"
 #include "../version.h"
 
 /* Command line options */
@@ -1645,7 +1646,7 @@ failure:
 		retval = e2fsck_check_ext3_journal(ctx);
 		if (retval) {
 			com_err(ctx->program_name, retval,
-				_("while checking ext3 journal for %s"),
+				_("while checking journal for %s"),
 				ctx->device_name);
 			fatal_error(ctx, 0);
 		}
@@ -1677,9 +1678,10 @@ failure:
 			retval = e2fsck_run_ext3_journal(ctx);
 			if (retval) {
 				com_err(ctx->program_name, retval,
-				_("while recovering ext3 journal of %s"),
+				_("while recovering journal of %s"),
 					ctx->device_name);
-				fatal_error(ctx, 0);
+				if ((retval != EFSBADCRC) && (retval != EFSCORRUPTED))
+					fatal_error(ctx, 0);
 			}
 			ext2fs_close_free(&ctx->fs);
 			ctx->flags |= E2F_FLAG_RESTARTED;
-- 
2.5.0

