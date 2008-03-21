From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [2.6.25-rc5-ext4-36c86] attempt to access beyond end of device
Date: Thu, 20 Mar 2008 17:49:08 -0700
Message-ID: <1206060548.3637.53.camel@localhost.localdomain>
References: <18399.36935.640758.796880@frecb006361.adech.frec.bull.fr>
	 <47E1CE7F.6050706@redhat.com>  <20080320081619.GB13928@dmon-lap.sw.ru>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>, Solofo.Ramangalahy@bull.net,
	linux-ext4@vger.kernel.org
To: Dmitri Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:47838 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077AbYCUAtQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Mar 2008 20:49:16 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m2L0pFUf029408
	for <linux-ext4@vger.kernel.org>; Thu, 20 Mar 2008 20:51:15 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m2L0nDTD096830
	for <linux-ext4@vger.kernel.org>; Thu, 20 Mar 2008 20:49:13 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m2L0nCwb029505
	for <linux-ext4@vger.kernel.org>; Thu, 20 Mar 2008 20:49:13 -0400
In-Reply-To: <20080320081619.GB13928@dmon-lap.sw.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2008-03-20 at 11:16 +0300, Dmitri Monakhov wrote:
> On 21:39 Wed 19 Mar     , Eric Sandeen wrote:
> > Solofo.Ramangalahy@bull.net wrote:
> > > Hello,
> > > 
> > > During stress testing (workload: racer from ltp + fio/iometer), here
> > > is an error I am encountering:
> > > 8<------------------------------------------------------------------------------
> > > kernel: WARNING: at fs/buffer.c:1680 __block_write_full_page+0xd4/0x2af()
> > 
> > So this is WARN_ON(bh->b_size != blocksize);
> > 
> > What is b_size in this case?
> FS block size, because this page pinned bh (it comes from page_buffers(page)), but
> not dummy bh which may comes from {write,read}pages or direct_IO. 
> Page's bh i_size must always be equal to fs blocksize.
> This bh always constructed via following construction
> if (!page_has_buffers(page))
> 	create_empty_buffers(page, 1<<inode->i_blkbits, flags)
> So page's bh->b_size was inited with right value from very beginning, but
> apparently somewhere this size was changed 
> I guess i've localized buggy place, at least it's looks strange.
> ext4_da_get_block_prep ()
> {
> ...
> 	BUG_ON(create == 0);
>         BUG_ON(bh_result->b_size != inode->i_sb->s_blocksize);
> 	ret =  ext4_get_blocks_wrap(NULL,  inode, iblock, 1,  bh_result, 0, 0);
> #Here ext4_get_block_write called with max_blocks == 1  ^^^^^
> 	...
> 	if (ret > 0) {
>                         bh_result->b_size = (ret << inode->i_blkbits);
> 	^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> ## I don't understand this place. I hoped what (ret <= max_blocks) must always
> ##be true true. But after I've add debug info printing I've got following result.
>                 ret = 0;
>         }
> ...
> }
> Some times I've seen following ,message 
>  bh= {state=0,size=114688, blknr=18446744073709551615 dev=0000000000000000,count=0}, ret=28
> And because it was page-cache's bh later this result in WARNING.

I think the root cause is here, ext4_get_block_wrap() could returns
number of blocks greater than the caller is asking for, and set the
mapped/allocated bytes in the bh->b_size.

The problem is that the for buffered IO (without delaloc) get_block()
via ext4_get_block_wrap() at write_begin time makes sure the buffer is
mapped, so later at the writepage()->block_write_full_page() time, it
never hits the branch  the  WARN_ON(bh->b_size != blocksize) in
__block_write_full_page(), even if the b_size is previously changed to
greater than the blocksize, by ext4_get_block_wrap() at the write_begin
time.

This warning is only seen with delayed allocation because we did a
get_block() (via ext4_da_get_block_prep()) look up with 1 block at a
time, but the bh->b_size is storing the length of the whole extent,
since ext4_get_block_wrap() could returns number of blocks greater than
the caller is asking for.


static int __block_write_full_page(struct inode *inode, struct page *page,
                        get_block_t *get_block, struct writeback_control *wbc)
{
	....

	if (!buffer_mapped(bh) && buffer_dirty(bh)) {
                        WARN_ON(bh->b_size != blocksize);
                        err = get_block(inode, block, bh, 1);
                        if (err)
                                goto recover;
                        if (buffer_new(bh)) {
                                /* blockdev mappings never come here */
                                clear_buffer_new(bh);
                                unmap_underlying_metadata(bh->b_bdev,
                                                        bh->b_blocknr);
                        }

}

I think the fix probabaly should enforce
ext4_get_blocks_handle()/ext4_ext_get_block() never map/allocate the
number of blocks that more than what is asking for..


Mingming
> > 
> > -Eric
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

