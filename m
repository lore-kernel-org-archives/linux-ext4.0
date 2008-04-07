From: Matthias Koenig <mkoenig@suse.de>
Subject: [PATCH] e2fsprogs: avoid double free of ctx->filesystem_name in e2fsck
Date: Mon, 07 Apr 2008 12:33:25 +0200
Message-ID: <n7x4paegdje.fsf@sor.suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:49477 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756418AbYDGKcB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Apr 2008 06:32:01 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=

Hi,

in current git there is a double free on ctx->filesystem_name in the end of
main() and in e2fsck_free_context, causing e2fsck to abort at the end of
pass5.

Matthias

Signed-off-by: Matthias Koenig <mkoenig@suse.de>


--=-=-=
Content-Type: text/x-patch
Content-Disposition: inline; filename=e2fsprogs-fsck_avoid_double_free.patch

Index: e2fsprogs-1.40.8+NEXT+git20080401/e2fsck/unix.c
===================================================================
--- e2fsprogs-1.40.8+NEXT+git20080401.orig/e2fsck/unix.c
+++ e2fsprogs-1.40.8+NEXT+git20080401/e2fsck/unix.c
@@ -1366,7 +1366,6 @@ no_journal:
 #endif
 	ext2fs_close(fs);
 	ctx->fs = NULL;
-	free(ctx->filesystem_name);
 	free(ctx->journal_name);
 
 	e2fsck_free_context(ctx);

--=-=-=--
