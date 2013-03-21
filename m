From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH] ext4: Do not normalize request from fallocate
Date: Thu, 21 Mar 2013 20:03:47 +0400
Message-ID: <877gl0yc2k.fsf@openvz.org>
References: <1363881045-21673-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: gharm@google.com, Lukas Czerner <lczerner@redhat.com>
To: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:55726 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756399Ab3CUQDx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Mar 2013 12:03:53 -0400
Received: by mail-la0-f47.google.com with SMTP id fj20so5522270lab.34
        for <linux-ext4@vger.kernel.org>; Thu, 21 Mar 2013 09:03:51 -0700 (PDT)
In-Reply-To: <1363881045-21673-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 21 Mar 2013 16:50:45 +0100, Lukas Czerner <lczerner@redhat.com> wrote:
> Block requests from fallocate has been normalized originally. Then it was
> changed by 556b27abf73833923d5cd4be80006292e1b31662 not to normalize it.
> And then it was changed by 3c6fe77017bc6ce489f231c35fed3220b6691836
> again to normalize the request.
> 
> The fact is that we _never_ want to normalize the request from
> fallocate. We know exactly how much space we're going to use and we do
> not want anyone to mess with the request and there is no point in doing
> so.
Looks reasonable. 
Reviewed-by:Dmitry Monakhov <dmonakhov@openvz.org>
> 
> Commit 3c6fe77017bc6ce489f231c35fed3220b6691836 mentioned that
> large fallocate requests were not physically contiguous. However it is
> important to see why that is the case. Because the request is so big the
> allocator will try to find free group to allocate from skipping block
> groups which are used, which is fine. However it will only allocate
> extents of 2^15-1 block (limitation of uninitialized extent size)
> which will leave one block in each block group free which will make the
> extent tree physically non-contiguous, however _only_ by one block which
> is perfectly fine.
> 
> This will never happen when we normalize the request because for some
> reason (maybe bug) it will be normalized to much smaller request (2048
> blocks) and those extents will then be merged together not leaving any
> free block in between - hence physically contiguous. However the fact
> that we're splitting huge requests into ton of smaller ones and then
> merging extents together is very _very_ bad for fallocate performance.
> 
> The situation is even worst since with commit
> ec22ba8edb507395c95fbc617eea26a6b2d98797 we no longer merge
> uninitialized extents so we end up with absolutely _huge_ extent tree
> for bigger fallocate requests which is also bad for performance but not
> only when fallocate itself, but even when working with the file
> later on.
> 
> Fix this by disabling normalization for fallocate. From my simple testing
> with this commit fallocate is much faster on non fragmented file
> system. On my system fallocate 15T is almost 3x faster with this patch
> and removing this file is almost 2x faster - tested on real hardware.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  fs/ext4/extents.c |   18 ++++++++++--------
>  1 files changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index e2bb929..a40a602 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4422,16 +4422,18 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
>  		trace_ext4_fallocate_exit(inode, offset, max_blocks, ret);
>  		return ret;
>  	}
> -	flags = EXT4_GET_BLOCKS_CREATE_UNINIT_EXT;
> -	if (mode & FALLOC_FL_KEEP_SIZE)
> -		flags |= EXT4_GET_BLOCKS_KEEP_SIZE;
> +
>  	/*
> -	 * Don't normalize the request if it can fit in one extent so
> -	 * that it doesn't get unnecessarily split into multiple
> -	 * extents.
> +	 * We do NOT want the requests from fallocate to be normalized
> +	 * ever!. We know exactly how much we want to allocate and
> +	 * we do not need to do any mumbo-jumbo with it. Requests bigger
> +	 * than uninit extent size, will be divided automatically into
> +	 * biggest possible extents.
>  	 */
> -	if (len <= EXT_UNINIT_MAX_LEN << blkbits)
> -		flags |= EXT4_GET_BLOCKS_NO_NORMALIZE;
> +	flags = EXT4_GET_BLOCKS_CREATE_UNINIT_EXT |
> +		EXT4_GET_BLOCKS_NO_NORMALIZE;
> +	if (mode & FALLOC_FL_KEEP_SIZE)
> +		flags |= EXT4_GET_BLOCKS_KEEP_SIZE;
>  
>  retry:
>  	while (ret >= 0 && ret < max_blocks) {
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
