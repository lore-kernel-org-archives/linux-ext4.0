From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Remove blocks from inode prealloc list on failure
Date: Fri, 4 Dec 2009 15:16:55 +0530
Message-ID: <20091204094654.GB4272@skywalker.linux.vnet.ibm.com>
References: <6601abe90912011017s41b74ed2nab4a45dc3f74825c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:42870 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668AbZLDJr2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Dec 2009 04:47:28 -0500
Received: from d23relay04.au.ibm.com (d23relay04.au.ibm.com [202.81.31.246])
	by e23smtp03.au.ibm.com (8.14.3/8.13.1) with ESMTP id nB49in6U030915
	for <linux-ext4@vger.kernel.org>; Fri, 4 Dec 2009 20:44:49 +1100
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay04.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id nB49hs9A1658998
	for <linux-ext4@vger.kernel.org>; Fri, 4 Dec 2009 20:43:55 +1100
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id nB49lWhS022142
	for <linux-ext4@vger.kernel.org>; Fri, 4 Dec 2009 20:47:32 +1100
Content-Disposition: inline
In-Reply-To: <6601abe90912011017s41b74ed2nab4a45dc3f74825c@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 01, 2009 at 10:17:02AM -0800, Curt Wohlgemuth wrote:
> This fixes a leak of blocks in an inode prealloc list if device failures
> cause ext4_mb_mark_diskspace_used() to fail.
> 
> Signed-off-by: Curt Wohlgemuth <curtw@google.com>
> ---
> diff -uprN orig/fs/ext4/mballoc.c new/fs/ext4/mballoc.c
> --- orig/fs/ext4/mballoc.c	2009-12-01 09:27:25.000000000 -0800
> +++ new/fs/ext4/mballoc.c	2009-12-01 09:28:38.000000000 -0800
> @@ -3011,6 +3011,22 @@ static void ext4_mb_collect_stats(struct
>  }
> 
>  /*
> + * Called on failure; free up any blocks from the inode PA for this
> + * context.
> + */
> +static void ext4_discard_inode_pa(struct ext4_allocation_context *ac)
> +{
> +	struct ext4_prealloc_space *pa = ac->ac_pa;
> +	int len;
> +
> +	if (pa && pa->pa_type == MB_INODE_PA) {
> +		len = ac->ac_b_ex.fe_len;
> +		pa->pa_free += len;
> +	}
> +
> +}

Can you name it as discard allocated blocks and add a comment saying why
we don't need it for MB_GROUP_PA ? Otherwise

Acked-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>


> +
> +/*
>   * use blocks preallocated to inode
>   */
>  static void ext4_mb_use_inode_pa(struct ext4_allocation_context *ac,
> @@ -4295,6 +4311,7 @@ repeat:
>  			ac->ac_status = AC_STATUS_CONTINUE;
>  			goto repeat;
>  		} else if (*errp) {
> +			ext4_discard_inode_pa(ac);
>  			ac->ac_b_ex.fe_len = 0;
>  			ar->len = 0;
>  			ext4_mb_show_ac(ac);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
