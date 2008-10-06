From: Kalpak Shah <Kalpak.Shah@Sun.COM>
Subject: [PATCH][13/15] e2fsprogs-i_size-corruption.patch
Date: Mon, 06 Oct 2008 16:01:26 +0530
Message-ID: <1223289086.4007.92.camel@localhost>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_IP2jmB7XH0CIo1W3A3LvXg)"
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: TheodoreTso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sineb-mail-1.sun.com ([192.18.19.6]:38321 "EHLO
	sineb-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbYJFKdG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Oct 2008 06:33:06 -0400
Received: from fe-apac-05.sun.com (fe-apac-05.sun.com [192.18.19.176] (may be forged))
	by sineb-mail-1.sun.com (8.13.6+Sun/8.12.9) with ESMTP id m96AX2N9004456
	for <linux-ext4@vger.kernel.org>; Mon, 6 Oct 2008 10:33:02 GMT
Received: from conversion-daemon.mail-apac.sun.com by mail-apac.sun.com
 (Sun Java System Messaging Server 6.2-6.01 (built Apr  3 2006))
 id <0K8B00701BXCIY00@mail-apac.sun.com>
 (original mail from Kalpak.Shah@Sun.COM) for linux-ext4@vger.kernel.org; Mon,
 06 Oct 2008 18:33:02 +0800 (SGT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Boundary_(ID_IP2jmB7XH0CIo1W3A3LvXg)
Content-type: text/plain
Content-transfer-encoding: 7BIT

Fix handling of block preallocation support in cases where the kernel
PAGE_SIZE is larger than the filesystem blocksize.

Signed-off-by: Kalpak Shah <kalpak.shah@sun.com>
Signed-off-by: Andreas Dilger <adilger@sun.com>


--Boundary_(ID_IP2jmB7XH0CIo1W3A3LvXg)
Content-type: text/x-patch; charset=UTF-8;
 name=e2fsprogs-i_size-corruption.patch
Content-transfer-encoding: 7BIT
Content-disposition: attachment; filename=e2fsprogs-i_size-corruption.patch

Fix handling of block preallocation support in cases where the kernel
PAGE_SIZE is larger than the filesystem blocksize.

Signed-off-by: Kalpak Shah <kalpak@clusterfs.com>
Signed-off-by: Andreas Dilger <adilger@clusterfs.com>

Index: e2fsprogs-1.40.2/e2fsck/pass1.c
===================================================================
--- e2fsprogs-1.40.2.orig/e2fsck/pass1.c
+++ e2fsprogs-1.40.2/e2fsck/pass1.c
@@ -2103,7 +2103,7 @@ static void check_blocks(e2fsck_t ctx, s
 		if ((pb.last_block >= 0) &&
 		    /* allow allocated blocks to end of PAGE_SIZE */
 		    (size < (__u64)pb.last_block * fs->blocksize) &&
-		    (pb.last_block / blkpg * blkpg != pb.last_block ||
+		    ((pb.last_block+1) / blkpg * blkpg != (pb.last_block+1) ||
 		     size < (__u64)(pb.last_block & ~(blkpg-1)) *fs->blocksize))
 			bad_size = 3;
 		else if (size > ext2_max_sizes[fs->super->s_log_block_size])


--Boundary_(ID_IP2jmB7XH0CIo1W3A3LvXg)--
