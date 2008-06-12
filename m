From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH 2/2] ext4: Make ext4_ext_find_extent fills ext_path
	completely
Date: Thu, 12 Jun 2008 15:27:51 -0700
Message-ID: <1213309672.3698.22.camel@localhost.localdomain>
References: <484F68BE.8040203@cn.fujitsu.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Theodore Tso <tytso@MIT.EDU>,
	Andrew Morton <akpm@linux-foundation.org>
To: Shen Feng <shen@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:38098 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755398AbYFLW2N (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Jun 2008 18:28:13 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m5CMUK6x026357
	for <linux-ext4@vger.kernel.org>; Thu, 12 Jun 2008 18:30:20 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5CMRrT0221928
	for <linux-ext4@vger.kernel.org>; Thu, 12 Jun 2008 18:27:53 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m5CMRqXg026321
	for <linux-ext4@vger.kernel.org>; Thu, 12 Jun 2008 18:27:53 -0400
In-Reply-To: <484F68BE.8040203@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2008-06-11 at 13:55 +0800, Shen Feng wrote:
> When pos=0 or depth, the fields of ext4_ext_path is not
> completely filled.
> This patch also removes some unnecessary code.
> 

I added this patch to the patch queue, unless somebody disagree.

Mingming
> Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
> ---
>  fs/ext4/extents.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index d4f76d7..ff609df 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -524,6 +524,7 @@ ext4_ext_find_extent(struct inode *inode, ext4_lblk_t block,
>  		alloc = 1;
>  	}
>  	path[0].p_hdr = eh;
> +	path[0].p_bh = NULL;
> 
>  	i = depth;
>  	/* walk through the tree */
> @@ -552,12 +553,11 @@ ext4_ext_find_extent(struct inode *inode, ext4_lblk_t block,
>  	}
> 
>  	path[ppos].p_depth = i;
> -	path[ppos].p_hdr = eh;
> -	path[ppos].p_ext = NULL;
>  	path[ppos].p_idx = NULL;
> 
>  	/* find extent */
>  	ext4_ext_binsearch(inode, path + ppos, block);
> +	path[ppos].p_block = ext4_ext_pblock(path[ppos].p_ext);
> 
>  	ext4_ext_show_path(inode, path);
> 

