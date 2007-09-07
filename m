From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: Bad performance results with the latest git patches
Date: Fri, 7 Sep 2007 15:37:16 -0600
Message-ID: <20070907213716.GH5377@schatzie.adilger.int>
References: <46E1430F.3050702@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alex Tomas <alex@clusterfs.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:44640 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758590AbXIGVgw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Sep 2007 17:36:52 -0400
Content-Disposition: inline
In-Reply-To: <46E1430F.3050702@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sep 07, 2007  14:24 +0200, Valerie Clement wrote:
> running ffsb tests (large files creation) on my system with the latest 
> ext4 git patches against a 2.6.23-rc4 kernel, I've got very bad 
> performance results: the I/O throughput measured on an ext4 filesystem 
> is ten times lower than those measured on an XFS filesystem on the same 
> machine.
> I have mounted the ext4 filesytem with mballoc, delalloc and 
> data=writeback options.
> 
> dmesg output shows plenty of error messages like this:
> 
> EXT4-fs error (device sdc): ext4_ext_search_right: bad header in inode 
> #3745797: unexpected eh_depth - magic f30a, entries 81, max 84(0), depth 
> 0(1)

It is the message that likely slows down the filesystem.

> If I removed the second call to ext4_ext_check_header() in the 
> ext4_ext_search_right() function, the problem disappears, no more error 
> messages and better throughput values close to those measured on the XFS 
> filesystem.
> It seems that the depth value passed in argument is buggy.
> 
> In a previous line,
>   while (++depth < path->p_depth) {
>
> the depth value is incremented even if we don't enter the loop. Is it 
> the problem ?

No, because the "depth" value is not used after the loop is done.  The
problem is really that the depth decreases down the tree instead of
increasing.  This is not immediately seen during testing because mballoc
does a good job of merging extents and files have to be very fragmented
(heavy multi-threaded IO) and/or very large (>512MB) before the index
grows outside the inode (depth > 0).

The problem was in the recently-added "extent sanity checks", and has
also been fixed:

Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
Signed-off-by: Alex Tomas <alex@clusterfs.com>
Signed-off-by: Johann Lombardi <johann@clusterfs.com>

diff -u linux-2.6.18.8/fs/ext3/extents.c linux-2.6.18.8/fs/ext3/extents.c
--- linux-2.6.18.8/fs/ext3/extents.c	2007-06-20 18:54:00.000000000 +0200
+++ linux-2.6.18.8/fs/ext3/extents.c	2007-06-20 18:54:00.000000000 +0200
@@ -1069,7 +1069,7 @@ ext3_ext_search_right(struct inode *inode,
 		if (bh == NULL)
 			return -EIO;
 		eh = ext_block_hdr(bh);
-		if (ext3_ext_check_header(inode, eh, depth)) {
+		if (ext3_ext_check_header(inode, eh, path->p_depth - depth)) {
 			brelse(bh);
 			return -EIO;
 		}

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
