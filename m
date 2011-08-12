From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 4/5 v2] e2fsck: do not attempt to discard if -n was specified
Date: Fri, 12 Aug 2011 18:42:59 +0200
Message-ID: <1313167380-3283-4-git-send-email-lczerner@redhat.com>
References: <1313167380-3283-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, adilger@dilger.ca,
	Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51233 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682Ab1HLQnR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 12 Aug 2011 12:43:17 -0400
In-Reply-To: <1313167380-3283-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If '-n' option is specified there should be no changes made to the file
system hence we should not attempt to discard the file system. This
commit adds a check into the e2fsck_discard_blocks() condition so it skip
discard if E2F_OPT_NO flag is set.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
v2: This is the actually the first version of the patch

 e2fsck/pass5.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index f9d746c..cf37556 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -87,7 +87,8 @@ static void e2fsck_discard_blocks(e2fsck_t ctx, io_manager manager,
 	if (ext2fs_test_changed(ctx->fs))
 		ctx->options &= ~E2F_OPT_DISCARD;
 
-	if ((ctx->options & E2F_OPT_DISCARD) &&
+	if (!(ctx->options & E2F_OPT_NO) &&
+	    (ctx->options & E2F_OPT_DISCARD) &&
 	    (io_channel_discard(fs->io, start, count)))
 		ctx->options &= ~E2F_OPT_DISCARD;
 }
@@ -331,11 +332,9 @@ redo_counts:
 			if (first_free > i)
 				first_free = i;
 		} else {
-			if ((i > first_free) &&
-			   (ctx->options & E2F_OPT_DISCARD)) {
+			if (i > first_free)
 				e2fsck_discard_blocks(ctx, manager, first_free,
 						      (i - first_free));
-			}
 			first_free = ext2fs_blocks_count(fs->super);
 		}
 		blocks ++;
-- 
1.7.4.4

