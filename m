From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 1/2] ext4: Fix block zeroing when punching holes in
 indirect block files
Date: Thu, 19 Jun 2014 17:38:12 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1406191737150.2182@localhost.localdomain>
References: <1403119984-3635-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57079 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932157AbaFSPig (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Jun 2014 11:38:36 -0400
In-Reply-To: <1403119984-3635-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 18 Jun 2014, Jan Kara wrote:

> Date: Wed, 18 Jun 2014 21:33:03 +0200
> From: Jan Kara <jack@suse.cz>
> To: Ted Tso <tytso@mit.edu>
> Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
> Subject: [PATCH 1/2] ext4: Fix block zeroing when punching holes in indirect
>     block files
> 
> free_holes_block() passed local variable as a block pointer
> to ext4_clear_blocks(). Thus ext4_clear_blocks() zeroed out this local
> variable instead of proper place in inode / indirect block. We later
> zero out proper place in inode / indirect block but don't dirty the
> inode / buffer again which can lead to subtle issues (some changes e.g.
> to inode can be lost).

Please see my patch

[PATCH] ext4: Fix punch hole on files with indirect mapping

which fixes those issues in a different way while also make this
operation faster.

Thanks!
-Lukas

> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/indirect.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
> index 8a57e9fcd1b9..9d381707a6fc 100644
> --- a/fs/ext4/indirect.c
> +++ b/fs/ext4/indirect.c
> @@ -1329,8 +1329,8 @@ static int free_hole_blocks(handle_t *handle, struct inode *inode,
>  		if (level == 0 ||
>  		    (bh && all_zeroes((__le32 *)bh->b_data,
>  				      (__le32 *)bh->b_data + addr_per_block))) {
> -			ext4_free_data(handle, inode, parent_bh, &blk, &blk+1);
> -			*i_data = 0;
> +			ext4_free_data(handle, inode, parent_bh,
> +				       i_data, i_data + 1);
>  		}
>  		brelse(bh);
>  		bh = NULL;
> 
