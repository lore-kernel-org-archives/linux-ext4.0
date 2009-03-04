From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] fix ext4_free_inode vs. ext4_claim_inode race
Date: Thu, 5 Mar 2009 00:36:59 +0530
Message-ID: <20090304190659.GB17949@skywalker>
References: <49AE05D1.9050607@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:56965 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbZCDTHK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Mar 2009 14:07:10 -0500
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28smtp02.in.ibm.com (8.13.1/8.13.1) with ESMTP id n24J76tB006863
	for <linux-ext4@vger.kernel.org>; Thu, 5 Mar 2009 00:37:06 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n24J451i2396316
	for <linux-ext4@vger.kernel.org>; Thu, 5 Mar 2009 00:34:05 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id n24J75wl017906
	for <linux-ext4@vger.kernel.org>; Thu, 5 Mar 2009 00:37:06 +0530
Content-Disposition: inline
In-Reply-To: <49AE05D1.9050607@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 03, 2009 at 10:38:41PM -0600, Eric Sandeen wrote:
> I was seeing fsck errors on inode bitmaps after a 4 thread
> dbench run on a 4 cpu machine:
> 
> Inode bitmap differences: -50736 -(50752--50753) etc...
> 
> I believe that this is because ext4_free_inode() uses atomic
> bitops, and although ext4_new_inode() *used* to also use atomic 
> bitops for synchronization, commit 
> 393418676a7602e1d7d3f6e560159c65c8cbd50e changed this to use
> the sb_bgl_lock, so that we could also synchronize against
> read_inode_bitmap and initialization of uninit inode tables.
> 
> However, that change left ext4_free_inode using atomic bitops,
> which I think leaves no synchronization between setting & 
> unsetting bits in the inode table.
> 
> The below patch fixes it for me, although I wonder if we're 
> getting at all heavy-handed with this spinlock...
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>


> ---
> 
> Index: linux-2.6/fs/ext4/ialloc.c
> ===================================================================
> --- linux-2.6.orig/fs/ext4/ialloc.c
> +++ linux-2.6/fs/ext4/ialloc.c
> @@ -188,7 +188,7 @@ void ext4_free_inode(handle_t *handle, s
>  	struct ext4_group_desc *gdp;
>  	struct ext4_super_block *es;
>  	struct ext4_sb_info *sbi;
> -	int fatal = 0, err, count;
> +	int fatal = 0, err, count, cleared;
>  	ext4_group_t flex_group;
> 
>  	if (atomic_read(&inode->i_count) > 1) {
> @@ -248,8 +248,10 @@ void ext4_free_inode(handle_t *handle, s
>  		goto error_return;
> 
>  	/* Ok, now we can actually update the inode bitmaps.. */
> -	if (!ext4_clear_bit_atomic(sb_bgl_lock(sbi, block_group),
> -					bit, bitmap_bh->b_data))
> +	spin_lock(sb_bgl_lock(sbi, block_group));
> +	cleared = ext4_clear_bit(bit, bitmap_bh->b_data);
> +	spin_unlock(sb_bgl_lock(sbi, block_group));
> +	if (!cleared)
>  		ext4_error(sb, "ext4_free_inode",
>  			   "bit already cleared for inode %lu", ino);
>  	else {
> 
