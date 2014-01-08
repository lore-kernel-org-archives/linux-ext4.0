From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: avoid clearing beyond i_blocks when truncating an
 inline data file
Date: Wed, 8 Jan 2014 22:46:40 +0100
Message-ID: <20140108214640.GA21663@quack.suse.cz>
References: <1389117437-12060-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	stable@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1389117437-12060-1-git-send-email-tytso@mit.edu>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue 07-01-14 12:57:17, Ted Tso wrote:
> A missing cast means that when we are truncating a file which is less
> than 60 bytes, we don't trunate the wrong area of memory, and in fact
> we can end up truncating the next inode in the inode table, or worse
> yet, some other kernel data structure.
  Looks good (after updating the changelog as you suggested). You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
> 
> Addresses-Coverity-Id: #751987
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Cc: stable@vger.kernel.org
> ---
>  fs/ext4/inline.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index c417e52..ed29e72 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
> @@ -1928,9 +1928,11 @@ void ext4_inline_data_truncate(struct inode *inode, int *has_inline)
>  		}
>  
>  		/* Clear the content within i_blocks. */
> -		if (i_size < EXT4_MIN_INLINE_DATA_SIZE)
> -			memset(ext4_raw_inode(&is.iloc)->i_block + i_size, 0,
> -					EXT4_MIN_INLINE_DATA_SIZE - i_size);
> +		if (i_size < EXT4_MIN_INLINE_DATA_SIZE) {
> +			void *p = (void *) ext4_raw_inode(&is.iloc)->i_block;
> +			memset(p + i_size, 0,
> +			       EXT4_MIN_INLINE_DATA_SIZE - i_size);
> +		}
>  
>  		EXT4_I(inode)->i_inline_size = i_size <
>  					EXT4_MIN_INLINE_DATA_SIZE ?
> -- 
> 1.8.5.rc3.362.gdf10213
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
