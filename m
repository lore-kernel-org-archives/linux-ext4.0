Return-Path: <SRS0=dqau=MX=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1861 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727357AbeJKVKx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 11 Oct 2018 17:10:53 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 682C14E8BC
        for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2018 13:43:38 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.40.205.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D1E4B1001F41
        for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2018 13:43:37 +0000 (UTC)
From: Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Subject: [PATCH] fuse2fs: return proper exit code from fuse_main
Date: Thu, 11 Oct 2018 15:43:36 +0200
Message-Id: <20181011134336.977-1-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently fuse2fs will always return 0 exit code indicating successful
operation even though the mount failed either because we failed to
properly read the file system in the first place, or the fuse_main()
failed for whatever reason.

Fix it by using the return code from fuse_main(), or return 32 in case
we fail because the file system is corrupted, or we encountered a
problem preventing us mounting the file system. 32 because this is a
libmount exit code indicating mount failed.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 misc/fuse2fs.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
index 5c73895e..d7a0b668 100644
--- a/misc/fuse2fs.c
+++ b/misc/fuse2fs.c
@@ -3720,7 +3720,7 @@ int main(int argc, char *argv[])
 {
 	struct fuse_args args = FUSE_ARGS_INIT(argc, argv);
 	struct fuse2fs fctx;
-	errcode_t err;
+	errcode_t err = 0;
 	char *logfile;
 	char extra_args[BUFSIZ];
 	int ret = 0, flags = EXT2_FLAG_64BITS | EXT2_FLAG_EXCLUSIVE;
@@ -3753,6 +3753,7 @@ int main(int argc, char *argv[])
 		fctx.err_fp = fopen(logfile, "a");
 		if (!fctx.err_fp) {
 			perror(logfile);
+			err = errno;
 			goto out;
 		}
 	} else
@@ -3766,7 +3767,6 @@ int main(int argc, char *argv[])
 	}
 
 	/* Start up the fs (while we still can use stdout) */
-	ret = 2;
 	if (!fctx.ro)
 		flags |= EXT2_FLAG_RW;
 	err = ext2fs_open2(fctx.device, NULL, flags, 0, 0, unix_io_manager,
@@ -3779,8 +3779,6 @@ int main(int argc, char *argv[])
 	fctx.fs = global_fs;
 	global_fs->priv_data = &fctx;
 
-	ret = 3;
-
 	if (ext2fs_has_feature_journal_needs_recovery(global_fs->super)) {
 		if (!fctx.ro) {
 			printf(_("%s: recovering journal\n"), fctx.device);
@@ -3797,6 +3795,7 @@ int main(int argc, char *argv[])
 		} else {
 			printf("%s", _("Journal needs recovery; running "
 			       "`e2fsck -E journal_only' is required.\n"));
+			err = 1;
 			goto out;
 		}
 	}
@@ -3836,6 +3835,7 @@ int main(int argc, char *argv[])
 	if (global_fs->super->s_state & EXT2_ERROR_FS) {
 		printf("%s",
 		       _("Errors detected; running e2fsck is required.\n"));
+		err = 1;
 		goto out;
 	}
 
@@ -3859,11 +3859,16 @@ int main(int argc, char *argv[])
 	}
 
 	pthread_mutex_init(&fctx.bfl, NULL);
-	fuse_main(args.argc, args.argv, &fs_ops, &fctx);
+	ret = fuse_main(args.argc, args.argv, &fs_ops, &fctx);
 	pthread_mutex_destroy(&fctx.bfl);
 
-	ret = 0;
 out:
+	/*
+	 * Encountered error reading the file system. Return standard "mount
+	 * failure" mount exit code (32).
+	 */
+	if (err)
+		ret = 32;
 	if (global_fs) {
 		err = ext2fs_close(global_fs);
 		if (err)
-- 
2.17.1
