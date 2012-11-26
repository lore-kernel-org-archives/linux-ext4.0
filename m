From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 5/6] libext2fs: optimize rb_get_bmap_range() for mostly
 allocated bmaps
Date: Mon, 26 Nov 2012 12:22:42 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1211261152260.18234@localhost>
References: <1353803794-11593-1-git-send-email-tytso@mit.edu> <1353803794-11593-6-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41053 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755027Ab2KZLWr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Nov 2012 06:22:47 -0500
In-Reply-To: <1353803794-11593-6-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 24 Nov 2012, Theodore Ts'o wrote:

> Date: Sat, 24 Nov 2012 19:36:33 -0500
> From: Theodore Ts'o <tytso@mit.edu>
> To: Ext4 Developers List <linux-ext4@vger.kernel.org>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Subject: [PATCH 5/6] libext2fs: optimize rb_get_bmap_range() for mostly
>     allocated bmaps
> 
> This optimizies the CPU utilization of the rb_get_bmap_range()
> function when most of the bitmap is allocated.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  lib/ext2fs/blkmap64_rb.c | 29 ++++++++++++++++++++++++-----
>  1 file changed, 24 insertions(+), 5 deletions(-)
> 
> diff --git a/lib/ext2fs/blkmap64_rb.c b/lib/ext2fs/blkmap64_rb.c
> index 0705cf2..3a5518b 100644
> --- a/lib/ext2fs/blkmap64_rb.c
> +++ b/lib/ext2fs/blkmap64_rb.c
> @@ -721,6 +721,7 @@ static errcode_t rb_get_bmap_range(ext2fs_generic_bitmap bitmap,
>  	struct rb_node *parent = NULL, *next, **n;
>  	struct ext2fs_rb_private *bp;
>  	struct bmap_rb_extent *ext;
> +	int count;
>  	__u64 pos;
>  
>  	bp = (struct ext2fs_rb_private *) bitmap->private;
> @@ -748,14 +749,32 @@ static errcode_t rb_get_bmap_range(ext2fs_generic_bitmap bitmap,
>  		ext = ext2fs_rb_entry(parent, struct bmap_rb_extent, node);
>  
>  		pos = ext->start;
> -		if (pos < start)
> +		count = ext->count;
> +		if (pos > start+num)

Missing spacing around '+'.

Also I think that the condition should rather be:

		if (pos >= start + num)

> +			break;
> +		if (pos < start) {
> +			count -= start - pos;
> +			if (count < 0)
> +				continue;
>  			pos = start;
> -
> -		while (pos < (ext->start + ext->count)) {
> -			if ((pos - start) >= num)
> -				return 0;
> +		}
> +		if (pos+count > start+num)
> +			count = start+num - pos;

missing spacing around '+'

> +
> +		while (count > 0) {
> +			if ((count >= 8) &&
> +			    ((pos - start) % 8) == 0) {
> +				int nbytes = count >> 3;
> +				int offset = (pos -start) >> 3;

missing spacing around '-'

> +
> +				memset(out + offset, 0xFF, nbytes);
> +				pos += nbytes << 3;
> +				count -= nbytes << 3;
> +				continue;
> +			}
>  			ext2fs_fast_set_bit64((pos - start), out);
>  			pos++;
> +			count--;
>  		}
>  	}
>  	return 0;
> 
