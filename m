From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH][25/28] e2fsprogs-i_size-corruption.patch
Date: Sat, 02 Feb 2008 01:54:11 -0700
Message-ID: <20080202085411.GZ31694@webber.adilger.int>
References: <20080202075943.GB23836@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
To: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:49941 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757528AbYBBIyN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Feb 2008 03:54:13 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m128sDwI021736
	for <linux-ext4@vger.kernel.org>; Sat, 2 Feb 2008 00:54:13 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JVL00501SFKSW00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Sat, 02 Feb 2008 00:54:13 -0800 (PST)
In-reply-to: <20080202075943.GB23836@webber.adilger.int>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


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


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
