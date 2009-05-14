From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/3] ext4: Clear the unwritten buffer_head flag properly
Date: Thu, 14 May 2009 11:30:15 +0530
Message-ID: <20090514060015.GB7359@skywalker>
References: <1241692770-22547-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1241692770-22547-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20090512030856.GI21518@mit.edu> <20090512044627.GA6753@skywalker> <4A0B17F8.3000402@redhat.com> <20090513222847.GA10003@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:55911 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbZENGAm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 May 2009 02:00:42 -0400
Received: from d23relay02.au.ibm.com (d23relay02.au.ibm.com [202.81.31.244])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id n4E5x54E003124
	for <linux-ext4@vger.kernel.org>; Thu, 14 May 2009 15:59:05 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay02.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n4E60fM61343656
	for <linux-ext4@vger.kernel.org>; Thu, 14 May 2009 16:00:41 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n4E60e6H008161
	for <linux-ext4@vger.kernel.org>; Thu, 14 May 2009 16:00:41 +1000
Content-Disposition: inline
In-Reply-To: <20090513222847.GA10003@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 13, 2009 at 06:28:47PM -0400, Theodore Tso wrote:
> On Wed, May 13, 2009 at 01:56:56PM -0500, Eric Sandeen wrote:
> > The comment:
> > 
> >  	/*
> > +	 * The above get_blocks can cause the buffer to be
> > +	 * marked unwritten. So clear the same.
> > +	 */
> > +	clear_buffer_unwritten(bh);
> > 
> > is imho not helpful; to me it says "we -just- set this, so clear it!"
> > It leaves me scratching my head.
> 
> I've updated it the comment to say this instead.
> 
> 	/*
> 	 * When we call get_blocks without the create flag, the
> 	 * BH_Unwritten flag could have gotten set if the blocks
> 	 * requested were part of a uninitialized extent.  We need to
> 	 * clear this flag now that we are committed to convert all or
> 	 * part of the uninitialized extent to be an initialized
> 	 * extent.  This is because we need to avoid the combination
> 	 * of BH_Unwritten and BH_Mapped flags being simultaneously
> 	 * set on the buffer_head.
> 	 */

The last line in the above comment is not a problem with the latest
kernel with all the patches in the patch queue. The patch that does that
is  "ext4: Mark the unwritten buffer_head as mapped during write_begin"

The unwritten and mapped state together was a problem with the code path
we had before in ext4_da_get_block_prep
we had:

ret = ext4_get_blocks(NULL, inode, iblock, 1,  bh_result, 0);
.....
..
} else if (ret > 0) {
	bh_result->b_size = (ret << inode->i_blkbits);
	if (buffer_unwritten(bh_result)) {
		bh_result.b_blocknr = ~0;
		....
	}
}

The above can result in 

1) We do a multi block delayed alloc to prealloc space. That would get
us multiple buffer_heads marked with BH_Unwritten. (say 10, 11, 12)
2) pdflush attempt to write some pages (say mapping block 10) which
cause
a get_block call with create = 1. That would attempt to convert
uninitialized extent to initialized one. This can cause multiple blocks
to be marked initialized. ( say 10, 11 , 12)
3) We do an overwrite of block 11. That would mean we call
ext4_da_get_block_prep, which would again do a get_block for block 11
with create = 0. But remember we already have buffer_head marked with
BH_Unwritten flag. But the buffer was unmapped because it is unwritten
( We are fixing this mess in the patch for 2.6.31).
4) The get_block call will find the buffer mapped due to step b. And
mark the buffer_head mapped. There we go . We end up with buffer_head
mapped and unwritten
5) later in ext4_da_get_block_prep we check whether the buffer_head in
marked
BH_Unwritten if so we set the block number to ~0. This is introduced by
[PATCH -V4 1/2] Fix sub-block zeroing for buffered writes into unwritten
extents
6) So now we have a buffer_head that is mapped, unwritten, with
b_blocknr = ~0. That would result in the I/O error.


Now that we have the actual block number in bh_result.b_blocknr I guess
we should be ok to have the unwritten flag set. But then i guess it is
against the VFS assumption of buffer_head state. The state unwritten
indicate the blocks are not yet written. So if we don't do a
clear_buffer_unwritten as in the patch we end up with a block that is
written ( done via create = 1 get_block call) and still marked
unwritten. (see the 6 step example above)

Now to explain what "ext4: Mark the unwritten buffer_head as mapped
during write_begin" does.

It marks the buffer_head as mapped in the write_begin phase.
And that helps in making sure we don't end up calling get_block
multiple times.  So with delayed allocation we now have between
the write_begin and writepage phase a buffer_head which is mapped
and unwritten for blocks in the fallocate space. Once we do
writepage for the block we will have buffer_head which is mapped and
unwritten flag cleared. The unwritten get cleared when we do a get_block
call with create = 1.


To achieve the above we need to make sure writepage code path looks at
the unwritten flag and does a get_blocks call with create = 1. With
mainline we have in writepage code path

mpage_da_map_blocks(...)

if ((mpd->b_state  & (1 << BH_Mapped)) &&
    !(mpd->b_state & (1 << BH_Delay)))
	return 0;
	...
	..
	ext4_da_get_block_write()


If we start marking buffer_head mapped for fallocate blocks in the
write_begin phase, then the above code will return without doing
any get_block(create = 1) call. That means we don't convert the
uninitialized extent to initialized one. So along with marking
buffer_head mapped and unwritten in the write_begin phase we also
need changes to writepage code path which does something like below

mpage_da_map_blocks(...)

if ((mpd->b_state  & (1 << BH_Mapped)) &&
	!(mpd->b_state & (1 << BH_Delay)) &&
	!(mpd->b_state & (1 << BH_Unwritten)))
	    return 0;
	...
	..
	ext4_da_get_block_write()

this is done in patch "ext4: Mark the unwritten buffer_head as mapped
during write_begin".

-aneesh
