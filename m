From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 1/3] ext4: Support for checksumming from journal triggers
Date: Fri, 17 Apr 2015 13:00:32 -0600
Message-ID: <7BED459B-E911-4651-8290-B2DD6D93069E@dilger.ca>
References: <1429198977-5637-1-git-send-email-jack@suse.cz> <1429198977-5637-2-git-send-email-jack@suse.cz>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:34722 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932162AbbDQTAh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Apr 2015 15:00:37 -0400
Received: by pdbqa5 with SMTP id qa5so136534695pdb.1
        for <linux-ext4@vger.kernel.org>; Fri, 17 Apr 2015 12:00:37 -0700 (PDT)
In-Reply-To: <1429198977-5637-2-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Apr 16, 2015, at 9:42 AM, Jan Kara <jack@suse.cz> wrote:
> 
> JBD2 layer support triggers which are called when journaling layer moves
> buffer to a certain state. We can use the frozen trigger, which gets
> called when buffer data is frozen and about to be written out to the
> journal, to compute block checksums for some buffer types (similarly as
> does ocfs2). This avoids unnecessary repeated recomputation of the
> checksum (at the cost of larger window where memory corruption won't be
> caught by checksumming) and is even necessary when there are
> unsynchronized updaters of the checksummed data.
> 
> So add argument to ext4_journal_get_write_access() and
> ext4_journal_get_create_access() which describes buffer type so that
> triggers can be set accordingly. This patch is mostly only a change of
> prototype of the above mentioned functions and a few small helpers. Real
> checksumming will come later.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
> fs/ext4/ext4.h      | 26 ++++++++++++++++++--
> fs/ext4/ext4_jbd2.c | 50 +++++++++++++++++++++++++------------
> fs/ext4/ext4_jbd2.h | 18 +++++++++-----
> fs/ext4/extents.c   | 10 +++++---
> fs/ext4/file.c      |  3 ++-
> fs/ext4/ialloc.c    | 15 +++++------
> fs/ext4/indirect.c  | 16 ++++++++----
> fs/ext4/inline.c    | 19 ++++++++------
> fs/ext4/inode.c     | 71 +++++++++++++++++++++++++++++++----------------------
> fs/ext4/mballoc.c   | 12 ++++-----
> fs/ext4/namei.c     | 39 +++++++++++++++++------------
> fs/ext4/resize.c    | 32 ++++++++++++++----------
> fs/ext4/super.c     | 16 +++++++++++-
> fs/ext4/xattr.c     | 15 +++++++----
> 14 files changed, 223 insertions(+), 119 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index f63c3d5805c4..abed83485915 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1186,6 +1186,24 @@ struct ext4_super_block {
> /* Number of quota types we support */
> #define EXT4_MAXQUOTAS 2
> 
> +/* Types of ext4 journal triggers */
> +enum ext4_journal_trigger_type {
> +	TR_NONE
> +};

Probably good if this has an EXT4_ prefix to avoid name clashes?

> +
> +#define EXT4_JOURNAL_TRIGGER_COUNT TR_NONE

This should just be added after TR_NONE so that it is always correct:

enum ext4_journal_trigger_type {
	EXT4_JTR_NONE,
	EXT4_JTR_MAX,
};

and the s_journal_triggers[] array would use EXT4_JTR_MAX - 1?

> +struct ext4_journal_trigger {
> +	struct jbd2_buffer_trigger_type tr_triggers;
> +	struct super_block *sb;
> +};
> +
> +static inline struct ext4_journal_trigger *EXT4_TRIGGER(
> +				struct jbd2_buffer_trigger_type *trigger)
> +{
> +	return container_of(trigger, struct ext4_journal_trigger, tr_triggers);
> +}
> +
> /*
>  * fourth extended-fs super-block data in memory
>  */
> @@ -1347,6 +1365,9 @@ struct ext4_sb_info {
> 	struct mb_cache *s_mb_cache;
> 	spinlock_t s_es_lock ____cacheline_aligned_in_smp;
> 
> +	/* Journal triggers for checksum computation */
> +	struct ext4_journal_trigger s_journal_triggers[EXT4_JOURNAL_TRIGGER_COUNT];
> +
> 	/* Ratelimit ext4 messages. */
> 	struct ratelimit_state s_err_ratelimit_state;
> 	struct ratelimit_state s_warning_ratelimit_state;
> @@ -2108,13 +2129,14 @@ int ext4_get_block(struct inode *inode, sector_t iblock,
> int ext4_da_get_block_prep(struct inode *inode, sector_t iblock,
> 			   struct buffer_head *bh, int create);
> int ext4_walk_page_buffers(handle_t *handle,
> +		 	   struct inode *inode,
> 			   struct buffer_head *head,
> 			   unsigned from,
> 			   unsigned to,
> 			   int *partial,
> -			   int (*fn)(handle_t *handle,
> +			   int (*fn)(handle_t *handle, struct inode *inode,
> 				     struct buffer_head *bh));
> -int do_journal_get_write_access(handle_t *handle,
> +int do_journal_get_write_access(handle_t *handle, struct inode *inode,
> 				struct buffer_head *bh);
> #define FALL_BACK_TO_NONDELALLOC 1
> #define CONVERT_INLINE_DATA	 2
> diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
> index 3445035c7e01..f5ac40942f5a 100644
> --- a/fs/ext4/ext4_jbd2.c
> +++ b/fs/ext4/ext4_jbd2.c
> @@ -148,19 +148,28 @@ static void ext4_journal_abort_handle(const char *caller, unsigned int line,
> }
> 
> int __ext4_journal_get_write_access(const char *where, unsigned int line,
> -				    handle_t *handle, struct buffer_head *bh)
> +				    handle_t *handle, struct super_block *sb,
> +				    struct buffer_head *bh,
> +				    enum ext4_journal_trigger_type trigger_type)
> {
> -	int err = 0;
> +	int err;
> 
> 	might_sleep();
> 
> -	if (ext4_handle_valid(handle)) {
> -		err = jbd2_journal_get_write_access(handle, bh);
> -		if (err)
> -			ext4_journal_abort_handle(where, line, __func__, bh,
> -						  handle, err);
> +	if (!ext4_handle_valid(handle))
> +		return 0;
> +
> +	err = jbd2_journal_get_write_access(handle, bh);
> +	if (err) {
> +		ext4_journal_abort_handle(where, line, __func__, bh, handle,
> +					  err);
> +		return err;
> 	}
> -	return err;
> +	if (trigger_type == TR_NONE || !ext4_has_metadata_csum(sb))
> +		return 0;

Should this add a check for trigger_type >= EXT4_JTR_MAX?  WARN_ON?
I was wondering whether checking for trigger_type == TR_NONE could be
replaced by checking tr_triggers == NULL in jbd2_journal_set_triggers(),
but that needs extra locking to access jh to see if it needs to be
reset or not, so it isn't worthwhile.

Cheers, Andreas

> +	jbd2_journal_set_triggers(bh,
> +		&EXT4_SB(sb)->s_journal_triggers[trigger_type].tr_triggers);

> +	return 0;
> }
> 
> /*
> @@ -231,17 +240,26 @@ int __ext4_forget(const char *where, unsigned int line, handle_t *handle,
> }
> 
> int __ext4_journal_get_create_access(const char *where, unsigned int line,
> -				handle_t *handle, struct buffer_head *bh)
> +				handle_t *handle, struct super_block *sb,
> +				struct buffer_head *bh,
> +				enum ext4_journal_trigger_type trigger_type)
> {
> -	int err = 0;
> +	int err;
> 
> -	if (ext4_handle_valid(handle)) {
> -		err = jbd2_journal_get_create_access(handle, bh);
> -		if (err)
> -			ext4_journal_abort_handle(where, line, __func__,
> -						  bh, handle, err);
> +	if (!ext4_handle_valid(handle))
> +		return 0;
> +
> +	err = jbd2_journal_get_create_access(handle, bh);
> +	if (err) {
> +		ext4_journal_abort_handle(where, line, __func__, bh, handle,
> +					  err);
> +		return err;
> 	}
> -	return err;
> +	if (trigger_type == TR_NONE || !ext4_has_metadata_csum(sb))
> +		return 0;

Same.

> +	jbd2_journal_set_triggers(bh,
> +		&EXT4_SB(sb)->s_journal_triggers[trigger_type].tr_triggers);
> +	return 0;
> }
> 
> int __ext4_handle_dirty_metadata(const char *where, unsigned int line,
> diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
> index 9c5b49fb281e..c5ec6de3220e 100644
> --- a/fs/ext4/ext4_jbd2.h
> +++ b/fs/ext4/ext4_jbd2.h
> @@ -232,14 +232,18 @@ int ext4_mark_inode_dirty(handle_t *handle, struct inode *inode);
>  * Wrapper functions with which ext4 calls into JBD.
>  */
> int __ext4_journal_get_write_access(const char *where, unsigned int line,
> -				    handle_t *handle, struct buffer_head *bh);
> +				    handle_t *handle, struct super_block *sb,
> +				    struct buffer_head *bh,
> +				    enum ext4_journal_trigger_type trigger_type);
> 
> int __ext4_forget(const char *where, unsigned int line, handle_t *handle,
> 		  int is_metadata, struct inode *inode,
> 		  struct buffer_head *bh, ext4_fsblk_t blocknr);
> 
> int __ext4_journal_get_create_access(const char *where, unsigned int line,
> -				handle_t *handle, struct buffer_head *bh);
> +				handle_t *handle, struct super_block *sb,
> +				struct buffer_head *bh,
> +				enum ext4_journal_trigger_type trigger_type);
> 
> int __ext4_handle_dirty_metadata(const char *where, unsigned int line,
> 				 handle_t *handle, struct inode *inode,
> @@ -248,13 +252,15 @@ int __ext4_handle_dirty_metadata(const char *where, unsigned int line,
> int __ext4_handle_dirty_super(const char *where, unsigned int line,
> 			      handle_t *handle, struct super_block *sb);
> 
> -#define ext4_journal_get_write_access(handle, bh) \
> -	__ext4_journal_get_write_access(__func__, __LINE__, (handle), (bh))
> +#define ext4_journal_get_write_access(handle, sb, bh, trigger_type) \
> +	__ext4_journal_get_write_access(__func__, __LINE__, (handle), (sb), \
> +					(bh), (trigger_type))
> #define ext4_forget(handle, is_metadata, inode, bh, block_nr) \
> 	__ext4_forget(__func__, __LINE__, (handle), (is_metadata), (inode), \
> 		      (bh), (block_nr))
> -#define ext4_journal_get_create_access(handle, bh) \
> -	__ext4_journal_get_create_access(__func__, __LINE__, (handle), (bh))
> +#define ext4_journal_get_create_access(handle, sb, bh, trigger_type) \
> +	__ext4_journal_get_create_access(__func__, __LINE__, (handle), (sb), \
> +					 (bh), (trigger_type))
> #define ext4_handle_dirty_metadata(handle, inode, bh) \
> 	__ext4_handle_dirty_metadata(__func__, __LINE__, (handle), (inode), \
> 				     (bh))
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index bed43081720f..1c5d29efe585 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -142,7 +142,8 @@ static int ext4_ext_get_access(handle_t *handle, struct inode *inode,
> 	if (path->p_bh) {
> 		/* path points to block */
> 		BUFFER_TRACE(path->p_bh, "get_write_access");
> -		return ext4_journal_get_write_access(handle, path->p_bh);
> +		return ext4_journal_get_write_access(handle, inode->i_sb,
> +						     path->p_bh, TR_NONE);
> 	}
> 	/* path points to leaf/index in inode body */
> 	/* we use in-core data, no need to protect them */
> @@ -1095,7 +1096,7 @@ static int ext4_ext_split(handle_t *handle, struct inode *inode,
> 	}
> 	lock_buffer(bh);
> 
> -	err = ext4_journal_get_create_access(handle, bh);
> +	err = ext4_journal_get_create_access(handle, inode->i_sb, bh, TR_NONE);
> 	if (err)
> 		goto cleanup;
> 
> @@ -1168,7 +1169,8 @@ static int ext4_ext_split(handle_t *handle, struct inode *inode,
> 		}
> 		lock_buffer(bh);
> 
> -		err = ext4_journal_get_create_access(handle, bh);
> +		err = ext4_journal_get_create_access(handle, inode->i_sb, bh,
> +						     TR_NONE);
> 		if (err)
> 			goto cleanup;
> 
> @@ -1287,7 +1289,7 @@ static int ext4_ext_grow_indepth(handle_t *handle, struct inode *inode,
> 		return -ENOMEM;
> 	lock_buffer(bh);
> 
> -	err = ext4_journal_get_create_access(handle, bh);
> +	err = ext4_journal_get_create_access(handle, inode->i_sb, bh, TR_NONE);
> 	if (err) {
> 		unlock_buffer(bh);
> 		goto out;
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 33a09da16c9c..39e9b39f3c1c 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -258,7 +258,8 @@ static int ext4_file_open(struct inode * inode, struct file * filp)
> 			if (IS_ERR(handle))
> 				return PTR_ERR(handle);
> 			BUFFER_TRACE(sbi->s_sbh, "get_write_access");
> -			err = ext4_journal_get_write_access(handle, sbi->s_sbh);
> +			err = ext4_journal_get_write_access(handle, sb,
> +							sbi->s_sbh, TR_NONE);
> 			if (err) {
> 				ext4_journal_stop(handle);
> 				return err;
> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index ac644c31ca67..7a711cf0d183 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -291,7 +291,7 @@ void ext4_free_inode(handle_t *handle, struct inode *inode)
> 		goto error_return;
> 
> 	BUFFER_TRACE(bitmap_bh, "get_write_access");
> -	fatal = ext4_journal_get_write_access(handle, bitmap_bh);
> +	fatal = ext4_journal_get_write_access(handle, sb, bitmap_bh, TR_NONE);
> 	if (fatal)
> 		goto error_return;
> 
> @@ -299,7 +299,7 @@ void ext4_free_inode(handle_t *handle, struct inode *inode)
> 	gdp = ext4_get_group_desc(sb, block_group, &bh2);
> 	if (gdp) {
> 		BUFFER_TRACE(bh2, "get_write_access");
> -		fatal = ext4_journal_get_write_access(handle, bh2);
> +		fatal = ext4_journal_get_write_access(handle, sb, bh2, TR_NONE);
> 	}
> 	ext4_lock_group(sb, block_group);
> 	cleared = ext4_test_and_clear_bit(bit, bitmap_bh->b_data);
> @@ -845,7 +845,8 @@ repeat_in_this_group:
> 			}
> 		}
> 		BUFFER_TRACE(inode_bitmap_bh, "get_write_access");
> -		err = ext4_journal_get_write_access(handle, inode_bitmap_bh);
> +		err = ext4_journal_get_write_access(handle, sb, inode_bitmap_bh,
> +						    TR_NONE);
> 		if (err) {
> 			ext4_std_error(sb, err);
> 			goto out;
> @@ -875,7 +876,7 @@ got:
> 	}
> 
> 	BUFFER_TRACE(group_desc_bh, "get_write_access");
> -	err = ext4_journal_get_write_access(handle, group_desc_bh);
> +	err = ext4_journal_get_write_access(handle, sb, group_desc_bh, TR_NONE);
> 	if (err) {
> 		ext4_std_error(sb, err);
> 		goto out;
> @@ -892,7 +893,8 @@ got:
> 			goto out;
> 		}
> 		BUFFER_TRACE(block_bitmap_bh, "get block bitmap access");
> -		err = ext4_journal_get_write_access(handle, block_bitmap_bh);
> +		err = ext4_journal_get_write_access(handle, sb, block_bitmap_bh,
> +						    TR_NONE);
> 		if (err) {
> 			brelse(block_bitmap_bh);
> 			ext4_std_error(sb, err);
> @@ -1288,8 +1290,7 @@ int ext4_init_inode_table(struct super_block *sb, ext4_group_t group,
> 	num = sbi->s_itb_per_group - used_blks;
> 
> 	BUFFER_TRACE(group_desc_bh, "get_write_access");
> -	ret = ext4_journal_get_write_access(handle,
> -					    group_desc_bh);
> +	ret = ext4_journal_get_write_access(handle, sb, group_desc_bh, TR_NONE);
> 	if (ret)
> 		goto err_out;
> 
> diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
> index 45fe924f82bc..54adceeb09aa 100644
> --- a/fs/ext4/indirect.c
> +++ b/fs/ext4/indirect.c
> @@ -351,7 +351,8 @@ static int ext4_alloc_branch(handle_t *handle,
> 		}
> 		lock_buffer(bh);
> 		BUFFER_TRACE(bh, "call get_create_access");
> -		err = ext4_journal_get_create_access(handle, bh);
> +		err = ext4_journal_get_create_access(handle, ar->inode->i_sb,
> +						     bh, TR_NONE);
> 		if (err) {
> 			unlock_buffer(bh);
> 			goto failed;
> @@ -423,7 +424,8 @@ static int ext4_splice_branch(handle_t *handle,
> 	 */
> 	if (where->bh) {
> 		BUFFER_TRACE(where->bh, "get_write_access");
> -		err = ext4_journal_get_write_access(handle, where->bh);
> +		err = ext4_journal_get_write_access(handle, ar->inode->i_sb,
> +						    where->bh, TR_NONE);
> 		if (err)
> 			goto err_out;
> 	}
> @@ -967,7 +969,8 @@ static int ext4_clear_blocks(handle_t *handle, struct inode *inode,
> 			goto out_err;
> 		if (bh) {
> 			BUFFER_TRACE(bh, "retaking write access");
> -			err = ext4_journal_get_write_access(handle, bh);
> +			err = ext4_journal_get_write_access(handle, inode->i_sb,
> +							    bh, TR_NONE);
> 			if (unlikely(err))
> 				goto out_err;
> 		}
> @@ -1018,7 +1021,8 @@ static void ext4_free_data(handle_t *handle, struct inode *inode,
> 
> 	if (this_bh) {				/* For indirect block */
> 		BUFFER_TRACE(this_bh, "get_write_access");
> -		err = ext4_journal_get_write_access(handle, this_bh);
> +		err = ext4_journal_get_write_access(handle, inode->i_sb,
> +						    this_bh, TR_NONE);
> 		/* Important: if we can't update the indirect pointers
> 		 * to the blocks, we can't free them. */
> 		if (err)
> @@ -1182,7 +1186,9 @@ static void ext4_free_branches(handle_t *handle, struct inode *inode,
> 				 */
> 				BUFFER_TRACE(parent_bh, "get_write_access");
> 				if (!ext4_journal_get_write_access(handle,
> -								   parent_bh)){
> +								   inode->i_sb,
> +								   parent_bh,
> +								   TR_NONE)){
> 					*p = 0;
> 					BUFFER_TRACE(parent_bh,
> 					"call ext4_handle_dirty_metadata");
> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index 4b143febf21f..d4879c2396ce 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
> @@ -259,7 +259,8 @@ static int ext4_create_inline_data(handle_t *handle,
> 		return error;
> 
> 	BUFFER_TRACE(is.iloc.bh, "get_write_access");
> -	error = ext4_journal_get_write_access(handle, is.iloc.bh);
> +	error = ext4_journal_get_write_access(handle, inode->i_sb, is.iloc.bh,
> +					      TR_NONE);
> 	if (error)
> 		goto out;
> 
> @@ -343,7 +344,8 @@ static int ext4_update_inline_data(handle_t *handle, struct inode *inode,
> 		goto out;
> 
> 	BUFFER_TRACE(is.iloc.bh, "get_write_access");
> -	error = ext4_journal_get_write_access(handle, is.iloc.bh);
> +	error = ext4_journal_get_write_access(handle, inode->i_sb, is.iloc.bh,
> +					      TR_NONE);
> 	if (error)
> 		goto out;
> 
> @@ -421,7 +423,8 @@ static int ext4_destroy_inline_data_nolock(handle_t *handle,
> 		goto out;
> 
> 	BUFFER_TRACE(is.iloc.bh, "get_write_access");
> -	error = ext4_journal_get_write_access(handle, is.iloc.bh);
> +	error = ext4_journal_get_write_access(handle, inode->i_sb, is.iloc.bh,
> +					      TR_NONE);
> 	if (error)
> 		goto out;
> 
> @@ -586,7 +589,7 @@ retry:
> 		ret = __block_write_begin(page, from, to, ext4_get_block);
> 
> 	if (!ret && ext4_should_journal_data(inode)) {
> -		ret = ext4_walk_page_buffers(handle, page_buffers(page),
> +		ret = ext4_walk_page_buffers(handle, inode, page_buffers(page),
> 					     from, to, NULL,
> 					     do_journal_get_write_access);
> 	}
> @@ -1011,7 +1014,8 @@ static int ext4_add_dirent_to_inline(handle_t *handle,
> 		return err;
> 
> 	BUFFER_TRACE(iloc->bh, "get_write_access");
> -	err = ext4_journal_get_write_access(handle, iloc->bh);
> +	err = ext4_journal_get_write_access(handle, dir->i_sb, iloc->bh,
> +					    TR_NONE);
> 	if (err)
> 		return err;
> 	ext4_insert_dentry(inode, de, inline_size, name, namelen);
> @@ -1211,7 +1215,8 @@ static int ext4_convert_inline_data_nolock(handle_t *handle,
> 	}
> 
> 	lock_buffer(data_bh);
> -	error = ext4_journal_get_create_access(handle, data_bh);
> +	error = ext4_journal_get_create_access(handle, inode->i_sb, data_bh,
> +					       TR_NONE);
> 	if (error) {
> 		unlock_buffer(data_bh);
> 		error = -EIO;
> @@ -1685,7 +1690,7 @@ int ext4_delete_inline_entry(handle_t *handle,
> 	}
> 
> 	BUFFER_TRACE(bh, "get_write_access");
> -	err = ext4_journal_get_write_access(handle, bh);
> +	err = ext4_journal_get_write_access(handle, dir->i_sb, bh, TR_NONE);
> 	if (err)
> 		goto out;
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 5cb9a212b86f..0813e6a9ca98 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -134,7 +134,6 @@ static inline int ext4_begin_ordered_truncate(struct inode *inode,
> static void ext4_invalidatepage(struct page *page, unsigned int offset,
> 				unsigned int length);
> static int __ext4_journalled_writepage(struct page *page, unsigned int len);
> -static int ext4_bh_delay_or_unwritten(handle_t *handle, struct buffer_head *bh);
> static int ext4_meta_trans_blocks(struct inode *inode, int lblocks,
> 				  int pextents);
> 
> @@ -766,7 +765,8 @@ struct buffer_head *ext4_getblk(handle_t *handle, struct inode *inode,
> 		 */
> 		lock_buffer(bh);
> 		BUFFER_TRACE(bh, "call get_create_access");
> -		err = ext4_journal_get_create_access(handle, bh);
> +		err = ext4_journal_get_create_access(handle, inode->i_sb, bh,
> +						     TR_NONE);
> 		if (unlikely(err)) {
> 			unlock_buffer(bh);
> 			goto errout;
> @@ -806,12 +806,12 @@ struct buffer_head *ext4_bread(handle_t *handle, struct inode *inode,
> 	return ERR_PTR(-EIO);
> }
> 
> -int ext4_walk_page_buffers(handle_t *handle,
> +int ext4_walk_page_buffers(handle_t *handle, struct inode *inode,
> 			   struct buffer_head *head,
> 			   unsigned from,
> 			   unsigned to,
> 			   int *partial,
> -			   int (*fn)(handle_t *handle,
> +			   int (*fn)(handle_t *handle, struct inode *inode,
> 				     struct buffer_head *bh))
> {
> 	struct buffer_head *bh;
> @@ -830,7 +830,7 @@ int ext4_walk_page_buffers(handle_t *handle,
> 				*partial = 1;
> 			continue;
> 		}
> -		err = (*fn)(handle, bh);
> +		err = (*fn)(handle, inode, bh);
> 		if (!ret)
> 			ret = err;
> 	}
> @@ -861,7 +861,7 @@ int ext4_walk_page_buffers(handle_t *handle,
>  * is elevated.  We'll still have enough credits for the tiny quotafile
>  * write.
>  */
> -int do_journal_get_write_access(handle_t *handle,
> +int do_journal_get_write_access(handle_t *handle, struct inode *inode,
> 				struct buffer_head *bh)
> {
> 	int dirty = buffer_dirty(bh);
> @@ -880,7 +880,7 @@ int do_journal_get_write_access(handle_t *handle,
> 	if (dirty)
> 		clear_buffer_dirty(bh);
> 	BUFFER_TRACE(bh, "get write access");
> -	ret = ext4_journal_get_write_access(handle, bh);
> +	ret = ext4_journal_get_write_access(handle, inode->i_sb, bh, TR_NONE);
> 	if (!ret && dirty)
> 		ret = ext4_handle_dirty_metadata(handle, NULL, bh);
> 	return ret;
> @@ -956,8 +956,8 @@ retry_journal:
> 		ret = __block_write_begin(page, pos, len, ext4_get_block);
> 
> 	if (!ret && ext4_should_journal_data(inode)) {
> -		ret = ext4_walk_page_buffers(handle, page_buffers(page),
> -					     from, to, NULL,
> +		ret = ext4_walk_page_buffers(handle, inode,
> +					     page_buffers(page), from, to, NULL,
> 					     do_journal_get_write_access);
> 	}
> 
> @@ -998,7 +998,8 @@ retry_journal:
> }
> 
> /* For write_end() in data=journal mode */
> -static int write_end_fn(handle_t *handle, struct buffer_head *bh)
> +static int write_end_fn(handle_t *handle, struct inode *inode,
> +			struct buffer_head *bh)
> {
> 	int ret;
> 	if (!buffer_mapped(bh) || buffer_freed(bh))
> @@ -1120,8 +1121,8 @@ static int ext4_journalled_write_end(struct file *file,
> 			page_zero_new_buffers(page, from+copied, to);
> 		}
> 
> -		ret = ext4_walk_page_buffers(handle, page_buffers(page), from,
> -					     to, &partial, write_end_fn);
> +		ret = ext4_walk_page_buffers(handle, inode, page_buffers(page),
> +					     from, to, &partial, write_end_fn);
> 		if (!partial)
> 			SetPageUptodate(page);
> 	}
> @@ -1377,7 +1378,8 @@ static void ext4_print_free_blocks(struct inode *inode)
> 	return;
> }
> 
> -static int ext4_bh_delay_or_unwritten(handle_t *handle, struct buffer_head *bh)
> +static int ext4_bh_delay_or_unwritten(handle_t *handle, struct inode *inode,
> +				      struct buffer_head *bh)
> {
> 	return (buffer_delay(bh) || buffer_unwritten(bh)) && buffer_dirty(bh);
> }
> @@ -1565,13 +1567,15 @@ int ext4_da_get_block_prep(struct inode *inode, sector_t iblock,
> 	return 0;
> }
> 
> -static int bget_one(handle_t *handle, struct buffer_head *bh)
> +static int bget_one(handle_t *handle, struct inode *inode,
> +		    struct buffer_head *bh)
> {
> 	get_bh(bh);
> 	return 0;
> }
> 
> -static int bput_one(handle_t *handle, struct buffer_head *bh)
> +static int bput_one(handle_t *handle, struct inode *inode,
> +		    struct buffer_head *bh)
> {
> 	put_bh(bh);
> 	return 0;
> @@ -1602,7 +1606,7 @@ static int __ext4_journalled_writepage(struct page *page,
> 			BUG();
> 			goto out;
> 		}
> -		ext4_walk_page_buffers(handle, page_bufs, 0, len,
> +		ext4_walk_page_buffers(handle, inode, page_bufs, 0, len,
> 				       NULL, bget_one);
> 	}
> 	/* As soon as we unlock the page, it can go away, but we have
> @@ -1620,16 +1624,17 @@ static int __ext4_journalled_writepage(struct page *page,
> 
> 	if (inline_data) {
> 		BUFFER_TRACE(inode_bh, "get write access");
> -		ret = ext4_journal_get_write_access(handle, inode_bh);
> +		ret = ext4_journal_get_write_access(handle, inode->i_sb,
> +						    inode_bh, TR_NONE);
> 
> 		err = ext4_handle_dirty_metadata(handle, inode, inode_bh);
> 
> 	} else {
> -		ret = ext4_walk_page_buffers(handle, page_bufs, 0, len, NULL,
> -					     do_journal_get_write_access);
> +		ret = ext4_walk_page_buffers(handle, inode, page_bufs, 0, len,
> +					     NULL, do_journal_get_write_access);
> 
> -		err = ext4_walk_page_buffers(handle, page_bufs, 0, len, NULL,
> -					     write_end_fn);
> +		err = ext4_walk_page_buffers(handle, inode, page_bufs, 0, len,
> +					     NULL, write_end_fn);
> 	}
> 	if (ret == 0)
> 		ret = err;
> @@ -1639,7 +1644,7 @@ static int __ext4_journalled_writepage(struct page *page,
> 		ret = err;
> 
> 	if (!ext4_has_inline_data(inode))
> -		ext4_walk_page_buffers(NULL, page_bufs, 0, len,
> +		ext4_walk_page_buffers(NULL, inode, page_bufs, 0, len,
> 				       NULL, bput_one);
> 	ext4_set_inode_state(inode, EXT4_STATE_JDATA);
> out:
> @@ -1714,7 +1719,7 @@ static int ext4_writepage(struct page *page,
> 	 * journal_submit_inode_data_buffers() and in that case we must write
> 	 * allocated buffers to achieve data=ordered mode guarantees.
> 	 */
> -	if (ext4_walk_page_buffers(NULL, page_bufs, 0, len, NULL,
> +	if (ext4_walk_page_buffers(NULL, inode, page_bufs, 0, len, NULL,
> 				   ext4_bh_delay_or_unwritten)) {
> 		redirty_page_for_writepage(wbc, page);
> 		if (current->flags & PF_MEMALLOC) {
> @@ -3265,7 +3270,8 @@ static int __ext4_block_zero_page_range(handle_t *handle,
> 	}
> 	if (ext4_should_journal_data(inode)) {
> 		BUFFER_TRACE(bh, "get write access");
> -		err = ext4_journal_get_write_access(handle, bh);
> +		err = ext4_journal_get_write_access(handle, inode->i_sb, bh,
> +						    TR_NONE);
> 		if (err)
> 			goto unlock;
> 	}
> @@ -4362,7 +4368,9 @@ static int ext4_do_update_inode(handle_t *handle,
> 	ext4_clear_inode_state(inode, EXT4_STATE_NEW);
> 	if (set_large_file) {
> 		BUFFER_TRACE(EXT4_SB(sb)->s_sbh, "get write access");
> -		err = ext4_journal_get_write_access(handle, EXT4_SB(sb)->s_sbh);
> +		err = ext4_journal_get_write_access(handle, sb,
> +						    EXT4_SB(sb)->s_sbh,
> +						    TR_NONE);
> 		if (err)
> 			goto out_brelse;
> 		ext4_update_dynamic_rev(sb);
> @@ -4828,7 +4836,8 @@ ext4_reserve_inode_write(handle_t *handle, struct inode *inode,
> 	err = ext4_get_inode_loc(inode, iloc);
> 	if (!err) {
> 		BUFFER_TRACE(iloc->bh, "get_write_access");
> -		err = ext4_journal_get_write_access(handle, iloc->bh);
> +		err = ext4_journal_get_write_access(handle, inode->i_sb,
> +						    iloc->bh, TR_NONE);
> 		if (err) {
> 			brelse(iloc->bh);
> 			iloc->bh = NULL;
> @@ -4981,7 +4990,8 @@ static int ext4_pin_inode(handle_t *handle, struct inode *inode)
> 		err = ext4_get_inode_loc(inode, &iloc);
> 		if (!err) {
> 			BUFFER_TRACE(iloc.bh, "get_write_access");
> -			err = jbd2_journal_get_write_access(handle, iloc.bh);
> +			err = jbd2_journal_get_write_access(inode->i_sb, handle,
> +							    iloc.bh, TR_NONE);
> 			if (!err)
> 				err = ext4_handle_dirty_metadata(handle,
> 								 NULL,
> @@ -5071,7 +5081,8 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
> 	return err;
> }
> 
> -static int ext4_bh_unmapped(handle_t *handle, struct buffer_head *bh)
> +static int ext4_bh_unmapped(handle_t *handle, struct inode *inode,
> +			    struct buffer_head *bh)
> {
> 	return !buffer_mapped(bh);
> }
> @@ -5121,7 +5132,7 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
> 	 * journal_start/journal_stop which can block and take a long time
> 	 */
> 	if (page_has_buffers(page)) {
> -		if (!ext4_walk_page_buffers(NULL, page_buffers(page),
> +		if (!ext4_walk_page_buffers(NULL, inode, page_buffers(page),
> 					    0, len, NULL,
> 					    ext4_bh_unmapped)) {
> 			/* Wait so that we don't change page under IO */
> @@ -5145,7 +5156,7 @@ retry_alloc:
> 	}
> 	ret = __block_page_mkwrite(vma, vmf, get_block);
> 	if (!ret && ext4_should_journal_data(inode)) {
> -		if (ext4_walk_page_buffers(handle, page_buffers(page), 0,
> +		if (ext4_walk_page_buffers(handle, inode, page_buffers(page), 0,
> 			  PAGE_CACHE_SIZE, NULL, do_journal_get_write_access)) {
> 			unlock_page(page);
> 			ret = VM_FAULT_SIGBUS;
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 8d1e60214ef0..dcd05c5f6c48 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -2886,7 +2886,7 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
> 		goto out_err;
> 
> 	BUFFER_TRACE(bitmap_bh, "getting write access");
> -	err = ext4_journal_get_write_access(handle, bitmap_bh);
> +	err = ext4_journal_get_write_access(handle, sb, bitmap_bh, TR_NONE);
> 	if (err)
> 		goto out_err;
> 
> @@ -2899,7 +2899,7 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
> 			ext4_free_group_clusters(sb, gdp));
> 
> 	BUFFER_TRACE(gdp_bh, "get_write_access");
> -	err = ext4_journal_get_write_access(handle, gdp_bh);
> +	err = ext4_journal_get_write_access(handle, sb, gdp_bh, TR_NONE);
> 	if (err)
> 		goto out_err;
> 
> @@ -4769,7 +4769,7 @@ do_more:
> 	}
> 
> 	BUFFER_TRACE(bitmap_bh, "getting write access");
> -	err = ext4_journal_get_write_access(handle, bitmap_bh);
> +	err = ext4_journal_get_write_access(handle, sb, bitmap_bh, TR_NONE);
> 	if (err)
> 		goto error_return;
> 
> @@ -4779,7 +4779,7 @@ do_more:
> 	 * using it
> 	 */
> 	BUFFER_TRACE(gd_bh, "get_write_access");
> -	err = ext4_journal_get_write_access(handle, gd_bh);
> +	err = ext4_journal_get_write_access(handle, sb, gd_bh, TR_NONE);
> 	if (err)
> 		goto error_return;
> #ifdef AGGRESSIVE_CHECK
> @@ -4945,7 +4945,7 @@ int ext4_group_add_blocks(handle_t *handle, struct super_block *sb,
> 	}
> 
> 	BUFFER_TRACE(bitmap_bh, "getting write access");
> -	err = ext4_journal_get_write_access(handle, bitmap_bh);
> +	err = ext4_journal_get_write_access(handle, sb, bitmap_bh, TR_NONE);
> 	if (err)
> 		goto error_return;
> 
> @@ -4955,7 +4955,7 @@ int ext4_group_add_blocks(handle_t *handle, struct super_block *sb,
> 	 * using it
> 	 */
> 	BUFFER_TRACE(gd_bh, "get_write_access");
> -	err = ext4_journal_get_write_access(handle, gd_bh);
> +	err = ext4_journal_get_write_access(handle, sb, gd_bh, TR_NONE);
> 	if (err)
> 		goto error_return;
> 
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 28fe71a2904c..460c716e38b0 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -68,7 +68,7 @@ static struct buffer_head *ext4_append(handle_t *handle,
> 	inode->i_size += inode->i_sb->s_blocksize;
> 	EXT4_I(inode)->i_disksize = inode->i_size;
> 	BUFFER_TRACE(bh, "get_write_access");
> -	err = ext4_journal_get_write_access(handle, bh);
> +	err = ext4_journal_get_write_access(handle, inode->i_sb, bh, TR_NONE);
> 	if (err) {
> 		brelse(bh);
> 		ext4_std_error(inode->i_sb, err);
> @@ -1528,12 +1528,13 @@ static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
> 	}
> 
> 	BUFFER_TRACE(*bh, "get_write_access");
> -	err = ext4_journal_get_write_access(handle, *bh);
> +	err = ext4_journal_get_write_access(handle, dir->i_sb, *bh, TR_NONE);
> 	if (err)
> 		goto journal_error;
> 
> 	BUFFER_TRACE(frame->bh, "get_write_access");
> -	err = ext4_journal_get_write_access(handle, frame->bh);
> +	err = ext4_journal_get_write_access(handle, dir->i_sb, frame->bh,
> +					    TR_NONE);
> 	if (err)
> 		goto journal_error;
> 
> @@ -1694,7 +1695,7 @@ static int add_dirent_to_buf(handle_t *handle, struct dentry *dentry,
> 			return err;
> 	}
> 	BUFFER_TRACE(bh, "get_write_access");
> -	err = ext4_journal_get_write_access(handle, bh);
> +	err = ext4_journal_get_write_access(handle, dir->i_sb, bh, TR_NONE);
> 	if (err) {
> 		ext4_std_error(dir->i_sb, err);
> 		return err;
> @@ -1756,7 +1757,7 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
> 	blocksize =  dir->i_sb->s_blocksize;
> 	dxtrace(printk(KERN_DEBUG "Creating index: inode %lu\n", dir->i_ino));
> 	BUFFER_TRACE(bh, "get_write_access");
> -	retval = ext4_journal_get_write_access(handle, bh);
> +	retval = ext4_journal_get_write_access(handle, dir->i_sb, bh, TR_NONE);
> 	if (retval) {
> 		ext4_std_error(dir->i_sb, retval);
> 		brelse(bh);
> @@ -1965,7 +1966,7 @@ static int ext4_dx_add_entry(handle_t *handle, struct dentry *dentry,
> 	}
> 
> 	BUFFER_TRACE(bh, "get_write_access");
> -	err = ext4_journal_get_write_access(handle, bh);
> +	err = ext4_journal_get_write_access(handle, sb, bh, TR_NONE);
> 	if (err)
> 		goto journal_error;
> 
> @@ -2002,7 +2003,8 @@ static int ext4_dx_add_entry(handle_t *handle, struct dentry *dentry,
> 		node2->fake.rec_len = ext4_rec_len_to_disk(sb->s_blocksize,
> 							   sb->s_blocksize);
> 		BUFFER_TRACE(frame->bh, "get_write_access");
> -		err = ext4_journal_get_write_access(handle, frame->bh);
> +		err = ext4_journal_get_write_access(handle, sb, frame->bh,
> +						    TR_NONE);
> 		if (err)
> 			goto journal_error;
> 		if (levels) {
> @@ -2012,8 +2014,9 @@ static int ext4_dx_add_entry(handle_t *handle, struct dentry *dentry,
> 				       icount1, icount2));
> 
> 			BUFFER_TRACE(frame->bh, "get_write_access"); /* index root */
> -			err = ext4_journal_get_write_access(handle,
> -							     frames[0].bh);
> +			err = ext4_journal_get_write_access(handle, sb,
> +							    frames[0].bh,
> +							    TR_NONE);
> 			if (err)
> 				goto journal_error;
> 
> @@ -2054,8 +2057,9 @@ static int ext4_dx_add_entry(handle_t *handle, struct dentry *dentry,
> 			frame->at = at = at - entries + entries2;
> 			frame->entries = entries = entries2;
> 			frame->bh = bh2;
> -			err = ext4_journal_get_write_access(handle,
> -							     frame->bh);
> +			err = ext4_journal_get_write_access(handle, sb,
> +							    frame->bh,
> +							    TR_NONE);
> 			if (err)
> 				goto journal_error;
> 		}
> @@ -2143,7 +2147,7 @@ static int ext4_delete_entry(handle_t *handle,
> 		csum_size = sizeof(struct ext4_dir_entry_tail);
> 
> 	BUFFER_TRACE(bh, "get_write_access");
> -	err = ext4_journal_get_write_access(handle, bh);
> +	err = ext4_journal_get_write_access(handle, dir->i_sb, bh, TR_NONE);
> 	if (unlikely(err))
> 		goto out;
> 
> @@ -2567,7 +2571,7 @@ int ext4_orphan_add(handle_t *handle, struct inode *inode)
> 		  S_ISLNK(inode->i_mode)) || inode->i_nlink == 0);
> 
> 	BUFFER_TRACE(sbi->s_sbh, "get_write_access");
> -	err = ext4_journal_get_write_access(handle, sbi->s_sbh);
> +	err = ext4_journal_get_write_access(handle, sb, sbi->s_sbh, TR_NONE);
> 	if (err)
> 		goto out;
> 
> @@ -2660,7 +2664,8 @@ int ext4_orphan_del(handle_t *handle, struct inode *inode)
> 	if (prev == &sbi->s_orphan) {
> 		jbd_debug(4, "superblock will point to %u\n", ino_next);
> 		BUFFER_TRACE(sbi->s_sbh, "get_write_access");
> -		err = ext4_journal_get_write_access(handle, sbi->s_sbh);
> +		err = ext4_journal_get_write_access(handle, inode->i_sb,
> +						    sbi->s_sbh, TR_NONE);
> 		if (err) {
> 			mutex_unlock(&sbi->s_orphan_lock);
> 			goto out_brelse;
> @@ -3039,7 +3044,8 @@ static int ext4_rename_dir_prepare(handle_t *handle, struct ext4_renament *ent)
> 	if (le32_to_cpu(ent->parent_de->inode) != ent->dir->i_ino)
> 		return -EIO;
> 	BUFFER_TRACE(ent->dir_bh, "get_write_access");
> -	return ext4_journal_get_write_access(handle, ent->dir_bh);
> +	return ext4_journal_get_write_access(handle, ent->dir->i_sb,
> +					     ent->dir_bh, TR_NONE);
> }
> 
> static int ext4_rename_dir_finish(handle_t *handle, struct ext4_renament *ent,
> @@ -3075,7 +3081,8 @@ static int ext4_setent(handle_t *handle, struct ext4_renament *ent,
> 	int retval;
> 
> 	BUFFER_TRACE(ent->bh, "get write access");
> -	retval = ext4_journal_get_write_access(handle, ent->bh);
> +	retval = ext4_journal_get_write_access(handle, ent->dir->i_sb, ent->bh,
> +					       TR_NONE);
> 	if (retval)
> 		return retval;
> 	ent->de->inode = cpu_to_le32(ino);
> diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
> index 8a8ec6293b19..f14ddaa96aa9 100644
> --- a/fs/ext4/resize.c
> +++ b/fs/ext4/resize.c
> @@ -361,7 +361,7 @@ static struct buffer_head *bclean(handle_t *handle, struct super_block *sb,
> 	if (unlikely(!bh))
> 		return ERR_PTR(-ENOMEM);
> 	BUFFER_TRACE(bh, "get_write_access");
> -	if ((err = ext4_journal_get_write_access(handle, bh))) {
> +	if ((err = ext4_journal_get_write_access(handle, sb, bh, TR_NONE))) {
> 		brelse(bh);
> 		bh = ERR_PTR(err);
> 	} else {
> @@ -440,7 +440,7 @@ static int set_flexbg_block_bitmap(struct super_block *sb, handle_t *handle,
> 			return -ENOMEM;
> 
> 		BUFFER_TRACE(bh, "get_write_access");
> -		err = ext4_journal_get_write_access(handle, bh);
> +		err = ext4_journal_get_write_access(handle, sb, bh, TR_NONE);
> 		if (err)
> 			return err;
> 		ext4_debug("mark block bitmap %#04llx (+%llu/%u)\n", block,
> @@ -533,7 +533,8 @@ static int setup_new_flex_group_blocks(struct super_block *sb,
> 			}
> 
> 			BUFFER_TRACE(gdb, "get_write_access");
> -			err = ext4_journal_get_write_access(handle, gdb);
> +			err = ext4_journal_get_write_access(handle, sb, gdb,
> +							    TR_NONE);
> 			if (err) {
> 				brelse(gdb);
> 				goto out;
> @@ -796,17 +797,18 @@ static int add_new_gdb(handle_t *handle, struct inode *inode,
> 	}
> 
> 	BUFFER_TRACE(EXT4_SB(sb)->s_sbh, "get_write_access");
> -	err = ext4_journal_get_write_access(handle, EXT4_SB(sb)->s_sbh);
> +	err = ext4_journal_get_write_access(handle, sb, EXT4_SB(sb)->s_sbh,
> +					    TR_NONE);
> 	if (unlikely(err))
> 		goto exit_dind;
> 
> 	BUFFER_TRACE(gdb_bh, "get_write_access");
> -	err = ext4_journal_get_write_access(handle, gdb_bh);
> +	err = ext4_journal_get_write_access(handle, sb, gdb_bh, TR_NONE);
> 	if (unlikely(err))
> 		goto exit_dind;
> 
> 	BUFFER_TRACE(dind, "get_write_access");
> -	err = ext4_journal_get_write_access(handle, dind);
> +	err = ext4_journal_get_write_access(handle, sb, dind, TR_NONE);
> 	if (unlikely(err))
> 		ext4_std_error(sb, err);
> 
> @@ -911,7 +913,7 @@ static int add_new_gdb_meta_bg(struct super_block *sb,
> 	EXT4_SB(sb)->s_gdb_count++;
> 	kvfree(o_group_desc);
> 	BUFFER_TRACE(gdb_bh, "get_write_access");
> -	err = ext4_journal_get_write_access(handle, gdb_bh);
> +	err = ext4_journal_get_write_access(handle, sb, gdb_bh, TR_NONE);
> 	if (unlikely(err))
> 		brelse(gdb_bh);
> 	return err;
> @@ -987,7 +989,8 @@ static int reserve_backup_gdb(handle_t *handle, struct inode *inode,
> 
> 	for (i = 0; i < reserved_gdb; i++) {
> 		BUFFER_TRACE(primary[i], "get_write_access");
> -		if ((err = ext4_journal_get_write_access(handle, primary[i])))
> +		if ((err = ext4_journal_get_write_access(handle, sb, primary[i],
> +							 TR_NONE)))
> 			goto exit_bh;
> 	}
> 
> @@ -1095,7 +1098,8 @@ static void update_backups(struct super_block *sb, int blk_off, char *data,
> 			   backup_block, backup_block -
> 			   ext4_group_first_block_no(sb, group));
> 		BUFFER_TRACE(bh, "get_write_access");
> -		if ((err = ext4_journal_get_write_access(handle, bh)))
> +		if ((err = ext4_journal_get_write_access(handle, sb, bh,
> +							 TR_NONE)))
> 			break;
> 		lock_buffer(bh);
> 		memcpy(bh->b_data, data, size);
> @@ -1175,7 +1179,8 @@ static int ext4_add_new_descs(handle_t *handle, struct super_block *sb,
> 		if (gdb_off) {
> 			gdb_bh = sbi->s_group_desc[gdb_num];
> 			BUFFER_TRACE(gdb_bh, "get_write_access");
> -			err = ext4_journal_get_write_access(handle, gdb_bh);
> +			err = ext4_journal_get_write_access(handle, sb, gdb_bh,
> +							    TR_NONE);
> 
> 			if (!err && reserved_gdb && ext4_bg_num_gdb(sb, group))
> 				err = reserve_backup_gdb(handle, resize_inode, group);
> @@ -1445,7 +1450,7 @@ static int ext4_flex_group_add(struct super_block *sb,
> 	}
> 
> 	BUFFER_TRACE(sbi->s_sbh, "get_write_access");
> -	err = ext4_journal_get_write_access(handle, sbi->s_sbh);
> +	err = ext4_journal_get_write_access(handle, sb, sbi->s_sbh, TR_NONE);
> 	if (err)
> 		goto exit_journal;
> 
> @@ -1658,7 +1663,8 @@ static int ext4_group_extend_no_check(struct super_block *sb,
> 	}
> 
> 	BUFFER_TRACE(EXT4_SB(sb)->s_sbh, "get_write_access");
> -	err = ext4_journal_get_write_access(handle, EXT4_SB(sb)->s_sbh);
> +	err = ext4_journal_get_write_access(handle, sb, EXT4_SB(sb)->s_sbh,
> +					    TR_NONE);
> 	if (err) {
> 		ext4_warning(sb, "error %d on journal write access", err);
> 		goto errout;
> @@ -1818,7 +1824,7 @@ static int ext4_convert_meta_bg(struct super_block *sb, struct inode *inode)
> 		return PTR_ERR(handle);
> 
> 	BUFFER_TRACE(sbi->s_sbh, "get_write_access");
> -	err = ext4_journal_get_write_access(handle, sbi->s_sbh);
> +	err = ext4_journal_get_write_access(handle, sb, sbi->s_sbh, TR_NONE);
> 	if (err)
> 		goto errout;
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index e061e66c8280..0babe8c435b6 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3406,6 +3406,20 @@ static int ext4_reserve_clusters(struct ext4_sb_info *sbi, ext4_fsblk_t count)
> 	return 0;
> }
> 
> +static void ext4_setup_csum_trigger(struct super_block *sb,
> +				    enum ext4_journal_trigger_type type,
> +				    void (*trigger)(
> +					struct jbd2_buffer_trigger_type *type,
> +					struct buffer_head *bh,
> +					void *mapped_data,
> +					size_t size))
> +{
> +	struct ext4_sb_info *sbi = EXT4_SB(sb);
> +
> +	sbi->s_journal_triggers[type].sb = sb;
> +	sbi->s_journal_triggers[type].tr_triggers.t_frozen = trigger;
> +}
> +
> static int ext4_fill_super(struct super_block *sb, void *data, int silent)
> {
> 	char *orig_data = kstrdup(data, GFP_KERNEL);
> @@ -5416,7 +5430,7 @@ static ssize_t ext4_quota_write(struct super_block *sb, int type,
> 	if (!bh)
> 		goto out;
> 	BUFFER_TRACE(bh, "get write access");
> -	err = ext4_journal_get_write_access(handle, bh);
> +	err = ext4_journal_get_write_access(handle, sb, bh, TR_NONE);
> 	if (err) {
> 		brelse(bh);
> 		return err;
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 1e09fc77395c..a0a285844037 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -530,7 +530,8 @@ static void ext4_xattr_update_super_block(handle_t *handle,
> 		return;
> 
> 	BUFFER_TRACE(EXT4_SB(sb)->s_sbh, "get_write_access");
> -	if (ext4_journal_get_write_access(handle, EXT4_SB(sb)->s_sbh) == 0) {
> +	if (ext4_journal_get_write_access(handle, sb, EXT4_SB(sb)->s_sbh,
> +					  TR_NONE) == 0) {
> 		EXT4_SET_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_EXT_ATTR);
> 		ext4_handle_dirty_super(handle, sb);
> 	}
> @@ -550,7 +551,7 @@ ext4_xattr_release_block(handle_t *handle, struct inode *inode,
> 
> 	ce = mb_cache_entry_get(ext4_mb_cache, bh->b_bdev, bh->b_blocknr);
> 	BUFFER_TRACE(bh, "get_write_access");
> -	error = ext4_journal_get_write_access(handle, bh);
> +	error = ext4_journal_get_write_access(handle, inode->i_sb, bh, TR_NONE);
> 	if (error)
> 		goto out;
> 
> @@ -793,7 +794,8 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
> 		ce = mb_cache_entry_get(ext4_mb_cache, bs->bh->b_bdev,
> 					bs->bh->b_blocknr);
> 		BUFFER_TRACE(bs->bh, "get_write_access");
> -		error = ext4_journal_get_write_access(handle, bs->bh);
> +		error = ext4_journal_get_write_access(handle, sb, bs->bh,
> +						      TR_NONE);
> 		if (error)
> 			goto cleanup;
> 		lock_buffer(bs->bh);
> @@ -880,7 +882,9 @@ inserted:
> 					goto cleanup;
> 				BUFFER_TRACE(new_bh, "get_write_access");
> 				error = ext4_journal_get_write_access(handle,
> -								      new_bh);
> +								      sb,
> +								      new_bh,
> +								      TR_NONE);
> 				if (error)
> 					goto cleanup_dquot;
> 				lock_buffer(new_bh);
> @@ -932,7 +936,8 @@ getblk_failed:
> 				goto cleanup;
> 			}
> 			lock_buffer(new_bh);
> -			error = ext4_journal_get_create_access(handle, new_bh);
> +			error = ext4_journal_get_create_access(handle, sb,
> +							new_bh, TR_NONE);
> 			if (error) {
> 				unlock_buffer(new_bh);
> 				error = -EIO;
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





