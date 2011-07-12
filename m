From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] jbd/2[stable only]: Use WRITE_SYNC_PLUG in
 journal_commit_transaction.
Date: Tue, 12 Jul 2011 08:30:41 -0400
Message-ID: <20110712123041.GC1293@redhat.com>
References: <1310467431-23108-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, stable@kernel.org,
	Jan Kara <jack@suse.cz>, Jeff Moyer <jmoyer@redhat.com>,
	Corrado Zoccolo <czoccolo@gmail.com>,
	Jens Axboe <jaxboe@fusionio.com>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36886 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753306Ab1GLMb3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Jul 2011 08:31:29 -0400
Content-Disposition: inline
In-Reply-To: <1310467431-23108-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 12, 2011 at 06:43:51PM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> In commit 749ef9f8423, we use WRITE_SYNC instead of WRITE in
> journal_commit_transaction. It causes a much heavy burden for
> the disk as now the seqenctial write can't be merged(see the blktrace below).

Tao Ma,

Few queries.

- What's the workload you are using for this test.

- Do you see any performance improvement by switching to WRITE_SYNC_PLUG.

- Why writes are not being merged? Because request got dispatched
  immediately? Do you have logs for insertion of requests also.

- WRITE_SYNC_PLUG will plug the queue and expects explicity unplug. Who
  is doing unplug in this case?

- I am not sure in how many cases we are expecting to submit multiple
  sequential write here.

Thanks
Vivek

> 
> Given the description of that commit 749ef9f8423, the reason why
> we use WRITE_SYNC is that it wants to use REQ_NOIDLE and WRITE_SYNC_PLUG
> also has that flag, so use WRITE_SYNC_PLUG instead. From blktrace,
> we can get that:
> 
> without the patch:
>   8,0    6       18     0.016058423  3342  D   W 461101317 + 4 [jbd2/sda11-8]
>   8,0    6       19     0.016065473  3342  D   W 461101321 + 4 [jbd2/sda11-8]
>   8,0    6       20     0.016070751  3342  D   W 461101325 + 4 [jbd2/sda11-8]
>   8,0    6       21     0.016076180  3342  D   W 461101329 + 4 [jbd2/sda11-8]
>   8,0    6       22     0.016081255  3342  D   W 461101333 + 4 [jbd2/sda11-8]
>   8,0    6       23     0.016085963  3342  D   W 461101337 + 4 [jbd2/sda11-8]
>   8,0    6       24     0.016182048     0  C   W 461101317 + 4 [0]
>   8,0    6       25     0.016190820     0  C   W 461101325 + 4 [0]
>   8,0    6       26     0.016193927     0  C   W 461101321 + 4 [0]
>   8,0    6       27     0.016196532     0  C   W 461101333 + 4 [0]
>   8,0    6       28     0.016199180     0  C   W 461101337 + 4 [0]
>   8,0    6       29     0.016206180     0  C   W 461101329 + 4 [0]
> 
> with this patch:
>   8,0    4       23     4.320315739  3129  D   W 461101317 + 24 [jbd2/sda11-8]
>   8,0    4       24     4.320364518     0  C   W 461101317 + 24 [0]
> 
> This only affects .37 and .38 since Jens' new plug patches are included
> in .39 and the bug is removed as a side effect. But I think it is needed
> anyway for the stable. And RHEL6 needs this also I guess.
> 
> Cc: stable@kernel.org # 2.6.37 and 2.6.38
> Cc: Jan Kara <jack@suse.cz>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: Jeff Moyer <jmoyer@redhat.com>
> Cc: Corrado Zoccolo <czoccolo@gmail.com>
> Cc: Jens Axboe <jaxboe@fusionio.com>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
> ---
>  fs/jbd/commit.c  |    9 +--------
>  fs/jbd2/commit.c |    9 +--------
>  2 files changed, 2 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
> index 34a4861..6d13df5 100644
> --- a/fs/jbd/commit.c
> +++ b/fs/jbd/commit.c
> @@ -294,7 +294,7 @@ void journal_commit_transaction(journal_t *journal)
>  	int first_tag = 0;
>  	int tag_flag;
>  	int i;
> -	int write_op = WRITE_SYNC;
> +	int write_op = WRITE_SYNC_PLUG;
>  
>  	/*
>  	 * First job: lock down the current transaction and wait for
> @@ -327,13 +327,6 @@ void journal_commit_transaction(journal_t *journal)
>  	spin_lock(&journal->j_state_lock);
>  	commit_transaction->t_state = T_LOCKED;
>  
> -	/*
> -	 * Use plugged writes here, since we want to submit several before
> -	 * we unplug the device. We don't do explicit unplugging in here,
> -	 * instead we rely on sync_buffer() doing the unplug for us.
> -	 */
> -	if (commit_transaction->t_synchronous_commit)
> -		write_op = WRITE_SYNC_PLUG;
>  	spin_lock(&commit_transaction->t_handle_lock);
>  	while (commit_transaction->t_updates) {
>  		DEFINE_WAIT(wait);
> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> index f3ad159..fc3840f 100644
> --- a/fs/jbd2/commit.c
> +++ b/fs/jbd2/commit.c
> @@ -329,7 +329,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
>  	int tag_bytes = journal_tag_bytes(journal);
>  	struct buffer_head *cbh = NULL; /* For transactional checksums */
>  	__u32 crc32_sum = ~0;
> -	int write_op = WRITE_SYNC;
> +	int write_op = WRITE_SYNC_PLUG;
>  
>  	/*
>  	 * First job: lock down the current transaction and wait for
> @@ -363,13 +363,6 @@ void jbd2_journal_commit_transaction(journal_t *journal)
>  	write_lock(&journal->j_state_lock);
>  	commit_transaction->t_state = T_LOCKED;
>  
> -	/*
> -	 * Use plugged writes here, since we want to submit several before
> -	 * we unplug the device. We don't do explicit unplugging in here,
> -	 * instead we rely on sync_buffer() doing the unplug for us.
> -	 */
> -	if (commit_transaction->t_synchronous_commit)
> -		write_op = WRITE_SYNC_PLUG;
>  	trace_jbd2_commit_locking(journal, commit_transaction);
>  	stats.run.rs_wait = commit_transaction->t_max_wait;
>  	stats.run.rs_locked = jiffies;
> -- 
> 1.7.4
