From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] e2fsck: return more status if fsck aborts
Date: Tue, 01 Nov 2011 12:32:28 -0500
Message-ID: <4EB02D2C.3090809@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23598 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736Ab1KARc3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Nov 2011 13:32:29 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pA1HWTp2009087
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 1 Nov 2011 13:32:29 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id pA1HWSCZ002740
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 1 Nov 2011 13:32:29 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If we abort fsck (due to ENOMEM for example) we exit
with only the FSCK_ERROR flag.  It seems useful
to do the same sorts of checks as we do on normal
exit, and return whether the filesystem was modified,
whether there are still uncorrected errors, etc, even
in the abort case.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/e2fsck/util.c b/e2fsck/util.c
index fb9a87a..d761ae5 100644
--- a/e2fsck/util.c
+++ b/e2fsck/util.c
@@ -45,18 +45,37 @@ extern e2fsck_t e2fsck_global_ctx;   /* Try your very best not to use this! */
 
 void fatal_error(e2fsck_t ctx, const char *msg)
 {
+	ext2_filsys fs = ctx->fs;
+	int exit_value = FSCK_ERROR;
+
 	if (msg)
 		fprintf (stderr, "e2fsck: %s\n", msg);
-	if (ctx->fs && ctx->fs->io) {
+	if (!fs)
+		goto out;
+	if (fs->io) {
 		if (ctx->fs->io->magic == EXT2_ET_MAGIC_IO_CHANNEL)
 			io_channel_flush(ctx->fs->io);
 		else
 			fprintf(stderr, "e2fsck: io manager magic bad!\n");
 	}
+	if (ext2fs_test_changed(fs)) {
+		exit_value |= FSCK_NONDESTRUCT;
+		printf(_("\n%s: ***** FILE SYSTEM WAS MODIFIED *****\n"),
+			ctx->device_name);
+		if (ctx->mount_flags & EXT2_MF_ISROOT)
+			exit_value |= FSCK_REBOOT;
+	}
+	if (!ext2fs_test_valid(fs)) {
+		printf(_("\n%s: ********** WARNING: Filesystem still has "
+			 "errors **********\n\n"), ctx->device_name);
+		exit_value |= FSCK_UNCORRECTED;
+		exit_value &= ~FSCK_NONDESTRUCT;
+	}
+out:
 	ctx->flags |= E2F_FLAG_ABORT;
 	if (ctx->flags & E2F_FLAG_SETJMP_OK)
 		longjmp(ctx->abort_loc, 1);
-	exit(FSCK_ERROR);
+	exit(exit_value);
 }
 
 void *e2fsck_allocate_memory(e2fsck_t ctx, unsigned int size,

