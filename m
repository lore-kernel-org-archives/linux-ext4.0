From: Girish Shilamkar <girish@clusterfs.com>
Subject: Re: [EXT4 set 8][PATCH 1/1]Add journal checksums
Date: Wed, 11 Jul 2007 17:16:39 +0530
Message-ID: <1184154399.3867.44.camel@dhcp4.linsyssoft.com>
References: <1183275505.4010.136.camel@localhost.localdomain>
	 <20070710231601.798304e0.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20070710231601.798304e0.akpm@linux-foundation.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2007-07-10 at 23:16 -0700, Andrew Morton wrote:
> On Sun, 01 Jul 2007 03:38:25 -0400 Mingming Cao <cmm@us.ibm.com> wrote:
> 
> > Journal checksum feature has been added to detect corruption of journal.
> 
> That was brief.  No description of what it does, how it does it, why it
> does it, how one operates it, why (or why not) one would choose to enable
> it nor of the costs of enabling it.
Somehow the description was lost due to the way the original patchset
was sent to ext4 list.

Here is the original description:

The journal checksum feature adds two new flags i.e 
JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT and JBD2_FEATURE_COMPAT_CHECKSUM.

JBD2_FEATURE_CHECKSUM flag indicates that the commit block contains the
checksum for the blocks described by the descriptor blocks.
Due to checksums, writing of the commit record no longer needs to be
synchronous. Now commit record can be sent to disk without waiting for
descriptor blocks to be written to disk. This behavior is controlled
using JBD2_FEATURE_ASYNC_COMMIT flag. Older kernels/e2fsck should not be
able to recover the journal with _ASYNC_COMMIT hence it is made
incompat.
The commit header has been extended to hold the checksum along with the
type of the checksum.

For recovery in pass scan checksums are verified to ensure the sanity
and completeness(in case of _ASYNC_COMMIT) of every transaction.


> 
> > Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
> > Signed-off-by: Girish Shilamkar <girish@clusterfs.com>
> > Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
> > 
> > diff -Nurp linux024/fs/ext4/super.c linux/fs/ext4/super.c
> > --- linux024/fs/ext4/super.c	2007-06-25 16:19:24.000000000 -0500
> > +++ linux/fs/ext4/super.c	2007-06-26 08:35:16.000000000 -0500
> > @@ -721,6 +721,7 @@ enum {
> >  	Opt_user_xattr, Opt_nouser_xattr, Opt_acl, Opt_noacl,
> >  	Opt_reservation, Opt_noreservation, Opt_noload, Opt_nobh, Opt_bh,
> >  	Opt_commit, Opt_journal_update, Opt_journal_inum, Opt_journal_dev,
> > +	Opt_journal_checksum, Opt_journal_async_commit,
> 
> A new user-visible feature should be accompanied by an update to
> Documentation/filesystems/ext4.txt?
Ok.

> >  	Opt_abort, Opt_data_journal, Opt_data_ordered, Opt_data_writeback,
> >  	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
> >  	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_quota, Opt_noquota,
> > @@ -760,6 +761,8 @@ static match_table_t tokens = {
> >  	{Opt_journal_update, "journal=update"},
> >  	{Opt_journal_inum, "journal=%u"},
> >  	{Opt_journal_dev, "journal_dev=%u"},
> > +	{Opt_journal_checksum, "journal_checksum"},
> > +	{Opt_journal_async_commit, "journal_async_commit"},
> 
> What's journal_async_commit?
I hope the description has answered this question.

> >  	{Opt_abort, "abort"},
> >  	{Opt_data_journal, "data=journal"},
> >  	{Opt_data_ordered, "data=ordered"},
> > @@ -948,6 +951,13 @@ static int parse_options (char *options,
> >  				return 0;
> >  			*journal_devnum = option;
> >  			break;
> > +		case Opt_journal_checksum:
> > +			set_opt (sbi->s_mount_opt, JOURNAL_CHECKSUM);
> > +			break;
> > +		case Opt_journal_async_commit:
> > +			set_opt (sbi->s_mount_opt, JOURNAL_ASYNC_COMMIT);
> > +			set_opt (sbi->s_mount_opt, JOURNAL_CHECKSUM);
> > +			break;
> >  		case Opt_noload:
> >  			set_opt (sbi->s_mount_opt, NOLOAD);
> >  			break;
> > @@ -1817,6 +1827,21 @@ static int ext4_fill_super (struct super
> >  		goto failed_mount4;
> >  	}
> >  
> > +	if (test_opt(sb, JOURNAL_ASYNC_COMMIT)) {
> > +		jbd2_journal_set_features(sbi->s_journal,
> > +				JBD2_FEATURE_COMPAT_CHECKSUM, 0,
> > +				JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT);
> > +	} else if (test_opt(sb, JOURNAL_CHECKSUM)) {
> > +		jbd2_journal_set_features(sbi->s_journal,
> > +				JBD2_FEATURE_COMPAT_CHECKSUM, 0, 0);
> > +		jbd2_journal_clear_features(sbi->s_journal, 0, 0,
> > +				JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT);
> > +	} else {
> > +		jbd2_journal_clear_features(sbi->s_journal,
> > +				JBD2_FEATURE_COMPAT_CHECKSUM, 0,
> > +				JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT);
> > +	}
> 
> Some discussion of the forward- and backward- compatibility design would be
> appropriate.  Also a description of whether and how fsck can be used to fix
> up these feature flags.
> >  	/* We have now updated the journal if required, so we can
> >  	 * validate the data journaling mode. */
> >  	switch (test_opt(sb, DATA_FLAGS)) {
> > diff -Nurp linux024/fs/jbd2/commit.c linux/fs/jbd2/commit.c
> > --- linux024/fs/jbd2/commit.c	2007-06-25 16:19:25.000000000 -0500
> > +++ linux/fs/jbd2/commit.c	2007-06-26 08:40:03.000000000 -0500
> > @@ -21,6 +21,7 @@
> >  #include <linux/mm.h>
> >  #include <linux/pagemap.h>
> >  #include <linux/jiffies.h>
> > +#include <linux/crc32.h>
> 
> I think we just broke CONFIG_EXT4=y, CONFIG_CRC32=n builds.
I will change fs/Kconfig to select crc32.

> >  /*
> >   * Default IO end handler for temporary BJ_IO buffer_heads.
> > @@ -93,15 +94,18 @@ static int inverted_lock(journal_t *jour
> >  	return 1;
> >  }
> >  
> > -/* Done it all: now write the commit record.  We should have
> > +/*
> > + * Done it all: now submit the commit record.  We should have
> >   * cleaned up our previous buffers by now, so if we are in abort
> >   * mode we can now just skip the rest of the journal write
> >   * entirely.
> >   *
> >   * Returns 1 if the journal needs to be aborted or 0 on success
> >   */
> > -static int journal_write_commit_record(journal_t *journal,
> > -					transaction_t *commit_transaction)
> > +static int journal_submit_commit_record(journal_t *journal,
> > +					transaction_t *commit_transaction,
> > +					struct buffer_head **cbh,
> > +					__u32 crc32_sum)
> >  {
> >  	struct journal_head *descriptor;
> >  	struct buffer_head *bh;
> > @@ -117,21 +121,36 @@ static int journal_write_commit_record(j
> >  
> >  	bh = jh2bh(descriptor);
> >  
> > -	/* AKPM: buglet - add `i' to tmp! */
> 
> Damn.  After, what, seven years, someone actually fixed it?
> 
> >  	for (i = 0; i < bh->b_size; i += 512) {
> > -		journal_header_t *tmp = (journal_header_t*)bh->b_data;
> > +		struct commit_header *tmp =
> > +			(struct commit_header *)(bh->b_data + i);
> >  		tmp->h_magic = cpu_to_be32(JBD2_MAGIC_NUMBER);
> >  		tmp->h_blocktype = cpu_to_be32(JBD2_COMMIT_BLOCK);
> >  		tmp->h_sequence = cpu_to_be32(commit_transaction->t_tid);
> > +
> > +		if (JBD2_HAS_COMPAT_FEATURE(journal,
> > +					    JBD2_FEATURE_COMPAT_CHECKSUM)) {
> > +			tmp->h_chksum_type 	= JBD2_CRC32_CHKSUM;
> > +			tmp->h_chksum_size 	= JBD2_CRC32_CHKSUM_SIZE;
> > +			tmp->h_chksum[0] 	= cpu_to_be32(crc32_sum);
> > +		}
> >  	}
> 
> And in doing so, changed the on-disk format of the journal commit blocks.
> 
> Surely this was worth a mention in the changelog, if not a standalone patch?
> 
> I don't think this is worth doing, really.  Why not just leave the format
> as it was, take the loop out and run this code once rather than eight
> times?
Andreas, comments ?

> > -	JBUFFER_TRACE(descriptor, "write commit block");
> > +	JBUFFER_TRACE(descriptor, "submit commit block");
> > +	lock_buffer(bh);
> > +
> >  	set_buffer_dirty(bh);
> > -	if (journal->j_flags & JBD2_BARRIER) {
> > +	set_buffer_uptodate(bh);
> > +	bh->b_end_io = journal_end_buffer_io_sync;
> > +
> > +	if (journal->j_flags & JBD2_BARRIER &&
> > +		!JBD2_HAS_COMPAT_FEATURE(journal,
> > +					 JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT)) {
> 
> What's this async_commit stuff?
> 
> >  		set_buffer_ordered(bh);
> >  		barrier_done = 1;
> >  	}
> > -	ret = sync_dirty_buffer(bh);
> > +	ret = submit_bh(WRITE, bh);
> > +
> 
> Hang on.  Now nobody will clear buffer_dirty().
Adding clear_buffer_dirty() before submit_bh would serve the purpose.

> 
> >  	/* is it possible for another commit to fail at roughly
> >  	 * the same time as this one?  If so, we don't want to
> >  	 * trust the barrier flag in the super, but instead want
> > @@ -152,14 +171,72 @@ static int journal_write_commit_record(j
> >  		clear_buffer_ordered(bh);
> >  		set_buffer_uptodate(bh);
> >  		set_buffer_dirty(bh);
> > -		ret = sync_dirty_buffer(bh);
> > +		ret = submit_bh(WRITE, bh);
> 
> Here also.  The buffer remains dirty.
> 
> >  	}
> > -	put_bh(bh);		/* One for getblk() */
> > -	jbd2_journal_put_journal_head(descriptor);
> > +	*cbh = bh;
> > +	return ret;
> > +}
> > +
> > +/*
> > + * This function along with journal_submit_commit_record
> > + * allows to write the commit record asynchronously.
> > + */
> 
> I don't feel able to review this patch without a description of what this
> async commit stuff is supposed to be doing.
> 
> > +static int journal_wait_on_commit_record(struct buffer_head *bh)
> > +{
> > +	int ret = 0;
> >  
> > -	return (ret == -EIO);
> > +	if (buffer_locked(bh))
> > +		wait_on_buffer(bh);
> 
> I don't think the extra buffer_locked() test here is worthwhile.
Agreed.

> > +	if (unlikely(!buffer_uptodate(bh)))
> > +		ret = -EIO;
> > +	put_bh(bh);            /* One for getblk() */
> > +	jbd2_journal_put_journal_head(bh2jh(bh));
> > +
> > +	return ret;
> >  }
> >  
> > +/*
> > + * Wait for all submitted IO to complete.
> > + */
> > +static int journal_wait_on_locked_list(journal_t *journal,
> > +				       transaction_t *commit_transaction)
> > +{
> > +	int ret = 0;
> > +	struct journal_head *jh;
> > +
> > +	while (commit_transaction->t_locked_list) {
> > +		struct buffer_head *bh;
> > +
> > +		jh = commit_transaction->t_locked_list->b_tprev;
> > +		bh = jh2bh(jh);
> > +		get_bh(bh);
> > +		if (buffer_locked(bh)) {
> > +			spin_unlock(&journal->j_list_lock);
> > +			wait_on_buffer(bh);
> > +			if (unlikely(!buffer_uptodate(bh)))
> > +				ret = -EIO;
> > +			spin_lock(&journal->j_list_lock);
> > +		}
> > +		if (!inverted_lock(journal, bh)) {
> > +			put_bh(bh);
> > +			spin_lock(&journal->j_list_lock);
> > +			continue;
> > +		}
> > +		if (buffer_jbd(bh) && jh->b_jlist == BJ_Locked) {
> > +			__jbd2_journal_unfile_buffer(jh);
> > +			jbd_unlock_bh_state(bh);
> > +			jbd2_journal_remove_journal_head(bh);
> > +			put_bh(bh);
> > +		} else {
> > +			jbd_unlock_bh_state(bh);
> > +		}
> > +		put_bh(bh);
> > +		cond_resched_lock(&journal->j_list_lock);
> > +	}
> > +	return ret;
> > +  }
> 
> OK..
> 
> >  static void journal_do_submit_data(struct buffer_head **wbuf, int bufs)
> >  {
> >  	int i;
> > @@ -307,6 +384,8 @@ void jbd2_journal_commit_transaction(jou
> >  	int tag_flag;
> >  	int i;
> >  	int tag_bytes = journal_tag_bytes(journal);
> > +	struct buffer_head *cbh = NULL; /* For transactional checksums */
> > +	__u32 crc32_sum = ~0;
> >  
> >  	/*
> >  	 * First job: lock down the current transaction and wait for
> > @@ -450,38 +529,15 @@ void jbd2_journal_commit_transaction(jou
> >  	journal_submit_data_buffers(journal, commit_transaction);
> >  
> >  	/*
> > -	 * Wait for all previously submitted IO to complete.
> > +	 * Wait for all previously submitted IO to complete if commit
> > +	 * record is to be written synchronously.
> >  	 */
> >  	spin_lock(&journal->j_list_lock);
> > -	while (commit_transaction->t_locked_list) {
> > -		struct buffer_head *bh;
> > +	if (!JBD2_HAS_INCOMPAT_FEATURE(journal,
> > +		JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT))
> > +		err = journal_wait_on_locked_list(journal,
> > +						commit_transaction);
> >  
> > -		jh = commit_transaction->t_locked_list->b_tprev;
> > -		bh = jh2bh(jh);
> > -		get_bh(bh);
> > -		if (buffer_locked(bh)) {
> > -			spin_unlock(&journal->j_list_lock);
> > -			wait_on_buffer(bh);
> > -			if (unlikely(!buffer_uptodate(bh)))
> > -				err = -EIO;
> > -			spin_lock(&journal->j_list_lock);
> > -		}
> > -		if (!inverted_lock(journal, bh)) {
> > -			put_bh(bh);
> > -			spin_lock(&journal->j_list_lock);
> > -			continue;
> > -		}
> > -		if (buffer_jbd(bh) && jh->b_jlist == BJ_Locked) {
> > -			__jbd2_journal_unfile_buffer(jh);
> > -			jbd_unlock_bh_state(bh);
> > -			jbd2_journal_remove_journal_head(bh);
> > -			put_bh(bh);
> > -		} else {
> > -			jbd_unlock_bh_state(bh);
> > -		}
> > -		put_bh(bh);
> > -		cond_resched_lock(&journal->j_list_lock);
> > -	}
> >  	spin_unlock(&journal->j_list_lock);
> >  
> >  	if (err)
> > @@ -654,6 +710,16 @@ void jbd2_journal_commit_transaction(jou
> >  start_journal_io:
> >  			for (i = 0; i < bufs; i++) {
> >  				struct buffer_head *bh = wbuf[i];
> > +				/*
> > +				 * Compute checksum.
> > +				 */
> > +				if (JBD2_HAS_COMPAT_FEATURE(journal,
> > +					JBD2_FEATURE_COMPAT_CHECKSUM)) {
> > +					crc32_sum = crc32_be(crc32_sum,
> > +							(void *)bh->b_data,
> 
> Is the cast here really needed?  Probably..
> > +							bh->b_size);
> > +				}
> > +
> >  				lock_buffer(bh);
> >  				clear_buffer_dirty(bh);
> >  				set_buffer_uptodate(bh);
> > @@ -670,6 +736,23 @@ start_journal_io:
> >  		}
> >  	}
> >  
> > +	/* Done it all: now write the commit record asynchronously. */
> > +
> > +	if (JBD2_HAS_INCOMPAT_FEATURE(journal,
> > +		JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT)) {
> > +		err = journal_submit_commit_record(journal, commit_transaction,
> > +						 &cbh, crc32_sum);
> > +		if (err)
> > +			__jbd2_journal_abort_hard(journal);
> > +
> > +		spin_lock(&journal->j_list_lock);
> > +		err = journal_wait_on_locked_list(journal,
> > +						commit_transaction);
> > +		spin_unlock(&journal->j_list_lock);
> > +		if (err)
> > +			__jbd2_journal_abort_hard(journal);
> > +	}
> > +
> >  	/* Lo and behold: we have just managed to send a transaction to
> >             the log.  Before we can commit it, wait for the IO so far to
> >             complete.  Control buffers being written are on the
> > @@ -769,8 +852,14 @@ wait_for_iobuf:
> >  
> >  	jbd_debug(3, "JBD: commit phase 6\n");
> >  
> > -	if (journal_write_commit_record(journal, commit_transaction))
> > -		err = -EIO;
> > +	if (!JBD2_HAS_INCOMPAT_FEATURE(journal,
> > +		JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT)) {
> > +		err = journal_submit_commit_record(journal, commit_transaction,
> > +						&cbh, crc32_sum);
> > +		if (err)
> > +			__jbd2_journal_abort_hard(journal);
> > +	}
> > +	err = journal_wait_on_commit_record(cbh);
> 
> Are you really sure that we cannot get here with cbh==NULL?
cbh is allocated by jbd2_journal_get_descriptor_buffer which is called by 
journal_submit_commit_record(). If _submit_commit_record fails we _abort_hard.
So I think we are safe.

> How come we can just wander off without doing a put_bh(cbh)?  
put_bh(cbh) has been done in journal_wait_on_commit_record(cbh) 
> Either we're
> playing with a buffer_head against which we don't have a reference (crash)
> or we forgot to undo the ref (leak).
> 
> > +/**
> > + * int jbd2_journal_clear_features () - Clear a given journal feature in the superblock
> 
> We don't usually put the return type in kerneldoc comments like this.  
Well I just copied the already existing comment about
jbd2_journal_set_features and made the appropriate changes.

> Does
> it work and is it desirable?  
We need to clear these features in the journal if the options are
not given, or it will be impossible to mount an ASYNC_COMMIT filesystem on
another kernel.

> kerneldoc picks that up from the C code
> doesn't it?
> 
> > + * @journal: Journal to act on.
> > + * @compat: bitmask of compatible features
> > + * @ro: bitmask of features that force read-only mount
> > + * @incompat: bitmask of incompatible features
> > + *
> > + * Clear a given journal feature as present on the
> > + * superblock.  Returns true if the requested features could be reset.
> > + *
> > + */
> > +int jbd2_journal_clear_features (journal_t *journal, unsigned long compat,
> 
> s/ (/(/
> 
> > +			  unsigned long ro, unsigned long incompat)
> > +{
> > +	journal_superblock_t *sb;
> > +
> > +	jbd_debug(1, "Clear features 0x%lx/0x%lx/0x%lx\n",
> > +		  compat, ro, incompat);
> > +
> > +	sb = journal->j_superblock;
> > +
> > +	sb->s_feature_compat    &= ~cpu_to_be32(compat);
> > +	sb->s_feature_ro_compat &= ~cpu_to_be32(ro);
> > +	sb->s_feature_incompat  &= ~cpu_to_be32(incompat);
> > +
> > +	return 1;
> > +}
> >  
> > ...
> >  
> > +/*
> > + * cal_chksums calculates the checksums for the blocks described in the
> > + * descriptor block.
> > + */
> > +static int cal_chksums(journal_t *journal, struct buffer_head *bh,
> > +		       unsigned long *next_log_block, __u32 *crc32_sum)
> 
> calc_checksums or calculate_checksums would be a nicer and more memorable
> name for this function.
Ok, I will make the change.

> > +{
> > +	int i, num_blks, err;
> > +	unsigned long io_block;
> 
> Shouldn't this be an fs_blk_t or whatever it is?
This io_block is used as an argument for jread(), so even an unsigned int would 
suffice.
Comments.

> > +	struct buffer_head *obh;
> > +
> > +	num_blks = count_tags(journal, bh);
> > +	/* Calculate checksum of the descriptor block. */
> > +	*crc32_sum = crc32_be(*crc32_sum, (void *)bh->b_data, bh->b_size);
> > +
> > +	for (i = 0; i < num_blks; i++) {
> > +		io_block = (*next_log_block)++;
> > +		wrap(journal, *next_log_block);
> > +		err = jread(&obh, journal, io_block);
> > +		if (err) {
> > +			printk(KERN_ERR "JBD: IO error %d recovering block "
> > +				"%ld in log\n", err, io_block);
> > +			return 1;
> > +		} else {
> > +			*crc32_sum = crc32_be(*crc32_sum, (void *)obh->b_data,
> > +				     obh->b_size);
> > +		}
> > +	}
> > +	return 0;
> > +}
> > +
> >  static int do_one_pass(journal_t *journal,
> >  			struct recovery_info *info, enum passtype pass)
> >  {
> > @@ -328,6 +360,7 @@ static int do_one_pass(journal_t *journa
> >  	unsigned int		sequence;
> >  	int			blocktype;
> >  	int			tag_bytes = journal_tag_bytes(journal);
> > +	__u32			crc32_sum = ~0; /* Transactional Checksums */
> 
> We normally use __u32 for visible-to-userspace stuff.  Kernel code would
> use plain old u32.
Ok.

> >  
> >  	/* Precompute the maximum metadata descriptors in a descriptor block */
> >  	int			MAX_BLOCKS_PER_DESC;
> > @@ -419,9 +452,23 @@ static int do_one_pass(journal_t *journa
> >  		switch(blocktype) {
> >  		case JBD2_DESCRIPTOR_BLOCK:
> >  			/* If it is a valid descriptor block, replay it
> > -			 * in pass REPLAY; otherwise, just skip over the
> > -			 * blocks it describes. */
> > +			 * in pass REPLAY; if journal_checksums enabled, then
> > +			 * calculate checksums in PASS_SCAN, otherwise,
> > +			 * just skip over the blocks it describes. */
> >  			if (pass != PASS_REPLAY) {
> > +				if (pass == PASS_SCAN &&
> > +				    JBD2_HAS_COMPAT_FEATURE(journal,
> > +					    JBD2_FEATURE_COMPAT_CHECKSUM) &&
> > +				    !info->end_transaction) {
> > +					if (cal_chksums(journal, bh,
> > +							&next_log_block,
> > +							&crc32_sum)) {
> > +						brelse(bh);
> > +						break;
> > +					}
> > +					brelse(bh);
> > +					continue;
> > +				}
> 
> If a buffer_head* can have a value of NULL then brelse() is appropriate. 
> Usually it cannot, in which case put_bh() is a better thing to use.
The original code has brlese() so I didn't change it.

> >  				next_log_block += count_tags(journal, bh);
> >  				wrap(journal, next_log_block);
> >  				brelse(bh);
> > @@ -516,9 +563,72 @@ static int do_one_pass(journal_t *journa
> >  			continue;
> >  
> >  		case JBD2_COMMIT_BLOCK:
> > -			/* Found an expected commit block: not much to
> > -			 * do other than move on to the next sequence
> > +			/*     How to differentiate between interrupted commit
> > +			 *               and journal corruption ?
> > +			 *
> > +			 * {nth transaction}
> > +			 *        Checksum Verification Failed
> > +			 *			 |
> > +			 *		 ____________________
> > +			 *		|		     |
> > +			 * 	async_commit             sync_commit
> > +			 *     		|                    |
> > +			 *		| GO TO NEXT    "Journal Corruption"
> > +			 *		| TRANSACTION
> > +			 *		|
> > +			 * {(n+1)th transanction}
> > +			 *		|
> > +			 * 	 _______|______________
> > +			 * 	|	 	      |
> > +			 * Commit block found	Commit block not found
> > +			 *      |		      |
> > +			 * "Journal Corruption"       |
> > +			 *		 _____________|_________
> > +			 *     		|	           	|
> > +			 *	nth trans corrupt	OR   nth trans
> > +			 *	and (n+1)th interrupted     interrupted
> > +			 *	before commit block
> > +			 *      could reach the disk.
> > +			 *	(Cannot find the difference in above
> > +			 *	 mentioned conditions. Hence assume
> > +			 *	 "Interrupted Commit".)
> > +			 */
> > +
> > +			/* Found an expected commit block: if checksums
> > +			 * are present verify them in PASS_SCAN; else not
> > +			 * much to do other than move on to the next sequence
> >  			 * number. */
> > +			if (pass == PASS_SCAN &&
> > +			    JBD2_HAS_COMPAT_FEATURE(journal,
> > +				    JBD2_FEATURE_COMPAT_CHECKSUM)) {
> > +				struct commit_header *cbh =
> > +					(struct commit_header *)bh->b_data;
> > +				unsigned found_chksum =
> > +					be32_to_cpu(cbh->h_chksum[0]);
> > +
> > +				if (info->end_transaction) {
> > +					printk(KERN_ERR "JBD: Transaction %u "
> > +						"found to be corrupt.\n",
> > +						next_commit_ID - 1);
> > +					brelse(bh);
> > +					break;
> > +				}
> > +
> > +				if (crc32_sum != found_chksum) {
> > +					info->end_transaction = next_commit_ID;
> > +
> > +					if (!JBD2_HAS_COMPAT_FEATURE(journal,
> > +					   JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT)){
> > +						printk(KERN_ERR
> > +						       "JBD: Transaction %u "
> > +						       "found to be corrupt.\n",
> > +						       next_commit_ID);
> > +						brelse(bh);
> > +						break;
> > +					}
> > +				}
> > +				crc32_sum = ~0;
> > +			}
> >  			brelse(bh);
> >  			next_commit_ID++;
> >  			continue;
> > @@ -554,9 +664,10 @@ static int do_one_pass(journal_t *journa
> >  	 * transaction marks the end of the valid log.
> >  	 */
> >  
> > -	if (pass == PASS_SCAN)
> > -		info->end_transaction = next_commit_ID;
> > -	else {
> > +	if (pass == PASS_SCAN) {
> > +		if (!info->end_transaction)
> > +			info->end_transaction = next_commit_ID;
> > +	} else {
> >
> > ...
> >
> > +/*
> > + * Commit block header for storing transactional checksums:
> > + */
> > +struct commit_header
> > +{
> 
> checkpatch should ask for
> 
> struct commit_header {
> 
> here.
I guess I used an older version of checkpatch.

I will make the changes and send an incremental patch.

Thanks & Regards,
Girish.


