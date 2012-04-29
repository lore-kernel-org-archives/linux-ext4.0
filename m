From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 15/23] jbd2: Change disk layout for metadata
 checksumming
Date: Sun, 29 Apr 2012 15:39:21 -0400
Message-ID: <20120429193921.GA7342@thunk.org>
References: <20120306204750.1663.96751.stgit@elm3b70.beaverton.ibm.com>
 <20120306204941.1663.56283.stgit@elm3b70.beaverton.ibm.com>
 <20120428141933.GB29481@thunk.org>
 <FCF93AD5-A078-4855-BC8D-B7B046884411@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>,
	Joel Becker <jlbec@evilplan.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55271 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752539Ab2D2TjZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 29 Apr 2012 15:39:25 -0400
Content-Disposition: inline
In-Reply-To: <FCF93AD5-A078-4855-BC8D-B7B046884411@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[ I've trimmed the cc line to avoid spamming lots of folks who might not
  care about the details of jbd2 checksumming. ]

On Sat, Apr 28, 2012 at 04:58:12PM -0600, Andreas Dilger wrote:
> 
> I thought we originally discussed using the high 16 bits of the
> t_flags field to store the checksum?  This would avoid the need to
> change the disk format.

I don't recall that suggestion, but I like it.  One thing that will
get subtle about this is that t_flags is stored big-endian (jbd/jbd2
data structures are stored be, but the data structures in ext4 proper
are stored le; sigh).   So we'd have to do something like this:

typedef struct journal_block_tag_s
{
	__u32		t_blocknr;	/* The on-disk block number */
	__u16		t_checksum;	/* 16-bit checksum */
	__u16		t_flags;	/* See below */
	__u32		t_blocknr_high; /* most-significant high 32bits. */
} journal_block_tag_t;

... and then make sure we change all of the places that access t_flags
using cpu_to_be32() and be32_to_cpu() get changed to the 16-bit
variant.

> Since there is still a whole transaction checksum, it isn't so
> critical that the per-block checksum be strong.
>
> One idea is to do the crc32c for each block, then store the high 16
> bits into t_flags, and checksum the full 32-bit per-block checksums
> to make the commit block checksum, to avoid having to do the block
> checksums twice.

It's not critical because the hard drive is doing its own ECC.  So I'm
not that worried about detecting a large burst of bit errors, which is
the main advantage of using a larger CRC.  I'm more worried about a
disk block getting written to the wrong place, or not getting written
at all.  So whether the chance of detecting a wrong block is 99.9985%
at all (w/ a 16-bit checksum) or 99.9999% (with a 32-bit checksum),
at all, either is fine.

I'm not even sure I would worry combining the per-block checksums into
the commit block checksum.  In the rare case where there is an error
not detected by the 16-bit checksum which is detected in the commit
checksum, what are we supposed to do?  Throw away the entire commit
again?  Just simply testing to see what we do in this rare case is
going to be interesting / painful.

   	     	     	      	 	     - Ted
