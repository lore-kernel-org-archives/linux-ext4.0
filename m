From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] libext2fs: use ext2fs_blocks_count() in ext2fs_open2()
Date: Tue, 01 Sep 2009 16:43:16 -0500
Message-ID: <4A9D9574.3010606@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33909 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755220AbZIAVnQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Sep 2009 17:43:16 -0400
Received: from int-mx03.intmail.prod.int.phx2.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n81LhInn016156
	for <linux-ext4@vger.kernel.org>; Tue, 1 Sep 2009 17:43:18 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id n81LhGxC025992
	for <linux-ext4@vger.kernel.org>; Tue, 1 Sep 2009 17:43:17 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext2fs_open2() was only looking at s_blocks_count, and
when it wrapped to a low number, it was failing the test of:

  fs->super->s_first_data_block >= fs->super->s_blocks_count

which made the superblock look corrupt.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Patch is against the pu branch

Index: e2fsprogs/lib/ext2fs/openfs.c
===================================================================
--- e2fsprogs.orig/lib/ext2fs/openfs.c
+++ e2fsprogs/lib/ext2fs/openfs.c
@@ -288,7 +288,7 @@ errcode_t ext2fs_open2(const char *name,
 	    blocks_per_group > EXT2_MAX_BLOCKS_PER_GROUP(fs->super) ||
 	    fs->inode_blocks_per_group > EXT2_MAX_INODES_PER_GROUP(fs->super) ||
            EXT2_DESC_PER_BLOCK(fs->super) == 0 ||
-           fs->super->s_first_data_block >= fs->super->s_blocks_count) {
+           fs->super->s_first_data_block >= ext2fs_blocks_count(fs->super)) {
 		retval = EXT2_ET_CORRUPT_SUPERBLOCK;
 		goto cleanup;
 	}

