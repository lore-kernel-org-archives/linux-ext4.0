From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 3/4] e2fsck: don't try to set a UUID on metadata_csum file systems
Date: Fri, 15 Apr 2016 21:13:44 -0400
Message-ID: <1460769225-31398-3-git-send-email-tytso@mit.edu>
References: <1460769225-31398-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34970 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbcDPBNt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 Apr 2016 21:13:49 -0400
In-Reply-To: <1460769225-31398-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the UUID field is NULL, e2fsck will try to generate and set a new
UUID.  This will cause massive problems if the metadata_csum feature
is set, so avoid doing so in that case.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 e2fsck/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/e2fsck/super.c b/e2fsck/super.c
index e09c14c..dec70bd 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -756,6 +756,7 @@ void check_super_block(e2fsck_t ctx)
 	 * if the id changes under the kernel remounting rw may fail.
 	 */
 	if (!(ctx->options & E2F_OPT_READONLY) && uuid_is_null(sb->s_uuid) &&
+	    !ext2fs_has_feature_metadata_csum(ctx->fs->super) &&
 	    (!csum_flag || !(ctx->mount_flags & EXT2_MF_MOUNTED))) {
 		if (fix_problem(ctx, PR_0_ADD_UUID, &pctx)) {
 			uuid_generate(sb->s_uuid);
-- 
2.5.0

