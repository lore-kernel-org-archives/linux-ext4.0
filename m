From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 3/3] ext4: Use readahead when reading an inode from the
	inode table
Date: Wed, 01 Oct 2008 19:17:46 -0700
Message-ID: <20081002021746.GL3160@webber.adilger.int>
References: <1222275213-16268-1-git-send-email-tytso@mit.edu>
 <1222275213-16268-2-git-send-email-tytso@mit.edu>
 <1222275213-16268-3-git-send-email-tytso@mit.edu>
 <20080926082107.GT10950@webber.adilger.int> <20080928042749.GA8711@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:46619 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbYJBCR7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Oct 2008 22:17:59 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m922Hwfi005143
	for <linux-ext4@vger.kernel.org>; Wed, 1 Oct 2008 19:17:58 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K8300901A951C00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Wed, 01 Oct 2008 19:17:58 -0700 (PDT)
In-reply-to: <20080928042749.GA8711@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 28, 2008  00:27 -0400, Theodore Ts'o wrote:
> ext4: Use readahead when reading an inode from the inode table
> 
> With modern hard drives, reading 64k takes roughly the same time as
> reading a 4k block.  So request readahead for adjacent inode table
> blocks to reduce the time it takes when iterating over directories
> (especially when doing this in htree sort order) in a cold cache case.
> With this patch, the time it takes to run "git status" on a kernel
> tree after flushing the caches via "echo 3 > /proc/sys/vm/drop_caches"
> is reduced by 21%.

I'd actually thought that having a tunable in units of "kB" is better
than blocks, since userspace shouldn't have to know the filesystem
block size to tune readahead for a device.  Depending on the block size
this tunable can vary by 64x the amount of readahead (1kB vs. 64kB blocks).

> @@ -3969,6 +3934,36 @@ static int __ext4_get_inode_loc(struct inode *inode,
>  
>  make_io:
>  		/*
> +		 * If we need to do any I/O, try to readahead up to 16
> +		 * blocks from the inode table.

Comment is out of date.

> +		if (EXT4_SB(sb)->s_inode_readahead_blks) {
> +			/* Make sure s_inode_readahead_blks is a power of 2 */
> +			while (EXT4_SB(sb)->s_inode_readahead_blks &
> +			       (EXT4_SB(sb)->s_inode_readahead_blks-1))
> +				EXT4_SB(sb)->s_inode_readahead_blks = 
> +				   (EXT4_SB(sb)->s_inode_readahead_blks &
> +				    (EXT4_SB(sb)->s_inode_readahead_blks-1));

Is there a good reason why the readahead blocks is a power of 2?  Given
that the blocks are likely NOT contiguous for a directory, nor are they
aligned to the underlying LUN offsets, I don't think this is a benefit.
In any case, any tweaking of s_inode_readahead_blks should probably be
done at the time it is set instead of each time an inode is read.

> +			ext4_error(sb, "ext4_get_inode_loc",

s/ext4_get_inode_loc/__func__/?

> +		case Opt_inode_readahead_blks:
> +			if (option < 0 || option > 31)
> +				return 0;
> +			sbi->s_inode_readahead_blks = option;

This would appear to limit the inode_readahead_blks to 31 blocks, yet the
default is 32?  I suspect this is left over from when it was a shift?

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

