From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: fix memory leak in ext4_ext_insert_extent
Date: Thu, 19 Jun 2008 21:38:51 +0530
Message-ID: <20080619160851.GA7874@skywalker>
References: <485A10B3.4020105@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Mingming Cao <cmm@us.ibm.com>
To: Shen Feng <shen@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:56630 "EHLO
	e28esmtp03.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753271AbYFSQJ0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Jun 2008 12:09:26 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp03.in.ibm.com (8.13.1/8.13.1) with ESMTP id m5JG94Gx017774
	for <linux-ext4@vger.kernel.org>; Thu, 19 Jun 2008 21:39:04 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5JG8AsN856106
	for <linux-ext4@vger.kernel.org>; Thu, 19 Jun 2008 21:38:10 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id m5JG93N5018275
	for <linux-ext4@vger.kernel.org>; Thu, 19 Jun 2008 21:39:04 +0530
Content-Disposition: inline
In-Reply-To: <485A10B3.4020105@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 19, 2008 at 03:54:27PM +0800, Shen Feng wrote:
> 
> In ext4_ext_insert_extent, when path is assigned by
> npath, there is a memory leak and then path points to
> a freed memory after the function returns becasue
> npath and path point to the same memory address
> and npath is freed.


NACK. The  refs are dropped and path freed in the caller.
For example look at ext4_ext_get_blocks we drop the path reference
at

2741 out2:
2742         if (path) {
2743                 ext4_ext_drop_refs(path);
2744                 kfree(path);
2745         }

in ext4_ext_insert_extent we use npath as a local variable
and is freed toward the end.



> 
> Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
> ---
>  fs/ext4/extents.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 3f6be32..71a56f1 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -1497,6 +1497,8 @@ repeat:
>  		if (le16_to_cpu(eh->eh_entries) < le16_to_cpu(eh->eh_max)) {
>  			ext_debug("next leaf isnt full(%d)\n",
>  				  le16_to_cpu(eh->eh_entries));
> +			ext4_ext_drop_refs(path);
> +			kfree(path);
>  			path = npath;
>  			goto repeat;
>  		}
> @@ -1578,7 +1580,7 @@ merge:
>  	err = ext4_ext_dirty(handle, inode, path + depth);
> 
>  cleanup:
> -	if (npath) {
> +	if (npath && npath != path) {
>  		ext4_ext_drop_refs(npath);
>  		kfree(npath);
>  	}
> -- 
> 1.5.5.1
