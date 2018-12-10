Return-Path: <SRS0=P4kf=OT=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39962 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727561AbeLJOMb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 10 Dec 2018 09:12:31 -0500
Date: Mon, 10 Dec 2018 15:12:26 +0100
From: Jan Kara <jack@suse.cz>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.com,
        viro@zeniv.linux.org.uk, darrick.wong@oracle.com, axboe@kernel.dk,
        jrdr.linux@gmail.com, ebiggers@google.com,
        jooyoung.hwang@samsung.com, chur.lee@samsung.com,
        prakash.v@samsung.com
Subject: Re: [PATCH 2/2] fs/ext4,jbd2: Add support for passing write-hint
 with journal.
Message-ID: <20181210141226.GM29289@quack2.suse.cz>
References: <1544446204-5291-1-git-send-email-joshi.k@samsung.com>
 <CGME20181210125256epcas1p1e4142cfefb9b21dfb8dad927fbd49143@epcas1p1.samsung.com>
 <1544446204-5291-3-git-send-email-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1544446204-5291-3-git-send-email-joshi.k@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 10-12-18 18:20:04, Kanchan Joshi wrote:
> This patch introduces "j_writehint" in JBD2 journal,
> which is set based by Ext4 depending on "journal_writehint"
> mount option (inspired from "journal_ioprio").

Thanks for the patch! It would be good to provide the explanation you have
in the cover letter in this patch as well so that it gets recorded in git
logs.

Also I don't like the fact that users have to set the hint via a mount
option for this to be enabled. OTOH the WRITE_FILE_<foo> hints defined in
fs.h are generally supposed to be used by userspace so it's difficult to
pick anything if we don't know what the userspace is going to do. I'd argue
it's even difficult for the sysadmin to pick any good value even if he
actually knows that he might benefit from setting some. Jens, is there
some reasonable way for fs to automatically pick some stream value for its
journal?

								Honza

> 
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> ---
>  fs/ext4/super.c      | 33 +++++++++++++++++++++++++++------
>  fs/jbd2/commit.c     | 11 +++++++----
>  fs/jbd2/journal.c    |  2 +-
>  fs/jbd2/revoke.c     |  2 +-
>  include/linux/jbd2.h |  7 +++++++
>  5 files changed, 43 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 53ff6c2..0283760 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1413,7 +1413,7 @@ enum {
>  	Opt_nowarn_on_error, Opt_mblk_io_submit,
>  	Opt_lazytime, Opt_nolazytime, Opt_debug_want_extra_isize,
>  	Opt_nomblk_io_submit, Opt_block_validity, Opt_noblock_validity,
> -	Opt_inode_readahead_blks, Opt_journal_ioprio,
> +	Opt_inode_readahead_blks, Opt_journal_ioprio, Opt_journal_writehint,
>  	Opt_dioread_nolock, Opt_dioread_lock,
>  	Opt_discard, Opt_nodiscard, Opt_init_itable, Opt_noinit_itable,
>  	Opt_max_dir_size_kb, Opt_nojournal_checksum, Opt_nombcache,
> @@ -1489,6 +1489,7 @@ static const match_table_t tokens = {
>  	{Opt_noblock_validity, "noblock_validity"},
>  	{Opt_inode_readahead_blks, "inode_readahead_blks=%u"},
>  	{Opt_journal_ioprio, "journal_ioprio=%u"},
> +	{Opt_journal_writehint, "journal_writehint=%u"},
>  	{Opt_auto_da_alloc, "auto_da_alloc=%u"},
>  	{Opt_auto_da_alloc, "auto_da_alloc"},
>  	{Opt_noauto_da_alloc, "noauto_da_alloc"},
> @@ -1677,6 +1678,7 @@ static const struct mount_opts {
>  	{Opt_journal_dev, 0, MOPT_NO_EXT2 | MOPT_GTE0},
>  	{Opt_journal_path, 0, MOPT_NO_EXT2 | MOPT_STRING},
>  	{Opt_journal_ioprio, 0, MOPT_NO_EXT2 | MOPT_GTE0},
> +	{Opt_journal_writehint, 0, MOPT_NO_EXT2 | MOPT_GTE0},
>  	{Opt_data_journal, EXT4_MOUNT_JOURNAL_DATA, MOPT_NO_EXT2 | MOPT_DATAJ},
>  	{Opt_data_ordered, EXT4_MOUNT_ORDERED_DATA, MOPT_NO_EXT2 | MOPT_DATAJ},
>  	{Opt_data_writeback, EXT4_MOUNT_WRITEBACK_DATA,
> @@ -1718,7 +1720,8 @@ static const struct mount_opts {
>  
>  static int handle_mount_opt(struct super_block *sb, char *opt, int token,
>  			    substring_t *args, unsigned long *journal_devnum,
> -			    unsigned int *journal_ioprio, int is_remount)
> +			    unsigned int *journal_ioprio,
> +			    enum rw_hint *journal_writehint, int is_remount)
>  {
>  	struct ext4_sb_info *sbi = EXT4_SB(sb);
>  	const struct mount_opts *m;
> @@ -1897,6 +1900,13 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
>  		}
>  		*journal_ioprio =
>  			IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE, arg);
> +	} else if (token == Opt_journal_writehint) {
> +		if (arg < WRITE_LIFE_NOT_SET || arg > WRITE_LIFE_EXTREME) {
> +			ext4_msg(sb, KERN_ERR, "Invalid journal write hint"
> +				 " (must be 0-5)");
> +			return -1;
> +		}
> +		*journal_writehint = arg;
>  	} else if (token == Opt_test_dummy_encryption) {
>  #ifdef CONFIG_EXT4_FS_ENCRYPTION
>  		sbi->s_mount_flags |= EXT4_MF_TEST_DUMMY_ENCRYPTION;
> @@ -1970,6 +1980,7 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
>  static int parse_options(char *options, struct super_block *sb,
>  			 unsigned long *journal_devnum,
>  			 unsigned int *journal_ioprio,
> +			 enum rw_hint *journal_writehint,
>  			 int is_remount)
>  {
>  	struct ext4_sb_info *sbi = EXT4_SB(sb);
> @@ -1990,7 +2001,8 @@ static int parse_options(char *options, struct super_block *sb,
>  		args[0].to = args[0].from = NULL;
>  		token = match_token(p, tokens, args);
>  		if (handle_mount_opt(sb, p, token, args, journal_devnum,
> -				     journal_ioprio, is_remount) < 0)
> +				     journal_ioprio, journal_writehint,
> +				     is_remount) < 0)
>  			return 0;
>  	}
>  #ifdef CONFIG_QUOTA
> @@ -3534,6 +3546,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  	int err = 0;
>  	unsigned int journal_ioprio = DEFAULT_JOURNAL_IOPRIO;
>  	ext4_group_t first_not_zeroed;
> +	enum rw_hint journal_writehint = WRITE_LIFE_NOT_SET;
>  
>  	if ((data && !orig_data) || !sbi)
>  		goto out_free_base;
> @@ -3694,7 +3707,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  		if (!s_mount_opts)
>  			goto failed_mount;
>  		if (!parse_options(s_mount_opts, sb, &journal_devnum,
> -				   &journal_ioprio, 0)) {
> +				   &journal_ioprio, &journal_writehint, 0)) {
>  			ext4_msg(sb, KERN_WARNING,
>  				 "failed to parse options in superblock: %s",
>  				 s_mount_opts);
> @@ -3703,7 +3716,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  	}
>  	sbi->s_def_mount_opt = sbi->s_mount_opt;
>  	if (!parse_options((char *) data, sb, &journal_devnum,
> -			   &journal_ioprio, 0))
> +			   &journal_ioprio, &journal_writehint, 0))
>  		goto failed_mount;
>  
>  	if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA) {
> @@ -4265,6 +4278,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  
>  	set_task_ioprio(sbi->s_journal->j_task, journal_ioprio);
>  
> +	sbi->s_journal->j_writehint = journal_writehint;
> +
>  	sbi->s_journal->j_commit_callback = ext4_journal_commit_callback;
>  
>  no_journal:
> @@ -5120,6 +5135,7 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
>  	int enable_quota = 0;
>  	ext4_group_t g;
>  	unsigned int journal_ioprio = DEFAULT_JOURNAL_IOPRIO;
> +	enum rw_hint journal_writehint = WRITE_LIFE_NOT_SET;
>  	int err = 0;
>  #ifdef CONFIG_QUOTA
>  	int i, j;
> @@ -5158,7 +5174,11 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
>  	if (sbi->s_journal && sbi->s_journal->j_task->io_context)
>  		journal_ioprio = sbi->s_journal->j_task->io_context->ioprio;
>  
> -	if (!parse_options(data, sb, NULL, &journal_ioprio, 1)) {
> +	if (sbi->s_journal)
> +		journal_writehint = sbi->s_journal->j_writehint;
> +
> +	if (!parse_options(data, sb, NULL, &journal_ioprio,
> +			   &journal_writehint, 1)) {
>  		err = -EINVAL;
>  		goto restore_opts;
>  	}
> @@ -5221,6 +5241,7 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
>  	if (sbi->s_journal) {
>  		ext4_init_journal_params(sb, sbi->s_journal);
>  		set_task_ioprio(sbi->s_journal->j_task, journal_ioprio);
> +		sbi->s_journal->j_writehint = journal_writehint;
>  	}
>  
>  	if (*flags & SB_LAZYTIME)
> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> index 150cc03..8710afe 100644
> --- a/fs/jbd2/commit.c
> +++ b/fs/jbd2/commit.c
> @@ -153,10 +153,12 @@ static int journal_submit_commit_record(journal_t *journal,
>  
>  	if (journal->j_flags & JBD2_BARRIER &&
>  	    !jbd2_has_feature_async_commit(journal))
> -		ret = submit_bh(REQ_OP_WRITE,
> -			REQ_SYNC | REQ_PREFLUSH | REQ_FUA, bh);
> +		ret = submit_bh_write_hint(REQ_OP_WRITE,
> +			REQ_SYNC | REQ_PREFLUSH | REQ_FUA, bh,
> +			journal->j_writehint);
>  	else
> -		ret = submit_bh(REQ_OP_WRITE, REQ_SYNC, bh);
> +		ret = submit_bh_write_hint(REQ_OP_WRITE, REQ_SYNC, bh,
> +					journal->j_writehint);
>  
>  	*cbh = bh;
>  	return ret;
> @@ -708,7 +710,8 @@ void jbd2_journal_commit_transaction(journal_t *journal)
>  				clear_buffer_dirty(bh);
>  				set_buffer_uptodate(bh);
>  				bh->b_end_io = journal_end_buffer_io_sync;
> -				submit_bh(REQ_OP_WRITE, REQ_SYNC, bh);
> +				submit_bh_write_hint(REQ_OP_WRITE, REQ_SYNC, bh,
> +						   journal->j_writehint);
>  			}
>  			cond_resched();
>  			stats.run.rs_blocks_logged += bufs;
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 8ef6b6d..f72ee4b 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -1384,7 +1384,7 @@ static int jbd2_write_superblock(journal_t *journal, int write_flags)
>  	jbd2_superblock_csum_set(journal, sb);
>  	get_bh(bh);
>  	bh->b_end_io = end_buffer_write_sync;
> -	ret = submit_bh(REQ_OP_WRITE, write_flags, bh);
> +	ret = submit_bh_write_hint(REQ_OP_WRITE, write_flags, bh, journal->j_writehint);
>  	wait_on_buffer(bh);
>  	if (buffer_write_io_error(bh)) {
>  		clear_buffer_write_io_error(bh);
> diff --git a/fs/jbd2/revoke.c b/fs/jbd2/revoke.c
> index a1143e5..d4fd178 100644
> --- a/fs/jbd2/revoke.c
> +++ b/fs/jbd2/revoke.c
> @@ -642,7 +642,7 @@ static void flush_descriptor(journal_t *journal,
>  	set_buffer_jwrite(descriptor);
>  	BUFFER_TRACE(descriptor, "write");
>  	set_buffer_dirty(descriptor);
> -	write_dirty_buffer(descriptor, REQ_SYNC);
> +	write_dirty_buffer_write_hint(descriptor, REQ_SYNC, journal->j_writehint);
>  }
>  #endif
>  
> diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
> index b708e51..0735ab0 100644
> --- a/include/linux/jbd2.h
> +++ b/include/linux/jbd2.h
> @@ -1138,6 +1138,13 @@ struct journal_s
>  	 */
>  	__u32 j_csum_seed;
>  
> +	/**
> +	 * @j_writehint:
> +	 *
> +	 * write hint for journal (set by fs).
> +	 */
> +	enum rw_hint j_writehint;
> +
>  #ifdef CONFIG_DEBUG_LOCK_ALLOC
>  	/**
>  	 * @j_trans_commit_map:
> -- 
> 2.7.4
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
