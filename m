From: Alexandre Ratchov <alexandre.ratchov@bull.net>
Subject: [patch 03/12] rfc: 2fsprogs update
Date: Tue, 26 Sep 2006 16:46:33 +0200
Message-ID: <20060926144633.GC25755@openx1.frec.bull.fr>
References: <20060926143343.GA20020@openx1.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jean-Pierre Dion <jean-pierre.dion@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:34182 "EHLO
	ecfrec.frec.bull.fr") by vger.kernel.org with ESMTP id S932096AbWIZOqk
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Sep 2006 10:46:40 -0400
Received: from localhost (localhost [127.0.0.1])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 4A70B19D90C
	for <linux-ext4@vger.kernel.org>; Tue, 26 Sep 2006 16:46:37 +0200 (CEST)
Received: from ecfrec.frec.bull.fr ([127.0.0.1])
 by localhost (ecfrec.frec.bull.fr [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 12070-10 for <linux-ext4@vger.kernel.org>;
 Tue, 26 Sep 2006 16:46:34 +0200 (CEST)
Received: from ecn002.frec.bull.fr (ecn002.frec.bull.fr [129.183.4.6])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 57C3619D915
	for <linux-ext4@vger.kernel.org>; Tue, 26 Sep 2006 16:46:34 +0200 (CEST)
To: linux-ext4@vger.kernel.org
In-Reply-To: <20060926143343.GA20020@openx1.frec.bull.fr>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Allow regular files to be preallocated on-disk up to the next multiple
of the system PAGE_SIZE without complaining about extra blocks.

Index: e2fsprogs/e2fsck/pass1.c
===================================================================
--- e2fsprogs.orig/e2fsck/pass1.c	2006-07-05 12:11:09.000000000 -0600
+++ e2fsprogs/e2fsck/pass1.c	2006-07-05 14:23:49.000000000 -0600
@@ -1486,9 +1486,14 @@ static void check_blocks(e2fsck_t ctx, s
 				bad_size = 2;
 		}
 	} else {
+		e2_blkcnt_t blkpg = getpagesize() / fs->blocksize;
+
 		size = EXT2_I_SIZE(inode);
 		if ((pb.last_block >= 0) &&
-		    (size < (__u64) pb.last_block * fs->blocksize))
+		    /* allow allocated blocks to end of PAGE_SIZE */
+		    (size < (__u64)pb.last_block * fs->blocksize) &&
+		    (pb.last_block / blkpg * blkpg != pb.last_block ||
+		     size < (__u64)(pb.last_block & ~(blkpg-1)) *fs->blocksize))
 			bad_size = 3;
 		else if (size > ext2_max_sizes[fs->super->s_log_block_size])
 			bad_size = 4;

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

