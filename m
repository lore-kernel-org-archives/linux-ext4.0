From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: memory leakage in ext4_mb_free_blocks()
Date: Wed, 24 Mar 2010 22:31:54 +0530
Message-ID: <87d3ytd56l.fsf@linux.vnet.ibm.com>
References: <ac8f92701003240655i32c5cfesf95651b96b812c66@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: jing zhang <zj.barak@gmail.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:37701 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932074Ab0CXRCC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Mar 2010 13:02:02 -0400
Received: from d23relay04.au.ibm.com (d23relay04.au.ibm.com [202.81.31.246])
	by e23smtp08.au.ibm.com (8.14.3/8.13.1) with ESMTP id o2OH20cv014841
	for <linux-ext4@vger.kernel.org>; Thu, 25 Mar 2010 04:02:00 +1100
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay04.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o2OGu0Yu864508
	for <linux-ext4@vger.kernel.org>; Thu, 25 Mar 2010 03:56:00 +1100
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o2OH1xf3023949
	for <linux-ext4@vger.kernel.org>; Thu, 25 Mar 2010 04:02:00 +1100
In-Reply-To: <ac8f92701003240655i32c5cfesf95651b96b812c66@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 24 Mar 2010 21:55:55 +0800, jing zhang <zj.barak@gmail.com> wrote:
> From: Jing Zhang <zj.barak@gmail.com>
> 
> Date: Wed Mar 24 21:54:22     2010
> 
> There is memory leakage in ext4_mb_free_blocks(), if error, double
> free of blocks, occurs in ext4_mb_free_metadata().
> 
> Cc: Theodore Ts'o <tytso@mit.edu>
> Cc: Andreas Dilger <adilger@sun.com>
> Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
> Signed-off-by: Jing Zhang <zj.barak@gmail.com>
> 
> ---
> 
> --- linux-2.6.32/fs/ext4/mballoc.c	2009-12-03 11:51:22.000000000 +0800
> +++ ext4_mm_leak/mballoc8.c	2010-03-24 21:46:50.000000000 +0800
> @@ -4419,7 +4419,8 @@ ext4_mb_free_metadata(handle_t *handle,
>  	spin_lock(&sbi->s_md_lock);
>  	list_add(&new_entry->list, &handle->h_transaction->t_private_list);
>  	spin_unlock(&sbi->s_md_lock);
> -	return 0;
> +	/* info the caller new_entry is used */
> +	return 1;
>  }
> 

return 0 on success and -1 on failure 


>  /*
> @@ -4547,7 +4548,8 @@ do_more:
> 
>  		ext4_lock_group(sb, block_group);
>  		mb_clear_bits(bitmap_bh->b_data, bit, count);
> -		ext4_mb_free_metadata(handle, &e4b, new_entry);
> +		if (0 == ext4_mb_free_metadata(handle, &e4b, new_entry))
> +			kmem_cache_free(ext4_free_ext_cachep,
>  		new_entry);

I guess  it would be better to be 

if (ext4_mb_free_metadat() == -1)
   kmem_cache_free(..)



>  	} else {
>  		/* need to update group_info->bb_free and bitmap
>  		 * with group lock held. generate_buddy look at


-aneesh
