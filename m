From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [RFC][Patch 1/1] Persistent preallocation in ext4
Date: Wed, 13 Dec 2006 15:31:58 +0530
Message-ID: <20061213100158.GA6517@amitarora.in.ibm.com>
References: <20061205134338.GA1894@amitarora.in.ibm.com> <20061206055822.GA6182@amitarora.in.ibm.com> <1165886895.3939.18.camel@dyn9047017103.beaverton.ibm.com> <20061212062302.GA8280@amitarora.in.ibm.com> <1165969238.3771.34.camel@dyn9047017103.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, suparna@in.ibm.com, suzuki@in.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:51444 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964784AbWLMKCI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Dec 2006 05:02:08 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id kBDA2Y00023617
	for <linux-ext4@vger.kernel.org>; Wed, 13 Dec 2006 05:02:34 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kBDA26Ji230770
	for <linux-ext4@vger.kernel.org>; Wed, 13 Dec 2006 05:02:06 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kBDA26J2025206
	for <linux-ext4@vger.kernel.org>; Wed, 13 Dec 2006 05:02:06 -0500
To: Mingming Cao <cmm@us.ibm.com>
Content-Disposition: inline
In-Reply-To: <1165969238.3771.34.camel@dyn9047017103.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Dec 12, 2006 at 04:20:38PM -0800, Mingming Cao wrote:
> On Tue, 2006-12-12 at 11:53 +0530, Amit K. Arora wrote:
> > +
> > +		if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL))
> > +			return -ENOTTY;
> >
> 
> Supporting preallocation for extent based files seems fairly
> straightforward.  I agree we should look at this first.  After get this
> done, it probably worth re-consider whether to support preallocation for
> non-extent based files on ext4. I could imagine user upgrade from ext3
> to ext4, and expecting to use preallocation on those existing files....

I gave a thought on this initially. But, I was not sure how we should
implement preallocation in a non-extent based file. Using extents we can
mark a set of blocks as unitialized, but how will we do this for
non-extent based files ? If we do not have a way to mark blocks
uninitialized, when someone will try to read from a preallocated block,
it will return junk/stale data instead of zeroes.

But, if we can think of a solution here then it will be as simple as
removing the check above and replacing "ext4_ext_get_blocks()" with
"ext4_get_blocks_wrap()" in the while() loop.

> 
> > +
> > +		block = EXT4_BLOCK_ALIGN(input.offset, blkbits) >> blkbits;
> > +		max_blocks = EXT4_BLOCK_ALIGN(input.len, blkbits) >> blkbits;

I was wondering if I should change above lines to this :

+		block = input.offset >> blkbits;
+		max_blocks = (EXT4_BLOCK_ALIGN(input.len+input.offset,
					blkbits) >> blkbits) - block;

Reason is that the block which contains the offset, should also be
preallocated. And the max_blocks should be calculated accordingly.

> > +		while(ret>=0 && ret<max_blocks)
> > +		{
> > +			block = block + ret;
> > +			max_blocks = max_blocks - ret;
> > +	  		ret = ext4_ext_get_blocks(handle, inode, block,
> > +					max_blocks, &map_bh,
> > +					EXT4_CREATE_UNINITIALIZED_EXT, 1);
> 
> Since the interface takes offset and number of blocks to allocate, I
> assuming we are going to handle holes in preallocation, thus, we cannot
> not mark the extend_size flag to 1 when calling ext4_ext_get_blocks.
> 
> I think we should update i_size and i_disksize after preallocation. Oh,
> to protect parallel updating i_size, we have to take i_mutex down.

Okay. So, is this what you want to be done here :

+retry:
+                ret = 0;
+                while(ret>=0 && ret<max_blocks)
+                {
+                        block = block + ret;
+                        max_blocks = max_blocks - ret;
+                        ret = ext4_ext_get_blocks(handle, inode, block,
+                                        max_blocks, &map_bh,
+                                        EXT4_CREATE_UNINITIALIZED_EXT,0);
+                        if(ret > 0 && test_bit(BH_New, &map_bh.b_state))
+                                nblocks = nblocks + ret;
+                }
+                if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb,
+                                                &retries))
+                        goto retry;
+
+                if(nblocks) {
+                        mutex_lock(&inode->i_mutex);
+                        inode->i_size = inode->i_size + (nblocks >> blkbits);
+                        EXT4_I(inode)->i_disksize = inode->i_size;
+                        mutex_unlock(&inode->i_mutex);
+                }

> 
> > +		}
> > +		ext4_mark_inode_dirty(handle, inode);
> > +		ext4_journal_stop(handle);
> > +
> 
> Error code returned by ext4_journal_stop() is being ignored here, is
> this right?
> Well, there are other places in ext34/ioctl.c which ignore the return
> returned by ext4_journal_stop(), maybe should fix this in a separate
> patch.

Agreed. I think following should take care of it:

+               ext4_mark_inode_dirty(handle, inode);
+               ret2 = ext4_journal_stop(handle);
+               if(ret > 0)
+                       ret = ret2;
+               return ret > 0 ? nblocks : ret;

> > +		return ret>0?0:ret;
> > +	}
> >
> >
> Oh, what if we failed to allocate the full amount of blocks? i.e, the
> ext4_ext_get_blocks() returns -ENOSPC error and exit the loop early. Are
> we going to return error, or try something like
> 
> if (ret == -ENOSPC && ext3_should_retry_alloc(inode->i_sb, &retries))
> 	goto retry
> 
> I wonder it might be useful to return the actual number of blocks
> preallocated back to the application.

Ok. Yes, makes sense. We can return the number of "new" blocks like
this:
+               return ret > 0 ? nblocks : ret;



Please let me know if you agree with the above set of changes, and any
further comments you have. I will then update and test the new patch and
post it again. Thanks!

Regards,
Amit Arora
