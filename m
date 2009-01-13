From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext3: wait on all pending commits in ext3_sync_fs
Date: Tue, 13 Jan 2009 16:14:11 -0600
Message-ID: <496D1233.2060905@redhat.com>
References: <4908C951.2000309@redhat.com> <20081103184426.GA31894@ajones-laptop.nbttech.com> <20081103113318.35b0c266.akpm@linux-foundation.org> <20081103201428.GB30565@ajones-laptop.nbttech.com> <20081218231707.GB20092@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Arthur Jones <ajones@riverbed.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"sct@redhat.com" <sct@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:35926 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753879AbZAMWOW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 Jan 2009 17:14:22 -0500
In-Reply-To: <20081218231707.GB20092@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan Kara wrote:

> From 0a578ba1b56fe655570ee6dad41748863a120dbc Mon Sep 17 00:00:00 2001
> From: Jan Kara <jack@suse.cz>
> Date: Fri, 19 Dec 2008 00:05:34 +0100
> Subject: [PATCH] jbd: Fix return value of journal_start_commit()
> 
> journal_start_commit() returns 1 if either a transaction is committing or the
> function has queued a transaction commit. But it returns 0 if we raced with
> somebody queueing the transaction commit as well. This resulted in
> ext3_sync_fs() not functioning correctly (description from Arthur Jones):
> In the case of a data=ordered umount with pending long symlinks which are
> delayed due to a long list of other I/O on the backing block device, this
> causes the buffer associated with the long symlinks to not be moved to the
> inode dirty list in the second phase of fsync_super.  Then, before they can be
> dirtied again, kjournald exits, seeing the UMOUNT flag and the dirty pages are
> never written to the backing block device, causing long symlink corruption and
> exposing new or previously freed block data to userspace.

This looks sane to me, and it does fix the below testcase.

Care to formally propose it?

Thanks,
-Eric

> This can be reproduced with a script created by Eric Sandeen
> <sandeen@redhat.com>:
> 
>         #!/bin/bash
> 
>         umount /mnt/test2
>         mount /dev/sdb4 /mnt/test2
>         rm -f /mnt/test2/*
>         dd if=/dev/zero of=/mnt/test2/bigfile bs=1M count=512
>         touch /mnt/test2/thisisveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryverylongfilename
>         ln -s /mnt/test2/thisisveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryverylongfilename
>         /mnt/test2/link
>         umount /mnt/test2
>         mount /dev/sdb4 /mnt/test2
>         ls /mnt/test2/
> 
> This patch fixes journal_start_commit() to always return 1 when there's
> a transaction committing or queued for commit.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/jbd/journal.c |   17 +++++++++++------
>  1 files changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
> index 9e4fa52..e79c078 100644
> --- a/fs/jbd/journal.c
> +++ b/fs/jbd/journal.c
> @@ -427,7 +427,7 @@ int __log_space_left(journal_t *journal)
>  }
>  
>  /*
> - * Called under j_state_lock.  Returns true if a transaction was started.
> + * Called under j_state_lock.  Returns true if a transaction commit was started.
>   */
>  int __log_start_commit(journal_t *journal, tid_t target)
>  {
> @@ -495,7 +495,8 @@ int journal_force_commit_nested(journal_t *journal)
>  
>  /*
>   * Start a commit of the current running transaction (if any).  Returns true
> - * if a transaction was started, and fills its tid in at *ptid
> + * if a transaction is going to be committed (or is currently already
> + * committing), and fills its tid in at *ptid
>   */
>  int journal_start_commit(journal_t *journal, tid_t *ptid)
>  {
> @@ -505,15 +506,19 @@ int journal_start_commit(journal_t *journal, tid_t *ptid)
>  	if (journal->j_running_transaction) {
>  		tid_t tid = journal->j_running_transaction->t_tid;
>  
> -		ret = __log_start_commit(journal, tid);
> -		if (ret && ptid)
> +		__log_start_commit(journal, tid);
> +		/* There's a running transaction and we've just made sure
> +		 * it's commit has been scheduled. */
> +		if (ptid)
>  			*ptid = tid;
> -	} else if (journal->j_committing_transaction && ptid) {
> +		ret = 1;
> +	} else if (journal->j_committing_transaction) {
>  		/*
>  		 * If ext3_write_super() recently started a commit, then we
>  		 * have to wait for completion of that transaction
>  		 */
> -		*ptid = journal->j_committing_transaction->t_tid;
> +		if (ptid)
> +			*ptid = journal->j_committing_transaction->t_tid;
>  		ret = 1;
>  	}
>  	spin_unlock(&journal->j_state_lock);

