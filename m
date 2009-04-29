From: Mingming <cmm@us.ibm.com>
Subject: Re: [PATCH -V3] Fix sub-block zeroing for buffered writes into
	unwritten extents
Date: Tue, 28 Apr 2009 18:30:26 -0700
Message-ID: <1240968626.5583.25.camel@BVR-FS.beaverton.ibm.com>
References: <1240944653-4328-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:52420 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758000AbZD2Ba2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Apr 2009 21:30:28 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.1/8.13.1) with ESMTP id n3T1Pipx020451
	for <linux-ext4@vger.kernel.org>; Tue, 28 Apr 2009 21:25:44 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n3T1URZ4151084
	for <linux-ext4@vger.kernel.org>; Tue, 28 Apr 2009 21:30:27 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n3T1URjG007737
	for <linux-ext4@vger.kernel.org>; Tue, 28 Apr 2009 21:30:27 -0400
In-Reply-To: <1240944653-4328-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Wed, 2009-04-29 at 00:20 +0530, Aneesh Kumar K.V wrote:
> We need to mark the  buffer_head mapping prealloc space
> as new during write_begin. Otherwise we don't zero out the
> page cache content properly for a partial write. This will
> cause file corruption with preallocation.
> 
> Also use block number -1 as the fake block number so that
> unmap_underlying_metadata doesn't drop wrong buffer_head
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> 
> ---
>  fs/ext4/inode.c |   11 ++++++++++-
>  1 files changed, 10 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index e91f978..0214389 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2318,11 +2318,20 @@ static int ext4_da_get_block_prep(struct inode *inode, sector_t iblock,
>  			/* not enough space to reserve */
>  			return ret;
> 
> -		map_bh(bh_result, inode->i_sb, 0);
> +		map_bh(bh_result, inode->i_sb, -1);
>  		set_buffer_new(bh_result);
>  		set_buffer_delay(bh_result);
>  	} else if (ret > 0) {
>  		bh_result->b_size = (ret << inode->i_blkbits);
> +		bh_result->b_bdev = inode->i_sb->s_bdev;
> +		bh->b_blocknr = -1;

A small typo, should be bh_result->b_blocknr

But isn't this will incorrect set up the b_blocknr for normal
successful(allocated, non preallocated) get_block lookup? As
ext4_get_blocks_wrap() will return 1 (>0) if it found it allocated.

> +		/*
> +		 * With sub-block writes into unwritten extents
> +		 * we also need to mark the buffer as new so that
> +		 * the unwritten parts of the buffer gets correctly zeroed.
> +		 */
> +		if (buffer_unwritten(bh_result))
> +			set_buffer_new(bh_result);
>  		ret = 0;
>  	}
> 

I think it nicer to setup the fake block_nr together when
set_buffer_new(), at the ext4_ext_get_block() time when it handles
preallocation lookup on delalloc. This will avoid calling
buffer_unwritten(bh_result) check for every return bh result for
ext4_get_blocks_wrap(). And makes the logic more saner.

How about patch attached, tested with my testcase, the partial write
preallocation corruption is fixed.

But looking at the comment change, looks like the original intention is
to set the buffer unwritten so that a read from that uninitialzed block
returns 0. Turns out the VFS needs to set the buffer new for this
purpose.


-----------------------------------------------------------------------------

This patch fixed the file data garbage with partial write to a
preallocated space when delayed allocation is enabled.

The preallocated (uninitialized) buffer need to be set as buffer_new()
so read to this uninitialized block will return 0. With delayed
allocation, the create flag pass to get_block() from write_begin()
does a look up on the preallocated extent, the returning buffer did not
have the proper buffer_new flag set, resulting the page filled up with
garbage and get written to disk later.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Index: linux-2.6.28-rc6/fs/ext4/extents.c
===================================================================
--- linux-2.6.28-rc6.orig/fs/ext4/extents.c	2009-04-28 11:52:05.000000000 -0700
+++ linux-2.6.28-rc6/fs/ext4/extents.c	2009-04-28 17:35:55.000000000 -0700
@@ -2767,15 +2767,28 @@ int ext4_ext_get_blocks(handle_t *handle
 			if (create == EXT4_CREATE_UNINITIALIZED_EXT)
 				goto out;
 			if (!create) {
+				if (allocated > max_blocks)
+					allocated = max_blocks;
 				/*
-				 * We have blocks reserved already.  We
+				 * We have blocks preallocated already. For
+				 * lookup (creat=0) at write_begin time we
 				 * return allocated blocks so that delalloc
 				 * won't do block reservation for us.  But
-				 * the buffer head will be unmapped so that
-				 * a read from the block returns 0s.
+				 * we need to mark the buffer head new so that
+				 * a read from the block returns 0s. Fake the
+				 * block number -1 so that the following call
+				 * of unmap_underlying_metadata doesn't drop
+				 * wrong buffer_head
 				 */
-				if (allocated > max_blocks)
-					allocated = max_blocks;
+				bh_result->b_blocknr = -1;
+				bh_result->b_bdev = inode->i_sb->s_bdev;
+				set_buffer_new(bh_result);
+
+				 /*
+				  * We also needs to mark the buffer as
+				  * unwritten so we don'te write these
+				  * uninitalized pages
+				  */
 				set_buffer_unwritten(bh_result);
 				goto out2;
 			}
Index: linux-2.6.28-rc6/fs/ext4/inode.c
===================================================================
--- linux-2.6.28-rc6.orig/fs/ext4/inode.c	2009-04-28 11:52:05.000000000 -0700
+++ linux-2.6.28-rc6/fs/ext4/inode.c	2009-04-28 17:34:24.000000000 -0700
@@ -2173,7 +2173,7 @@ static int ext4_da_get_block_prep(struct
 			/* not enough space to reserve */
 			return ret;
 
-		map_bh(bh_result, inode->i_sb, 0);
+		map_bh(bh_result, inode->i_sb, -1);
 		set_buffer_new(bh_result);
 		set_buffer_delay(bh_result);
 	} else if (ret > 0) {

