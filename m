From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH v2] ext4: avoid redundant cache finding if flags not
	cantian PUNCH_OUT
Date: Mon, 27 Jun 2011 12:59:11 -0700
Message-ID: <20110627195911.GD20655@tux1.beaverton.ibm.com>
References: <1309171513-5246-1-git-send-email-sanbai@taobao.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Robin Dong <sanbai@taobao.com>
To: Robin Dong <hao.bigrat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:56782 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946Ab1F0T74 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Jun 2011 15:59:56 -0400
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com [9.17.195.107])
	by e36.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p5RJrfNd021282
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jun 2011 13:53:41 -0600
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p5RJxJas089202
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jun 2011 13:59:23 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p5RDx8YA032742
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jun 2011 07:59:08 -0600
Content-Disposition: inline
In-Reply-To: <1309171513-5246-1-git-send-email-sanbai@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 27, 2011 at 06:45:13PM +0800, Robin Dong wrote:
> Subject: [PATCH v2] ext4: avoid redundant cache finding if flags not cantian

I suspect you mean "contain" as opposed to "cantian".

> In old code, ext4 will find extent in cache first even flags does
> not contian PUNCH_OUT, that may waste some time.

Same here ("contian").

--D
> 
> Signed-off-by: Robin Dong <sanbai@taobao.com>
> Reviewed-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  fs/ext4/extents.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index eb63c7b..fed2633 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3358,8 +3358,8 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
>  	trace_ext4_ext_map_blocks_enter(inode, map->m_lblk, map->m_len, flags);
> 
>  	/* check in cache */
> -	if (ext4_ext_in_cache(inode, map->m_lblk, &newex) &&
> -		((flags & EXT4_GET_BLOCKS_PUNCH_OUT_EXT) == 0)) {
> +	if (!(flags & EXT4_GET_BLOCKS_PUNCH_OUT_EXT) &&
> +		ext4_ext_in_cache(inode, map->m_lblk, &newex)) {
>  		if (!newex.ee_start_lo && !newex.ee_start_hi) {
>  			if ((flags & EXT4_GET_BLOCKS_CREATE) == 0) {
>  				/*
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
