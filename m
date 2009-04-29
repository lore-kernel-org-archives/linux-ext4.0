From: Mingming <cmm@us.ibm.com>
Subject: Re: [PATCH -V4 1/2] Fix sub-block zeroing for buffered writes into
	unwritten extents
Date: Wed, 29 Apr 2009 10:28:40 -0700
Message-ID: <1241026120.5583.49.camel@BVR-FS.beaverton.ibm.com>
References: <1240980441-8105-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <49F85D5E.8040701@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	tytso@mit.edu, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:48683 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbZD2R2p (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 29 Apr 2009 13:28:45 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e33.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n3THR3wG013197
	for <linux-ext4@vger.kernel.org>; Wed, 29 Apr 2009 11:27:03 -0600
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n3THSf3G154416
	for <linux-ext4@vger.kernel.org>; Wed, 29 Apr 2009 11:28:42 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n3THSfw5023745
	for <linux-ext4@vger.kernel.org>; Wed, 29 Apr 2009 11:28:41 -0600
In-Reply-To: <49F85D5E.8040701@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Wed, 2009-04-29 at 08:59 -0500, Eric Sandeen wrote:
> Aneesh Kumar K.V wrote:
> > We need to mark the  buffer_head mapping prealloc space
> > as new during write_begin. Otherwise we don't zero out the
> > page cache content properly for a partial write. This will
> > cause file corruption with preallocation.
> > 
> > Also use block number -1 as the fake block number so that
> > unmap_underlying_metadata doesn't drop wrong buffer_head
> > 
> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> > 
> > ---
> >  fs/ext4/inode.c |   10 ++++++++++
> >  1 files changed, 10 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > index e91f978..12dcfab 100644
> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > @@ -2323,6 +2323,16 @@ static int ext4_da_get_block_prep(struct inode *inode, sector_t iblock,
> >  		set_buffer_delay(bh_result);
> >  	} else if (ret > 0) {
> >  		bh_result->b_size = (ret << inode->i_blkbits);
> > +		/*
> > +		 * With sub-block writes into unwritten extents
> > +		 * we also need to mark the buffer as new so that
> > +		 * the unwritten parts of the buffer gets correctly zeroed.
> > +		 */
> > +		if (buffer_unwritten(bh_result)) {
> > +			bh_result->b_bdev = inode->i_sb->s_bdev;
> > +			set_buffer_new(bh_result);
> > +			bh_result->b_blocknr = -1;
> > +		}
> >  		ret = 0;
> >  	}
> >  
> 
> Ok, I guess this seems like the safest approach.  Long term we should
> look really hard at the state & block nr of these buffer heads, but I
> agree that keeping the changes restricted to the preallocation path for
> now is safest.
> 

This path (ret >0) this is the path where get_blocks() find the block
allocated or preallocated. The buffer_unwritten() is strict to the
preallocation case, but why not take care of the buffer_new() when we
set the buffer_unwritten() for preallocation  in ext4_ext_get_blocks()
at the first place? That makes the "preallocation" case handling there
all together. 

But both patch is correct, I have tested the prealloc,
prealloc->paritial write, prealloc->paritial long
write->partial-short-write, the content of the afterward read seems all
sane in both patch.

Any thoughts about the comments update I made in my previous patch? This
part of comment in preallocation  handling in ext4_ext_get_blocks()
needs some cleanup.


Think this over, if we set the buffer new here(i.e. in the write_begin()
path), I wonder about the read case: where do we set the buffer_new()
for the read on preallocated space? the ext4_ext_get_blocks() with
create = 0 on preallocated extent will return bh unwritten, but not new.
However my read tests right after new preallocation returns all zeroed
data. I wonder what I am missing.

Mingming
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

