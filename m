From: Michael Marineau <michael.marineau@coreos.com>
Subject: [PATCH] e2fsck: skip fixing UUID on a mounted filesystem with csums
Date: Sun, 19 Jan 2014 14:09:34 -0800
Message-ID: <1390169374-1775-1-git-send-email-michael.marineau@coreos.com>
Cc: linux-ext4@vger.kernel.org,
	Michael Marineau <michael.marineau@coreos.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:65415 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105AbaASWJm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 19 Jan 2014 17:09:42 -0500
Received: by mail-pd0-f177.google.com with SMTP id x10so4718206pdj.8
        for <linux-ext4@vger.kernel.org>; Sun, 19 Jan 2014 14:09:42 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This fix is similar to 66457fcb for tune2fs. When booting from a root
filesystem with an empty UUID which fsck fixes the following remount
step reliably fails, leaving the filesystem in an inconsistent state.
Like the tune2fs fix this patch resolves the issue by simply refusing to
update the UUID if the filesystem is mounted.

Signed-off-by: Michael Marineau <michael.marineau@coreos.com>
---

This patch is against master but is equally applicable to maint, it
applies to maint with 1 line of fuzz (ext2fs_init_csum_seed).
I've tested it on top of v1.42.9.

It may also be possible to fix this issue with a patch to ext4_remount
in the kernel but I have not investigated that.

 e2fsck/super.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/e2fsck/super.c b/e2fsck/super.c
index 59c1f97..3c92df2 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -734,8 +734,11 @@ void check_super_block(e2fsck_t ctx)
 #ifndef EXT2_SKIP_UUID
 	/*
 	 * If the UUID field isn't assigned, assign it.
+	 * Skip if checksums are enabled and the filesystem is mounted,
+	 * if the id changes under the kernel remounting rw may fail.
 	 */
-	if (!(ctx->options & E2F_OPT_READONLY) && uuid_is_null(sb->s_uuid)) {
+	if (!(ctx->options & E2F_OPT_READONLY) && uuid_is_null(sb->s_uuid) &&
+	    (!csum_flag || !(ctx->mount_flags & EXT2_MF_MOUNTED))) {
 		if (fix_problem(ctx, PR_0_ADD_UUID, &pctx)) {
 			uuid_generate(sb->s_uuid);
 			ext2fs_init_csum_seed(fs);
-- 
1.8.3.2

