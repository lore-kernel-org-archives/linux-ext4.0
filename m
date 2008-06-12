From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [Fwd: [PATCH 2/5] ext4: Change the return value of
	ext4_ext_journal_restart]
Date: Thu, 12 Jun 2008 15:49:33 -0700
Message-ID: <1213310973.3698.25.camel@localhost.localdomain>
References: <484F690D.9090004@cn.fujitsu.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Theodore Tso <tytso@MIT.EDU>,
	Andrew Morton <akpm@linux-foundation.org>
To: Shen Feng <shen@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:36592 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753438AbYFLWtj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Jun 2008 18:49:39 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m5CMnYdk000303
	for <linux-ext4@vger.kernel.org>; Thu, 12 Jun 2008 18:49:34 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5CMnYE7200202
	for <linux-ext4@vger.kernel.org>; Thu, 12 Jun 2008 18:49:34 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m5CMnXZx020961
	for <linux-ext4@vger.kernel.org>; Thu, 12 Jun 2008 18:49:34 -0400
In-Reply-To: <484F690D.9090004@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2008-06-11 at 13:56 +0800, Shen Feng wrote:
> ext4_ext_journal_restart does not return the return value
> of ext4_journal_extend and ext4_journal_restart.
> Fix it.
> 

Added to the patch queue.

Mingming
> Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
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

