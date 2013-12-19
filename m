From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] e2fsck: read only parameter incorrectly compared
Date: Thu, 19 Dec 2013 16:31:43 -0500
Message-ID: <1387488703-18595-1-git-send-email-tytso@mit.edu>
Cc: Johan Erlandsson <johan.erlandsson@sonyericsson.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41792 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756566Ab3LSVbw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Dec 2013 16:31:52 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Johan Erlandsson <johan.erlandsson@sonyericsson.com>

Don't check for lost+found in read only mode.

[Note: this patch was originally made against 1.41.14 version of
e2fsprogs found as part of the AOSP (Android Open Source Program)
tree.  My Signed-off-by relies on the fact that the original patch
author would have had to have filed a contribution agreement with Open
Handset Alliance before this commit before this commit was allowed
into the AOSP tree. -- tytso]

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---

Note: This patch was original authored on August 2, 2012.  It would have
been nice if had been sent directly to upstream earlier, but oh, well.
(This patch was sent to me via Google's Android team.)

I will apply it against the maint branch and it will be in the 1.42.9
release.

 e2fsck/pass3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/e2fsck/pass3.c b/e2fsck/pass3.c
index d87bd79..32c05b5 100644
--- a/e2fsck/pass3.c
+++ b/e2fsck/pass3.c
@@ -112,7 +112,7 @@ void e2fsck_pass3(e2fsck_t ctx)
 	/*
 	 * Force the creation of /lost+found if not present
 	 */
-	if ((ctx->flags & E2F_OPT_READONLY) == 0)
+	if ((ctx->options & E2F_OPT_READONLY) == 0)
 		e2fsck_get_lost_and_found(ctx, 1);
 
 	/*
-- 
1.8.5.rc3.362.gdf10213

