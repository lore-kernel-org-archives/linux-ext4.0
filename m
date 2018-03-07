From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 7/7] ext4: don't update checksum of new initialized
 bitmaps
Date: Wed, 7 Mar 2018 10:06:07 +0100
Message-ID: <20180307090607.wfkplsuvigaoie5o@quack2.suse.cz>
References: <20180220023038.19883-1-tytso@mit.edu>
 <20180220023038.19883-8-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        stable@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180220023038.19883-8-tytso@mit.edu>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon 19-02-18 21:30:38, Theodore Ts'o wrote:
> When reading the inode or block allocation bitmap, if the bitmap needs
> to be initialized, do not update the checksum in the block group
> descriptor.  That's because we're not set up to journal those changes.
> Instead, just set the verified bit on the bitmap block, so that it's
> not necessary to validate the checksum.
> 
> When a block or inode allocation actually happens, at that point the
> checksum will be calculated, and update of the bg descriptor block
> will be properly journalled.
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Cc: stable@vger.kernel.org
> ---
>  fs/ext4/balloc.c |  3 +--
>  fs/ext4/ialloc.c | 47 +++--------------------------------------------
>  2 files changed, 4 insertions(+), 46 deletions(-)
> 
> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> index f9b3e0a83526..f82c4966f4ce 100644
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -243,8 +243,6 @@ static int ext4_init_block_bitmap(struct super_block *sb,
>  	 */
>  	ext4_mark_bitmap_end(num_clusters_in_group(sb, block_group),
>  			     sb->s_blocksize * 8, bh->b_data);
> -	ext4_block_bitmap_csum_set(sb, block_group, gdp, bh);
> -	ext4_group_desc_csum_set(sb, block_group, gdp);
>  	return 0;
>  }

Probably you should remove the bad checksum handling in
ext4_init_block_bitmap() the same way as you did in
ext4_init_inode_bitmap()? Otherwise the patch looks good.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
