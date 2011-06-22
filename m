From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: check eh_max before really insert index
Date: Wed, 22 Jun 2011 10:38:21 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1106221031230.4118@dhcp-27-109.brq.redhat.com>
References: <1308725476-5393-1-git-send-email-sanbai@taobao.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, Robin Dong <sanbai@taobao.com>
To: Robin Dong <hao.bigrat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22054 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753162Ab1FVIia (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 22 Jun 2011 04:38:30 -0400
In-Reply-To: <1308725476-5393-1-git-send-email-sanbai@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 22 Jun 2011, Robin Dong wrote:

> Check eh_entries/eh_max before really insert index.

Hi Robin,

thanks for the patch. Could you please describe why is the change
needed and what problem it fixes in the commit description. It is
not clear from the patch itself.

Thanks!
-Lukas

> 
> Signed-off-by: Robin Dong <sanbai@taobao.com>
> ---
>  fs/ext4/extents.c |   18 ++++++++++--------
>  1 files changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index eb63c7b..a742e6e 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -776,6 +776,16 @@ static int ext4_ext_insert_index(handle_t *handle, struct inode *inode,
>  				 logical, le32_to_cpu(curp->p_idx->ei_block));
>  		return -EIO;
>  	}
> +
> +	if (unlikely(le16_to_cpu(curp->p_hdr->eh_entries) + 1
> +			     > le16_to_cpu(curp->p_hdr->eh_max))) {
> +		EXT4_ERROR_INODE(inode,
> +				 "eh_entries %d + 1 > eh_max %d!",
> +				 le16_to_cpu(curp->p_hdr->eh_entries),
> +				 le16_to_cpu(curp->p_hdr->eh_max));
> +		return -EIO;
> +	}
> +
>  	len = EXT_MAX_INDEX(curp->p_hdr) - curp->p_idx;
>  	if (logical > le32_to_cpu(curp->p_idx->ei_block)) {
>  		/* insert after */
> @@ -805,14 +815,6 @@ static int ext4_ext_insert_index(handle_t *handle, struct inode *inode,
>  	ext4_idx_store_pblock(ix, ptr);
>  	le16_add_cpu(&curp->p_hdr->eh_entries, 1);
>  
> -	if (unlikely(le16_to_cpu(curp->p_hdr->eh_entries)
> -			     > le16_to_cpu(curp->p_hdr->eh_max))) {
> -		EXT4_ERROR_INODE(inode,
> -				 "eh_entries %d > eh_max %d!",
> -				 le16_to_cpu(curp->p_hdr->eh_entries),
> -				 le16_to_cpu(curp->p_hdr->eh_max));
> -		return -EIO;
> -	}
>  	if (unlikely(ix > EXT_LAST_INDEX(curp->p_hdr))) {
>  		EXT4_ERROR_INODE(inode, "ix > EXT_LAST_INDEX!");
>  		return -EIO;
> 
