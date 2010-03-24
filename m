From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: page_cache pages not released in
 ext4_mb_load_buddy()
Date: Wed, 24 Mar 2010 22:19:47 +0530
Message-ID: <87eij9d5qs.fsf@linux.vnet.ibm.com>
References: <ac8f92701003240721l7a7079dnd9cbd55526cd1788@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: jing zhang <zj.barak@gmail.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:40940 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756138Ab0CXQtx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Mar 2010 12:49:53 -0400
Received: from d28relay01.in.ibm.com (d28relay01.in.ibm.com [9.184.220.58])
	by e28smtp02.in.ibm.com (8.14.3/8.13.1) with ESMTP id o2OGnodM007224
	for <linux-ext4@vger.kernel.org>; Wed, 24 Mar 2010 22:19:50 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay01.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o2OGnoQ73506220
	for <linux-ext4@vger.kernel.org>; Wed, 24 Mar 2010 22:19:50 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o2OGnnEQ019875
	for <linux-ext4@vger.kernel.org>; Wed, 24 Mar 2010 22:19:50 +0530
In-Reply-To: <ac8f92701003240721l7a7079dnd9cbd55526cd1788@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 24 Mar 2010 22:21:01 +0800, jing zhang <zj.barak@gmail.com> wrote:
> From: Jing Zhang <zj.barak@gmail.com>
> 
> Date: Wed Mar 24 20:38:48     2010
> 
> If ext4_mb_init_cache() returns error, there is no page_cache_release() issued.
> 
> Cc: Theodore Ts'o <tytso@mit.edu>
> Cc: Andreas Dilger <adilger@sun.com>
> Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
> Signed-off-by: Jing Zhang <zj.barak@gmail.com>
> 
> ---
> 
> --- linux-2.6.32/fs/ext4/mballoc.c	2009-12-03 11:51:22.000000000 +0800
> +++ ext4_mm_leak/mballoc-9.c	2010-03-24 22:24:56.000000000 +0800
> @@ -1132,8 +1132,6 @@ repeat_load_buddy:
>  	e4b->bd_buddy = page_address(page) + (poff * sb->s_blocksize);
>  	mark_page_accessed(page);
> 
> -	BUG_ON(e4b->bd_bitmap_page == NULL);
> -	BUG_ON(e4b->bd_buddy_page == NULL);

Why remove these ? 

> 
>  	return 0;
> 
> @@ -1142,6 +1140,8 @@ err:
>  		page_cache_release(e4b->bd_bitmap_page);
>  	if (e4b->bd_buddy_page)
>  		page_cache_release(e4b->bd_buddy_page);
> +	if (page)
> +		page_cache_release(page);
>  	e4b->bd_buddy = NULL;
>  	e4b->bd_bitmap = NULL;

Can you add a comment which says on error page will point to the page
cache page which haven't been assigned to neither bd_bitmap_page or
bd_buddy_page

But good catch !!

-aneesh
