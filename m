From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Patches for the patchqueue
Date: Fri, 6 Jun 2008 00:29:04 +0530
Message-ID: <20080605185904.GB4723@skywalker>
References: <20080605095032.GE8942@skywalker> <20080605095158.GF8942@skywalker> <20080605095350.GG8942@skywalker> <20080605095510.GH8942@skywalker> <1212688960.3613.10.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:50946 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327AbYFES7Z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Jun 2008 14:59:25 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp01.au.ibm.com (8.13.1/8.13.1) with ESMTP id m55IxwsJ008383
	for <linux-ext4@vger.kernel.org>; Fri, 6 Jun 2008 04:59:58 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m55J3XKQ081582
	for <linux-ext4@vger.kernel.org>; Fri, 6 Jun 2008 05:03:33 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m55IxM1E013477
	for <linux-ext4@vger.kernel.org>; Fri, 6 Jun 2008 04:59:22 +1000
Content-Disposition: inline
In-Reply-To: <1212688960.3613.10.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 05, 2008 at 11:02:40AM -0700, Mingming Cao wrote:
> On Thu, 2008-06-05 at 15:25 +0530, Aneesh Kumar K.V wrote:
> > f) clear the delay bit in ext4_da_get_block_write instead of
> > __block_write_full_page
> > so that we clear the delay bit for every successfull block allocation.
> > We may fail
> > while marking inode dirty in ext4_da_get_block_write after allocating
> > block. So
> > it is better to clear the delay bit in ext4_da_get_block_write rather
> > than
> > __block_write_full_page
> > 
> 
> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> > ---
> 
> > @@ -1555,7 +1565,15 @@ static int ext4_da_get_block_write(struct inode
> > *inode, sector_t iblock,
> >                 bh_result->b_size = (ret << inode->i_blkbits);
> > 
> >                 /* release reserved-but-unused meta blocks */
> > -               ext4_da_release_space(inode, ret, 0);
> > +               if (buffer_delay(bh_result)) {
> > +                       ext4_da_release_space(inode, ret, 0);
> > +                       /*
> > +                        * clear the delay bit now that we allocated
> > +                        * blocks. If it is not a single block request
> > +                        * we clear the delay bit in
> > mpage_put_bnr_to_bhs
> > +                        */
> > +                       clear_buffer_delay(bh_result);
> > +               }
> > 
> >                 /*
> >                  * Update on-disk size along with block allocation
> 
> It seems with this fix, the buffer_delay bit is still cleared before the
> ext4_mark_inode_dirty() could return error? Actually the already
> allocated blocks are leaked if mark_inode-dirty() returns error, and we
> cleared the buffer_delay for the buffer needs block.
> 

How abou the below ? For single block request we are ok to clear the
delay bit as shown by the above patch. For multiple block request we
clear the delay bit if the buffer_head passed to the get_block have
its delay bit cleared. That should take care of the  block leaking you
mentioned above.

diff --git a/fs/mpage.c b/fs/mpage.c
index c4376ec..2c90350 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -908,25 +908,41 @@ static void mpage_da_map_blocks(struct mpage_da_data *mpd)
 		new.b_blocknr = 0;
 		new.b_size = remain;
 		err = mpd->get_block(mpd->inode, next, &new, 1);
-		if (err) {
+		/*
+		 * we may have successfully allocated block. But
+		 * failed to mark inode dirty. If we have allocated
+		 * blocks update the buffer_head mappings
+		 */
+		if (buffer_new(&new)) {
 			/*
-			 * Rather than implement own error handling
-			 * here, we just leave remaining blocks
-			 * unallocated and try again with ->writepage()
+			 * buffer_head is only makred new if we have
+			 * a successfull block allocation
 			 */
-			break;
-		}
-		BUG_ON(new.b_size == 0);
-
-		if (buffer_new(&new))
 			__unmap_underlying_blocks(mpd->inode, &new);
+		}
 
 		/*
 		 * If blocks are delayed marked, we need to
 		 * put actual blocknr and drop delayed bit
 		 */
-		if (buffer_delay(lbh))
+		if (buffer_delay(lbh) && !buffer_delay(&new)) {
+			/*
+			 * get_block if successfully allocated
+			 * block will clear the delay bit of
+			 * new buffer_head
+			 */
 			mpage_put_bnr_to_bhs(mpd, next, &new);
+		}
+
+		if (err) {
+			/*
+			 * Rather than implement own error handling
+			 * here, we just leave remaining blocks
+			 * unallocated and try again with ->writepage()
+			 */
+			break;
+		}
+		BUG_ON(new.b_size == 0);
 
 		/* go for the remaining blocks */
 		next += new.b_size >> mpd->inode->i_blkbits;
