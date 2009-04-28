From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH] mark buffer_head mapping preallocate area as new
	during write_begin with delayed allocation
Date: Tue, 28 Apr 2009 15:01:45 +0530
Message-ID: <20090428093145.GA13719@skywalker>
References: <1240859143-31122-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1240873494.6775.8.camel@mingming-laptop> <20090428042049.GA6520@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:58610 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261AbZD1Jby (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Apr 2009 05:31:54 -0400
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.31.243])
	by e23smtp01.au.ibm.com (8.13.1/8.13.1) with ESMTP id n3S9VGIN013097
	for <linux-ext4@vger.kernel.org>; Tue, 28 Apr 2009 19:31:16 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n3S9VqjD348330
	for <linux-ext4@vger.kernel.org>; Tue, 28 Apr 2009 19:31:52 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n3S9Vprl006148
	for <linux-ext4@vger.kernel.org>; Tue, 28 Apr 2009 19:31:52 +1000
Content-Disposition: inline
In-Reply-To: <20090428042049.GA6520@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 28, 2009 at 09:50:49AM +0530, Aneesh Kumar K.V wrote:
> On Mon, Apr 27, 2009 at 04:04:54PM -0700, Mingming Cao wrote:
> .....
> 
> > 
> > Index: linux-2.6.28-rc6/fs/ext4/inode.c
> > ===================================================================
> > --- linux-2.6.28-rc6.orig/fs/ext4/inode.c	2009-03-12 10:21:05.000000000 -0700
> > +++ linux-2.6.28-rc6/fs/ext4/inode.c	2009-04-27 14:35:21.000000000 -0700
> > @@ -2177,7 +2177,10 @@ static int ext4_da_get_block_prep(struct
> >  		set_buffer_new(bh_result);
> >  		set_buffer_delay(bh_result);
> >  	} else if (ret > 0) {
> > +		if (buffer_unwritten(bh_result))
> > +			set_buffer_new(bh_result);
> >  		bh_result->b_size = (ret << inode->i_blkbits);
> > +		bh_result->b_bdev = inode->i_sb->s_bdev;
> 
> 
> Updated patch to set bh_result->b_dev. I also added comments in the
> source to explain whey we need to mark buffer_head new. Also updated
> single line patch summary. I will send the update (-v2) patch.

Looking at the source again i guess setting just b_dev is not enough.
unmap_underlying_metadata looks at the mapping block number, which we
don't have in case on unwritten buffer_head. How about the below patch ?
It involve vfs changes. But i guess it is correct with respect to the
meaning of BH_New (Disk mapping was newly created by get_block). I guess
BH_New implies BH_Mapped.

I haven't tested the patch yet. Also it should be split into multiple
patches. It also a fix a problem where we missed an
unamp_underlying_metadata in case of delayed allocated blocks. I guess
that can also cause corruption with delayed allocation.


From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V3] ext4: Fix sub-block zeroing for buffered writes into unwritten extents.

We need to mark the  buffer_head mapping prealloc space
as new during write_begin. Otherwise we don't zero out the
page cache content properly for a partial write. This will
cause file corruption with preallocation.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

---
 fs/buffer.c     |    9 ++++++++-
 fs/ext4/inode.c |    8 +++++---
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index b3e5be7..13f0d52 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1867,15 +1867,22 @@ static int __block_prepare_write(struct inode *inode, struct page *page,
 			err = get_block(inode, block, bh, 1);
 			if (err)
 				break;
-			if (buffer_new(bh)) {
+			if (buffer_new(bh))
 				unmap_underlying_metadata(bh->b_bdev,
 							bh->b_blocknr);
+			if (buffer_new(bh) || buffer_unwritten(bh) ||
+					buffer_delay(bh)) {
 				if (PageUptodate(page)) {
 					clear_buffer_new(bh);
 					set_buffer_uptodate(bh);
 					mark_buffer_dirty(bh);
 					continue;
 				}
+				/*
+				 * sub-block writes into unwritten or
+				 * delayed buffer should result in zero out
+				 * of the rest of the buffer
+				 */
 				if (block_end > to || block_start < from)
 					zero_user_segments(page,
 						to, block_end,
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index e91f978..504afb7 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1892,13 +1892,17 @@ static void mpage_put_bnr_to_bhs(struct mpage_da_data *mpd, sector_t logical,
 				if (buffer_delay(bh)) {
 					bh->b_blocknr = pblock;
 					clear_buffer_delay(bh);
+					set_buffer_mapped(bh);
 					bh->b_bdev = inode->i_sb->s_bdev;
+					unmap_underlying_metadata(bh->b_bdev,
+								pblock);
 				} else if (buffer_unwritten(bh)) {
 					bh->b_blocknr = pblock;
 					clear_buffer_unwritten(bh);
 					set_buffer_mapped(bh);
-					set_buffer_new(bh);
 					bh->b_bdev = inode->i_sb->s_bdev;
+					unmap_underlying_metadata(bh->b_bdev,
+								pblock);
 				} else if (buffer_mapped(bh))
 					BUG_ON(bh->b_blocknr != pblock);
 
@@ -2318,8 +2322,6 @@ static int ext4_da_get_block_prep(struct inode *inode, sector_t iblock,
 			/* not enough space to reserve */
 			return ret;
 
-		map_bh(bh_result, inode->i_sb, 0);
-		set_buffer_new(bh_result);
 		set_buffer_delay(bh_result);
 	} else if (ret > 0) {
 		bh_result->b_size = (ret << inode->i_blkbits);
-- 
tg: (2084a87..) preallocate_corruption (depends on: ext4_lock_group_conversion)

