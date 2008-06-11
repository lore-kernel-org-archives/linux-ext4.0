From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [Fwd: [PATCH 2/5] ext4: Change the return value of
	ext4_ext_journal_restart]
Date: Wed, 11 Jun 2008 17:06:53 +0530
Message-ID: <20080611113653.GE9008@skywalker>
References: <484F690D.9090004@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Mingming Cao <cmm@us.ibm.com>,
	Theodore Tso <tytso@MIT.EDU>,
	Andrew Morton <akpm@linux-foundation.org>
To: Shen Feng <shen@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:52935 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724AbYFKLiV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Jun 2008 07:38:21 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id m5BBc9Vj013044
	for <linux-ext4@vger.kernel.org>; Wed, 11 Jun 2008 21:38:09 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5BBfF7J167756
	for <linux-ext4@vger.kernel.org>; Wed, 11 Jun 2008 21:41:15 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m5BBb3eA004915
	for <linux-ext4@vger.kernel.org>; Wed, 11 Jun 2008 21:37:04 +1000
Content-Disposition: inline
In-Reply-To: <484F690D.9090004@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 11, 2008 at 01:56:29PM +0800, Shen Feng wrote:
> 
> ext4_ext_journal_restart does not return the return value
> of ext4_journal_extend and ext4_journal_restart.
> Fix it.
> 
> Signed-off-by: Shen Feng <shen@cn.fujitsu.com>

Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

We also need to update the defrag patches in the patchqueue to take care
of the change


> ---
>  fs/ext4/extents.c |   19 ++++++++-----------
>  1 files changed, 8 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index fa8a578..d4f76d7 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -92,17 +92,16 @@ static void ext4_idx_store_pblock(struct ext4_extent_idx *ix, ext4_fsblk_t pb)
>  	ix->ei_leaf_hi = cpu_to_le16((unsigned long) ((pb >> 31) >> 1) & 0xffff);
>  }
> 
> -static handle_t *ext4_ext_journal_restart(handle_t *handle, int needed)
> +static int ext4_ext_journal_restart(handle_t *handle, int needed)
>  {
>  	int err;
> 
>  	if (handle->h_buffer_credits > needed)
> -		return handle;
> -	if (!ext4_journal_extend(handle, needed))
> -		return handle;
> -	err = ext4_journal_restart(handle, needed);
> -
> -	return handle;
> +		return 0;
> +	err = ext4_journal_extend(handle, needed);
> +	if (err)
> +		return err;
> +	return ext4_journal_restart(handle, needed);
>  }
> 
>  /*
> @@ -1885,11 +1884,9 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
>  		credits += 2 * EXT4_QUOTA_TRANS_BLOCKS(inode->i_sb);
>  #endif
> 
> -		handle = ext4_ext_journal_restart(handle, credits);
> -		if (IS_ERR(handle)) {
> -			err = PTR_ERR(handle);
> +		err = ext4_ext_journal_restart(handle, credits);
> +		if (err)
>  			goto out;
> -		}
> 
>  		err = ext4_ext_get_access(handle, inode, path + depth);
>  		if (err)
> -- 
> 1.5.4.5
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
