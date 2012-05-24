From: Andreas Dilger <adilger@whamcloud.com>
Subject: [PATCH] e2fsck: fix checks done for mounted vs. read-only
Date: Thu, 24 May 2012 15:34:56 -0600
Message-ID: <1337895296-16629-1-git-send-email-adilger@whamcloud.com>
Cc: Andreas Dilger <adilger@whamcloud.com>
To: tytso@mit.edu, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:9960 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965561Ab2EXVe6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 May 2012 17:34:58 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently, if e2fsck is run without the "-n" flag (i.e. it
might modify the filesystem), there is no guarantee that it will
open the filesystem with the EXCLUSIVE flag (i.e. O_EXCL) to
prevent the block device from being checked (in most cases this
means mounted, but it could also be an MD/LVM member device).

Conversely, if e2fsck is run with "-n" (i.e. read-only), and
/etc/mtab or /proc/mounts does not report the block device as
mounted then e2fsck thinks the filesystem is unmounted.  In this
case, e2fsck incorrectly sets the EXCLUSIVE flag, which causes
the check to fail, even though e2fsck is running read-only.

To fix this, do not open with EXCLUSIVE if it is a read-only check,
and always open with EXCLUSIVE if the filesystem might be changed.
This also prevents filesystem mounts while e2fsck is running.

Also refuse allow e2fsck to run at all if the filesystem is BUSY.
The e2fsck check_mount() was checking for MOUNTED, but not BUSY,
and it should refuse to run outright if the block device is BUSY.
The previous MOUNTED heuristics pre-date the O_EXCL reservation
by the kernel, so there could be uncertainty due to stale /etc/mtab
data, but with newer kernels a busy device should never be modified.

Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
---
 e2fsck/unix.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 53fcd04..6161e46 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -219,7 +219,7 @@ static void check_mount(e2fsck_t ctx)
 	 * filesystem and it's mounted read-only, and we're not doing
 	 * a read/write check, then everything's fine.
 	 */
-	if ((!(ctx->mount_flags & EXT2_MF_MOUNTED)) ||
+	if ((!(ctx->mount_flags & (EXT2_MF_MOUNTED | EXT2_MF_BUSY))) ||
 	    ((ctx->mount_flags & EXT2_MF_ISROOT) &&
 	     (ctx->mount_flags & EXT2_MF_READONLY) &&
 	     !(ctx->options & E2F_OPT_WRITECHECK)))
@@ -227,13 +227,16 @@ static void check_mount(e2fsck_t ctx)
 
 	if ((ctx->options & E2F_OPT_READONLY) &&
 	    !(ctx->options & E2F_OPT_WRITECHECK)) {
-		log_out(ctx, _("Warning!  %s is mounted.\n"),
-			ctx->filesystem_name);
+		log_out(ctx, _("Warning!  %s is %s.\n"),
+			ctx->filesystem_name,
+			ctx->mount_flags & EXT2_MF_MOUNTED ?
+				"mounted" : "in use");
 		return;
 	}
 
-	log_out(ctx, _("%s is mounted.  "), ctx->filesystem_name);
-	if (!ctx->interactive)
+	log_out(ctx, _("%s is %s.\n"), ctx->filesystem_name,
+		ctx->mount_flags & EXT2_MF_MOUNTED ? "mounted" : "in use");
+	if (!ctx->interactive || ctx->mount_flags & EXT2_MF_BUSY)
 		fatal_error(ctx, _("Cannot continue, aborting.\n\n"));
 	puts("\007\007\007\007");
 	log_out(ctx, _("\n\nWARNING!!!  "
@@ -1219,9 +1222,7 @@ restart:
 	if (!old_bitmaps)
 		flags |= EXT2_FLAG_64BITS;
 	if ((ctx->options & E2F_OPT_READONLY) == 0)
-		flags |= EXT2_FLAG_RW;
-	if ((ctx->mount_flags & EXT2_MF_MOUNTED) == 0)
-		flags |= EXT2_FLAG_EXCLUSIVE;
+		flags |= EXT2_FLAG_RW | EXT2_FLAG_EXCLUSIVE;
 
 	retval = try_open_fs(ctx, flags, io_ptr, &fs);
 
-- 
1.7.3.4

