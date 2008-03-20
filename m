From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [2.6.25-rc5-ext4-36c86] attempt to access beyond end of device
Date: Thu, 20 Mar 2008 17:39:57 +0530
Message-ID: <20080320120957.GB11891@skywalker>
References: <18399.36935.640758.796880@frecb006361.adech.frec.bull.fr> <47E1CE7F.6050706@redhat.com> <20080320081619.GB13928@dmon-lap.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, Solofo.Ramangalahy@bull.net,
	linux-ext4@vger.kernel.org
To: Dmitri Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:47713 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbYCTMKP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Mar 2008 08:10:15 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp01.in.ibm.com (8.13.1/8.13.1) with ESMTP id m2KC9uux022826
	for <linux-ext4@vger.kernel.org>; Thu, 20 Mar 2008 17:39:56 +0530
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m2KC9ulb856186
	for <linux-ext4@vger.kernel.org>; Thu, 20 Mar 2008 17:39:56 +0530
Received: from d28av03.in.ibm.com (loopback [127.0.0.1])
	by d28av03.in.ibm.com (8.13.1/8.13.3) with ESMTP id m2KC9t1K004728
	for <linux-ext4@vger.kernel.org>; Thu, 20 Mar 2008 12:09:56 GMT
Content-Disposition: inline
In-Reply-To: <20080320081619.GB13928@dmon-lap.sw.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 20, 2008 at 11:16:19AM +0300, Dmitri Monakhov wrote:
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

Is that a fallocate space ?. For falloc space we can return values
greater than max_blocks. ext4_ext_get_blocks was made to return  >0
for a read on prealloc space to ensure delalloc doesn't reserve space
for the same. I guess we need to make sure we don't return more than
max_blocks. Can you try the patch below

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index d6ae40a..4985fd5 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2600,8 +2600,18 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 			}
 			if (create == EXT4_CREATE_UNINITIALIZED_EXT)
 				goto out;
-			if (!create)
+			if (!create) {
+				/*
+				 * We have blocks reserved already. We
+				 * return allocated blocks so that delalloc
+				 * won't do block reservation for us. But
+				 * the buffer head will be unmapped so that
+				 * a read from the block return 0
+				 */
+				if (allocated > max_blocks)
+					allocated = max_blocks;
 				goto out2;
+			}
 
 			ret = ext4_ext_convert_to_initialized(handle, inode,
 								path, iblock,
