From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 4/6] libext2fs: optimize rb_get_bmap_range()
Date: Mon, 26 Nov 2012 11:46:24 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1211261146110.18234@localhost>
References: <1353803794-11593-1-git-send-email-tytso@mit.edu> <1353803794-11593-5-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62227 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754361Ab2KZKqa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Nov 2012 05:46:30 -0500
In-Reply-To: <1353803794-11593-5-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 24 Nov 2012, Theodore Ts'o wrote:

> Date: Sat, 24 Nov 2012 19:36:32 -0500
> From: Theodore Ts'o <tytso@mit.edu>
> To: Ext4 Developers List <linux-ext4@vger.kernel.org>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Subject: [PATCH 4/6] libext2fs: optimize rb_get_bmap_range()
> 
> This simplifies the rb_get_bmap_range() function and speeds it up for
> the case where most of the bitmap is zero.

Looks good

Reviewed-by: Lukas Czerner <lczerner@redhat.com>

> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  lib/ext2fs/blkmap64_rb.c | 25 ++++++++-----------------
>  1 file changed, 8 insertions(+), 17 deletions(-)
> 
> diff --git a/lib/ext2fs/blkmap64_rb.c b/lib/ext2fs/blkmap64_rb.c
> index 816f44f..0705cf2 100644
> --- a/lib/ext2fs/blkmap64_rb.c
> +++ b/lib/ext2fs/blkmap64_rb.c
> @@ -741,32 +741,23 @@ static errcode_t rb_get_bmap_range(ext2fs_generic_bitmap bitmap,
>  			break;
>  	}
>  
> -	pos = start;
> +	memset(out, 0, (num + 7) >> 3);
> +
>  	for (; parent != NULL; parent = next) {
>  		next = ext2fs_rb_next(parent);
>  		ext = ext2fs_rb_entry(parent, struct bmap_rb_extent, node);
>  
> -		while (((pos - start) < num) &&
> -			(pos < ext->start)) {
> -			ext2fs_fast_clear_bit64((pos - start), out);
> -			pos++;
> -		}
> -
> -		if ((pos - start) >= num)
> -			return 0;
> +		pos = ext->start;
> +		if (pos < start)
> +			pos = start;
>  
> -		while (((pos - start) < num) &&
> -			(pos < (ext->start + ext->count))) {
> +		while (pos < (ext->start + ext->count)) {
> +			if ((pos - start) >= num)
> +				return 0;
>  			ext2fs_fast_set_bit64((pos - start), out);
>  			pos++;
>  		}
>  	}
> -
> -	while ((pos - start) < num) {
> -		ext2fs_fast_clear_bit64((pos - start), out);
> -		pos++;
> -	}
> -
>  	return 0;
>  }
>  
> 
