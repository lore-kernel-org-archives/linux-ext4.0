From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Need clear buffer_delay after page writeout for
	delayed allocation
Date: Mon, 2 Jun 2008 12:05:19 +0530
Message-ID: <20080602063519.GA26379@skywalker>
References: <1212154769-16486-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1212354602.4368.12.camel@localhost.localdomain> <20080602031433.GA17678@skywalker> <1212378632.4368.79.camel@localhost.localdomain> <20080602040934.GB17678@skywalker> <1212385116.4368.90.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:58331 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbYFBGfj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Jun 2008 02:35:39 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id m526Yix0007344
	for <linux-ext4@vger.kernel.org>; Mon, 2 Jun 2008 16:34:44 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m526ZJwO4296868
	for <linux-ext4@vger.kernel.org>; Mon, 2 Jun 2008 16:35:20 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m526ZZa6025632
	for <linux-ext4@vger.kernel.org>; Mon, 2 Jun 2008 16:35:36 +1000
Content-Disposition: inline
In-Reply-To: <1212385116.4368.90.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jun 01, 2008 at 10:38:35PM -0700, Mingming Cao wrote:
> On Mon, 2008-06-02 at 09:39 +0530, Aneesh Kumar K.V wrote:
> > On Sun, Jun 01, 2008 at 08:50:32PM -0700, Mingming Cao wrote:
> > > On Mon, 2008-06-02 at 08:44 +0530, Aneesh Kumar K.V wrote:
> > > > On Sun, Jun 01, 2008 at 02:10:02PM -0700, Mingming Cao wrote:
> > > > > ext4:  Need clear buffer_delay after page writeout for delayed allocation
> > > > > 
> > > > > From: Mingming Cao <cmm@us.ibm.com>
> > > > > 
> > > > > Need clear buffer_delay in ext4_da_writepage() after page has been writeout
> > > > > 
> > > > > Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> > > > > 
> > > > > ---
> > > > 
> > > > We do that in mpage_put_bnr_to_bhs.
> > > > 
> > > Normally delayed buffer could be cleared in that case, but if allocation
> > > failed in __mapge_da_writepages(), it will keep buffer_delay marked and
> > > deferring to later ext4_da_writepage() to do block allocation. This
> > > patch handles clear bh delay bit in this case.
> > > 
> > 
> > Why not do it in ext4_da_get_block_write then.
> 
> The buffer head passed to ext4_da_get_block_write() calling from
> mpage_da_map_blocks is a dummy one, to store the allocated extent, not
> the bh that need map.


ie true when ext4_da_get_block_write is called via writepages. In
that case mpage_put_bnr_to_bhs clears the delay bit properly. How about
the changes below.


diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 26f3626..9d25255 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2873,6 +2873,7 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 		allocated = max_blocks;
 	ext4_ext_show_leaf(inode, path);
 	__set_bit(BH_Mapped, &bh_result->b_state);
+	__clear_bit(BH_Delay, &bh_result->b_state);
 	bh_result->b_bdev = inode->i_sb->s_bdev;
 	bh_result->b_blocknr = newblock;
 out2:
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 2194aa7..2a2f832 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -917,6 +917,7 @@ int ext4_get_blocks_handle(handle_t *handle, struct inode *inode,
 		goto cleanup;
 
 	set_buffer_new(bh_result);
+	clear_buffer_delay(bh_result);
 got_it:
 	map_bh(bh_result, inode->i_sb, le32_to_cpu(chain[depth-1].key));
 	if (count > blocks_to_boundary)
diff --git a/fs/mpage.c b/fs/mpage.c
index c107728..0d05d7a 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -897,6 +897,14 @@ static void mpage_da_map_blocks(struct mpage_da_data *mpd)
 	int err = 0, remain = lbh->b_size;
 	sector_t next = lbh->b_blocknr;
 	struct buffer_head new;
+	int delay_buf = 0;
+
+	/*
+	 * We clear the delay bit in get_block so remember
+	 * whether we are doing a delay allocation
+	 */
+	if (buffer_delay(lbh))
+		delay_buf = 1;
 
 	/*
 	 * We consider only non-mapped and non-allocated blocks
@@ -926,7 +934,7 @@ static void mpage_da_map_blocks(struct mpage_da_data *mpd)
 		 * If blocks are delayed marked, we need to
 		 * put actual blocknr and drop delayed bit
 		 */
-		if (buffer_delay(lbh))
+		if (delay_buf)
 			mpage_put_bnr_to_bhs(mpd, next, &new);
 
 		/* go for the remaining blocks */

