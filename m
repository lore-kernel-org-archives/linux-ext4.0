From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] fix ext4_free_inode vs. ext4_claim_inode race
Date: Thu, 5 Mar 2009 09:33:40 +0530
Message-ID: <20090305040340.GC17949@skywalker>
References: <49AE05D1.9050607@redhat.com> <49AF0AA0.3080506@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:39672 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbZCEEDv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Mar 2009 23:03:51 -0500
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp06.in.ibm.com (8.13.1/8.13.1) with ESMTP id n2543lef014119
	for <linux-ext4@vger.kernel.org>; Thu, 5 Mar 2009 09:33:47 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n2543sVH2076788
	for <linux-ext4@vger.kernel.org>; Thu, 5 Mar 2009 09:33:54 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id n2543kOo001283
	for <linux-ext4@vger.kernel.org>; Thu, 5 Mar 2009 09:33:46 +0530
Content-Disposition: inline
In-Reply-To: <49AF0AA0.3080506@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 04, 2009 at 05:11:28PM -0600, Eric Sandeen wrote:
> Eric Sandeen wrote:
> 
> Index: linux-2.6/fs/ext4/ialloc.c
> ===================================================================
> --- linux-2.6.orig/fs/ext4/ialloc.c
> +++ linux-2.6/fs/ext4/ialloc.c
> @@ -609,26 +609,33 @@ static int ext4_claim_inode(struct super
>  			struct buffer_head *inode_bitmap_bh,
>  			unsigned long ino, ext4_group_t group, int mode)
>  {
> -	int free = 0, retval = 0, count;
> +	int free = 0, bitset, count;
>  	struct ext4_sb_info *sbi = EXT4_SB(sb);
>  	struct ext4_group_desc *gdp = ext4_get_group_desc(sb, group, NULL);
> 
> -	spin_lock(sb_bgl_lock(sbi, group));
> -	if (ext4_set_bit(ino, inode_bitmap_bh->b_data)) {
> -		/* not a free inode */
> -		retval = 1;
> -		goto err_ret;
> +	/* if uninit, protect against ext4_read_inode_bitmap initialization */
> +	bitset = -1;
> +	if (gdp->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT)) {
> +		spin_lock(sb_bgl_lock(sbi, group));
> +		if (gdp->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT))
> +			bitset = ext4_set_bit(ino, inode_bitmap_bh->b_data);
> +		spin_unlock(sb_bgl_lock(sbi, group));
>  	}


That won't work. We need set the bit and clear the  INODE_UNINIT flag
by holding the spin_lock. In ext4_read_inode_bitmap we check the
INODE_UNINIT flag and re-init the inode bitmap. So we may end up 
re-initing the bitmap if we don't clear the INODE_UNINIT flag holding
the spin lock


> +	if (bitset < 0) /* we didn't set it above, so not uninit */
> +		bitset = ext4_set_bit_atomic(sb_bgl_lock(sbi, group),
> +					ino, inode_bitmap_bh->b_data);
> +	if (bitset)	/* this is not a free inode */
> +		return 1;
>  	ino++;
>  	if ((group == 0 && ino < EXT4_FIRST_INO(sb)) ||
>  			ino > EXT4_INODES_PER_GROUP(sb)) {
> -		spin_unlock(sb_bgl_lock(sbi, group));
>  		ext4_error(sb, __func__,
>  			   "reserved inode or inode > inodes count - "
>  			   "block_group = %u, inode=%lu", group,
>  			   ino + group * EXT4_INODES_PER_GROUP(sb));
>  		return 1;
>  	}
> +	spin_lock(sb_bgl_lock(sbi, group));
>  	/* If we didn't allocate from within the initialized part of the inode
>  	 * table then we need to initialize up to this inode. */
>  	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) {
> @@ -665,9 +672,8 @@ static int ext4_claim_inode(struct super
>  		ext4_used_dirs_set(sb, gdp, count);
>  	}
>  	gdp->bg_checksum = ext4_group_desc_csum(sbi, group, gdp);
> -err_ret:
>  	spin_unlock(sb_bgl_lock(sbi, group));
> -	return retval;
> +	return 0;
>  }
> 

-aneesh
