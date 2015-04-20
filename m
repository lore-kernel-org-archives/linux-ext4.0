From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/3] ext4: Support for checksumming from journal triggers
Date: Mon, 20 Apr 2015 11:07:20 +0200
Message-ID: <20150420090720.GB3117@quack.suse.cz>
References: <1429198977-5637-1-git-send-email-jack@suse.cz>
 <1429198977-5637-2-git-send-email-jack@suse.cz>
 <7BED459B-E911-4651-8290-B2DD6D93069E@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39649 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754026AbbDTJH0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Apr 2015 05:07:26 -0400
Content-Disposition: inline
In-Reply-To: <7BED459B-E911-4651-8290-B2DD6D93069E@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 17-04-15 13:00:32, Andreas Dilger wrote:
> On Apr 16, 2015, at 9:42 AM, Jan Kara <jack@suse.cz> wrote:
> > 
> > JBD2 layer support triggers which are called when journaling layer moves
> > buffer to a certain state. We can use the frozen trigger, which gets
> > called when buffer data is frozen and about to be written out to the
> > journal, to compute block checksums for some buffer types (similarly as
> > does ocfs2). This avoids unnecessary repeated recomputation of the
> > checksum (at the cost of larger window where memory corruption won't be
> > caught by checksumming) and is even necessary when there are
> > unsynchronized updaters of the checksummed data.
> > 
> > So add argument to ext4_journal_get_write_access() and
> > ext4_journal_get_create_access() which describes buffer type so that
> > triggers can be set accordingly. This patch is mostly only a change of
> > prototype of the above mentioned functions and a few small helpers. Real
> > checksumming will come later.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> > fs/ext4/ext4.h      | 26 ++++++++++++++++++--
> > fs/ext4/ext4_jbd2.c | 50 +++++++++++++++++++++++++------------
> > fs/ext4/ext4_jbd2.h | 18 +++++++++-----
> > fs/ext4/extents.c   | 10 +++++---
> > fs/ext4/file.c      |  3 ++-
> > fs/ext4/ialloc.c    | 15 +++++------
> > fs/ext4/indirect.c  | 16 ++++++++----
> > fs/ext4/inline.c    | 19 ++++++++------
> > fs/ext4/inode.c     | 71 +++++++++++++++++++++++++++++++----------------------
> > fs/ext4/mballoc.c   | 12 ++++-----
> > fs/ext4/namei.c     | 39 +++++++++++++++++------------
> > fs/ext4/resize.c    | 32 ++++++++++++++----------
> > fs/ext4/super.c     | 16 +++++++++++-
> > fs/ext4/xattr.c     | 15 +++++++----
> > 14 files changed, 223 insertions(+), 119 deletions(-)
> > 
> > diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> > index f63c3d5805c4..abed83485915 100644
> > --- a/fs/ext4/ext4.h
> > +++ b/fs/ext4/ext4.h
> > @@ -1186,6 +1186,24 @@ struct ext4_super_block {
> > /* Number of quota types we support */
> > #define EXT4_MAXQUOTAS 2
> > 
> > +/* Types of ext4 journal triggers */
> > +enum ext4_journal_trigger_type {
> > +	TR_NONE
> > +};
> 
> Probably good if this has an EXT4_ prefix to avoid name clashes?
  OK.

> > +
> > +#define EXT4_JOURNAL_TRIGGER_COUNT TR_NONE
> 
> This should just be added after TR_NONE so that it is always correct:
> 
> enum ext4_journal_trigger_type {
> 	EXT4_JTR_NONE,
> 	EXT4_JTR_MAX,
> };
  So my idea was that EXT4_JTR_NONE would always be the last one (it has to
be so that indexing properly works - but that deserves a comment I agree) and
thus EXT4_JOURNAL_TRIGGER_COUNT is always correct.

> and the s_journal_triggers[] array would use EXT4_JTR_MAX - 1?
> 
> > +struct ext4_journal_trigger {
> > +	struct jbd2_buffer_trigger_type tr_triggers;
> > +	struct super_block *sb;
> > +};
> > +
> > +static inline struct ext4_journal_trigger *EXT4_TRIGGER(
> > +				struct jbd2_buffer_trigger_type *trigger)
> > +{
> > +	return container_of(trigger, struct ext4_journal_trigger, tr_triggers);
> > +}
> > +
> > /*
> >  * fourth extended-fs super-block data in memory
> >  */
> > @@ -1347,6 +1365,9 @@ struct ext4_sb_info {
> > 	struct mb_cache *s_mb_cache;
> > 	spinlock_t s_es_lock ____cacheline_aligned_in_smp;
> > 
> > +	/* Journal triggers for checksum computation */
> > +	struct ext4_journal_trigger s_journal_triggers[EXT4_JOURNAL_TRIGGER_COUNT];
> > +
> > 	/* Ratelimit ext4 messages. */
> > 	struct ratelimit_state s_err_ratelimit_state;
> > 	struct ratelimit_state s_warning_ratelimit_state;
> > @@ -2108,13 +2129,14 @@ int ext4_get_block(struct inode *inode, sector_t iblock,
> > int ext4_da_get_block_prep(struct inode *inode, sector_t iblock,
> > 			   struct buffer_head *bh, int create);
> > int ext4_walk_page_buffers(handle_t *handle,
> > +		 	   struct inode *inode,
> > 			   struct buffer_head *head,
> > 			   unsigned from,
> > 			   unsigned to,
> > 			   int *partial,
> > -			   int (*fn)(handle_t *handle,
> > +			   int (*fn)(handle_t *handle, struct inode *inode,
> > 				     struct buffer_head *bh));
> > -int do_journal_get_write_access(handle_t *handle,
> > +int do_journal_get_write_access(handle_t *handle, struct inode *inode,
> > 				struct buffer_head *bh);
> > #define FALL_BACK_TO_NONDELALLOC 1
> > #define CONVERT_INLINE_DATA	 2
> > diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
> > index 3445035c7e01..f5ac40942f5a 100644
> > --- a/fs/ext4/ext4_jbd2.c
> > +++ b/fs/ext4/ext4_jbd2.c
> > @@ -148,19 +148,28 @@ static void ext4_journal_abort_handle(const char *caller, unsigned int line,
> > }
> > 
> > int __ext4_journal_get_write_access(const char *where, unsigned int line,
> > -				    handle_t *handle, struct buffer_head *bh)
> > +				    handle_t *handle, struct super_block *sb,
> > +				    struct buffer_head *bh,
> > +				    enum ext4_journal_trigger_type trigger_type)
> > {
> > -	int err = 0;
> > +	int err;
> > 
> > 	might_sleep();
> > 
> > -	if (ext4_handle_valid(handle)) {
> > -		err = jbd2_journal_get_write_access(handle, bh);
> > -		if (err)
> > -			ext4_journal_abort_handle(where, line, __func__, bh,
> > -						  handle, err);
> > +	if (!ext4_handle_valid(handle))
> > +		return 0;
> > +
> > +	err = jbd2_journal_get_write_access(handle, bh);
> > +	if (err) {
> > +		ext4_journal_abort_handle(where, line, __func__, bh, handle,
> > +					  err);
> > +		return err;
> > 	}
> > -	return err;
> > +	if (trigger_type == TR_NONE || !ext4_has_metadata_csum(sb))
> > +		return 0;
> 
> Should this add a check for trigger_type >= EXT4_JTR_MAX?  WARN_ON?
  OK, I'll add that. Thanks for review.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
