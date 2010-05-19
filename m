From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] e2fsck: correct test for EOFBLOCKS
Date: Wed, 19 May 2010 13:20:13 -0500
Message-ID: <4BF42BDD.9090301@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15966 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400Ab0ESSUR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 May 2010 14:20:17 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This test, added to e2fsprogs-1.41.12, is backwards.

If EOFBLOCKS is set, then the size -should- be less than
the last physical block...

xfstests 013 caught this.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: e2fsprogs-1.41.12/e2fsck/pass1.c
===================================================================
--- e2fsprogs-1.41.12.orig/e2fsck/pass1.c
+++ e2fsprogs-1.41.12/e2fsck/pass1.c
@@ -2013,7 +2013,7 @@ static void check_blocks(e2fsck_t ctx, s
 		 * doesn't need to be.
 		 */
 		if ((inode->i_flags & EXT4_EOFBLOCKS_FL) &&
-		    (size <= (((__u64)pb.last_block + 1) * fs->blocksize))) {
+		    (size >= (((__u64)pb.last_block + 1) * fs->blocksize))) {
 			pctx->blkcount = pb.last_block;
 			if (fix_problem(ctx, PR_1_EOFBLOCKS_FL_SET, pctx)) {
 				inode->i_flags &= ~EXT4_EOFBLOCKS_FL;

