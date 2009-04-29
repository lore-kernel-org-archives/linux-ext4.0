From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH -V4 1/2] Fix sub-block zeroing for buffered writes into
 unwritten extents
Date: Wed, 29 Apr 2009 08:59:58 -0500
Message-ID: <49F85D5E.8040701@redhat.com>
References: <1240980441-8105-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:34839 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036AbZD2OAD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Apr 2009 10:00:03 -0400
In-Reply-To: <1240980441-8105-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
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
>  fs/ext4/inode.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index e91f978..12dcfab 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2323,6 +2323,16 @@ static int ext4_da_get_block_prep(struct inode *inode, sector_t iblock,
>  		set_buffer_delay(bh_result);
>  	} else if (ret > 0) {
>  		bh_result->b_size = (ret << inode->i_blkbits);
> +		/*
> +		 * With sub-block writes into unwritten extents
> +		 * we also need to mark the buffer as new so that
> +		 * the unwritten parts of the buffer gets correctly zeroed.
> +		 */
> +		if (buffer_unwritten(bh_result)) {
> +			bh_result->b_bdev = inode->i_sb->s_bdev;
> +			set_buffer_new(bh_result);
> +			bh_result->b_blocknr = -1;
> +		}
>  		ret = 0;
>  	}
>  

Ok, I guess this seems like the safest approach.  Long term we should
look really hard at the state & block nr of these buffer heads, but I
agree that keeping the changes restricted to the preallocation path for
now is safest.

-Eric
