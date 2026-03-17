Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECCFD20DD52;
	Tue, 17 Mar 2026 16:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773764494; cv=none; b=DEzdFzAFXUneNBdNGr9UHlK6bWzDVHsrmFDIpNQiucomvDR0OIYGp2gLGMudH6PGnSOiSHzzwOjqNw9GxHH397LWfu+6oo+nAhb4mayg/Jam3UeR5BmQfgAwFLHizvKTVG0XC6rCfMGjVaqx9igAZGCBKlngGy6hPHb+C1jX194=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773764494; c=relaxed/simple;
	bh=6r7G/4OTNvkQE+Rg5oVMsf4prm1UCgUkcDBXs3A5mZ8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dxbn8gUZaxqJOuxyJSHAr1YybvsgqEEfK0l1e9DHPuHgohHvcPMq5L4Fa6A2ZGwRo217ht1kjG3RWxpXv+4YEjxm8PCKm7F4ryfL7jV83s03Us54H04jJl7KVZSvC7Hm6knAAVZHx+2COv3V38vOIQpohNLL1K2UChPBUAOjT8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5A16889140;
	Tue, 17 Mar 2026 16:21:25 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf04.hostedemail.com (Postfix) with ESMTPA id 3E5B920023;
	Tue, 17 Mar 2026 16:21:23 +0000 (UTC)
Date: Tue, 17 Mar 2026 12:21:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Li Chen <me@linux.beauty>
Cc: Zhang Yi <yi.zhang@huaweicloud.com>, Theodore Ts'o <tytso@mit.edu>,
 Andreas Dilger <adilger.kernel@dilger.ca>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, Vineeth Remanan Pillai
 <vineeth@bitbyteword.org>
Subject: Re: [RFC v5 6/7] ext4: fast commit: add lock_updates tracepoint
Message-ID: <20260317122149.5d07132a@gandalf.local.home>
In-Reply-To: <20260317084624.457185-7-me@linux.beauty>
References: <20260317084624.457185-1-me@linux.beauty>
	<20260317084624.457185-7-me@linux.beauty>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3E5B920023
X-Stat-Signature: 8wftqtjmkaz6x7engyczbi45seohm84i
X-Rspamd-Server: rspamout03
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18/vahWcqh0LeqN6Fii+Q5YS/YquRt+sr4=
X-HE-Tag: 1773764483-188773
X-HE-Meta: U2FsdGVkX18MXY6zzIi/kwm+GVm1Q2PfzoCGwvYqWpdKJu0SpslaWaJ7BA2v/ZQUQbJxu7/z4q0wIBp2H5s/NZiouIhlDDKNA2ANMgCgTzFu77Pr/40mv/eEHbn4p8R9397FYjRWeSy5AKeMyAmlOHsVKvaoRn4f66rGprr0TprRYHC/7FNdSV+zw9ZPCYNwID1Kku9v9pZdVIGMJ5cdtP0ya9nPPkNTpojX6n1eUJ+JTr14VkvE6huktIYAYul1uzckPziUQo2cTUUuwArDlh4OLYHBtIxFfPsV2Shb3jbQAW1dSNYglT16yMRVYhgUdf+Olqdvx73TnMok7QILu44O6VCOu2qSApc3zmPxTf4xaICeRjCNX/IdM43z3PVxV+HQT115po9IhgbkXJgE6A==

On Tue, 17 Mar 2026 16:46:21 +0800
Li Chen <me@linux.beauty> wrote:

> Commit-time fast commit snapshots run under jbd2_journal_lock_updates(),
> so it is useful to quantify the time spent with updates locked and to
> understand why snapshotting can fail.
> 
> Add a new tracepoint, ext4_fc_lock_updates, reporting the time spent in
> the updates-locked window along with the number of snapshotted inodes
> and ranges. Record the first snapshot failure reason in a stable snap_err
> field for tooling.
> 
> Signed-off-by: Li Chen <me@linux.beauty>
> ---
>  fs/ext4/ext4.h              | 15 ++++++++
>  fs/ext4/fast_commit.c       | 71 +++++++++++++++++++++++++++++--------
>  include/trace/events/ext4.h | 61 +++++++++++++++++++++++++++++++
>  3 files changed, 132 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 68a64fa0be926..b9e146f3dd9e4 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1037,6 +1037,21 @@ enum {
>  
>  struct ext4_fc_inode_snap;
>  
> +/*
> + * Snapshot failure reasons for ext4_fc_lock_updates tracepoint.
> + * Keep these stable for tooling.
> + */
> +enum ext4_fc_snap_err {
> +	EXT4_FC_SNAP_ERR_NONE		= 0,
> +	EXT4_FC_SNAP_ERR_ES_MISS	= 1,
> +	EXT4_FC_SNAP_ERR_ES_DELAYED	= 2,
> +	EXT4_FC_SNAP_ERR_ES_OTHER	= 3,
> +	EXT4_FC_SNAP_ERR_INODES_CAP	= 4,
> +	EXT4_FC_SNAP_ERR_RANGES_CAP	= 5,
> +	EXT4_FC_SNAP_ERR_NOMEM		= 6,
> +	EXT4_FC_SNAP_ERR_INODE_LOC	= 7,

You don't need to explicitly state the assignments, the enum will increment
them without them.

> +};
> +
>  /*
>   * fourth extended file system inode data in memory
>   */
> diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
> index d1eefee609120..4929e2990b292 100644
> --- a/fs/ext4/fast_commit.c
> +++ b/fs/ext4/fast_commit.c
> @@ -193,6 +193,12 @@ static struct kmem_cache *ext4_fc_range_cachep;
>  #define EXT4_FC_SNAPSHOT_MAX_INODES	1024
>  #define EXT4_FC_SNAPSHOT_MAX_RANGES	2048
>  
> +static inline void ext4_fc_set_snap_err(int *snap_err, int err)
> +{
> +	if (snap_err && *snap_err == EXT4_FC_SNAP_ERR_NONE)
> +		*snap_err = err;
> +}
> +
>  static void ext4_end_buffer_io_sync(struct buffer_head *bh, int uptodate)
>  {
>  	BUFFER_TRACE(bh, "");
> @@ -983,11 +989,12 @@ static void ext4_fc_free_inode_snap(struct inode *inode)
>  static int ext4_fc_snapshot_inode_data(struct inode *inode,
>  				       struct list_head *ranges,
>  				       unsigned int nr_ranges_total,
> -				       unsigned int *nr_rangesp)
> +				       unsigned int *nr_rangesp,
> +				       int *snap_err)
>  {
>  	struct ext4_inode_info *ei = EXT4_I(inode);
> -	unsigned int nr_ranges = 0;
>  	ext4_lblk_t start_lblk, end_lblk, cur_lblk;
> +	unsigned int nr_ranges = 0;
>  
>  	spin_lock(&ei->i_fc_lock);
>  	if (ei->i_fc_lblk_len == 0) {
> @@ -1010,11 +1017,16 @@ static int ext4_fc_snapshot_inode_data(struct inode *inode,
>  		struct ext4_fc_range *range;
>  		ext4_lblk_t len;
>  
> -		if (!ext4_es_lookup_extent(inode, cur_lblk, NULL, &es, NULL))
> +		if (!ext4_es_lookup_extent(inode, cur_lblk, NULL, &es, NULL)) {
> +			ext4_fc_set_snap_err(snap_err, EXT4_FC_SNAP_ERR_ES_MISS);
>  			return -EAGAIN;
> +		}
>  
> -		if (ext4_es_is_delayed(&es))
> +		if (ext4_es_is_delayed(&es)) {
> +			ext4_fc_set_snap_err(snap_err,
> +					     EXT4_FC_SNAP_ERR_ES_DELAYED);
>  			return -EAGAIN;
> +		}
>  
>  		len = es.es_len - (cur_lblk - es.es_lblk);
>  		if (len > end_lblk - cur_lblk + 1)
> @@ -1024,12 +1036,17 @@ static int ext4_fc_snapshot_inode_data(struct inode *inode,
>  			continue;
>  		}
>  
> -		if (nr_ranges_total + nr_ranges >= EXT4_FC_SNAPSHOT_MAX_RANGES)
> +		if (nr_ranges_total + nr_ranges >= EXT4_FC_SNAPSHOT_MAX_RANGES) {
> +			ext4_fc_set_snap_err(snap_err,
> +					     EXT4_FC_SNAP_ERR_RANGES_CAP);
>  			return -E2BIG;
> +		}
>  
>  		range = kmem_cache_alloc(ext4_fc_range_cachep, GFP_NOFS);
> -		if (!range)
> +		if (!range) {
> +			ext4_fc_set_snap_err(snap_err, EXT4_FC_SNAP_ERR_NOMEM);
>  			return -ENOMEM;
> +		}
>  		nr_ranges++;
>  
>  		range->lblk = cur_lblk;
> @@ -1054,6 +1071,7 @@ static int ext4_fc_snapshot_inode_data(struct inode *inode,
>  				range->len = max;
>  		} else {
>  			kmem_cache_free(ext4_fc_range_cachep, range);
> +			ext4_fc_set_snap_err(snap_err, EXT4_FC_SNAP_ERR_ES_OTHER);
>  			return -EAGAIN;
>  		}
>  
> @@ -1070,7 +1088,7 @@ static int ext4_fc_snapshot_inode_data(struct inode *inode,
>  
>  static int ext4_fc_snapshot_inode(struct inode *inode,
>  				  unsigned int nr_ranges_total,
> -				  unsigned int *nr_rangesp)
> +				  unsigned int *nr_rangesp, int *snap_err)
>  {
>  	struct ext4_inode_info *ei = EXT4_I(inode);
>  	struct ext4_fc_inode_snap *snap;
> @@ -1082,8 +1100,10 @@ static int ext4_fc_snapshot_inode(struct inode *inode,
>  	int alloc_ctx;
>  
>  	ret = ext4_get_inode_loc_noio(inode, &iloc);
> -	if (ret)
> +	if (ret) {
> +		ext4_fc_set_snap_err(snap_err, EXT4_FC_SNAP_ERR_INODE_LOC);
>  		return ret;
> +	}
>  
>  	if (ext4_test_inode_flag(inode, EXT4_INODE_INLINE_DATA))
>  		inode_len = EXT4_INODE_SIZE(inode->i_sb);
> @@ -1092,6 +1112,7 @@ static int ext4_fc_snapshot_inode(struct inode *inode,
>  
>  	snap = kmalloc(struct_size(snap, inode_buf, inode_len), GFP_NOFS);
>  	if (!snap) {
> +		ext4_fc_set_snap_err(snap_err, EXT4_FC_SNAP_ERR_NOMEM);
>  		brelse(iloc.bh);
>  		return -ENOMEM;
>  	}
> @@ -1102,7 +1123,7 @@ static int ext4_fc_snapshot_inode(struct inode *inode,
>  	brelse(iloc.bh);
>  
>  	ret = ext4_fc_snapshot_inode_data(inode, &ranges, nr_ranges_total,
> -					  &nr_ranges);
> +					  &nr_ranges, snap_err);
>  	if (ret) {
>  		kfree(snap);
>  		ext4_fc_free_ranges(&ranges);
> @@ -1203,7 +1224,10 @@ static int ext4_fc_alloc_snapshot_inodes(struct super_block *sb,
>  					 unsigned int *nr_inodesp);
>  
>  static int ext4_fc_snapshot_inodes(journal_t *journal, struct inode **inodes,
> -				   unsigned int inodes_size)
> +				   unsigned int inodes_size,
> +				   unsigned int *nr_inodesp,
> +				   unsigned int *nr_rangesp,
> +				   int *snap_err)
>  {
>  	struct super_block *sb = journal->j_private;
>  	struct ext4_sb_info *sbi = EXT4_SB(sb);
> @@ -1221,6 +1245,8 @@ static int ext4_fc_snapshot_inodes(journal_t *journal, struct inode **inodes,
>  	alloc_ctx = ext4_fc_lock(sb);
>  	list_for_each_entry(iter, &sbi->s_fc_q[FC_Q_MAIN], i_fc_list) {
>  		if (i >= inodes_size) {
> +			ext4_fc_set_snap_err(snap_err,
> +					     EXT4_FC_SNAP_ERR_INODES_CAP);
>  			ret = -E2BIG;
>  			goto unlock;
>  		}
> @@ -1244,6 +1270,8 @@ static int ext4_fc_snapshot_inodes(journal_t *journal, struct inode **inodes,
>  			continue;
>  
>  		if (i >= inodes_size) {
> +			ext4_fc_set_snap_err(snap_err,
> +					     EXT4_FC_SNAP_ERR_INODES_CAP);
>  			ret = -E2BIG;
>  			goto unlock;
>  		}
> @@ -1268,16 +1296,20 @@ static int ext4_fc_snapshot_inodes(journal_t *journal, struct inode **inodes,
>  		unsigned int inode_ranges = 0;
>  
>  		ret = ext4_fc_snapshot_inode(inodes[idx], nr_ranges,
> -					     &inode_ranges);
> +					     &inode_ranges, snap_err);
>  		if (ret)
>  			break;
>  		nr_ranges += inode_ranges;
>  	}
>  
> +	if (nr_inodesp)
> +		*nr_inodesp = i;
> +	if (nr_rangesp)
> +		*nr_rangesp = nr_ranges;
>  	return ret;
>  }
>  
> -static int ext4_fc_perform_commit(journal_t *journal)
> +static int ext4_fc_perform_commit(journal_t *journal, tid_t commit_tid)
>  {
>  	struct super_block *sb = journal->j_private;
>  	struct ext4_sb_info *sbi = EXT4_SB(sb);
> @@ -1286,10 +1318,15 @@ static int ext4_fc_perform_commit(journal_t *journal)
>  	struct inode *inode;
>  	struct inode **inodes;
>  	unsigned int inodes_size;
> +	unsigned int snap_inodes = 0;
> +	unsigned int snap_ranges = 0;
> +	int snap_err = EXT4_FC_SNAP_ERR_NONE;
>  	struct blk_plug plug;
>  	int ret = 0;
>  	u32 crc = 0;
>  	int alloc_ctx;
> +	ktime_t lock_start;
> +	u64 locked_ns;
>  
>  	/*
>  	 * Step 1: Mark all inodes on s_fc_q[MAIN] with
> @@ -1337,13 +1374,13 @@ static int ext4_fc_perform_commit(journal_t *journal)
>  	if (ret)
>  		return ret;
>  
> -
>  	ret = ext4_fc_alloc_snapshot_inodes(sb, &inodes, &inodes_size);
>  	if (ret)
>  		return ret;
>  
>  	/* Step 4: Mark all inodes as being committed. */
>  	jbd2_journal_lock_updates(journal);
> +	lock_start = ktime_get();
>  	/*
>  	 * The journal is now locked. No more handles can start and all the
>  	 * previous handles are now drained. Snapshotting happens in this
> @@ -1357,8 +1394,12 @@ static int ext4_fc_perform_commit(journal_t *journal)
>  	}
>  	ext4_fc_unlock(sb, alloc_ctx);
>  
> -	ret = ext4_fc_snapshot_inodes(journal, inodes, inodes_size);
> +	ret = ext4_fc_snapshot_inodes(journal, inodes, inodes_size,
> +				      &snap_inodes, &snap_ranges, &snap_err);
>  	jbd2_journal_unlock_updates(journal);
> +	locked_ns = ktime_to_ns(ktime_sub(ktime_get(), lock_start));

If locked_ns is only used for the tracepoint, it should either be
calculated in the tracepoint, or add:

	if (trace_ext4_fc_lock_updates_enabled()) {
		locked_ns = ktime_to_ns(ktime_sub(ktime_get(), lock_start));

> +	trace_ext4_fc_lock_updates(sb, commit_tid, locked_ns, snap_inodes,
> +				   snap_ranges, ret, snap_err);

	}

Note, we are going to also add a code to call the tracepoint directly, to
remove the double static_branch.

	https://lore.kernel.org/all/20260312150523.2054552-1-vineeth@bitbyteword.org/

But that code is still being worked on so you don't need to worry about it
at the moment.

-- Steve



>  	kvfree(inodes);
>  	if (ret)
>  		return ret;
> @@ -1563,7 +1604,7 @@ int ext4_fc_commit(journal_t *journal, tid_t commit_tid)
>  		journal_ioprio = EXT4_DEF_JOURNAL_IOPRIO;
>  	set_task_ioprio(current, journal_ioprio);
>  	fc_bufs_before = (sbi->s_fc_bytes + bsize - 1) / bsize;
> -	ret = ext4_fc_perform_commit(journal);
> +	ret = ext4_fc_perform_commit(journal, commit_tid);
>  	if (ret < 0) {
>  		if (ret == -EAGAIN || ret == -E2BIG || ret == -ECANCELED)
>  			status = EXT4_FC_STATUS_INELIGIBLE;
> diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
> index fd76d14c2776e..dc084f39b74ad 100644
> --- a/include/trace/events/ext4.h
> +++ b/include/trace/events/ext4.h
> @@ -104,6 +104,26 @@ TRACE_DEFINE_ENUM(EXT4_FC_REASON_INODE_JOURNAL_DATA);
>  TRACE_DEFINE_ENUM(EXT4_FC_REASON_ENCRYPTED_FILENAME);
>  TRACE_DEFINE_ENUM(EXT4_FC_REASON_MAX);
>  
> +#undef EM
> +#undef EMe
> +#define EM(a)	TRACE_DEFINE_ENUM(EXT4_FC_SNAP_ERR_##a);
> +#define EMe(a)	TRACE_DEFINE_ENUM(EXT4_FC_SNAP_ERR_##a);
> +
> +#define TRACE_SNAP_ERR						\
> +	EM(NONE)						\
> +	EM(ES_MISS)						\
> +	EM(ES_DELAYED)						\
> +	EM(ES_OTHER)						\
> +	EM(INODES_CAP)						\
> +	EM(RANGES_CAP)						\
> +	EM(NOMEM)						\
> +	EMe(INODE_LOC)
> +
> +TRACE_SNAP_ERR
> +
> +#undef EM
> +#undef EMe
> +
>  #define show_fc_reason(reason)						\
>  	__print_symbolic(reason,					\
>  		{ EXT4_FC_REASON_XATTR,		"XATTR"},		\
> @@ -2812,6 +2832,47 @@ TRACE_EVENT(ext4_fc_commit_stop,
>  		  __entry->num_fc_ineligible, __entry->nblks_agg, __entry->tid)
>  );
>  
> +#define EM(a)	{ EXT4_FC_SNAP_ERR_##a, #a },
> +#define EMe(a)	{ EXT4_FC_SNAP_ERR_##a, #a }
> +
> +TRACE_EVENT(ext4_fc_lock_updates,
> +	    TP_PROTO(struct super_block *sb, tid_t commit_tid, u64 locked_ns,
> +		     unsigned int nr_inodes, unsigned int nr_ranges, int err,
> +		     int snap_err),
> +
> +	TP_ARGS(sb, commit_tid, locked_ns, nr_inodes, nr_ranges, err, snap_err),
> +
> +	TP_STRUCT__entry(/* entry */
> +		__field(dev_t, dev)
> +		__field(tid_t, tid)
> +		__field(u64, locked_ns)
> +		__field(unsigned int, nr_inodes)
> +		__field(unsigned int, nr_ranges)
> +		__field(int, err)
> +		__field(int, snap_err)
> +	),
> +
> +	TP_fast_assign(/* assign */
> +		__entry->dev = sb->s_dev;
> +		__entry->tid = commit_tid;
> +		__entry->locked_ns = locked_ns;
> +		__entry->nr_inodes = nr_inodes;
> +		__entry->nr_ranges = nr_ranges;
> +		__entry->err = err;
> +		__entry->snap_err = snap_err;
> +	),
> +
> +	TP_printk("dev %d,%d tid %u locked_ns %llu nr_inodes %u nr_ranges %u err %d snap_err %s",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->tid,
> +		  __entry->locked_ns, __entry->nr_inodes, __entry->nr_ranges,
> +		  __entry->err, __print_symbolic(__entry->snap_err,
> +						 TRACE_SNAP_ERR))
> +);
> +
> +#undef EM
> +#undef EMe
> +#undef TRACE_SNAP_ERR
> +
>  #define FC_REASON_NAME_STAT(reason)					\
>  	show_fc_reason(reason),						\
>  	__entry->fc_ineligible_rc[reason]

