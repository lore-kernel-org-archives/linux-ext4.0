From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 3/3] ext4: fix block swap procedure on migration V2
Date: Mon, 19 Sep 2011 20:45:32 +0400
Message-ID: <87wrd4zdjn.fsf@dmbot.sw.ru>
References: <1316266379-18737-1-git-send-email-dmonakhov@openvz.org> <1316266379-18737-3-git-send-email-dmonakhov@openvz.org> <4CCE9F3D-0343-4FF2-A969-291335071D69@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, aneesh.kumar@linux.vnet.ibm.com,
	tytso@mit.edu
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49905 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755013Ab1ISQpY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Sep 2011 12:45:24 -0400
Received: by bkbzt4 with SMTP id zt4so5451374bkb.19
        for <linux-ext4@vger.kernel.org>; Mon, 19 Sep 2011 09:45:23 -0700 (PDT)
In-Reply-To: <4CCE9F3D-0343-4FF2-A969-291335071D69@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 19 Sep 2011 10:29:24 -0600, Andreas Dilger <adilger@dilger.ca> wrote:
> On 2011-09-17, at 7:32 AM, Dmitry Monakhov wrote:
> > Currently if system halted in the midle of migration procedure
> > tmp_inode will be truncated on next mount during orphan list cleanup
> > as a regular inode, but in fact it is the special one. Temporal inode
> > refers to original's inode leaf blocks, but does not own it.
> > And we should free only index blocks, but not a leaf one.
> > We have to somehow flag migration inode as a special one, and then
> > cleanup it accordingly. The flag in question should survive
> > trough reboots.
> 
> I think this is potentially the wrong approach for extent migration.
> We don't want the kernel to automatically delete these inodes, which
> is what should happen if they are on the orphan list, since it means
> the blocks will be marked unused by the bitmap, and further corruption
> will result.
> 
> It would potentially be better to just leave the inode off the orphan
> list, and in the _extremely_ rare case that there is a crash during
> inode migration the inode is leaked until e2fsck is run.  The migrate
> will happen at most once for any filesystem, so the loss of a single
> inode per crash will not be a serious issue IMHO.
But we still need to tell e2fsck that it is not just an average inode,
and it should be cleaned up without touching it's data blocks. Otherwise
fsck will complain about blocks are referenced by multiple inodes, which
is really scary message. So IMHO we still need persistent flag. 
> 
> > This patch introduce new inode flag for this purpose. Yes I know
> > that may seems not optimal to use didicated flag for such a rare case,
> > and if you know a better way, or a good flag that we can share please
> > say tell me. Also we don't need didicated (migration only) cleanup
> > functions. It is reasonable just skip leaf blocks for inodes with
> > migration flag enabled inode inside ext4_truncate(). So tmp_inode will
> > be cleaned automatically on last iput()
> > 
> > - Introduce new inode flag for temporal inodes
> > - Move cleanup logic to truncate.
> > - Remove duplicated code. We no longer need it.
> > 
> > Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> > ---
> > fs/ext4/ext4.h     |    3 +
> > fs/ext4/extents.c  |   10 ++-
> > fs/ext4/indirect.c |    4 +
> > fs/ext4/migrate.c  |  247 +++++-----------------------------------------------
> > 4 files changed, 35 insertions(+), 229 deletions(-)
> > 
> > diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> > index 3aa2f7c..8a6f612 100644
> > --- a/fs/ext4/ext4.h
> > +++ b/fs/ext4/ext4.h
> > @@ -350,6 +350,7 @@ struct flex_groups {
> > #define EXT4_EXTENTS_FL			0x00080000 /* Inode uses extents */
> > #define EXT4_EA_INODE_FL	        0x00200000 /* Inode used for large EA */
> > #define EXT4_EOFBLOCKS_FL		0x00400000 /* Blocks allocated beyond EOF */
> > +#define EXT4_MIGRATE_FL			0x10000000 /* Inode used for data migration */
> > #define EXT4_RESERVED_FL		0x80000000 /* reserved for ext4 lib */
> > 
> > #define EXT4_FL_USER_VISIBLE		0x004BDFFF /* User visible flags */
> > @@ -407,6 +408,7 @@ enum {
> > 	EXT4_INODE_EXTENTS	= 19,	/* Inode uses extents */
> > 	EXT4_INODE_EA_INODE	= 21,	/* Inode used for large EA */
> > 	EXT4_INODE_EOFBLOCKS	= 22,	/* Blocks allocated beyond EOF */
> > +	EXT4_INODE_MIGRATE	= 28,	/* Inode used for data migration */
> > 	EXT4_INODE_RESERVED	= 31,	/* reserved for ext4 lib */
> > };
> > 
> > @@ -453,6 +455,7 @@ static inline void ext4_check_flag_values(void)
> > 	CHECK_FLAG_VALUE(EXTENTS);
> > 	CHECK_FLAG_VALUE(EA_INODE);
> > 	CHECK_FLAG_VALUE(EOFBLOCKS);
> > +	CHECK_FLAG_VALUE(MIGRATE);
> > 	CHECK_FLAG_VALUE(RESERVED);
> > }
> > 
> > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > index 57cf568..0ac5a63 100644
> > --- a/fs/ext4/extents.c
> > +++ b/fs/ext4/extents.c
> > @@ -2416,10 +2416,12 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
> > 		if (err)
> > 			goto out;
> > 
> > -		err = ext4_remove_blocks(handle, inode, ex, a, b);
> > -		if (err)
> > -			goto out;
> > -
> > +		/* Migration inode does not own it's leaf blocks */
> > +		if (!ext4_test_inode_flag(inode, EXT4_INODE_MIGRATE)) {
> > +			err = ext4_remove_blocks(handle, inode, ex, a, b);
> > +			if (err)
> > +				goto out;
> > +		}
> > 		if (num == 0) {
> > 			/* this extent is removed; mark slot entirely unused */
> > 			ext4_ext_store_pblock(ex, 0);
> > diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
> > index 0962642..4581d0e 100644
> > --- a/fs/ext4/indirect.c
> > +++ b/fs/ext4/indirect.c
> > @@ -1147,6 +1147,10 @@ static void ext4_free_data(handle_t *handle, struct inode *inode,
> > 					       for current block */
> > 	int err = 0;
> > 
> > +	/* Migration inode does not own it's data blocks */
> > +	if (ext4_test_inode_flag(inode, EXT4_INODE_MIGRATE))
> > +		return;
> > +
> > 	if (this_bh) {				/* For indirect block */
> > 		BUFFER_TRACE(this_bh, "get_write_access");
> > 		err = ext4_journal_get_write_access(handle, this_bh);
> > diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
> > index 74f2900..a75e40d 100644
> > --- a/fs/ext4/migrate.c
> > +++ b/fs/ext4/migrate.c
> > @@ -24,6 +24,7 @@
> > struct migrate_struct {
> > 	ext4_lblk_t first_block, last_block, curr_block;
> > 	ext4_fsblk_t first_pblock, last_pblock;
> > +	blkcnt_t ind_blocks;
> > 
> > };
> > 
> > @@ -135,6 +136,7 @@ static int update_ind_extent_range(handle_t *handle, struct inode *inode,
> > 			lb->curr_block++;
> > 		}
> > 	}
> > +	lb->ind_blocks++;
> > 	put_bh(bh);
> > 	return retval;
> > 
> > @@ -164,6 +166,7 @@ static int update_dind_extent_range(handle_t *handle, struct inode *inode,
> > 			lb->curr_block += max_entries;
> > 		}
> > 	}
> > +	lb->ind_blocks++;
> > 	put_bh(bh);
> > 	return retval;
> > 
> > @@ -193,144 +196,30 @@ static int update_tind_extent_range(handle_t *handle, struct inode *inode,
> > 			lb->curr_block += max_entries * max_entries;
> > 		}
> > 	}
> > +	lb->ind_blocks++;
> > 	put_bh(bh);
> > 	return retval;
> > 
> > }
> > 
> > -static int extend_credit_for_blkdel(handle_t *handle, struct inode *inode)
> > -{
> > -	int retval = 0, needed;
> > -
> > -	if (ext4_handle_has_enough_credits(handle, EXT4_RESERVE_TRANS_BLOCKS+1))
> > -		return 0;
> > -	/*
> > -	 * We are freeing a blocks. During this we touch
> > -	 * superblock, group descriptor and block bitmap.
> > -	 * So allocate a credit of 3. We may update
> > -	 * quota (user and group).
> > -	 */
> > -	needed = 3 + EXT4_MAXQUOTAS_TRANS_BLOCKS(inode->i_sb);
> > -
> > -	if (ext4_journal_extend(handle, needed) != 0)
> > -		retval = ext4_journal_restart(handle, needed);
> > -
> > -	return retval;
> > -}
> > -
> > -static int free_dind_blocks(handle_t *handle,
> > -				struct inode *inode, __le32 i_data)
> > -{
> > -	int i;
> > -	__le32 *tmp_idata;
> > -	struct buffer_head *bh;
> > -	unsigned long max_entries = inode->i_sb->s_blocksize >> 2;
> > -
> > -	bh = sb_bread(inode->i_sb, le32_to_cpu(i_data));
> > -	if (!bh)
> > -		return -EIO;
> > -
> > -	tmp_idata = (__le32 *)bh->b_data;
> > -	for (i = 0; i < max_entries; i++) {
> > -		if (tmp_idata[i]) {
> > -			extend_credit_for_blkdel(handle, inode);
> > -			ext4_free_blocks(handle, inode, NULL,
> > -					 le32_to_cpu(tmp_idata[i]), 1,
> > -					 EXT4_FREE_BLOCKS_METADATA |
> > -					 EXT4_FREE_BLOCKS_FORGET);
> > -		}
> > -	}
> > -	put_bh(bh);
> > -	extend_credit_for_blkdel(handle, inode);
> > -	ext4_free_blocks(handle, inode, NULL, le32_to_cpu(i_data), 1,
> > -			 EXT4_FREE_BLOCKS_METADATA |
> > -			 EXT4_FREE_BLOCKS_FORGET);
> > -	return 0;
> > -}
> > -
> > -static int free_tind_blocks(handle_t *handle,
> > -				struct inode *inode, __le32 i_data)
> > -{
> > -	int i, retval = 0;
> > -	__le32 *tmp_idata;
> > -	struct buffer_head *bh;
> > -	unsigned long max_entries = inode->i_sb->s_blocksize >> 2;
> > -
> > -	bh = sb_bread(inode->i_sb, le32_to_cpu(i_data));
> > -	if (!bh)
> > -		return -EIO;
> > -
> > -	tmp_idata = (__le32 *)bh->b_data;
> > -	for (i = 0; i < max_entries; i++) {
> > -		if (tmp_idata[i]) {
> > -			retval = free_dind_blocks(handle,
> > -					inode, tmp_idata[i]);
> > -			if (retval) {
> > -				put_bh(bh);
> > -				return retval;
> > -			}
> > -		}
> > -	}
> > -	put_bh(bh);
> > -	extend_credit_for_blkdel(handle, inode);
> > -	ext4_free_blocks(handle, inode, NULL, le32_to_cpu(i_data), 1,
> > -			 EXT4_FREE_BLOCKS_METADATA |
> > -			 EXT4_FREE_BLOCKS_FORGET);
> > -	return 0;
> > -}
> > -
> > -static int free_ind_block(handle_t *handle, struct inode *inode, __le32 *i_data)
> > -{
> > -	int retval;
> > -
> > -	/* ei->i_data[EXT4_IND_BLOCK] */
> > -	if (i_data[0]) {
> > -		extend_credit_for_blkdel(handle, inode);
> > -		ext4_free_blocks(handle, inode, NULL,
> > -				le32_to_cpu(i_data[0]), 1,
> > -				 EXT4_FREE_BLOCKS_METADATA |
> > -				 EXT4_FREE_BLOCKS_FORGET);
> > -	}
> > -
> > -	/* ei->i_data[EXT4_DIND_BLOCK] */
> > -	if (i_data[1]) {
> > -		retval = free_dind_blocks(handle, inode, i_data[1]);
> > -		if (retval)
> > -			return retval;
> > -	}
> > -
> > -	/* ei->i_data[EXT4_TIND_BLOCK] */
> > -	if (i_data[2]) {
> > -		retval = free_tind_blocks(handle, inode, i_data[2]);
> > -		if (retval)
> > -			return retval;
> > -	}
> > -	return 0;
> > -}
> > -
> > static int ext4_ext_swap_inode_data(handle_t *handle, struct inode *inode,
> > -						struct inode *tmp_inode)
> > +				struct inode *tmp_inode,
> > +				struct migrate_struct *mreq)
> > {
> > 	int retval;
> > -	__le32	i_data[3];
> > +	__le32  i_data[EXT4_N_BLOCKS];
> > 	struct ext4_inode_info *ei = EXT4_I(inode);
> > 	struct ext4_inode_info *tmp_ei = EXT4_I(tmp_inode);
> > -
> > 	/*
> > -	 * One credit accounted for writing the
> > -	 * i_data field of the original inode
> > +	 * Two credits accounted for writing the
> > +	 * i_data field of the two inodes
> > 	 */
> > -	retval = ext4_journal_extend(handle, 1);
> > -	if (retval) {
> > +	if (ext4_journal_extend(handle, 2) != 0) {
> > 		retval = ext4_journal_restart(handle, 1);
> > 		if (retval)
> > 			goto err_out;
> > 	}
> > -
> > -	i_data[0] = ei->i_data[EXT4_IND_BLOCK];
> > -	i_data[1] = ei->i_data[EXT4_DIND_BLOCK];
> > -	i_data[2] = ei->i_data[EXT4_TIND_BLOCK];
> > -
> > +	memcpy(i_data, ei->i_data, sizeof(ei->i_data));
> > 	down_write(&EXT4_I(inode)->i_data_sem);
> > 	/*
> > 	 * if EXT4_STATE_EXT_MIGRATE is cleared a block allocation
> > @@ -345,89 +234,31 @@ static int ext4_ext_swap_inode_data(handle_t *handle, struct inode *inode,
> > 		ext4_clear_inode_state(inode, EXT4_STATE_EXT_MIGRATE);
> > 	/*
> > 	 * We have the extent map build with the tmp inode.
> > -	 * Now copy the i_data across
> > +	 * Now swap i_data maps
> > 	 */
> > 	ext4_set_inode_flag(inode, EXT4_INODE_EXTENTS);
> > 	memcpy(ei->i_data, tmp_ei->i_data, sizeof(ei->i_data));
> > -
> > +	ext4_clear_inode_flag(tmp_inode, EXT4_INODE_EXTENTS);
> > +	memcpy(tmp_ei->i_data, i_data, sizeof(ei->i_data));
> > 	/*
> > 	 * Update i_blocks with the new blocks that got
> > 	 * allocated while adding extents for extent index
> > 	 * blocks.
> > 	 *
> > -	 * While converting to extents we need not
> > -	 * update the orignal inode i_blocks for extent blocks
> > -	 * via quota APIs. The quota update happened via tmp_inode already.
> > +	 * While converting to extents new meta_data blocks was accounted for
> > +	 * tmp_inode, swap counter info with original inode.
> > 	 */
> > +	mreq->ind_blocks <<= (inode->i_blkbits - 9);
> > 	spin_lock(&inode->i_lock);
> > -	inode->i_blocks += tmp_inode->i_blocks;
> > +	inode->i_blocks += tmp_inode->i_blocks - mreq->ind_blocks;
> > 	spin_unlock(&inode->i_lock);
> > +	tmp_inode->i_blocks = mreq->ind_blocks;
> > 	up_write(&EXT4_I(inode)->i_data_sem);
> > -
> > -	/*
> > -	 * We mark the inode dirty after, because we decrement the
> > -	 * i_blocks when freeing the indirect meta-data blocks
> > -	 */
> > -	retval = free_ind_block(handle, inode, i_data);
> > 	ext4_mark_inode_dirty(handle, inode);
> > -
> > err_out:
> > 	return retval;
> > }
> > 
> > -static int free_ext_idx(handle_t *handle, struct inode *inode,
> > -					struct ext4_extent_idx *ix)
> > -{
> > -	int i, retval = 0;
> > -	ext4_fsblk_t block;
> > -	struct buffer_head *bh;
> > -	struct ext4_extent_header *eh;
> > -
> > -	block = ext4_idx_pblock(ix);
> > -	bh = sb_bread(inode->i_sb, block);
> > -	if (!bh)
> > -		return -EIO;
> > -
> > -	eh = (struct ext4_extent_header *)bh->b_data;
> > -	if (eh->eh_depth != 0) {
> > -		ix = EXT_FIRST_INDEX(eh);
> > -		for (i = 0; i < le16_to_cpu(eh->eh_entries); i++, ix++) {
> > -			retval = free_ext_idx(handle, inode, ix);
> > -			if (retval)
> > -				break;
> > -		}
> > -	}
> > -	put_bh(bh);
> > -	extend_credit_for_blkdel(handle, inode);
> > -	ext4_free_blocks(handle, inode, NULL, block, 1,
> > -			 EXT4_FREE_BLOCKS_METADATA | EXT4_FREE_BLOCKS_FORGET);
> > -	return retval;
> > -}
> > -
> > -/*
> > - * Free the extent meta data blocks only
> > - */
> > -static int free_ext_block(handle_t *handle, struct inode *inode)
> > -{
> > -	int i, retval = 0;
> > -	struct ext4_inode_info *ei = EXT4_I(inode);
> > -	struct ext4_extent_header *eh = (struct ext4_extent_header *)ei->i_data;
> > -	struct ext4_extent_idx *ix;
> > -	if (eh->eh_depth == 0)
> > -		/*
> > -		 * No extra blocks allocated for extent meta data
> > -		 */
> > -		return 0;
> > -	ix = EXT_FIRST_INDEX(eh);
> > -	for (i = 0; i < le16_to_cpu(eh->eh_entries); i++, ix++) {
> > -		retval = free_ext_idx(handle, inode, ix);
> > -		if (retval)
> > -			return retval;
> > -	}
> > -	return retval;
> > -
> > -}
> > -
> > int ext4_ext_migrate(struct inode *inode)
> > {
> > 	handle_t *handle;
> > @@ -481,7 +312,7 @@ int ext4_ext_migrate(struct inode *inode)
> > 	 * when we drop inode reference.
> > 	 */
> > 	tmp_inode->i_nlink = 0;
> > -
> > +	ext4_set_inode_flag(tmp_inode, EXT4_INODE_MIGRATE);
> > 	ext4_ext_tree_init(handle, tmp_inode);
> > 	ext4_orphan_add(handle, tmp_inode);
> > 	ext4_journal_stop(handle);
> > @@ -557,44 +388,10 @@ int ext4_ext_migrate(struct inode *inode)
> > 	 * Build the last extent
> > 	 */
> > 	retval = finish_range(handle, tmp_inode, &lb);
> > +	if (!retval)
> > +		retval = ext4_ext_swap_inode_data(handle, inode, tmp_inode, &lb);
> > err_out:
> > -	if (retval)
> > -		/*
> > -		 * Failure case delete the extent information with the
> > -		 * tmp_inode
> > -		 */
> > -		free_ext_block(handle, tmp_inode);
> > -	else {
> > -		retval = ext4_ext_swap_inode_data(handle, inode, tmp_inode);
> > -		if (retval)
> > -			/*
> > -			 * if we fail to swap inode data free the extent
> > -			 * details of the tmp inode
> > -			 */
> > -			free_ext_block(handle, tmp_inode);
> > -	}
> > 
> > -	/* We mark the tmp_inode dirty via ext4_ext_tree_init. */
> > -	if (ext4_journal_extend(handle, 1) != 0)
> > -		ext4_journal_restart(handle, 1);
> > -
> > -	/*
> > -	 * Mark the tmp_inode as of size zero
> > -	 */
> > -	i_size_write(tmp_inode, 0);
> > -
> > -	/*
> > -	 * set the  i_blocks count to zero
> > -	 * so that the ext4_delete_inode does the
> > -	 * right job
> > -	 *
> > -	 * We don't need to take the i_lock because
> > -	 * the inode is not visible to user space.
> > -	 */
> > -	tmp_inode->i_blocks = 0;
> > -
> > -	/* Reset the extent details */
> > -	ext4_ext_tree_init(handle, tmp_inode);
> > 	ext4_journal_stop(handle);
> > out:
> > 	unlock_new_inode(tmp_inode);
> > -- 
> > 1.7.2.3
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> Cheers, Andreas
> 
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
