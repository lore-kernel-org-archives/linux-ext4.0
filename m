From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: page_cache pages over pinned in
 ext4_mb_free_metadata()
Date: Wed, 24 Mar 2010 22:46:13 +0530
Message-ID: <87aatxd4iq.fsf@linux.vnet.ibm.com>
References: <ac8f92701003240600o5ce6a682i431de77bef66b736@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: jing zhang <zj.barak@gmail.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:60145 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873Ab0CXRQW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Mar 2010 13:16:22 -0400
Received: from d23relay05.au.ibm.com (d23relay05.au.ibm.com [202.81.31.247])
	by e23smtp01.au.ibm.com (8.14.3/8.13.1) with ESMTP id o2OHEBq4006745
	for <linux-ext4@vger.kernel.org>; Thu, 25 Mar 2010 04:14:11 +1100
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay05.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o2OHAF0b1212458
	for <linux-ext4@vger.kernel.org>; Thu, 25 Mar 2010 04:10:15 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o2OHGJqh013798
	for <linux-ext4@vger.kernel.org>; Thu, 25 Mar 2010 04:16:20 +1100
In-Reply-To: <ac8f92701003240600o5ce6a682i431de77bef66b736@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 24 Mar 2010 21:00:34 +0800, jing zhang <zj.barak@gmail.com> wrote:
> From: Jing Zhang <zj.barak@gmail.com>
> 
> Date: Wed Mar 24 20:38:48     2010
> 
> The function, ext4_mb_free_metadata(), is called after
>      ext4_mb_load_buddy(sb, block_group, &e4b);
> and before
>      ext4_mb_release_desc(&e4b);
> in the function, ext4_mb_free_blocks(), so the bd_bitmap_page and
> bd_buddy_page of e4b are well managed.
> 
> If for special purpose, page_cache_get() is issued on these two pages,
> there should also be page_cache_release() issued correspondingly, or
> the two pages are over pinned.

release_blocks_on_commit does that. I also have a comment around that page_cache_release.

> 
> Cc: Theodore Ts'o <tytso@mit.edu>
> Cc: Andreas Dilger <adilger@sun.com>
> Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
> Signed-off-by: Jing Zhang <zj.barak@gmail.com>
> 
> ---
> 
> --- linux-2.6.32/fs/ext4/mballoc.c	2009-12-03 11:51:22.000000000 +0800
> +++ ext4_mm_leak/mballoc6.c	2010-03-24 20:31:52.000000000 +0800
> @@ -4361,15 +4361,6 @@ ext4_mb_free_metadata(handle_t *handle,
>  	new_node = &new_entry->node;
>  	block = new_entry->start_blk;
> 
> -	if (!*n) {
> -		/* first free block exent. We need to
> -		   protect buddy cache from being freed,
> -		 * otherwise we'll refresh it from
> -		 * on-disk bitmap and lose not-yet-available
> -		 * blocks */
> -		page_cache_get(e4b->bd_buddy_page);
> -		page_cache_get(e4b->bd_bitmap_page);
> -	}
>  	while (*n) {
>  		parent = *n;
>  		entry = rb_entry(parent, struct ext4_free_data, node);


-aneesh
