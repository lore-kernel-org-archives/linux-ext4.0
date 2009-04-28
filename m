From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH -V3] Fix sub-block zeroing for buffered writes into unwritten
 extents
Date: Tue, 28 Apr 2009 16:47:43 -0500
Message-ID: <49F7797F.9080401@redhat.com>
References: <1240944653-4328-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:58814 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753610AbZD1Vrr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Apr 2009 17:47:47 -0400
In-Reply-To: <1240944653-4328-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> We need to mark the  buffer_head mapping prealloc space
> as new during write_begin. Otherwise we don't zero out the
> page cache content properly for a partial write. This will
> cause file corruption with preallocation.
> 
> Also use block number -1 as the fake block number so that
> unmap_underlying_metadata doesn't drop wrong buffer_head
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> 
> ---
>  fs/ext4/inode.c |   11 ++++++++++-
>  1 files changed, 10 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index e91f978..0214389 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2318,11 +2318,20 @@ static int ext4_da_get_block_prep(struct inode *inode, sector_t iblock,
>  			/* not enough space to reserve */
>  			return ret;
>  
> -		map_bh(bh_result, inode->i_sb, 0);
> +		map_bh(bh_result, inode->i_sb, -1);

This seems fine, though unrelated, isn't it?  But mapping delalloc
blocks to -1 temporarily rather than to 0 seems safer to me (could this
possibly be related to our low-block corruption cases?)

Oh, I guess this is for the unmap_underlying_metadata stuff, though I
don't know what that call is for in ext4, to be honest.  :)  At any rate
this should make it not findable there which is fine, I guess.

>  		set_buffer_new(bh_result);
>  		set_buffer_delay(bh_result);
>  	} else if (ret > 0) {
>  		bh_result->b_size = (ret << inode->i_blkbits);
> +		bh_result->b_bdev = inode->i_sb->s_bdev;
> +		bh->b_blocknr = -1;

Mingming pointed out on irc that this sets the blocknr to -1 for every
mapping we find, which is probably not what we want.  :)  But if it's an
actually (pre)allocated block, why do we set it to a fake number at all?

I guess it seems to me that we should be setting up a preallocated
block/bh just about like any other, with a block nr, bdev, etc when we
create it or look it up - but with BH_Unwritten as well to flag it as
such.  It may not actually matter but it just seems odd to me for it to
have a fake block nr.

If surrounding infrastructure still expects to call get_block each time
to split up an unwritten extent, ok for now to leave it unmapped, but
that needs work I think, as we mentioned on irc.

FWIW, setting it to -1 even under the if (buffer_unwritten()) test below
is probably redundant, I think it's already set that way from
alloc_page_buffers().

> +		/*
> +		 * With sub-block writes into unwritten extents
> +		 * we also need to mark the buffer as new so that
> +		 * the unwritten parts of the buffer gets correctly zeroed.
> +		 */
> +		if (buffer_unwritten(bh_result))
> +			set_buffer_new(bh_result);
>  		ret = 0;
>  	}
>  

This part still seems fine to me :)

-Eric
