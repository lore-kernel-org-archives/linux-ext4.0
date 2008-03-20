From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: delayed allocation result in BUG at fs/buffer.c:2880!
Date: Thu, 20 Mar 2008 11:18:52 -0700
Message-ID: <1206037132.3637.30.camel@localhost.localdomain>
References: <18399.36935.640758.796880@frecb006361.adech.frec.bull.fr>
	 <47E1CE7F.6050706@redhat.com> <20080320081619.GB13928@dmon-lap.sw.ru>
	 <20080320120957.GB11891@skywalker> <20080320140447.GB19995@dmon-lap.sw.ru>
	 <20080320151645.GA23301@skywalker>
	 <1206033709.3637.15.camel@localhost.localdomain>
	 <20080320180234.GB6931@skywalker>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Dmitri Monakhov <dmonakhov@openvz.org>,
	ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:40441 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754702AbYCTSTA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Mar 2008 14:19:00 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m2KIIv1M018640
	for <linux-ext4@vger.kernel.org>; Thu, 20 Mar 2008 14:18:57 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m2KIIvtn282936
	for <linux-ext4@vger.kernel.org>; Thu, 20 Mar 2008 14:18:57 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m2KIIvHv015744
	for <linux-ext4@vger.kernel.org>; Thu, 20 Mar 2008 14:18:57 -0400
In-Reply-To: <20080320180234.GB6931@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2008-03-20 at 23:32 +0530, Aneesh Kumar K.V wrote:
> Adding linux-ext4 back.
> 
> On Thu, Mar 20, 2008 at 10:21:49AM -0700, Mingming Cao wrote:
> > On Thu, 2008-03-20 at 20:46 +0530, Aneesh Kumar K.V wrote:
> > > On Thu, Mar 20, 2008 at 05:04:47PM +0300, Dmitri Monakhov wrote:
> > > > On 17:39 Thu 20 Mar     , Aneesh Kumar K.V wrote:
> > > > > On Thu, Mar 20, 2008 at 11:16:19AM +0300, Dmitri Monakhov wrote:
> > > > > > On 21:39 Wed 19 Mar     , Eric Sandeen wrote:
> > > > > > > Solofo.Ramangalahy@bull.net wrote:
> > > > > > > > Hello,
> > > > > > > > 
> > > > > > > > During stress testing (workload: racer from ltp + fio/iometer), here
> > > > > > > > is an error I am encountering:
> > > > > > > > 8<------------------------------------------------------------------------------
> > > > > > > > kernel: WARNING: at fs/buffer.c:1680 __block_write_full_page+0xd4/0x2af()
> > > > > > > 
> > > > > > > So this is WARN_ON(bh->b_size != blocksize);
> > > > > > > 
> > > > > > > What is b_size in this case?
> > > > > > FS block size, because this page pinned bh (it comes from page_buffers(page)), but
> > > > > > not dummy bh which may comes from {write,read}pages or direct_IO. 
> > > > > > Page's bh i_size must always be equal to fs blocksize.
> > > > > > This bh always constructed via following construction
> > > > > > if (!page_has_buffers(page))
> > > > > > 	create_empty_buffers(page, 1<<inode->i_blkbits, flags)
> > > > > > So page's bh->b_size was inited with right value from very beginning, but
> > > > > > apparently somewhere this size was changed 
> > > > > > I guess i've localized buggy place, at least it's looks strange.
> > > > > > ext4_da_get_block_prep ()
> > > > > > {
> > > > > > ...
> > > > > > 	BUG_ON(create == 0);
> > > > > >         BUG_ON(bh_result->b_size != inode->i_sb->s_blocksize);
> > > > > > 	ret =  ext4_get_blocks_wrap(NULL,  inode, iblock, 1,  bh_result, 0, 0);
> > > > > > #Here ext4_get_block_write called with max_blocks == 1  ^^^^^
> > > > > > 	...
> > > > > > 	if (ret > 0) {
> > > > > >                         bh_result->b_size = (ret << inode->i_blkbits);
> > > > > > 	^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > > > > > ## I don't understand this place. I hoped what (ret <= max_blocks) must always
> > > > > > ##be true true. But after I've add debug info printing I've got following result.
> > > > > >                 ret = 0;
> > > > > >         }
> > > > > > ...
> > > > > > }
> > > > > > Some times I've seen following ,message 
> > > > > >  bh= {state=0,size=114688, blknr=18446744073709551615 dev=0000000000000000,count=0}, ret=28
> > > > > > And because it was page-cache's bh later this result in WARNING.
> > > > > 
> > > > > Is that a fallocate space ?. For falloc space we can return values
> > > > > greater than max_blocks. ext4_ext_get_blocks was made to return  >0
> > > > > for a read on prealloc space to ensure delalloc doesn't reserve space
> > > > > for the same. I guess we need to make sure we don't return more than
> > > > > max_blocks. Can you try the patch below
> > > > Ok Warning has gone, but resulted bh still incorrectly filled.
> > > > I've found what function ext4_da_get_block_prep() return bh witch 
> > > > is !mapped and !delayed, which is prohibited because it is always called with
> > > > create != 0. BH debug info at the end of this function result in following msg
> > > > 
> > > > BH={state=0, size=4096, blknr=18446744073709551615,dev=0000000000000000,
> > > >   count=0} block =288 ret=1
> > > > 
> > > > Later this incorrectly filled bh result in BUG_ON triggering
> > > > ------------[ cut here ]------------
> > > >  kernel BUG at fs/buffer.c:2880!
> > > >  invalid opcode: 0000 [1] SMP
> > > >  CPU 1
> 
> .....
> 
> > > > 
> > > > > 
> > > > > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > > > > index d6ae40a..4985fd5 100644
> > > > > --- a/fs/ext4/extents.c
> > > > > +++ b/fs/ext4/extents.c
> > > > > @@ -2600,8 +2600,18 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
> > > > >  			}
> > > > >  			if (create == EXT4_CREATE_UNINITIALIZED_EXT)
> > > > >  				goto out;
> > > > > -			if (!create)
> > > > > +			if (!create) {
> > > > > +				/*
> > > > > +				 * We have blocks reserved already. We
> > > > > +				 * return allocated blocks so that delalloc
> > > > > +				 * won't do block reservation for us. But
> > > > > +				 * the buffer head will be unmapped so that
> > > > > +				 * a read from the block return 0
> > > > > +				 */
> > > > > +				if (allocated > max_blocks)
> > > > > +					allocated = max_blocks;
> > > > >  				goto out2;
> > > > > +			}
> > > > >  
> > > > >  			ret = ext4_ext_convert_to_initialized(handle, inode,
> > > > >  								path, iblock,
> > > 
> > > With prealloc space we still need to make sure buffer heads are marked
> > > new and delayed. 
> > I doubt this. prealloc space should not mark as delayed. The allocation
> > already done. delayed flag triggeres block reservation for delayed
> > allocation, with is not needed for preallocation, that will cause double
> > accounting for free space.
> > 
> > With delayed allocation, where hit preallocated space, get_block() right
> > now returns bh as new but return value > 0 (it's possible that returns >
> > maxblocks, as we just return a single large extent).
> 
> 
> As Dmitri mentioned in the previous mail if the buffer head is not
> marked as delayed or new, in __block_prepare_write after get_block
> we would do a ll_rw_block(READ, 1, &bh); and that will result in BUG_ON.
> 
> 
bh is not marked as new? Oh that's right. Perhaps we should mark the bh
as unwritten, xfs does that. __block_prepare_write() will avoid do
ll_rw_block() if the bh is unwritten.

Mingming
> > 
> > > Only difference between prealloc and get_block failure
> > > case should be in failure case we need to do block reservation.
> > 
> > Correct, in the failure case, the returned number of blocks from
> > get_block() is 0, but with preallocation, the return value is positive.
> > Both case the resulting bh is remains new, unmapped.
> > 
> > >   With
> > > prealloc we still like to get get_block called again with create = 1
> > > so that the uninit extent get split. 
> > > 
> > I could not see why we still need doing create =1 at write_begin time
> > with delayed allocation, if the space has already preallocated.
> > 
> > The preallocation extent split could be defered at write out time,
> > get_block() is always called with create = 1 at writepage() time. 
> > 
> 
> 
> I meant at writepage time.
> 
> 
> 
> > > I would also like to test it locally. How are you reproducing it. Just
> > > fsstress won't reproduce it right ?
> > > 
> > 
> > Not sure which ext4 tree Dmitri is testing, I have a patch to handle
> > preallocation case in delayed allocation, I wonder if that makes the
> > problem goes away? 
> > 
> > http://repo.or.cz/w/ext4-patch-queue.git?a=blob;f=delalloc-ext4-preallocation-handling.patch;h=ba3b70ecba99137d452b6692c92caabe8831392e;hb=80aeb2ef59cdb97bf527570cb273f6e5d5d27e3f
> > 

