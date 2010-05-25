From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 2/2] ext4: Clear the EXT4_EOFBLOCKS_FL flag only when warranted
Date: Tue, 25 May 2010 11:23:48 +0400
Message-ID: <87zkzola0r.fsf@openvz.org>
References: <20100525041737.GB5556@thunk.org>
	<1274761117-26560-2-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:14825 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab0EYHXx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 May 2010 03:23:53 -0400
Received: by fg-out-1718.google.com with SMTP id e12so163394fga.1
        for <linux-ext4@vger.kernel.org>; Tue, 25 May 2010 00:23:51 -0700 (PDT)
In-Reply-To: <1274761117-26560-2-git-send-email-tytso@mit.edu> (Theodore
	Ts'o's message of "Tue, 25 May 2010 00:18:37 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Ts'o <tytso@mit.edu> writes:

> Dimitry Monakhov discovered an edge case where it was possible for the
> EXT4_EOFBLOCKS_FL flag could get cleared unnecessarily.  This is true;
> I have a test case that can be exercised via downloading and
> decompressing the file:
>
> wget ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/ext4-testcases/eofblocks-fl-test-case.img.bz2
> bunzip2 eofblocks-fl-test-case.img
> dd if=/dev/zero of=eofblocks-fl-test-case.img bs=1k seek=17925 bs=1k count=1 conv=notrunc
>
> However, triggering it in real life is highly unlikely since it
> requires an extremely fragmented sparse file with a hole in exactly
> the right place in the extent tree.  (It actually took quite a bit of
This condition was triggered during fsstress test. So I consider
it as rare but possible in real life. Nor than less it is better
to fix it now, than fix it in response from a midnight call from some
crazy customer :)
> work to generate this test case.)  Still, it's nice to get even
> extreme corner cases to be correct, so this patch makes sure that we
> don't clear the EXT4_EOFBLOCKS_FL incorrectly even in this corner
> case.
>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  fs/ext4/extents.c |   18 +++++++++++++++---
>  1 files changed, 15 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index aeec5c7..c7c304f 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3319,7 +3319,7 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
>  	struct ext4_extent_header *eh;
>  	struct ext4_extent newex, *ex, *last_ex;
>  	ext4_fsblk_t newblock;
> -	int err = 0, depth, ret, cache_type;
> +	int i, err = 0, depth, ret, cache_type;
>  	unsigned int allocated = 0;
>  	struct ext4_allocation_request ar;
>  	ext4_io_end_t *io = EXT4_I(inode)->cur_aio_dio;
> @@ -3508,8 +3508,20 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
>  			goto out2;
>  		}
>  		last_ex = EXT_LAST_EXTENT(eh);
> -		if (map->m_lblk + ar.len > le32_to_cpu(last_ex->ee_block)
> -		    + ext4_ext_get_actual_len(last_ex))
> +		/*
> +		 * If the current leaf block was reached by looking at
> +		 * the last index block all the way down the tree, and
> +		 * we are extending the inode beyond the last extent
> +		 * in the current leaf block, then clear the
> +		 * EOFBLOCKS_FL flag.
> +		 */
> +		for (i=depth-1; i >= 0; i--) {
> +			if (path[i].p_idx != EXT_LAST_INDEX(path[i].p_hdr))
> +				break;
This approach definitely looks better.
> +		}
> +		if ((i < 0) &&
> +		    (map->m_lblk + ar.len > le32_to_cpu(last_ex->ee_block) + 
> +		     ext4_ext_get_actual_len(last_ex)))
>  			ext4_clear_inode_flag(inode, EXT4_INODE_EOFBLOCKS);
>  	}
>  	err = ext4_ext_insert_extent(handle, inode, path, &newex, flags);
