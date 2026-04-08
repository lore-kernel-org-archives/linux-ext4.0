Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF13038D007;
	Wed,  8 Apr 2026 20:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775678581; cv=none; b=TjzvU0YnM6c0WqZ+i1Sx2KRAyBvhIbjHmQvif0ybwC+EMfSO1jzpTdOCRdvctdzrofCXXDEAlXeNREWroXr90ecZ4TiUDWXYOzpL/bwoZFOt4qSuK7YFC+PQUNm3A2OzjKoGqUmBxMPNrGCQ1AFfCY83HaU9H2l0lBBeNYfnXyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775678581; c=relaxed/simple;
	bh=yI0gf8gI4SVLBBvRbXbDhKekxGCVbzCyZg+rugJd84Y=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nf0uSv5eASdRcMaR8R7ZdQtxbaXhpad90HcZjdaJ6HwyXzJUew0IgDcXNfALMswDnehj1GKaZMds4q5XRSy8AXgRNsDcvDdYVU2kUwmC94f3m4C6VJA3124+yDOEeLwii4L74nBV6axPGj+tFTOb//avi+xVxSJT94TxoA0Qmaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D3F52138162;
	Wed,  8 Apr 2026 20:02:51 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf20.hostedemail.com (Postfix) with ESMTPA id F130320026;
	Wed,  8 Apr 2026 20:02:48 +0000 (UTC)
Date: Wed, 8 Apr 2026 16:04:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Li Chen <me@linux.beauty>
Cc: Zhang Yi <yi.zhang@huaweicloud.com>, Theodore Ts'o <tytso@mit.edu>,
 Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li
 <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, Ojaswin Mujoo
 <ojaswin@linux.ibm.com>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Zhang Yi <yi.zhang@huawei.com>, Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
Subject: Re: [RFC v6 6/7] ext4: fast commit: add lock_updates tracepoint
Message-ID: <20260408160405.45a5ee09@gandalf.local.home>
In-Reply-To: <20260408112020.716706-7-me@linux.beauty>
References: <20260408112020.716706-1-me@linux.beauty>
	<20260408112020.716706-7-me@linux.beauty>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: F130320026
X-Rspamd-Server: rspamout06
X-Stat-Signature: 31f3wkxzr7b1o9rbmffjuiurwxs7afg4
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+fNRqLMKHLva9mfCIRC3qtfuY8KaONfJs=
X-HE-Tag: 1775678568-265512
X-HE-Meta: U2FsdGVkX18aAJWzRtF34Vi9zUSLx49mvEH+R9xkDO1iO/T6NoLAGMimOxsRrT7nU6Ww9B/VRzMcJV6Mhkj9S3CAE7VXwLM0CbV9tiELPqIsbXoPnmAX1saMakuxvCU4wDOMZvzzXJbkk/5n10QK0/9uR0sy7KPhBlLWaXbS7Y8Ky0SM7gXd5ht0si9JNB0k8ltzMrKVZGoOjag1lVH05TUd9HNc/LRPBgf4jUJT41C8Kzvik3MPSLVshoYDL3FdZINYV7wTl/GDG15bKQcuo0SFvkUX9MotBS8QhjogsaRPUnA/K5ppkBnIwsfmwApC7N/jCTdCdU5nYPMtyRTapTC3iuBh8SztvyrAciTFUvAWLD5Z4SY8qhA9ZF8AGVF9

On Wed,  8 Apr 2026 19:20:17 +0800
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

[..]

> @@ -1338,13 +1375,13 @@ static int ext4_fc_perform_commit(journal_t *journal)
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

ktime_get() is rather quick but if you care about micro-optimizations, you
could have:

	if (trace_ext4_fc_lock_updates_enabled())
		lock_start = ktime_get();
	else	
		lock_start = 0;

>  	/*
>  	 * The journal is now locked. No more handles can start and all the
>  	 * previous handles are now drained. Snapshotting happens in this
> @@ -1358,8 +1395,15 @@ static int ext4_fc_perform_commit(journal_t *journal)
>  	}
>  	ext4_fc_unlock(sb, alloc_ctx);
>  
> -	ret = ext4_fc_snapshot_inodes(journal, inodes, inodes_size);
> +	ret = ext4_fc_snapshot_inodes(journal, inodes, inodes_size,
> +				      &snap_inodes, &snap_ranges, &snap_err);
>  	jbd2_journal_unlock_updates(journal);
> +	if (trace_ext4_fc_lock_updates_enabled()) {

	if (trace_ext4_fc_lock_updates_enabled() && lock_start) {

But feel free to ignore this if the overhead of always calling ktime_get()
is not an issue.


> +		locked_ns = ktime_to_ns(ktime_sub(ktime_get(), lock_start));
> +		trace_ext4_fc_lock_updates(sb, commit_tid, locked_ns,
> +					   snap_inodes, snap_ranges, ret,
> +					   snap_err);
> +	}
>  	kvfree(inodes);
>  	if (ret)
>  		return ret;
> @@ -1564,7 +1608,7 @@ int ext4_fc_commit(journal_t *journal, tid_t commit_tid)
>  		journal_ioprio = EXT4_DEF_JOURNAL_IOPRIO;
>  	set_task_ioprio(current, journal_ioprio);
>  	fc_bufs_before = (sbi->s_fc_bytes + bsize - 1) / bsize;
> -	ret = ext4_fc_perform_commit(journal);
> +	ret = ext4_fc_perform_commit(journal, commit_tid);
>  	if (ret < 0) {
>  		if (ret == -EAGAIN || ret == -E2BIG || ret == -ECANCELED)
>  			status = EXT4_FC_STATUS_INELIGIBLE;
> diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
> index f493642cf121..7028a28316fa 100644
> --- a/include/trace/events/ext4.h
> +++ b/include/trace/events/ext4.h
> @@ -107,6 +107,26 @@ TRACE_DEFINE_ENUM(EXT4_FC_REASON_VERITY);
>  TRACE_DEFINE_ENUM(EXT4_FC_REASON_MOVE_EXT);
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
> @@ -2818,6 +2838,47 @@ TRACE_EVENT(ext4_fc_commit_stop,
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

As for the rest:

Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>

[ Please add this reviewed-by to any new versions so I remember I already
  looked at it. ]

Thanks,

-- Steve
