From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: return error when calling ext4_ext_split failed
Date: Wed, 11 Jun 2008 17:09:17 +0530
Message-ID: <20080611113917.GA12998@skywalker>
References: <484F696A.4070703@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Theodore Tso <tytso@MIT.EDU>,
	Mingming Cao <cmm@us.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>
To: Shen Feng <shen@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:49485 "EHLO
	e28esmtp05.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752285AbYFKLjp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Jun 2008 07:39:45 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp05.in.ibm.com (8.13.1/8.13.1) with ESMTP id m5BBdJY0028151
	for <linux-ext4@vger.kernel.org>; Wed, 11 Jun 2008 17:09:19 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5BBd3Oi1310806
	for <linux-ext4@vger.kernel.org>; Wed, 11 Jun 2008 17:09:03 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.13.1/8.13.3) with ESMTP id m5BBdIQA011955
	for <linux-ext4@vger.kernel.org>; Wed, 11 Jun 2008 17:09:19 +0530
Content-Disposition: inline
In-Reply-To: <484F696A.4070703@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 11, 2008 at 01:58:02PM +0800, Shen Feng wrote:
> 
> ext4_ext_create_new_leaf must return error when its
> calling to ext4_ext_split failed.
> 
> Signed-off-by: Shen Feng <shen@cn.fujitsu.com>

Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

> ---
>  fs/ext4/extents.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index ff609df..177345d 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -981,6 +981,8 @@ repeat:
>  		/* if we found index with free entry, then use that
>  		 * entry: create all needed subtree and add new leaf */
>  		err = ext4_ext_split(handle, inode, path, newext, i);
> +		if (err)
> +			goto out;
> 
>  		/* refill path */
>  		ext4_ext_drop_refs(path);
> -- 
> 1.5.4.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
