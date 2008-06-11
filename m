From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] ext4: Make ext4_ext_find_extent fills ext_path
	completely
Date: Wed, 11 Jun 2008 17:13:44 +0530
Message-ID: <20080611114344.GF9008@skywalker>
References: <484F68BE.8040203@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Theodore Tso <tytso@MIT.EDU>,
	Mingming Cao <cmm@us.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>
To: Shen Feng <shen@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:37017 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbYFKLoI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Jun 2008 07:44:08 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp06.in.ibm.com (8.13.1/8.13.1) with ESMTP id m5BBhlQj009327
	for <linux-ext4@vger.kernel.org>; Wed, 11 Jun 2008 17:13:47 +0530
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5BBhU5U1437702
	for <linux-ext4@vger.kernel.org>; Wed, 11 Jun 2008 17:13:30 +0530
Received: from d28av03.in.ibm.com (loopback [127.0.0.1])
	by d28av03.in.ibm.com (8.13.1/8.13.3) with ESMTP id m5BBhkbY024732
	for <linux-ext4@vger.kernel.org>; Wed, 11 Jun 2008 17:13:46 +0530
Content-Disposition: inline
In-Reply-To: <484F68BE.8040203@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 11, 2008 at 01:55:10PM +0800, Shen Feng wrote:
> When pos=0 or depth, the fields of ext4_ext_path is not
> completely filled.
> This patch also removes some unnecessary code.
> 
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


We did a kzalloc before. So do we need this ?



> 
>  	i = depth;
>  	/* walk through the tree */
> @@ -552,12 +553,11 @@ ext4_ext_find_extent(struct inode *inode, ext4_lblk_t block,
>  	}
> 
>  	path[ppos].p_depth = i;
> -	path[ppos].p_hdr = eh;


This is needed. Because we look at extent_header  in ext_binsearch.



> -	path[ppos].p_ext = NULL;
>  	path[ppos].p_idx = NULL;
> 
>  	/* find extent */
>  	ext4_ext_binsearch(inode, path + ppos, block);
> +	path[ppos].p_block = ext4_ext_pblock(path[ppos].p_ext);
> 
>  	ext4_ext_show_path(inode, path);
> 

-aneesh
