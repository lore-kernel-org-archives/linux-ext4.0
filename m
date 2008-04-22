From: Josef Bacik <jbacik@redhat.com>
Subject: Re: [RFC][PATCH] fiemap support for ext3
Date: Mon, 21 Apr 2008 20:16:07 -0400
Message-ID: <20080422001607.GB14775@unused.rdu.redhat.com>
References: <20080418210913.GB13973@unused.rdu.redhat.com> <20080421220851.GP2775@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <jbacik@redhat.com>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47122 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758907AbYDVA0Q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Apr 2008 20:26:16 -0400
Content-Disposition: inline
In-Reply-To: <20080421220851.GP2775@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 21, 2008 at 04:08:51PM -0600, Andreas Dilger wrote:
> On Apr 18, 2008  17:09 -0400, Josef Bacik wrote:
> > Here is my patch for fiemap support on ext3.  The main reason for doing this is
> > because it will make it easier for application developers who are wanting to
> > take advantage of fiemap on extent based fs's to be able to use the same
> > interface for ext3 as well without having to fallback onto something like
> > fibmap.  Fibmap also means you are calling ext3_get_block for _every_ block in
> > the file, which is ineffecient when ext3_get_blocks can map multiple contiguous
> > blocks all at once, reducing the number of times you have to call
> > ext3_get_blocks.  Tested this with sandeens fiemap test program and verified it
> > with filefrag.  Thanks much,
> > 
> > Signed-off-by: Josef Bacik <jbacik@redhat.com>
> 
> Josef, thanks for doing this work.  Having more than a single filesystem
> implement FIEMAP (especially a block-mapped one) is very useful.  Did you
> look at all at making a "generic_fiemap()" function?  It seems very little
> of ext3_fiemap() is ext3 specific, only the call to ext3_force_commit()
> (which could just be a sync on the inode), ext3_block_map() (generic for
> all block-based filesystems), and truncate_mutex (would i_sem be enough?).
>

Like Eric points out I wasn't sure if other fs's would handle the case where
b_size > blocksize properly and map contiguous blocks together until it hit an
unallocated block.  If that is a safe assumption to take then I'll do it
generically.  I thought i_sem would be a bit heavy handed, but if you would
prefer it that way I can change it.
 
> > +int ext3_fiemap(struct inode *inode, unsigned long arg)
> > +{
> > +	/*
> > +	 * if fm_start is in the middle of the current block, get the next
> > +	 * block so we don't end up returning a start thats before the given
> > +	 * fm_start
> > +	 */
> > +	start_blk = (fiemap_s->fm_start + (1 << inode->i_blkbits) - 1) >>
> > +		inode->i_blkbits;
> 
> Hmm, I'd think that if someone is requesting the mapping for bytes [50-5000]
> they wouldn't be very happy with the mapping returned being [4096-8191],
> because it is missing part of the requested range.  Instead, the fm_start
> should be rounded down to the start of the first block and up to the end
> of the last block to return [0-8191] (fm_start = 0, fm_length = 8192).
> 

Ok I will change it, just wasn't sure if returning a start value before the
given start value would be appreciated or not.  I guess we can say what it will
do in the man page :).  Thanks much,

Josef
