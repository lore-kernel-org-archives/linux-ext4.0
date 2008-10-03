From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 3/3] ext4: Use readahead when reading an inode from the
	inode table
Date: Thu, 2 Oct 2008 23:56:04 -0400
Message-ID: <20081003035604.GC9017@mit.edu>
References: <1222275213-16268-1-git-send-email-tytso@mit.edu> <1222275213-16268-2-git-send-email-tytso@mit.edu> <1222275213-16268-3-git-send-email-tytso@mit.edu> <20080926082107.GT10950@webber.adilger.int> <20080928042749.GA8711@mit.edu> <20081002021746.GL3160@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:54083 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753895AbYJCD4H (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Oct 2008 23:56:07 -0400
Content-Disposition: inline
In-Reply-To: <20081002021746.GL3160@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 01, 2008 at 07:17:46PM -0700, Andreas Dilger wrote:
> I'd actually thought that having a tunable in units of "kB" is better
> than blocks, since userspace shouldn't have to know the filesystem
> block size to tune readahead for a device.  Depending on the block size
> this tunable can vary by 64x the amount of readahead (1kB vs. 64kB blocks).

True, but realistically, except for benchmarks and die-hards that want
to get the last bit of performance out, I really doubt that many
people will be tweaking this tunable anyway.  Mainly I'm just feeling
rather lazy and am not sure it's worth it.  :-)

> > +		 * If we need to do any I/O, try to readahead up to 16
> > +		 * blocks from the inode table.
> 
> Comment is out of date.

Good point, thanks, I'll fix it.

> 
> > +		if (EXT4_SB(sb)->s_inode_readahead_blks) {
> > +			/* Make sure s_inode_readahead_blks is a power of 2 */
> > +			while (EXT4_SB(sb)->s_inode_readahead_blks &
> > +			       (EXT4_SB(sb)->s_inode_readahead_blks-1))
> > +				EXT4_SB(sb)->s_inode_readahead_blks = 
> > +				   (EXT4_SB(sb)->s_inode_readahead_blks &
> > +				    (EXT4_SB(sb)->s_inode_readahead_blks-1));
> 
> Is there a good reason why the readahead blocks is a power of 2?  Given
> that the blocks are likely NOT contiguous for a directory, nor are they
> aligned to the underlying LUN offsets, I don't think this is a benefit.

What we are reading ahead here are not directory blocks, but the inode
table.  So these are real, physical block numbers that we are dealing
with here, and so aligning the read requests to powers of two can be very
helpful.

> In any case, any tweaking of s_inode_readahead_blks should probably be
> done at the time it is set instead of each time an inode is read.

The parameter s_inode_readahead_blks can be set via a proc setting, so
it would be a lot more trouble to tweak the parameter at the time when
it is set.  (It could be done, but it means we could no longer use the
generic proc functions.)  As it turns out, if s_inode_readahead_blks
is a power of two, the while loop becomes a single conditional branch
instruction, so it's really not that expensive.

> > +			ext4_error(sb, "ext4_get_inode_loc",
> 
> s/ext4_get_inode_loc/__func__/?

Sure.

> > +		case Opt_inode_readahead_blks:
> > +			if (option < 0 || option > 31)
> > +				return 0;
> > +			sbi->s_inode_readahead_blks = option;
> 
> This would appear to limit the inode_readahead_blks to 31 blocks, yet the
> default is 32?  I suspect this is left over from when it was a shift?

Yup, good point.  I didn't notice becuase it's much more convenient to
use the /proc interface, and that's how I did all of my testing.

    	      		     	    	- Ted

