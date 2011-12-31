From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH 2/2 take2] jbd2: delete spin_lock(t_handle_lock) inside wirte_lock(j_state_lock)
Date: Sat, 31 Dec 2011 14:35:12 +0800
Message-ID: <CAGBYx2ZcJFO5nycxuom9nkgk1hYss_+H+oVxTTkZa0KiFhFusg@mail.gmail.com>
References: <20111216201915.4a012154.toshi.okajima@jp.fujitsu.com>
	<CAGBYx2YZ4M8QwwOcnLAaf+934WAcZoNS_pPrw8j3Nkr3=6fA5g@mail.gmail.com>
	<4EF066F0.5010809@jp.fujitsu.com>
	<20111222203639.4200538e.toshi.okajima@jp.fujitsu.com>
	<20111222210007.ca8fb54f.toshi.okajima@jp.fujitsu.com>
	<CAGBYx2YBq_=N0Gnky7RhNHhyTybhP1fLB6Fzzp-GLhEy6Lyekw@mail.gmail.com>
	<4EF7BDE2.4000309@jp.fujitsu.com>
	<20111226101727.1ca09119.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:56909 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750786Ab1LaGfO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 31 Dec 2011 01:35:14 -0500
Received: by obcwo16 with SMTP id wo16so10669628obc.19
        for <linux-ext4@vger.kernel.org>; Fri, 30 Dec 2011 22:35:13 -0800 (PST)
In-Reply-To: <20111226101727.1ca09119.toshi.okajima@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Looks good to me.

Thanks,
Yongqiang.
On Mon, Dec 26, 2011 at 9:17 AM, Toshiyuki Okajima
<toshi.okajima@jp.fujitsu.com> wrote:
> Delete all spin_lock(t_handle_lock) statements inside write_lock(j_st=
ate_lock)
> because the critical code sections can be protected by write_lock(j_s=
tate_lock)
> only.
>
> Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
> Reported-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
> ---
> =A0fs/jbd2/commit.c =A0 =A0 =A0| =A0 =A04 ----
> =A0fs/jbd2/transaction.c | =A0 =A06 +-----
> =A02 files changed, 1 insertions(+), 9 deletions(-)
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
> index 76f2eca..c418ed9 100644
> --- a/fs/jbd2/transaction.c
> +++ b/fs/jbd2/transaction.c
> @@ -516,14 +516,10 @@ void jbd2_journal_lock_updates(journal_t *journ=
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
