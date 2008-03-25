From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext3: Return EIO if new block is allocated from system
	zone.
Date: Tue, 25 Mar 2008 16:33:11 +0530
Message-ID: <20080325110311.GA7151@skywalker>
References: <1206378298-10341-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080324223251.GL2691@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, Mingming Cao <cmm@us.vnet.ibm.com>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:51931 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432AbYCYLDY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Mar 2008 07:03:24 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28smtp05.in.ibm.com (8.13.1/8.13.1) with ESMTP id m2PB3Bbc008784
	for <linux-ext4@vger.kernel.org>; Tue, 25 Mar 2008 16:33:11 +0530
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m2PB3Bgk1167466
	for <linux-ext4@vger.kernel.org>; Tue, 25 Mar 2008 16:33:11 +0530
Received: from d28av02.in.ibm.com (loopback [127.0.0.1])
	by d28av02.in.ibm.com (8.13.1/8.13.3) with ESMTP id m2PB3AVl004313
	for <linux-ext4@vger.kernel.org>; Tue, 25 Mar 2008 11:03:11 GMT
Content-Disposition: inline
In-Reply-To: <20080324223251.GL2691@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 24, 2008 at 04:32:51PM -0600, Andreas Dilger wrote:
> On Mar 24, 2008  22:34 +0530, Aneesh Kumar K.V wrote:
> > If the block allocator gets blocks out of system zone ext3 calls
> > ext3_error. But if the file system is mounted with errors=continue
> > return with -EIO.
> > 
> > System zone is the block range mapping block bitmap, inode bitmap and inode
> > table.
> 
> I don't understand this patch.  Surely it has nothing to do with the user,
> and instead the code should re-try the allocation after marking the block
> in-use in the bitmap?
> 
> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> > Signed-off-by: Mingming Cao <cmm@us.vnet.ibm.com>
> > ---
> >  fs/ext3/balloc.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
> > index da0cb2c..6ce7f7d 100644
> > --- a/fs/ext3/balloc.c
> > +++ b/fs/ext3/balloc.c
> > @@ -1642,7 +1642,7 @@ allocated:
> >  			    "Allocating block in system zone - "
> >  			    "blocks from "E3FSBLK", length %lu",
> >  			     ret_block, num);
> > -		goto out;
> > +		goto io_error;
> >  	}
> 
> I think the problem here is that this "goto" is simply an in-effective
> method of error handling.  The block HAS to be marked in-use in the
> bitmap, or it will just continue to try and be allocated.  After marking
> the block in-use there should be a "goto retry-alloc" instead of error.
> To be honest, I thought in 2.6 this would invoke the block bitmap checking
> code to revalidate the whole bitmap at this point and then retry the alloc.
> 
> In 2.4 this similar code looks like:
> 
>         if (tmp == le32_to_cpu(gdp->bg_block_bitmap) ||
>             tmp == le32_to_cpu(gdp->bg_inode_bitmap) ||
>             in_range (tmp, le32_to_cpu(gdp->bg_inode_table),
>                       EXT3_SB(sb)->s_itb_per_group)) {
>                 ext3_error(sb, __FUNCTION__,
>                            "Allocating block in system zone - block = %u", tmp);
> 
>                 /* Note: This will potentially use up one of the handle's
>                  * buffer credits.  Normally we have way too many credits,
>                  * so that is OK.  In _very_ rare cases it might not be OK.
>                  * We will trigger an assertion if we run out of credits,
>                  * and we will have to do a full fsck of the filesystem -
>                  * better than randomly corrupting filesystem metadata.
>                  */
>                 ext3_set_bit(j, bh->b_data);
>                 goto repeat;
>         }
> 
> 

How about this. Patch is not complete, we leak some of the blocks here.

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 6d30af2..a9f27c7 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -289,11 +289,11 @@ read_block_bitmap(struct super_block *sb, ext4_group_t block_group)
 			    (int)block_group, (unsigned long long)bitmap_blk);
 		return NULL;
 	}
-	if (!ext4_valid_block_bitmap(sb, desc, block_group, bh)) {
-		put_bh(bh);
-		return NULL;
-	}
