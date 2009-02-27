From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH, RFC] ext4: New inode/block allocation algorithms for
	flex_bg filesystems
Date: Fri, 27 Feb 2009 02:17:04 -0700
Message-ID: <20090227091704.GR3199@webber.adilger.int>
References: <20090218154310.GH3600@mini-me.lan> <20090226182156.GL7227@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Eric Sandeen <sandeen@redhat.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:61842 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319AbZB0JRX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 27 Feb 2009 04:17:23 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n1R9HG3x029685
	for <linux-ext4@vger.kernel.org>; Fri, 27 Feb 2009 01:17:16 -0800 (PST)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7.0-3.01 64bit (built Dec 23 2008))
 id <0KFP00L00WFGIO00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Fri,
 27 Feb 2009 01:17:16 -0800 (PST)
In-reply-to: <20090226182156.GL7227@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Feb 26, 2009  13:21 -0500, Theodore Ts'o wrote:
> I tried adding some of Andreas' suggestions which would tend to pack
> the inodes less agressively, in the hopes that it might speed up the
> mkdir operation, but at least for seq_mkdir/mkdirs_mark benchmark, it
> really didn't help, because we are disk bound, not cpu bound.

Could you explain in a bit more detail what you tried?  In particular,
was this the "mapping hash range onto itable range" I have proposed in
the past?

As a rough outline of what I'm thinking, this kind of mapping might only
start once we exceed a single directory leaf block, as this coincides
with the start of htree hashing and hash-order vs. itable-order randomness.

Basically we would map the N leaf blocks of a directory into a range
of M itable blocks that had some number of free inodes.  If we start
with 2 directory leaf blocks (right after split) that are 1/2 full:

 4096 bytes/itable block / 512 bytes/inode = 8 inode/itable block
 4096 bytes/leaf block / 40 bytes/dirent  = 102 dirent/leaf block
 
 102 dirent/leaf * 1/2 / 1 dirent/inode / 8 inode/itable = 6 itable/leaf

so that would mean filling the remaining 1/2 space in the 2 leaf blocks
would consume about 12 itable blocks.  When there are 4 leaf blocks in the
directory we map to 24 itable blocks.

When we are scanning this directory (say at 4 leaf block size) for values
in the first leaf block (which is in hash order) the entries will likely
be in either:
+ the first 12 itable blocks (there was no itable ordering at that time)
+ the first 3 blocks of the first 12-block range (1/4 of hash values)
+ the first 6 blocks of the second 24-block range (1/4 of hash values)
= 21 blocks

Contrast this with regular htree inode allocation, the first 1/4 of the
directory entries will likely (randomly) have entries in all 12+12+24=48
of the blocks, so we are loading/modifying about 1/2 of the itable blocks
when doing stat/unlink in the directory.

If we make a table for stat/unlink of all entries in the first leaf block:

directory size	total			1 leaf blk	leaf blocks	access
blocks:files	itable blocks		file ratio	accessed	ratio
  1	  102	12			1/1		12		1
  2 	  204	12+12=24		1/2		12+6=18		3/4
  4 	  408	12+12+24=48		1/4		12+3+6=21	1/3
  8 	  816	12+12+24+48=96 		1/8		12+2+3+6=23	1/4
 16	 1632	12+12+24+48+96=192	1/16		12+1+2+3+6=24	1/8
 32	 3264	 384			1/32		24+1=25		1/15
 64	 6528	 768			1/64		25+1=26		1/30
128	13056   1536			1/128		27		1/57

While initially it seems that past a directory of size 8 blocks we would
only modify at most 102 itable blocks per dirent block (== number of
entries in the dirent block) and the "access ratio" would stick around 1/4,
in practise we should continue to get proportionately fewer itable blocks
loaded/modified per dirent block because the itable blocks allocated
at the beginning (12+...) are used/modified repeatedly for the first
N dirent blocks and do not further negatively impact performance (no
re-loads due to cache pressure, or are redirtied in the journal).

In comparison, with the current "random" dirent->itable mapping we would
get another 102 new dirent blocks touched for each leaf block, and for
larger directories the leaf blocks cannot even all fit into a single
journal transaction and the performance tanks because each unlink will
cause a separate 4kB block to be written into the journal.

> +	int flex_size = ext4_flex_bg_size(EXT4_SB(ac->ac_sb));
>  
> +		/* Avoid using the first bg of a flexgroup for data files */
> +		    (flex_size >= EXT4_FLEX_SIZE_DIR_ALLOC_SCHEME) &&

Since these are both constants, wouldn't it make more sense to just
check the sbi->s_log_groups_per_flex against the lg of the threshold:

	if (sbi->s_log_groups_per_flex > (2)) (as a #defined constant)

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

