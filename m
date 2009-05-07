From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 1/3] ext4: Properly initialize the buffer_head state
Date: Thu, 07 May 2009 10:20:26 -0500
Message-ID: <4A02FC3A.9000806@redhat.com>
References: <1241692770-22547-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:50406 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752656AbZEGPUb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 May 2009 11:20:31 -0400
In-Reply-To: <1241692770-22547-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> These buffer_heads are allocated on stack and are
> used only to make get_blocks calls. So we can set the
> b_state to 0
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

I'd noticed this too, thanks for fixing up.

> ---
>  fs/ext4/extents.c |    1 +
>  fs/ext4/inode.c   |    2 +-
>  fs/mpage.c        |    2 +-
>  3 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index e963870..10b3028 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3141,6 +3141,7 @@ long ext4_fallocate(struct inode *inode, int mode, loff_t offset, loff_t len)
>  			ret = PTR_ERR(handle);
>  			break;
>  		}
> +		map_bh.b_state = 0;
>  		ret = ext4_get_blocks_wrap(handle, inode, block,
>  					  max_blocks, &map_bh,
>  					  EXT4_CREATE_UNINITIALIZED_EXT, 0, 0);
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 43884e3..c3cd00f 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2104,7 +2104,7 @@ static int mpage_da_map_blocks(struct mpage_da_data *mpd)
>  	if ((mpd->b_state  & (1 << BH_Mapped)) &&
>  	    !(mpd->b_state & (1 << BH_Delay)))
>  		return 0;
> -	new.b_state = mpd->b_state;
> +	new.b_state = 0;

hm can you explain why we want 0 rather than mpd->b_state?  The others
are obvious, b_state was largely uninitialized, but this is changing
what looked like a different intentional initialization.  Can you update
the changelog to say why it's wrong?

While we're at it could we name this something other than "new?"

If it's a mapping bh, maybe "map_bh" like normal? :)

>  	new.b_blocknr = 0;
>  	new.b_size = mpd->b_size;
>  	next = mpd->b_blocknr;
> diff --git a/fs/mpage.c b/fs/mpage.c
> index 680ba60..cd98409 100644
> --- a/fs/mpage.c
> +++ b/fs/mpage.c
> @@ -412,7 +412,7 @@ int mpage_readpage(struct page *page, get_block_t get_block)
>  	struct buffer_head map_bh;
>  	unsigned long first_logical_block = 0;
>  
> -	clear_buffer_mapped(&map_bh);
> +	map_bh.b_state = 0;
>  	bio = do_mpage_readpage(bio, page, 1, &last_block_in_bio,
>  			&map_bh, &first_logical_block, get_block);
>  	if (bio)

the rest looks good to me; there are places in the core kernel that
don't initialize state and just clear flags they "know" they'll care
about... it always struck me as messy, clearing state is much much better.

-Eric
