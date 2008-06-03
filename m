From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] ext4: Need clear buffer_delay after page writeout for
	delayed allocation
Date: Mon, 02 Jun 2008 21:43:18 -0700
Message-ID: <1212468198.3636.116.camel@localhost.localdomain>
References: <1212154769-16486-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1212354602.4368.12.camel@localhost.localdomain>
	 <20080602031433.GA17678@skywalker>
	 <1212378632.4368.79.camel@localhost.localdomain>
	 <20080602040934.GB17678@skywalker>
	 <1212385116.4368.90.camel@localhost.localdomain>
	 <20080602063519.GA26379@skywalker>
	 <1212390247.4368.107.camel@localhost.localdomain>
	 <20080602080527.GE26379@skywalker>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: jack@suse.cz, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:56934 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbYFCEnY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Jun 2008 00:43:24 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m534hNmI023571
	for <linux-ext4@vger.kernel.org>; Tue, 3 Jun 2008 00:43:23 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m534hMcS115120
	for <linux-ext4@vger.kernel.org>; Mon, 2 Jun 2008 22:43:22 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m534hMr4024540
	for <linux-ext4@vger.kernel.org>; Mon, 2 Jun 2008 22:43:22 -0600
In-Reply-To: <20080602080527.GE26379@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2008-06-02 at 13:35 +0530, Aneesh Kumar K.V wrote:
> On Mon, Jun 02, 2008 at 12:04:07AM -0700, Mingming Cao wrote:
> > On Mon, 2008-06-02 at 12:05 +0530, Aneesh Kumar K.V wrote:
> > > On Sun, Jun 01, 2008 at 10:38:35PM -0700, Mingming Cao wrote:
> > > > On Mon, 2008-06-02 at 09:39 +0530, Aneesh Kumar K.V wrote:
> > > > > On Sun, Jun 01, 2008 at 08:50:32PM -0700, Mingming Cao wrote:
> > > > > > On Mon, 2008-06-02 at 08:44 +0530, Aneesh Kumar K.V wrote:
> > > > > > > On Sun, Jun 01, 2008 at 02:10:02PM -0700, Mingming Cao wrote:
> > > > > > > > ext4:  Need clear buffer_delay after page writeout for delayed allocation
> > > > > > > > 
> > > > > > > > From: Mingming Cao <cmm@us.ibm.com>
> > > > > > > > 
> > > > > > > > Need clear buffer_delay in ext4_da_writepage() after page has been writeout
> > > > > > > > 
> > > > > > > > Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> > > > > > > > 
> > > > > > > > ---
> > > > > > > 
> > > > > > > We do that in mpage_put_bnr_to_bhs.
> > > > > > > 
> > > > > > Normally delayed buffer could be cleared in that case, but if allocation
> > > > > > failed in __mapge_da_writepages(), it will keep buffer_delay marked and
> > > > > > deferring to later ext4_da_writepage() to do block allocation. This
> > > > > > patch handles clear bh delay bit in this case.
> > > > > > 
> > > > > 
> > > > > Why not do it in ext4_da_get_block_write then.
> > > > 
> > > > The buffer head passed to ext4_da_get_block_write() calling from
> > > > mpage_da_map_blocks is a dummy one, to store the allocated extent, not
> > > > the bh that need map.
> > > 
> > > 
> > > ie true when ext4_da_get_block_write is called via writepages. In
> > > that case mpage_put_bnr_to_bhs clears the delay bit properly. How about
> > > the changes below.
> > > 
> > I see your patch below is trying to address how to detect and assign
> > blocks with your suggestion(i.e clear delayed bit in get_block). But I
> > don;t think it's needed. 
> > 
> > My last email I mean the buffer head new in mpage_da_map_blocks() is a
> > dummy bh, the real buffer head lbh is not passed to get_block. We could
> > clear the delayed bit on successful return of get_block,
> > mpage_put_bnr_to_bhs() ignore that dummy bh anyway. But that seems
> > twisted, unccessary.
> > 
> > I still think clear the bit in the ext4_da_write_page() is more clean
> > way. the original patch clears the delayed bit on success case. 
> > 
> > For the error case I think we could handle properly by only clear the
> > delayed bit if buffer is mapped.
> 
> 
> Buffer marked as delay is also mapped
> fs/ext4/inode.c
> 
> 1437                 map_bh(bh_result, inode->i_sb, 0);
> 1438                 set_buffer_new(bh_result);
> 1439                 set_buffer_delay(bh_result);
> 
> 
I find a better place to handle this, it make sense to clear this bit in
block_write_full_page() after get_block() returns successfully. This
handles partial error case smoothly. Updated patch below (to replace the
original patch)

ext4: Need clear buffer_delay in block_write_full_page() after allocation

From: Mingming Cao <cmm@us.ibm.com>

Normally delayed buffer could be cleared in mpage_da_map_blocks(), after
blocks are successfully allocated. But if allocation failed, it will
keep buffer_delay marked and deferring to later 
ext4_da_writepage()(via block_write_full_page()) to do block allocation.
This patch handles clear bh delay bit in this case. Clear buffer_delay
in block_write_full_page() after the block is allocated.

This patch also fixed a bug in block_write_full_page() error case, we need
to check the delayed flag before flush bh to disk when trying to recover from
error.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>

---
 fs/buffer.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6.26-rc4/fs/buffer.c
===================================================================
--- linux-2.6.26-rc4.orig/fs/buffer.c	2008-06-02 21:34:30.000000000 -0700
+++ linux-2.6.26-rc4/fs/buffer.c	2008-06-02 21:35:17.000000000 -0700
@@ -1697,6 +1697,7 @@ static int __block_write_full_page(struc
 			err = get_block(inode, block, bh, 1);
 			if (err)
 				goto recover;
+			clear_buffer_delay(bh);
 			if (buffer_new(bh)) {
 				/* blockdev mappings never come here */
 				clear_buffer_new(bh);
@@ -1775,7 +1776,8 @@ recover:
 	bh = head;
 	/* Recovery: lock and submit the mapped buffers */
 	do {
-		if (buffer_mapped(bh) && buffer_dirty(bh)) {
+		if (buffer_mapped(bh) && buffer_dirty(bh)
+			&& !buffer_delay(bh)) {
 			lock_buffer(bh);
 			mark_buffer_async_write(bh);
 		} else {


