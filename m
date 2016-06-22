From: Wang Shilong <wshilong@ddn.com>
Subject: RE: [PATCH] jbd2: wake up j_wait_done_commit before commit callback
Date: Wed, 22 Jun 2016 11:04:27 +0000
Message-ID: <3ED34739A4E85E4F894367D57617CDEF9ED90708@LAX-EX-MB2.datadirect.datadirectnet.com>
References: <1466048728-4325-1-git-send-email-wangshilong1991@gmail.com>,<CAP9B-Qk8-AUUZwPpbQ4xdrNxcQzOL2R5_ZT2W_NdAYPQNfPx3A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: Wang Shilong <wangshilong1991@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from legacy.ddn.com ([64.47.133.206]:62544 "EHLO legacy.ddn.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750854AbcFVLKq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 22 Jun 2016 07:10:46 -0400
In-Reply-To: <CAP9B-Qk8-AUUZwPpbQ4xdrNxcQzOL2R5_ZT2W_NdAYPQNfPx3A@mail.gmail.com>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Please ignore this version of patch, patch has problems. will send a v2.

Thanks,
Shilong

________________________________________
From: Wang Shilong [wangshilong1991@gmail.com]
Sent: Friday, June 17, 2016 18:05
To: Ext4 Developers List; Wang Shilong
Subject: Re: [PATCH] jbd2: wake up j_wait_done_commit before commit callback

On Thu, Jun 16, 2016 at 12:45 PM, Wang Shilong
<wangshilong1991@gmail.com> wrote:
> From: Wang Shilong <wshilong@ddn.com>
>
> Lustre register some callbacks in ext4 to keep data consistency,
> we see millons callbacks possibility on MDS for metadata operations.
>
> If there are many commit callbacks which might take some cpu
> time, we can mark commit done before we call commit callback.
> this can relax some thread waiting for commit finished, for example
> transaction throttle in end transaction.

This patch might not be correct before patch:
[PATCH -v2] ext4: optimize ext4_should_retry_alloc() to improve ENOSPC
performance

Because some thread might assume transaction commit can free some
metadata space, and in that case transaction callback need done before
we mark transaction done.

But Lustre just use commit callback to confirm transaction is done and data
is in a consistent state.

After Ted's patch, Lustre is only user for commit callback, it is fine to
apply this optimizations.

Regards,
Shilong
>
> Signed-off-by: Wang Shilong <wshilong@ddn.com>
> ---
>  fs/jbd2/commit.c |   12 ++++++++----
>  1 files changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> index 7007809..a9cf5a4 100644
> --- a/fs/jbd2/commit.c
> +++ b/fs/jbd2/commit.c
> @@ -379,6 +379,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
>         tid_t first_tid;
>         int update_tail;
>         int csum_size = 0;
> +       int need_free = 0;
>         LIST_HEAD(io_bufs);
>         LIST_HEAD(log_bufs);
>
> @@ -1100,9 +1101,6 @@ restart_loop:
>
>         write_unlock(&journal->j_state_lock);
>
> -       if (journal->j_commit_callback)
> -               journal->j_commit_callback(journal, commit_transaction);
> -
>         trace_jbd2_end_commit(journal, commit_transaction);
>         jbd_debug(1, "JBD2: commit %d complete, head %d\n",
>                   journal->j_commit_sequence, journal->j_tail_sequence);
> @@ -1114,12 +1112,18 @@ restart_loop:
>         if (commit_transaction->t_checkpoint_list == NULL &&
>             commit_transaction->t_checkpoint_io_list == NULL) {
>                 __jbd2_journal_drop_transaction(journal, commit_transaction);
> -               jbd2_journal_free_transaction(commit_transaction);
> +               need_free = 1;
>         }
>         spin_unlock(&journal->j_list_lock);
>         write_unlock(&journal->j_state_lock);
>         wake_up(&journal->j_wait_done_commit);
>
> +       if (journal->j_commit_callback)
> +               journal->j_commit_callback(journal, commit_transaction);
> +
> +       if (need_free)
> +               jbd2_journal_free_transaction(commit_transaction);
> +
>         /*
>          * Calculate overall stats
>          */
> --
> 1.7.1
>
