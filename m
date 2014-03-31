From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 1/2] ext4: Fix flag handling in ext4_split_convert_extents()
Date: Mon, 31 Mar 2014 18:12:39 +0400
Message-ID: <874n2emp7s.fsf@openvz.org>
References: <1396257094-10386-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dan.carpenter@oracle.com, Lukas Czerner <lczerner@redhat.com>
To: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:53643 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956AbaCaOMn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 31 Mar 2014 10:12:43 -0400
Received: by mail-lb0-f178.google.com with SMTP id s7so5939821lbd.9
        for <linux-ext4@vger.kernel.org>; Mon, 31 Mar 2014 07:12:42 -0700 (PDT)
In-Reply-To: <1396257094-10386-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 31 Mar 2014 11:11:33 +0200, Lukas Czerner <lczerner@redhat.com> wrote:
> In commit 1f0e51771281 "ext4: Introduce FALLOC_FL_ZERO_RANGE flag
> for fallocate" we've introduced wrong flag handling. Fix it.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  fs/ext4/extents.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 243a02e..491208c 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3644,13 +3644,13 @@ static int ext4_split_convert_extents(handle_t *handle,
>  	ee_len = ext4_ext_get_actual_len(ex);
>  
>  	/* Convert to unwritten */
> -	if (flags | EXT4_GET_BLOCKS_CONVERT_UNWRITTEN) {
> +	if (flags & EXT4_GET_BLOCKS_CONVERT_UNWRITTEN) {
:).  But how did you found this? 
I think that this type of bugs should be caught by some semantics
analyzer? I've done simple test and sparse(1) owerlooked this,
Also I cant find specific rule for Coccinelle ( if (var | CONST)).

>  		split_flag |= EXT4_EXT_DATA_VALID1;
>  	/* Convert to initialized */
> -	} else if (flags | EXT4_GET_BLOCKS_CONVERT) {
> +	} else if (flags & EXT4_GET_BLOCKS_CONVERT) {
>  		split_flag |= ee_block + ee_len <= eof_block ?
>  			      EXT4_EXT_MAY_ZEROOUT : 0;
> -		split_flag |= (EXT4_EXT_MARK_UNINIT2 & EXT4_EXT_DATA_VALID2);
> +		split_flag |= (EXT4_EXT_MARK_UNINIT2 | EXT4_EXT_DATA_VALID2);
>  	}
>  	flags |= EXT4_GET_BLOCKS_PRE_IO;
>  	return ext4_split_extent(handle, inode, path, map, split_flag, flags);
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
