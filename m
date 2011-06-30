From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 1/2] ext4: remove redundant goto tag "repeat"
Date: Thu, 30 Jun 2011 13:56:39 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1106301352000.4489@dhcp-27-109.brq.redhat.com>
References: <1309421014-6148-1-git-send-email-sanbai@taobao.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, Robin Dong <sanbai@taobao.com>
To: Robin Dong <hao.bigrat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56138 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105Ab1F3L4s (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 Jun 2011 07:56:48 -0400
In-Reply-To: <1309421014-6148-1-git-send-email-sanbai@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 30 Jun 2011, Robin Dong wrote:

> If eh->eh_entries is smaller than eh->eh_max, the routine will
> go to the "repeat" and then go to "has_space" directlly ,
> since argument "depth" and "eh" are not even changed.
> 
> Therefore, goto "has_space" directly and remove redundant "repeat" tag.

The patch looks good. Thanks!

-Lukas

> 
> Signed-off-by: Robin Dong <sanbai@taobao.com>
> ---
>  fs/ext4/extents.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index eb63c7b..dc5ef91 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -1758,7 +1758,6 @@ int ext4_ext_insert_extent(handle_t *handle, struct inode *inode,
>  		goto merge;
>  	}
>  
> -repeat:
>  	depth = ext_depth(inode);
>  	eh = path[depth].p_hdr;
>  	if (le16_to_cpu(eh->eh_entries) < le16_to_cpu(eh->eh_max))
> @@ -1780,7 +1779,7 @@ repeat:
>  			ext_debug("next leaf isn't full(%d)\n",
>  				  le16_to_cpu(eh->eh_entries));
>  			path = npath;
> -			goto repeat;
> +			goto has_space;
>  		}
>  		ext_debug("next leaf has no free space(%d,%d)\n",
>  			  le16_to_cpu(eh->eh_entries), le16_to_cpu(eh->eh_max));
> 
