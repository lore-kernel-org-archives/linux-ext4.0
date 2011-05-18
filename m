From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 1/4] e2fsprogs: Add memory allocation and zero-out
 helpers
Date: Wed, 18 May 2011 14:22:04 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1105181421240.4100@dhcp-27-109.brq.redhat.com>
References: <1305718615-5991-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, sandeen@redhat.com,
	adilger@dilger.ca
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27692 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933016Ab1ERMWK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 May 2011 08:22:10 -0400
In-Reply-To: <1305718615-5991-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 18 May 2011, Lukas Czerner wrote:

> Add functions ext2fs_get_memzero() which will malloc() the memory
> using ext2fs_get_mem(), but it will zero the allocated memory afterwards
> with memset().
> 
> Add function ext2fs_get_arrayzero() which will use calloc() for
> allocating and zero-out the array.

Sorry this is not right I forgot to commit my changes. Version 2 is out there.

Thanks!
-Lukas

> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  lib/ext2fs/ext2fs.h |   24 ++++++++++++++++++++++++
>  1 files changed, 24 insertions(+), 0 deletions(-)
> 
> diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> index d3eb31d..4aff26d 100644
> --- a/lib/ext2fs/ext2fs.h
> +++ b/lib/ext2fs/ext2fs.h
> @@ -1404,6 +1404,17 @@ _INLINE_ errcode_t ext2fs_get_memalign(unsigned long size,
>  	return 0;
>  }
>  
> +_INLINE_ errcode_t ext2fs_get_memzero(unsigned long size, void *ptr)
> +{
> +	errcode_t retval;
> +
> +	retval = ext2fs_get_mem(size, ptr);
> +	if (retval)
> +		return retval;
> +	memset(ptr, 0, size);
> +	return 0;
> +}
> +
>  _INLINE_ errcode_t ext2fs_get_array(unsigned long count, unsigned long size, void *ptr)
>  {
>  	if (count && (-1UL)/count<size)
> @@ -1411,6 +1422,19 @@ _INLINE_ errcode_t ext2fs_get_array(unsigned long count, unsigned long size, voi
>  	return ext2fs_get_mem(count*size, ptr);
>  }
>  
> +_INLINE_ errcode_t ext2fs_get_arrayzero(unsigned long count, unsigned long size, void *ptr)
> +{
> +	void *pp;
> +
> +	if (count && (-1UL)/count<size)
> +		return EXT2_ET_NO_MEMORY; //maybe define EXT2_ET_OVERFLOW ?
> +	pp = calloc(count, size);
> +	if (!pp)
> +		return EXT2_ET_NO_MEMORY;
> +	memcpy(ptr, &pp, sizeof (pp));
> +	return 0;
> +}
> +
>  /*
>   * Free memory
>   */
> 

-- 
