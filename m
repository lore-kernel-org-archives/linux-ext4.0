Return-Path: <SRS0=hSPz=NR=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from relay.sw.ru ([185.231.240.75]:53434 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729416AbeKFPsU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 6 Nov 2018 10:48:20 -0500
Subject: Re: [PATCH] ext4: remove code duplication in free_ind_block()
To: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-kernel@vger.kernel.org
References: <f1ec9378-6b0f-fdee-392c-bb97187fae12@virtuozzo.com>
From: Vasily Averin <vvs@virtuozzo.com>
Message-ID: <8248d9f2-b758-21cb-5cd8-30bba2bb9137@virtuozzo.com>
Date: Tue, 6 Nov 2018 09:24:38 +0300
MIME-Version: 1.0
In-Reply-To: <f1ec9378-6b0f-fdee-392c-bb97187fae12@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

btw I have few related questions:
1) extend_credit_for_blkdel() can return error but its return code is not checked, 
neither here nor in all other places. Could somebody clarify, is it normal?

2) there is similar function free_ext_idx(). After internal failures  it calls 
extend_credit_for_blkdel() and ext4_free_blocks().
In the same situation free_ind_blocks() returns without calling of these functions.
Is it OK?

Thank you,
	Vasily Averin

On 11/6/18 9:13 AM, Vasily Averin wrote:
> free_ind_block(), free_dind_blocks() and free_tind_blocks() are replaced
> by a single recursive function.
> 
> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
> ---
>  fs/ext4/migrate.c | 115 +++++++++++++---------------------------------
>  1 file changed, 32 insertions(+), 83 deletions(-)
> 
> diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
> index 224e136d1c10..754f172b18d4 100644
> --- a/fs/ext4/migrate.c
> +++ b/fs/ext4/migrate.c
> @@ -157,100 +157,43 @@ static int extend_credit_for_blkdel(handle_t *handle, struct inode *inode)
>  	return retval;
>  }
>  
> -static int free_dind_blocks(handle_t *handle,
> -				struct inode *inode, __le32 i_data)
> +static int free_ind_blocks(handle_t *handle,
> +				struct inode *inode, __le32 i_data, int ind)
>  {
> -	int i;
> -	__le32 *tmp_idata;
> -	struct buffer_head *bh;
> -	unsigned long max_entries = inode->i_sb->s_blocksize >> 2;
> -
> -	bh = sb_bread(inode->i_sb, le32_to_cpu(i_data));
> -	if (!bh)
> -		return -EIO;
> -
> -	tmp_idata = (__le32 *)bh->b_data;
> -	for (i = 0; i < max_entries; i++) {
> -		if (tmp_idata[i]) {
> -			extend_credit_for_blkdel(handle, inode);
> -			ext4_free_blocks(handle, inode, NULL,
> -					 le32_to_cpu(tmp_idata[i]), 1,
> -					 EXT4_FREE_BLOCKS_METADATA |
> -					 EXT4_FREE_BLOCKS_FORGET);
> -		}
> -	}
> -	put_bh(bh);
> -	extend_credit_for_blkdel(handle, inode);
> -	ext4_free_blocks(handle, inode, NULL, le32_to_cpu(i_data), 1,
> -			 EXT4_FREE_BLOCKS_METADATA |
> -			 EXT4_FREE_BLOCKS_FORGET);
> -	return 0;
> -}
> -
> -static int free_tind_blocks(handle_t *handle,
> -				struct inode *inode, __le32 i_data)
> -{
> -	int i, retval = 0;
> -	__le32 *tmp_idata;
> -	struct buffer_head *bh;
> -	unsigned long max_entries = inode->i_sb->s_blocksize >> 2;
> -
> -	bh = sb_bread(inode->i_sb, le32_to_cpu(i_data));
> -	if (!bh)
> -		return -EIO;
> -
> -	tmp_idata = (__le32 *)bh->b_data;
> -	for (i = 0; i < max_entries; i++) {
> -		if (tmp_idata[i]) {
> -			retval = free_dind_blocks(handle,
> -					inode, tmp_idata[i]);
> -			if (retval) {
> -				put_bh(bh);
> -				return retval;
> +	if (ind > 0) {
> +		int retval = 0;
> +		__le32 *tmp_idata;
> +		ext4_lblk_t i, max_entries;
> +		struct buffer_head *bh;
> +
> +		bh = sb_bread(inode->i_sb, le32_to_cpu(i_data));
> +		if (!bh)
> +			return -EIO;
> +
> +		tmp_idata = (__le32 *)bh->b_data;
> +		max_entries = inode->i_sb->s_blocksize >> 2;
> +		for (i = 0; i < max_entries; i++) {
> +			if (tmp_idata[i]) {
> +				retval = free_ind_blocks(handle,
> +						inode, tmp_idata[i], ind - 1);
> +				if (retval) {
> +					put_bh(bh);
> +					return retval;
> +				}
>  			}
>  		}
> +		put_bh(bh);
>  	}
> -	put_bh(bh);
>  	extend_credit_for_blkdel(handle, inode);
>  	ext4_free_blocks(handle, inode, NULL, le32_to_cpu(i_data), 1,
> -			 EXT4_FREE_BLOCKS_METADATA |
> -			 EXT4_FREE_BLOCKS_FORGET);
> -	return 0;
> -}
> -
> -static int free_ind_block(handle_t *handle, struct inode *inode, __le32 *i_data)
> -{
> -	int retval;
> -
> -	/* ei->i_data[EXT4_IND_BLOCK] */
> -	if (i_data[0]) {
> -		extend_credit_for_blkdel(handle, inode);
> -		ext4_free_blocks(handle, inode, NULL,
> -				le32_to_cpu(i_data[0]), 1,
> -				 EXT4_FREE_BLOCKS_METADATA |
> -				 EXT4_FREE_BLOCKS_FORGET);
> -	}
> -
> -	/* ei->i_data[EXT4_DIND_BLOCK] */
> -	if (i_data[1]) {
> -		retval = free_dind_blocks(handle, inode, i_data[1]);
> -		if (retval)
> -			return retval;
> -	}
> -
> -	/* ei->i_data[EXT4_TIND_BLOCK] */
> -	if (i_data[2]) {
> -		retval = free_tind_blocks(handle, inode, i_data[2]);
> -		if (retval)
> -			return retval;
> -	}
> +			 EXT4_FREE_BLOCKS_METADATA | EXT4_FREE_BLOCKS_FORGET);
>  	return 0;
>  }
>  
>  static int ext4_ext_swap_inode_data(handle_t *handle, struct inode *inode,
>  						struct inode *tmp_inode)
>  {
> -	int retval;
> +	int i, retval;
>  	__le32	i_data[3];
>  	struct ext4_inode_info *ei = EXT4_I(inode);
>  	struct ext4_inode_info *tmp_ei = EXT4_I(tmp_inode);
> @@ -307,7 +250,13 @@ static int ext4_ext_swap_inode_data(handle_t *handle, struct inode *inode,
>  	 * We mark the inode dirty after, because we decrement the
>  	 * i_blocks when freeing the indirect meta-data blocks
>  	 */
> -	retval = free_ind_block(handle, inode, i_data);
> +	for (i = 0; i < ARRAY_SIZE(i_data); i++) {
> +		if (i_data[i]) {
> +			retval = free_ind_blocks(handle, inode, i_data[i], i);
> +			if (retval)
> +				break;
> +		}
> +	}
>  	ext4_mark_inode_dirty(handle, inode);
>  
>  err_out:
> 
