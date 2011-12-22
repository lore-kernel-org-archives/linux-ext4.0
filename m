From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH 2/2] jbd2: remove all t_handle_lock statements
Date: Thu, 22 Dec 2011 22:07:32 +0800
Message-ID: <CAGBYx2YBq_=N0Gnky7RhNHhyTybhP1fLB6Fzzp-GLhEy6Lyekw@mail.gmail.com>
References: <20111216201915.4a012154.toshi.okajima@jp.fujitsu.com>
	<CAGBYx2YZ4M8QwwOcnLAaf+934WAcZoNS_pPrw8j3Nkr3=6fA5g@mail.gmail.com>
	<4EF066F0.5010809@jp.fujitsu.com>
	<20111222203639.4200538e.toshi.okajima@jp.fujitsu.com>
	<20111222210007.ca8fb54f.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:48926 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751689Ab1LVOHd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 Dec 2011 09:07:33 -0500
Received: by obcwo16 with SMTP id wo16so4153126obc.19
        for <linux-ext4@vger.kernel.org>; Thu, 22 Dec 2011 06:07:33 -0800 (PST)
In-Reply-To: <20111222210007.ca8fb54f.toshi.okajima@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 22, 2011 at 8:00 PM, Toshiyuki Okajima
<toshi.okajima@jp.fujitsu.com> wrote:
> Remove all t_handle_lock statements because they are not necessary an=
ymore.
>
> Because there is read_lock(&journal->j_state_lock) or
> write_lock(&journal->j_state_lock) on all the forward codes beyond th=
e place
> which needs a spin_lock(&transaction->t_handle_lock).
>
> Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
> Cc:
> ---
> =A0fs/jbd2/commit.c =A0 =A0 =A0| =A0 =A04 ----
> =A0fs/jbd2/transaction.c | =A0 18 +++---------------
> =A0include/linux/jbd2.h =A0| =A0 =A08 --------
> =A03 files changed, 3 insertions(+), 27 deletions(-)
>
> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> index 68d704d..1030d47 100644
> --- a/fs/jbd2/commit.c
> +++ b/fs/jbd2/commit.c
> @@ -364,22 +364,18 @@ void jbd2_journal_commit_transaction(journal_t =
*journal)
> =A0 =A0 =A0 =A0stats.run.rs_running =3D jbd2_time_diff(commit_transac=
tion->t_start,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0stats.run.rs_locked);
>
> - =A0 =A0 =A0 spin_lock(&commit_transaction->t_handle_lock);
> =A0 =A0 =A0 =A0while (atomic_read(&commit_transaction->t_updates)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0DEFINE_WAIT(wait);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0prepare_to_wait(&journal->j_wait_updat=
es, &wait,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0TASK_UNINTERRUPTIBLE);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (atomic_read(&commit_transaction->t=
_updates)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&commit_tra=
nsaction->t_handle_lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0write_unlock(&journal-=
>j_state_lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0schedule();
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0write_lock(&journal->j=
_state_lock);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&commit_trans=
action->t_handle_lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0finish_wait(&journal->j_wait_updates, =
&wait);
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 spin_unlock(&commit_transaction->t_handle_lock);
>
> =A0 =A0 =A0 =A0J_ASSERT (atomic_read(&commit_transaction->t_outstandi=
ng_credits) <=3D
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0journal->j_max_transac=
tion_buffers);
> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> index 76f2eca..7f84e3f 100644
> --- a/fs/jbd2/transaction.c
> +++ b/fs/jbd2/transaction.c
> @@ -56,7 +56,6 @@ jbd2_get_transaction(journal_t *journal, transactio=
n_t *transaction)
> =A0 =A0 =A0 =A0transaction->t_start_time =3D ktime_get();
> =A0 =A0 =A0 =A0transaction->t_tid =3D journal->j_transaction_sequence=
++;
> =A0 =A0 =A0 =A0transaction->t_expires =3D jiffies + journal->j_commit=
_interval;
> - =A0 =A0 =A0 spin_lock_init(&transaction->t_handle_lock);
> =A0 =A0 =A0 =A0atomic_set(&transaction->t_updates, 0);
> =A0 =A0 =A0 =A0atomic_set(&transaction->t_outstanding_credits, 0);
> =A0 =A0 =A0 =A0atomic_set(&transaction->t_handle_count, 0);
> @@ -100,10 +99,8 @@ static inline void update_t_max_wait(transaction_=
t *transaction,
> =A0 =A0 =A0 =A0if (jbd2_journal_enable_debug &&
> =A0 =A0 =A0 =A0 =A0 =A0time_after(transaction->t_start, ts)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ts =3D jbd2_time_diff(ts, transaction-=
>t_start);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&transaction->t_handle_lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ts > transaction->t_max_wait)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0transaction->t_max_wai=
t =3D ts;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&transaction->t_handle_lock=
);
Hi Toshiyuki,

     I think you removed too much.  t_handle_lock is needed here to
protect t_max_wait.   I meant just removing t_handle_lock from where I
commented in your patch post out last time.

Yongqiang.
> =A0 =A0 =A0 =A0}
> =A0#endif
> =A0}
> @@ -401,19 +398,18 @@ int jbd2_journal_extend(handle_t *handle, int n=
blocks)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto error_out;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 spin_lock(&transaction->t_handle_lock);
> =A0 =A0 =A0 =A0wanted =3D atomic_read(&transaction->t_outstanding_cre=
dits) + nblocks;
>
> =A0 =A0 =A0 =A0if (wanted > journal->j_max_transaction_buffers) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0jbd_debug(3, "denied handle %p %d bloc=
ks: "
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"transaction too l=
arge\n", handle, nblocks);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto unlock;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto error_out;
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0if (wanted > __jbd2_log_space_left(journal)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0jbd_debug(3, "denied handle %p %d bloc=
ks: "
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"insufficient log =
space\n", handle, nblocks);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto unlock;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto error_out;
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0handle->h_buffer_credits +=3D nblocks;
> @@ -421,8 +417,6 @@ int jbd2_journal_extend(handle_t *handle, int nbl=
ocks)
> =A0 =A0 =A0 =A0result =3D 0;
>
> =A0 =A0 =A0 =A0jbd_debug(3, "extended handle %p by %d\n", handle, nbl=
ocks);
> -unlock:
> - =A0 =A0 =A0 spin_unlock(&transaction->t_handle_lock);
> =A0error_out:
> =A0 =A0 =A0 =A0read_unlock(&journal->j_state_lock);
> =A0out:
> @@ -464,12 +458,10 @@ int jbd2__journal_restart(handle_t *handle, int=
 nblocks, gfp_t gfp_mask)
> =A0 =A0 =A0 =A0J_ASSERT(journal_current_handle() =3D=3D handle);
>
> =A0 =A0 =A0 =A0read_lock(&journal->j_state_lock);
> - =A0 =A0 =A0 spin_lock(&transaction->t_handle_lock);
> =A0 =A0 =A0 =A0atomic_sub(handle->h_buffer_credits,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &transaction->t_outstanding_credi=
ts);
> =A0 =A0 =A0 =A0if (atomic_dec_and_test(&transaction->t_updates))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0wake_up(&journal->j_wait_updates);
> - =A0 =A0 =A0 spin_unlock(&transaction->t_handle_lock);
>
> =A0 =A0 =A0 =A0jbd_debug(2, "restarting handle %p\n", handle);
> =A0 =A0 =A0 =A0tid =3D transaction->t_tid;
> @@ -516,14 +508,10 @@ void jbd2_journal_lock_updates(journal_t *journ=
al)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!transaction)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&transaction->t_handle_lock);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!atomic_read(&transaction->t_update=
s)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&transactio=
n->t_handle_lock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!atomic_read(&transaction->t_update=
s))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0prepare_to_wait(&journal->j_wait_updat=
es, &wait,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0TASK_U=
NINTERRUPTIBLE);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&transaction->t_handle_lock=
);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0write_unlock(&journal->j_state_lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0schedule();
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0finish_wait(&journal->j_wait_updates, =
&wait);
> diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
> index 2092ea2..55f7a8c 100644
> --- a/include/linux/jbd2.h
> +++ b/include/linux/jbd2.h
> @@ -440,9 +440,6 @@ struct transaction_chp_stats_s {
> =A0* =A0 =A0->j_list_lock
> =A0*
> =A0* =A0 =A0j_state_lock
> - * =A0 =A0->t_handle_lock
> - *
> - * =A0 =A0j_state_lock
> =A0* =A0 =A0->j_list_lock =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(jou=
rnal_unmap_buffer)
> =A0*
> =A0*/
> @@ -538,11 +535,6 @@ struct transaction_s
> =A0 =A0 =A0 =A0struct list_head =A0 =A0 =A0 =A0t_inode_list;
>
> =A0 =A0 =A0 =A0/*
> - =A0 =A0 =A0 =A0* Protects info related to handles
> - =A0 =A0 =A0 =A0*/
> - =A0 =A0 =A0 spinlock_t =A0 =A0 =A0 =A0 =A0 =A0 =A0t_handle_lock;
> -
> - =A0 =A0 =A0 /*
> =A0 =A0 =A0 =A0 * Longest time some handle had to wait for running tr=
ansaction
> =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0unsigned long =A0 =A0 =A0 =A0 =A0 t_max_wait;
> --
> 1.5.5.6



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
