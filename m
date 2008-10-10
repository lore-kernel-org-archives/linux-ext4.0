From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] e2fsprogs: exit from preenhalt if IO errors were encountered
Date: Fri, 10 Oct 2008 17:14:08 -0500
Message-ID: <48EFD3B0.4060009@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:33485 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754077AbYJJWOK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 10 Oct 2008 18:14:10 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id m9AME9jL003013
	for <linux-ext4@vger.kernel.org>; Fri, 10 Oct 2008 18:14:10 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9AME9D6022550
	for <linux-ext4@vger.kernel.org>; Fri, 10 Oct 2008 18:14:09 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id m9AME8jZ021834
	for <linux-ext4@vger.kernel.org>; Fri, 10 Oct 2008 18:14:09 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Resolves RH Bug 465679- e2fsck -p crashes with read-only DM device (e.g. logical volume)  

If a block device is unwritable, e2fsck -p gets into an infinite loop
trying to preenhalt, close & flush the fs, which tries to flush the cache, 
which gets a write error and calls preenhalt which tries to close & flush
the fs ... ad infinitum.

Per Ted's suggestion just flag the ctx as "exiting" and short-circuit
the infinite loop.

Tested by running e2fsck -p on a block device set read-only by BLKROSET.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Index: e2fsprogs/e2fsck/e2fsck.h
===================================================================
--- e2fsprogs.orig/e2fsck/e2fsck.h
+++ e2fsprogs/e2fsck/e2fsck.h
@@ -174,6 +174,7 @@ struct resource_track {
 #define E2F_FLAG_RESTARTED	0x0200 /* E2fsck has been restarted */
 #define E2F_FLAG_RESIZE_INODE	0x0400 /* Request to recreate resize inode */
 #define E2F_FLAG_GOT_DEVSIZE	0x0800 /* Device size has been fetched */
+#define E2F_FLAG_EXITING	0x1000 /* E2fsck exiting due to errors */
 
 /*
  * Defines for indicating the e2fsck pass number
Index: e2fsprogs/e2fsck/ehandler.c
===================================================================
--- e2fsprogs.orig/e2fsck/ehandler.c
+++ e2fsprogs/e2fsck/ehandler.c
@@ -33,7 +33,8 @@ static errcode_t e2fsck_handle_read_erro
 	e2fsck_t ctx;
 
 	ctx = (e2fsck_t) fs->priv_data;
-
+	if (ctx->flags & E2F_FLAG_EXITING)
+		return 0;
 	/*
 	 * If more than one block was read, try reading each block
 	 * separately.  We could use the actual bytes read to figure
@@ -79,6 +80,8 @@ static errcode_t e2fsck_handle_write_err
 	e2fsck_t ctx;
 
 	ctx = (e2fsck_t) fs->priv_data;
+	if (ctx->flags & E2F_FLAG_EXITING)
+		return 0;
 
 	/*
 	 * If more than one block was written, try writing each block
Index: e2fsprogs/e2fsck/util.c
===================================================================
--- e2fsprogs.orig/e2fsck/util.c
+++ e2fsprogs/e2fsck/util.c
@@ -257,6 +257,7 @@ void preenhalt(e2fsck_t ctx)
 	fprintf(stderr, _("\n\n%s: UNEXPECTED INCONSISTENCY; "
 		"RUN fsck MANUALLY.\n\t(i.e., without -a or -p options)\n"),
 	       ctx->device_name);
+	ctx->flags |= E2F_FLAG_EXITING;
 	if (fs != NULL) {
 		fs->super->s_state |= EXT2_ERROR_FS;
 		ext2fs_mark_super_dirty(fs);

