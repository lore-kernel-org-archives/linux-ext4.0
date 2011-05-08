From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: fix memory leak in
 ext2fs_free_generic_bmap()
Date: Sun, 8 May 2011 18:10:55 -0400
Message-ID: <20110508221055.GE15585@thunk.org>
References: <1300702440-4835-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48811 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617Ab1EHWK7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 8 May 2011 18:10:59 -0400
Content-Disposition: inline
In-Reply-To: <1300702440-4835-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 21, 2011 at 11:14:00AM +0100, Lukas Czerner wrote:
> In ext2fs_free_generic_bmap() when we are freeing 64-bit bitmap, we do
> call free_bmap() to free backend specific bitmap structures, however we
> should also free ext2fs_generic_bitmap structure as well. So this commit
> fixes that and removes unnecessary assignments.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  lib/ext2fs/gen_bitmap64.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/lib/ext2fs/gen_bitmap64.c b/lib/ext2fs/gen_bitmap64.c
> index 8b9e4c5..f343cc7 100644
> --- a/lib/ext2fs/gen_bitmap64.c
> +++ b/lib/ext2fs/gen_bitmap64.c
> @@ -153,11 +153,11 @@ void ext2fs_free_generic_bmap(ext2fs_generic_bitmap bmap)
>  
>  	bmap->bitmap_ops->free_bmap(bmap);
>  
> -	if (bmap->description) {
> +	if (bmap->description)
>  		ext2fs_free_mem(&bmap->description);
> -		bmap->description = 0;
> -	}
> -	bmap->magic = 0;
> +
> +	ext2fs_free_mem(&bmap);
> +	bmap = NULL;

Setting bmap to NULL is pointless since C doesn't have
pass-by-reference ala C++ (i.e., it's not like this function parameter
is declared "ext2fs_generic_bitmap &bmap").

So it's actually a good idea to zap bmap->description, and especially
bmap->magic, since that will allow us to catch attempts to use the
bitmap after we free it.

I'll make the simplification of your patch which just adds the missing
"ext2fs_free_mem(&bmap)" call.

					- Ted
