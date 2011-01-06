From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] ext3: Add journal error check in resize.c
Date: Thu, 6 Jan 2011 12:50:43 +0100
Message-ID: <20110106115043.GF4641@quack.suse.cz>
References: <1290617593-4615-1-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:38945 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753291Ab1AFLus (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Jan 2011 06:50:48 -0500
Content-Disposition: inline
In-Reply-To: <1290617593-4615-1-git-send-email-namhyung@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 25-11-10 01:53:12, Namhyung Kim wrote:
> Check return value of ext3_journal_get_write_access() and
> ext3_journal_dirty_metadata().
  OK, both patches merged.

								Honza
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  fs/ext3/resize.c |   65 ++++++++++++++++++++++++++++++++++++++++++-----------
>  1 files changed, 51 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/ext3/resize.c b/fs/ext3/resize.c
> index e746d30..108b142 100644
> --- a/fs/ext3/resize.c
> +++ b/fs/ext3/resize.c
> @@ -249,7 +249,11 @@ static int setup_new_group_blocks(struct super_block *sb,
>  		memcpy(gdb->b_data, sbi->s_group_desc[i]->b_data, gdb->b_size);
>  		set_buffer_uptodate(gdb);
>  		unlock_buffer(gdb);
> -		ext3_journal_dirty_metadata(handle, gdb);
> +		err = ext3_journal_dirty_metadata(handle, gdb);
> +		if (err) {
> +			brelse(gdb);
> +			goto exit_bh;
> +		}
>  		ext3_set_bit(bit, bh->b_data);
>  		brelse(gdb);
>  	}
> @@ -269,7 +273,11 @@ static int setup_new_group_blocks(struct super_block *sb,
>  			err = PTR_ERR(gdb);
>  			goto exit_bh;
>  		}
> -		ext3_journal_dirty_metadata(handle, gdb);
> +		err = ext3_journal_dirty_metadata(handle, gdb);
> +		if (err) {
> +			brelse(gdb);
> +			goto exit_bh;
> +		}
>  		ext3_set_bit(bit, bh->b_data);
>  		brelse(gdb);
>  	}
> @@ -295,7 +303,11 @@ static int setup_new_group_blocks(struct super_block *sb,
>  			err = PTR_ERR(it);
>  			goto exit_bh;
>  		}
> -		ext3_journal_dirty_metadata(handle, it);
> +		err = ext3_journal_dirty_metadata(handle, it);
> +		if (err) {
> +			brelse(it);
> +			goto exit_bh;
> +		}
>  		brelse(it);
>  		ext3_set_bit(bit, bh->b_data);
>  	}
> @@ -306,7 +318,9 @@ static int setup_new_group_blocks(struct super_block *sb,
>  
>  	mark_bitmap_end(input->blocks_count, EXT3_BLOCKS_PER_GROUP(sb),
>  			bh->b_data);
> -	ext3_journal_dirty_metadata(handle, bh);
> +	err = ext3_journal_dirty_metadata(handle, bh);
> +	if (err)
> +		goto exit_bh;
>  	brelse(bh);
>  
>  	/* Mark unused entries in inode bitmap used */
> @@ -319,7 +333,7 @@ static int setup_new_group_blocks(struct super_block *sb,
>  
>  	mark_bitmap_end(EXT3_INODES_PER_GROUP(sb), EXT3_BLOCKS_PER_GROUP(sb),
>  			bh->b_data);
> -	ext3_journal_dirty_metadata(handle, bh);
> +	err = ext3_journal_dirty_metadata(handle, bh);
>  exit_bh:
>  	brelse(bh);
>  
> @@ -503,12 +517,19 @@ static int add_new_gdb(handle_t *handle, struct inode *inode,
>  	 * reserved inode, and will become GDT blocks (primary and backup).
>  	 */
>  	data[gdb_num % EXT3_ADDR_PER_BLOCK(sb)] = 0;
> -	ext3_journal_dirty_metadata(handle, dind);
> +	err = ext3_journal_dirty_metadata(handle, dind);
> +	if (err)
> +		goto exit_group_desc;
>  	brelse(dind);
> +	dind = NULL;
>  	inode->i_blocks -= (gdbackups + 1) * sb->s_blocksize >> 9;
> -	ext3_mark_iloc_dirty(handle, inode, &iloc);
> +	err = ext3_mark_iloc_dirty(handle, inode, &iloc);
> +	if (err)
> +		goto exit_group_desc;
>  	memset((*primary)->b_data, 0, sb->s_blocksize);
> -	ext3_journal_dirty_metadata(handle, *primary);
> +	err = ext3_journal_dirty_metadata(handle, *primary);
> +	if (err)
> +		goto exit_group_desc;
>  
>  	o_group_desc = EXT3_SB(sb)->s_group_desc;
>  	memcpy(n_group_desc, o_group_desc,
> @@ -519,10 +540,14 @@ static int add_new_gdb(handle_t *handle, struct inode *inode,
>  	kfree(o_group_desc);
>  
>  	le16_add_cpu(&es->s_reserved_gdt_blocks, -1);
> -	ext3_journal_dirty_metadata(handle, EXT3_SB(sb)->s_sbh);
> +	err = ext3_journal_dirty_metadata(handle, EXT3_SB(sb)->s_sbh);
> +	if (err)
> +		goto exit_inode;
>  
>  	return 0;
>  
> +exit_group_desc:
> +	kfree(n_group_desc);
>  exit_inode:
>  	//ext3_journal_release_buffer(handle, iloc.bh);
>  	brelse(iloc.bh);
> @@ -706,16 +731,20 @@ static void update_backups(struct super_block *sb,
>  		}
>  		ext3_debug("update metadata backup %#04lx\n",
>  			  (unsigned long)bh->b_blocknr);
> -		if ((err = ext3_journal_get_write_access(handle, bh)))
> +		if ((err = ext3_journal_get_write_access(handle, bh))) {
> +			brelse(bh);
>  			break;
> +		}
>  		lock_buffer(bh);
>  		memcpy(bh->b_data, data, size);
>  		if (rest)
>  			memset(bh->b_data + size, 0, rest);
>  		set_buffer_uptodate(bh);
>  		unlock_buffer(bh);
> -		ext3_journal_dirty_metadata(handle, bh);
> +		err = ext3_journal_dirty_metadata(handle, bh);
>  		brelse(bh);
> +		if (err)
> +			break;
>  	}
>  	if ((err2 = ext3_journal_stop(handle)) && !err)
>  		err = err2;
> @@ -922,7 +951,9 @@ int ext3_group_add(struct super_block *sb, struct ext3_new_group_data *input)
>  	/* Update the global fs size fields */
>  	sbi->s_groups_count++;
>  
> -	ext3_journal_dirty_metadata(handle, primary);
> +	err = ext3_journal_dirty_metadata(handle, primary);
> +	if (err)
> +		goto exit_journal;
>  
>  	/* Update the reserved block counts only once the new group is
>  	 * active. */
> @@ -934,7 +965,7 @@ int ext3_group_add(struct super_block *sb, struct ext3_new_group_data *input)
>  	percpu_counter_add(&sbi->s_freeinodes_counter,
>  			   EXT3_INODES_PER_GROUP(sb));
>  
> -	ext3_journal_dirty_metadata(handle, sbi->s_sbh);
> +	err = ext3_journal_dirty_metadata(handle, sbi->s_sbh);
>  
>  exit_journal:
>  	mutex_unlock(&sbi->s_resize_lock);
> @@ -1064,8 +1095,14 @@ int ext3_group_extend(struct super_block *sb, struct ext3_super_block *es,
>  		goto exit_put;
>  	}
>  	es->s_blocks_count = cpu_to_le32(o_blocks_count + add);
> -	ext3_journal_dirty_metadata(handle, EXT3_SB(sb)->s_sbh);
> +	err = ext3_journal_dirty_metadata(handle, EXT3_SB(sb)->s_sbh);
>  	mutex_unlock(&EXT3_SB(sb)->s_resize_lock);
> +	if (err) {
> +		ext3_warning(sb, __func__,
> +			     "error %d on journal dirty metadata", err);
> +		ext3_journal_stop(handle);
> +		goto exit_put;
> +	}
>  	ext3_debug("freeing blocks "E3FSBLK" through "E3FSBLK"\n",
>  		   o_blocks_count, o_blocks_count + add);
>  	ext3_free_blocks_sb(handle, sb, o_blocks_count, add, &freed_blocks);
> -- 
> 1.7.0.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
