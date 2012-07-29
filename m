From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] e2fsck: check a file system mounted read-only if forced
Date: Sun, 29 Jul 2012 00:19:57 -0400
Message-ID: <1343535597-18983-1-git-send-email-tytso@mit.edu>
References: <1343535209-18588-1-git-send-email-tytso@mit.edu>
Cc: sandeen@redhat.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:41890 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950Ab2G2EUC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 29 Jul 2012 00:20:02 -0400
In-Reply-To: <1343535209-18588-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Previously e2fsck would only allow a mounted file system to be checked
if it was the root file system and it was mounted read-only.  Now
allow any file system mounted read-only if the -f option is specified.

This makes it easier to test how e2fsck handles checking file systems
which are mounted without having to test on the root file system.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/unix.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index f71a125..da41f69 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -225,7 +225,9 @@ static void check_mount(e2fsck_t ctx)
 	     !(ctx->options & E2F_OPT_WRITECHECK)))
 		return;
 
-	if ((ctx->options & E2F_OPT_READONLY) &&
+	if (((ctx->options & E2F_OPT_READONLY) ||
+	     ((ctx->options & E2F_OPT_FORCE) &&
+	      (ctx->mount_flags & EXT2_MF_READONLY))) &&
 	    !(ctx->options & E2F_OPT_WRITECHECK)) {
 		log_out(ctx, _("Warning!  %s is %s.\n"),
 			ctx->filesystem_name,
@@ -1226,6 +1228,9 @@ restart:
 		if (!(ctx->mount_flags & EXT2_MF_ISROOT &&
 		      ctx->mount_flags & EXT2_MF_READONLY))
 			flags |= EXT2_FLAG_EXCLUSIVE;
+		if ((ctx->mount_flags & EXT2_MF_READONLY) &&
+		    (ctx->options & E2F_OPT_FORCE))
+			flags &= ~EXT2_FLAG_EXCLUSIVE;
 	}
 
 	retval = try_open_fs(ctx, flags, io_ptr, &fs);
-- 
1.7.12.rc0.22.gcdd159b

