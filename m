From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: fsstress-induced corruption reproduced
Date: Wed, 6 Jan 2010 14:19:18 +0530
Message-ID: <20100106084918.GA3475@skywalker.linux.vnet.ibm.com>
References: <E1NQNIB-0006gT-1r@closure.thunk.org>
 <4B424BE4.3030605@redhat.com>
 <4B427507.40004@redhat.com>
 <20100105061728.GA7868@skywalker.linux.vnet.ibm.com>
 <4B43CD55.1050904@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:60095 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932067Ab0AFIuP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Jan 2010 03:50:15 -0500
Received: from d28relay05.in.ibm.com (d28relay05.in.ibm.com [9.184.220.62])
	by e28smtp08.in.ibm.com (8.14.3/8.13.1) with ESMTP id o068IntR020528
	for <linux-ext4@vger.kernel.org>; Wed, 6 Jan 2010 13:48:50 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay05.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o068nfd63567780
	for <linux-ext4@vger.kernel.org>; Wed, 6 Jan 2010 14:19:46 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o068nfaP012282
	for <linux-ext4@vger.kernel.org>; Wed, 6 Jan 2010 14:19:41 +0530
Content-Disposition: inline
In-Reply-To: <4B43CD55.1050904@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Maybe something like this works:
> 
> Index: linux-2.6/fs/ext4/inode.c
> ===================================================================
> --- linux-2.6.orig/fs/ext4/inode.c
> +++ linux-2.6/fs/ext4/inode.c
> @@ -1203,6 +1203,7 @@ int ext4_get_blocks(handle_t *handle, st
>  		    int flags)
>  {
>  	int retval;
> +	int was_unwritten;
> 
>  	clear_buffer_mapped(bh);
>  	clear_buffer_unwritten(bh);
> @@ -1253,9 +1254,13 @@ int ext4_get_blocks(handle_t *handle, st
>  	 * part of the uninitialized extent to be an initialized
>  	 * extent.  This is because we need to avoid the combination
>  	 * of BH_Unwritten and BH_Mapped flags being simultaneously
> -	 * set on the buffer_head.
> +	 * set on the buffer_head.  However, if it was unwritten we
> +	 * don't want to update reserved space later.
>  	 */
> -	clear_buffer_unwritten(bh);
> +	if (buffer_unwritten(bh)) {
> +		was_unwritten = 1;
> +		clear_buffer_unwritten(bh);
> +	}


That won't work because we can do the fallocate after we did the ext4_ext_get_block
with create = 0 and before we do down_write below. So we would still have was_unwritten = 0


> 
>  	/*
>  	 * New blocks allocate and/or writing to uninitialized extent
> @@ -1301,7 +1306,8 @@ int ext4_get_blocks(handle_t *handle, st
>  	 * Update reserved blocks/metadata blocks after successful
>  	 * block allocation which had been deferred till now.
>  	 */
> -	if ((retval > 0) && (flags & EXT4_GET_BLOCKS_UPDATE_RESERVE_SPACE))
> +	if ((retval > 0) && !was_unwritten &&
> +	    (flags & EXT4_GET_BLOCKS_UPDATE_RESERVE_SPACE))
>  		ext4_da_update_reserve_space(inode, retval);
> 
>  	up_write((&EXT4_I(inode)->i_data_sem));
> 
> but that might leave the previous reservations hanging around from
> prior to the fallocate ...
> 

What commit d21cd8f163ac44b15c465aab7306db931c606908 did was to move
quota claim to ext4_get_block function. Earlier we didn't do a 
quota claim if we happened to write to fallocate area because
ext4_ext_handle_uninitialized_extents didn't call ext4_mb_mark_diskspace_used
So that should explain why we are seeing this problem with
d21cd8f163ac44b15c465aab7306db931c606908.

How about the patch below ?

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index af7b626..b98de17 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1443,6 +1443,8 @@ extern int ext4_block_truncate_page(handle_t *handle,
 extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf);
 extern qsize_t *ext4_get_reserved_space(struct inode *inode);
 extern int flush_aio_dio_completed_IO(struct inode *inode);
+extern void ext4_da_update_reserve_space(struct inode *inode,
+					int used, int quota_claim);
 /* ioctl.c */
 extern long ext4_ioctl(struct file *, unsigned int, unsigned long);
 extern long ext4_compat_ioctl(struct file *, unsigned int, unsigned long);
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 7d7b74e..3b6ff72 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3132,7 +3132,19 @@ out:
 		unmap_underlying_metadata_blocks(inode->i_sb->s_bdev,
 					newblock + max_blocks,
 					allocated - max_blocks);
+		allocated = max_blocks;
 	}
+
+	/*
+	 * If we have done fallocate with the offset that is already
+	 * delayed allocated, we would have block reservation
+	 * and quota reservation done in the delayed write path.
+	 * But fallocate would have already updated quota and block
+	 * count for this offset. So cancel these reservation
+	 */
+	if (flags & EXT4_GET_BLOCKS_UPDATE_RESERVE_SPACE)
+		ext4_da_update_reserve_space(inode, allocated, 0);
+
 map_out:
 	set_buffer_mapped(bh_result);
 out1:
@@ -3368,9 +3380,18 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 	/* previous routine could use block we allocated */
 	newblock = ext_pblock(&newex);
 	allocated = ext4_ext_get_actual_len(&newex);
+	if (allocated > max_blocks)
+		allocated = max_blocks;
 	set_buffer_new(bh_result);
 
 	/*
+	 * Update reserved blocks/metadata blocks after successful
+	 * block allocation which had been deferred till now.
+	 */
+	if (flags & EXT4_GET_BLOCKS_UPDATE_RESERVE_SPACE)
+		ext4_da_update_reserve_space(inode, allocated, 1);
+
+	/*
 	 * Cache the extent and update transaction to commit on fdatasync only
 	 * when it is _not_ an uninitialized extent.
 	 */
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c818972..77ff941 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1053,7 +1053,7 @@ static int ext4_calc_metadata_amount(struct inode *inode, sector_t lblock)
  * Called with i_data_sem down, which is important since we can call
  * ext4_discard_preallocations() from here.
  */
-static void ext4_da_update_reserve_space(struct inode *inode, int used)
+void ext4_da_update_reserve_space(struct inode *inode, int used, int quota_claim)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	struct ext4_inode_info *ei = EXT4_I(inode);
@@ -1090,9 +1090,17 @@ static void ext4_da_update_reserve_space(struct inode *inode, int used)
 	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 
 	/* Update quota subsystem */
-	vfs_dq_claim_block(inode, used);
-	if (mdb_free)
-		vfs_dq_release_reservation_block(inode, mdb_free);
+	if (quota_claim) {
+		vfs_dq_claim_block(inode, used);
+		if (mdb_free)
+			vfs_dq_release_reservation_block(inode, mdb_free);
+	} else {
+		/*
+		 * This is a request to cancel the reservation. So just
+		 * update the resevation and cancel the quota reservation
+		 */
+		vfs_dq_release_reservation_block(inode, mdb_free + used);
+	}
 
 	/*
 	 * If we have done all the pending block allocations and if
@@ -1292,18 +1300,20 @@ int ext4_get_blocks(handle_t *handle, struct inode *inode, sector_t block,
 			 */
 			EXT4_I(inode)->i_state &= ~EXT4_STATE_EXT_MIGRATE;
 		}
-	}
 
+		/*
+		 * Update reserved blocks/metadata blocks after successful
+		 * block allocation which had been deferred till now. We don't
+		 * support fallocate for non extent files. So we can update
+		 * reserve space here.
+		 */
+		if ((retval > 0) &&
+			(flags & EXT4_GET_BLOCKS_UPDATE_RESERVE_SPACE))
+			ext4_da_update_reserve_space(inode, retval, 1);
+	}
 	if (flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE)
 		EXT4_I(inode)->i_delalloc_reserved_flag = 0;
 
-	/*
-	 * Update reserved blocks/metadata blocks after successful
-	 * block allocation which had been deferred till now.
-	 */
-	if ((retval > 0) && (flags & EXT4_GET_BLOCKS_UPDATE_RESERVE_SPACE))
-		ext4_da_update_reserve_space(inode, retval);
