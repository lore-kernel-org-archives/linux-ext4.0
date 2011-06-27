From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: avoid redundant cache finding if flags not cantian
 PUNCH_OUT
Date: Mon, 27 Jun 2011 12:15:00 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1106271211210.3845@dhcp-27-109.brq.redhat.com>
References: <1309156420-4201-1-git-send-email-sanbai@taobao.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, Robin Dong <sanbai@taobao.com>
To: Robin Dong <hao.bigrat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11091 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757311Ab1F0KPJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Jun 2011 06:15:09 -0400
In-Reply-To: <1309156420-4201-1-git-send-email-sanbai@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 27 Jun 2011, Robin Dong wrote:

> In old code, ext4 will find extent in cache first even flags does
> not contian PUNCH_OUT, that may waste some time.
> 
> Signed-off-by: Robin Dong <sanbai@taobao.com>
> ---
>  fs/ext4/extents.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index eb63c7b..d583ec3 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3358,8 +3358,8 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
>  	trace_ext4_ext_map_blocks_enter(inode, map->m_lblk, map->m_len, flags);
>  
>  	/* check in cache */
> -	if (ext4_ext_in_cache(inode, map->m_lblk, &newex) &&
> -		((flags & EXT4_GET_BLOCKS_PUNCH_OUT_EXT) == 0)) {
> +	if (((flags & EXT4_GET_BLOCKS_PUNCH_OUT_EXT) == 0) &&
> +		ext4_ext_in_cache(inode, map->m_lblk, &newex)) {

Hi Robin,

The patch is good thanks, but I think that this:

	if (!(flags & EXT4_GET_BLOCKS_PUNCH_OUT_EXT) &&
	    ext4_ext_in_cache(inode, map->m_lblk, &newex)) {

looks better.

Thanks!
-Lukas

>  		if (!newex.ee_start_lo && !newex.ee_start_hi) {
>  			if ((flags & EXT4_GET_BLOCKS_CREATE) == 0) {
>  				/*
> 
