From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: memory leakage in ext4_discard_preallocations
Date: Fri, 26 Mar 2010 14:07:31 +0530
Message-ID: <87vdcjv5pw.fsf@linux.vnet.ibm.com>
References: <ac8f92701003180539h7228040bm82a0c69d678ec93b@mail.gmail.com>
	<20100318174629.GK8256@thunk.org>
	<ac8f92701003190717u19334b4ei58e4829e4651db22@mail.gmail.com>
	<67790F0F-9921-4A98-8DC6-DA1C00CE6CA9@sun.com>
	<ac8f92701003200705u2bb6b65p4adce7b79f250705@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4 <linux-ext4@vger.kernel.org>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: jing zhang <zj.barak@gmail.com>, Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:58876 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199Ab0CZIhg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Mar 2010 04:37:36 -0400
Received: from d28relay03.in.ibm.com (d28relay03.in.ibm.com [9.184.220.60])
	by e28smtp05.in.ibm.com (8.14.3/8.13.1) with ESMTP id o2Q8bXNK020470
	for <linux-ext4@vger.kernel.org>; Fri, 26 Mar 2010 14:07:33 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay03.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o2Q8bXGR2818210
	for <linux-ext4@vger.kernel.org>; Fri, 26 Mar 2010 14:07:33 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o2Q8bWm7017833
	for <linux-ext4@vger.kernel.org>; Fri, 26 Mar 2010 14:07:33 +0530
In-Reply-To: <ac8f92701003200705u2bb6b65p4adce7b79f250705@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 20 Mar 2010 22:05:13 +0800, jing zhang <zj.barak@gmail.com> wrote:
> 
> Evening,
> 
> Thanks Andreas and Ted for your good explanations to deal error in
> gentle way, and I got it that the chance may exist since the pa is not
> deleted from its group_list yet.
> 
> And it also seems that there is work deserved.
>        - zj
> 
> ---
> 
> --- linux-2.6.32/fs/ext4/mballoc.c	2009-12-03 11:51:22.000000000 +0800
> +++ fs/mballoc.c	2010-03-20 21:40:04.000000000 +0800
> @@ -3788,14 +3788,14 @@ repeat:
>  		err = ext4_mb_load_buddy(sb, group, &e4b);
>  		if (err) {
>  			ext4_error(sb, __func__, "Error in loading buddy "
> -					"information for %u", group);
> +			"information for group %u inode %lu", group, inode->i_ino);
>  			continue;
>  		}
> 
>  		bitmap_bh = ext4_read_block_bitmap(sb, group);
>  		if (bitmap_bh == NULL) {
>  			ext4_error(sb, __func__, "Error in reading block "
> -					"bitmap for %u", group);
> +			"bitmap for group %u inode %lu", group, inode->i_ino);
>  			ext4_mb_release_desc(&e4b);
>  			continue;
>  		}
> @@ -3811,6 +3811,14 @@ repeat:
>  		list_del(&pa->u.pa_tmp_list);
>  		call_rcu(&(pa)->u.pa_rcu, ext4_mb_pa_callback);
>  	}
> +	if (! list_empty(&list)) {
> +		/*
> +		 * we have to do something for the check in
> +		 * the function, ext4_mb_discard_group_preallocations()
> +		 */
> +		list_for_each_entry(pa, &list, u.pa_tmp_list)
> +			pa->pa_deleted = 0;
> +	}
>  	if (ac)
>  		kmem_cache_free(ext4_ac_cachep, ac);
>  }

Can you add a comment saying if we fail to load buddy or read block
bitmap we skip freeing the prealloc space. So mark it undeleted. The
prealloc space is still removed from the inode but it is linked to the
group prealloc list via (pa_group_list)


-aneesh
