From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] e2fsprogs- fix ext2fs_swap_inode_full attr test on BE boxes
Date: Fri, 29 Feb 2008 16:10:21 -0600
Message-ID: <47C882CD.3090204@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:33056 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933365AbYB2WKX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 Feb 2008 17:10:23 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m1TMAM4F022575
	for <linux-ext4@vger.kernel.org>; Fri, 29 Feb 2008 17:10:22 -0500
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1TMAMju002740
	for <linux-ext4@vger.kernel.org>; Fri, 29 Feb 2008 17:10:22 -0500
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1TMALsQ013345
	for <linux-ext4@vger.kernel.org>; Fri, 29 Feb 2008 17:10:22 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

After the fix for resize2fs's inode mover losing in-inode
extended attributes, the regression test I wrote caught 
that the attrs were still getting lost on powerpc.

Looks like the problem is that ext2fs_swap_inode_full()
isn't paying attention to whether or not the EA magic is
in hostorder, so it's not recognized (and not swapped)
on BE machines.  Patch below seems to fix it.

Yay for regression tests.  ;)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: e2fsprogs-1.40.7/lib/ext2fs/swapfs.c
===================================================================
--- e2fsprogs-1.40.7.orig/lib/ext2fs/swapfs.c
+++ e2fsprogs-1.40.7/lib/ext2fs/swapfs.c
@@ -133,7 +133,7 @@ void ext2fs_swap_inode_full(ext2_filsys 
 			    struct ext2_inode_large *f, int hostorder,
 			    int bufsize)
 {
-	unsigned i, has_data_blocks, extra_isize;
+	unsigned i, has_data_blocks, extra_isize, attr_magic;
 	int islnk = 0;
 	__u32 *eaf, *eat;
 
@@ -231,13 +231,17 @@ void ext2fs_swap_inode_full(ext2_filsys 
 
 	eaf = (__u32 *) (((char *) f) + sizeof(struct ext2_inode) +
 					extra_isize);
-
-	if (ext2fs_swab32(*eaf) != EXT2_EXT_ATTR_MAGIC)
-		return; /* it seems no magic here */
