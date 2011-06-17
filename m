From: Andreas Dilger <adilger@whamcloud.com>
Subject: Commit 94968e74 breaks f_lotsbad
Date: Fri, 17 Jun 2011 00:28:01 -0600
Message-ID: <418F4E42-50E6-4CAA-B6F5-CA59B17E84C0@whamcloud.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:63704 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512Ab1FQG2G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Jun 2011 02:28:06 -0400
Received: by pvg12 with SMTP id 12so1573873pvg.19
        for <linux-ext4@vger.kernel.org>; Thu, 16 Jun 2011 23:28:05 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted,
I was going to send some more fixes, but it looks like your commit
94968e74 "libext2fs: teach bitmap functions about bigalloc/cluster"
breaks the "f_lotsbad" test, which I found via git bisect and verified
is the offending commit:

--- ./f_lotsbad/expect.1        2011-06-01 20:25:00.871615457 +0000
+++ f_lotsbad.1.log     2011-06-17 05:33:37.398073505 +0000
@@ -26,6 +26,7 @@
 
 Restarting e2fsck from the beginning...
 Pass 1: Checking inodes, blocks, and sizes
+Illegal block number passed to ext2fs_test_block_bitmap #0 for in-use block map
 Pass 2: Checking directory structure
 Entry 'termcap' in / (2) has deleted/unused inode 12.  Clear? yes


I couldn't see the obvious correlation between the failure and the patch,
though it is clear the patch is changing ext2fs_test_generic_bitmap(),
but all of the changes should be no-ops because cluster_bits should be 0
unless bigalloc is enabled.

My tree is up to b2e6c86d6, "mke2fs, e2fsck: fix i_blocks handling for bigalloc file systems", which AFAICS is the latest.

Cheers, Andreas
--
Andreas Dilger 
Principal Engineer
Whamcloud, Inc.



