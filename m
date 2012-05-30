From: Andreas Dilger <adilger@whamcloud.com>
Subject: [PATCH] e2fsck: allow checking on mounted root fs (v2)
Date: Wed, 30 May 2012 16:55:04 -0600
Message-ID: <1338418504-3408-1-git-send-email-adilger@whamcloud.com>
References: <1338403182-2253-1-git-send-email-adilger@whamcloud.com>
Cc: Andreas Dilger <adilger@whamcloud.com>
To: tytso@mit.edu, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:34563 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab2E3WzH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 May 2012 18:55:07 -0400
In-Reply-To: <1338403182-2253-1-git-send-email-adilger@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Commit 732e26b98e5c79a4298dbe341f43b54b354bb241 added checks to
prevent e2fsck from being run in filesystem-modifying mode against
a mounted or otherwise busy device, due to several bug reports of
users doing this even with the verbose warnings in check_mount().

However, it also prevented e2fsck from checking a mounted root
filesystem, which will prevent the node from booting.  Once again
allow e2fsck to run against the mounted root filesystem if it is
also mounted read-only at the time.

Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
---
 e2fsck/unix.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 6161e46..94260bd 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1221,8 +1221,12 @@ restart:
 			    &old_bitmaps);
 	if (!old_bitmaps)
 		flags |= EXT2_FLAG_64BITS;
-	if ((ctx->options & E2F_OPT_READONLY) == 0)
-		flags |= EXT2_FLAG_RW | EXT2_FLAG_EXCLUSIVE;
+	if ((ctx->options & E2F_OPT_READONLY) == 0) {
+		flags |= EXT2_FLAG_RW;
+		if (!(ctx->mount_flags & EXT2_MF_ISROOT &&
+		      ctx->mount_flags & EXT2_MF_READONLY))
+			flags |= EXT2_FLAG_EXCLUSIVE;
+	}
 
 	retval = try_open_fs(ctx, flags, io_ptr, &fs);
 
-- 
1.7.3.4

