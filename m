From: Andreas Dilger <adilger@sun.com>
Subject: [PATCH] only restart e2fsck once for inodes in uninit range
Date: Thu, 28 May 2009 00:39:49 -0600
Message-ID: <20090528063949.GE3218@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:35410 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbZE1GkB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 May 2009 02:40:01 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n4S6e1lt023705
	for <linux-ext4@vger.kernel.org>; Wed, 27 May 2009 23:40:01 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KKC00C00CQ3P700@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Wed,
 27 May 2009 23:40:01 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Restart e2fsck only once in case of multiple inodes in uninit range.
Display correct inode number during BG_INO_UNINIT and INOREF_IN_USED errors.

Signed-off-by: Kalpak Shah <kalpak.shah@sun.com>
Signed-off-by: Andreas Dilger <adilger@sun.com>

Index: e2fsprogs-1.41.4/e2fsck/pass2.c
===================================================================
--- e2fsprogs-1.41.4.orig/e2fsck/pass2.c	2008-12-09 08:02:37.000000000 +0530
+++ e2fsprogs-1.41.4/e2fsck/pass2.c	2009-04-12 11:25:00.000000000 +0530
@@ -153,6 +153,12 @@
 						&cd);
 	if (ctx->flags & E2F_FLAG_SIGNAL_MASK || ctx->flags & E2F_FLAG_RESTART)
 		return;
+
+	if (ctx->flags & E2F_FLAG_RESTART_LATER) {
+		ctx->flags |= E2F_FLAG_RESTART;
+		return;
+	}
+
 	if (cd.pctx.errcode) {
 		fix_problem(ctx, PR_2_DBLIST_ITERATE, &cd.pctx);
 		ctx->flags |= E2F_FLAG_ABORT;
@@ -988,23 +994,24 @@
 		 * newly visible inodes.
 		 */
 		if (fs->group_desc[group].bg_flags & EXT2_BG_INODE_UNINIT) {
+			pctx.num = dirent->inode;
 			if (fix_problem(ctx, PR_2_INOREF_BG_INO_UNINIT,
 					&cd->pctx)){
 				fs->group_desc[group].bg_flags &=
 					~EXT2_BG_INODE_UNINIT;
 				ext2fs_mark_super_dirty(fs);
-				ctx->flags |= E2F_FLAG_RESTART;
+				ctx->flags |= E2F_FLAG_RESTART_LATER;
 			} else {
 				ext2fs_unmark_valid(fs);
 				if (problem == PR_2_BAD_INO)
 					goto next;
 			}
 		} else if (dirent->inode >= first_unused_inode) {
+			pctx.num = dirent->inode;
 			if (fix_problem(ctx, PR_2_INOREF_IN_UNUSED, &cd->pctx)){
 				fs->group_desc[group].bg_itable_unused = 0;
 				ext2fs_mark_super_dirty(fs);
-				ctx->flags |= E2F_FLAG_RESTART;
-				goto restart_fsck;
+				ctx->flags |= E2F_FLAG_RESTART_LATER;
 			} else {
 				ext2fs_unmark_valid(fs);
 				if (problem == PR_2_BAD_INO)
@@ -1145,7 +1152,6 @@
 	return 0;
 abort_free_dict:
 	ctx->flags |= E2F_FLAG_ABORT;
-restart_fsck:
 	dict_free_nodes(&de_dict);
 	return DIRENT_ABORT;
 }
Index: e2fsprogs-1.41.4/e2fsck/e2fsck.h
===================================================================
--- e2fsprogs-1.41.4.orig/e2fsck/e2fsck.h	2009-04-12 11:07:44.000000000 +0530
+++ e2fsprogs-1.41.4/e2fsck/e2fsck.h	2009-04-12 11:20:53.000000000 +0530
@@ -163,6 +163,7 @@
 #define E2F_FLAG_CANCEL		0x0002 /* Cancel signaled */
 #define E2F_FLAG_SIGNAL_MASK	0x0003
 #define E2F_FLAG_RESTART	0x0004 /* Restart signaled */
+#define E2F_FLAG_RESTART_LATER	0x0008 /* Restart after all iterations done */
 
 #define E2F_FLAG_SETJMP_OK	0x0010 /* Setjmp valid for abort */
 
Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

