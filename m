From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 1/6] libext2fs: optimize rb_set_bmap_range()
Date: Mon, 26 Nov 2012 10:40:28 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1211261027260.18234@localhost>
References: <1353803794-11593-1-git-send-email-tytso@mit.edu> <1353803794-11593-2-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753959Ab2KZKEM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Nov 2012 05:04:12 -0500
In-Reply-To: <1353803794-11593-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 24 Nov 2012, Theodore Ts'o wrote:

> Date: Sat, 24 Nov 2012 19:36:29 -0500
> From: Theodore Ts'o <tytso@mit.edu>
> To: Ext4 Developers List <linux-ext4@vger.kernel.org>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Subject: [PATCH 1/6] libext2fs: optimize rb_set_bmap_range()
> 
> This speeds up reading bitmaps from disk for very large (and full)
> disks by significant amounts (i.e., up to two CPU minutes for a 4T
> file system).
> 
> Addresses-Google-Bug: #7534813
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  lib/ext2fs/blkmap64_rb.c | 32 +++++++++++++++++++++++++++++---
>  1 file changed, 29 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/ext2fs/blkmap64_rb.c b/lib/ext2fs/blkmap64_rb.c
> index a42eda1..816f44f 100644
> --- a/lib/ext2fs/blkmap64_rb.c
> +++ b/lib/ext2fs/blkmap64_rb.c
> @@ -674,16 +674,42 @@ static errcode_t rb_set_bmap_range(ext2fs_generic_bitmap bitmap,
>  				     __u64 start, size_t num, void *in)
>  {
>  	struct ext2fs_rb_private *bp;
> +	unsigned char *cp;
>  	size_t i;
> +	int first_set = -1;
>  	int ret;
>  
>  	bp = (struct ext2fs_rb_private *) bitmap->private;
>  
>  	for (i = 0; i < num; i++) {
> -		ret = ext2fs_test_bit(i, in);
> -		if (ret)
> -			rb_insert_extent(start + i - bitmap->start, 1, bp);
> +		if (i & 7 == 0) {
> +			unsigned char c = cp[i/8];

I do not see cp initialized anywhere. I suppose it should map to the
'in' bitmap ?

I guess that 8 will always be aliquot part of 'num', by maybe we
could explicitly check for that to avoid access to uninitialized
memory ?

> +			if (c == 0xFF) {
> +				if (first_set == -1)
> +					first_set = i;
> +				i += 7;
> +				continue;
> +			}
> +			if ((c == 0x00) && (first_set == -1)) {
> +				i += 7;
> +				continue;
> +			}
> +		}
> +		if (ext2fs_test_bit(i, in)) {
> +			if (first_set == -1)
> +				first_set = i;
> +			continue;
> +		}
> +		if (first_set == -1)
> +			continue;
> +
> +		rb_insert_extent(start + first_set - bitmap->start,
> +				 i - first_set, bp);
> +		first_set = -1;
>  	}
> +	if (first_set != -1)
> +		rb_insert_extent(start + first_set - bitmap->start,
> +				 num - first_set, bp);
>  
>  	return 0;
>  }
> 
