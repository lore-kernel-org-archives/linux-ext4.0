From: Manish Katiyar <mkatiyar@gmail.com>
Subject: Re: [PATCH v2] jbd2:Make journal transaction allocations come from
 its own cache.
Date: Fri, 22 Jul 2011 11:21:42 -0700
Message-ID: <CAE0An6dQWEaSr6enRDT82hkYhzprvAzPXVcf6LtQsPTHUv0Ryg@mail.gmail.com>
References: <1307785005-1525-1-git-send-email-mkatiyar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Manish Katiyar <mkatiyar@gmail.com>
To: tytso@mit.edu, linux-ext4@vger.kernel.org, jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:34090 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754674Ab1GVSWD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Jul 2011 14:22:03 -0400
Received: by qyk9 with SMTP id 9so1446861qyk.19
        for <linux-ext4@vger.kernel.org>; Fri, 22 Jul 2011 11:22:02 -0700 (PDT)
In-Reply-To: <1307785005-1525-1-git-send-email-mkatiyar@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jun 11, 2011 at 2:36 AM, Manish Katiyar <mkatiyar@gmail.com> wr=
ote:
> Add a cache for jbd2 journal transaction allocations. This also
> helps to leverage fault-injection framework to test various memory
> allocation failures in the jbd2 layer.
>
> Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
> Acked-by: Jan Kara <jack@suse.cz>
>
> ---
> v1->v2 :
> =A0*) Drop SLAB_TEMPORARY flag for cache allocation.
> =A0*) Remove filling with pattern during frees.
>
> =A0fs/jbd2/checkpoint.c =A0| =A0 =A02 +-
> =A0fs/jbd2/commit.c =A0 =A0 =A0| =A0 =A02 +-
> =A0fs/jbd2/journal.c =A0 =A0 | =A0 25 +++++++++++++++++++++++++
> =A0fs/jbd2/transaction.c | =A0 =A07 ++++---
> =A0include/linux/jbd2.h =A0| =A0 17 +++++++++++++++++
> =A05 files changed, 48 insertions(+), 5 deletions(-)
>
> diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
> index 6a79fd0..6f554ce 100644
> --- a/fs/jbd2/checkpoint.c
> +++ b/fs/jbd2/checkpoint.c
> @@ -716,7 +716,7 @@ int __jbd2_journal_remove_checkpoint(struct journ=
al_head *jh)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
transaction->t_tid, stats);
>
> =A0 =A0 =A0 =A0__jbd2_journal_drop_transaction(journal, transaction);
> - =A0 =A0 =A0 kfree(transaction);
> + =A0 =A0 =A0 jbd2_free_transaction(transaction);
>
> =A0 =A0 =A0 =A0/* Just in case anybody was waiting for more transacti=
ons to be
> =A0 =A0 =A0 =A0 =A0 =A0checkpointed... */
> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> index 7f21cf3..8e33d84 100644
> --- a/fs/jbd2/commit.c
> +++ b/fs/jbd2/commit.c
> @@ -1037,7 +1037,7 @@ restart_loop:
> =A0 =A0 =A0 =A0jbd_debug(1, "JBD: commit %d complete, head %d\n",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0journal->j_commit_sequence, journa=
l->j_tail_sequence);
> =A0 =A0 =A0 =A0if (to_free)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(commit_transaction);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 jbd2_free_transaction(commit_transactio=
n);
>
> =A0 =A0 =A0 =A0wake_up(&journal->j_wait_done_commit);
> =A0}
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 9a78269..61e0206 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -95,6 +95,7 @@ EXPORT_SYMBOL(jbd2_journal_init_jbd_inode);
> =A0EXPORT_SYMBOL(jbd2_journal_release_jbd_inode);
> =A0EXPORT_SYMBOL(jbd2_journal_begin_ordered_truncate);
> =A0EXPORT_SYMBOL(jbd2_inode_cache);
> +EXPORT_SYMBOL(jbd2_transaction_cache);
>
> =A0static int journal_convert_superblock_v1(journal_t *, journal_supe=
rblock_t *);
> =A0static void __journal_abort_soft (journal_t *journal, int errno);
> @@ -2371,6 +2372,27 @@ static void jbd2_journal_destroy_handle_cache(=
void)
>
> =A0}
>
> +struct kmem_cache *jbd2_transaction_cache;
> +
> +static int journal_init_transaction_cache(void)
> +{
> + =A0 =A0 =A0 J_ASSERT(jbd2_transaction_cache =3D=3D NULL);
> + =A0 =A0 =A0 jbd2_transaction_cache =3D kmem_cache_create("jbd2_tran=
saction",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sizeof(transaction_t),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00, 0, NULL);
> + =A0 =A0 =A0 if (jbd2_transaction_cache =3D=3D NULL) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_EMERG "JBD2: failed to crea=
te transaction cache\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 return 0;
> +}
> +
> +static void jbd2_journal_destroy_transaction_cache(void)
> +{
> + =A0 =A0 =A0 if (jbd2_transaction_cache)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 kmem_cache_destroy(jbd2_transaction_cac=
he);
> +}
> +
> =A0/*
> =A0* Module startup and shutdown
> =A0*/
> @@ -2384,6 +2406,8 @@ static int __init journal_init_caches(void)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D journal_init_jbd2_journal_head=
_cache();
> =A0 =A0 =A0 =A0if (ret =3D=3D 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D journal_init_handle_cache();
> + =A0 =A0 =A0 if (ret =3D=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D journal_init_transaction_cache(=
);
> =A0 =A0 =A0 =A0return ret;
> =A0}
>
> @@ -2392,6 +2416,7 @@ static void jbd2_journal_destroy_caches(void)
> =A0 =A0 =A0 =A0jbd2_journal_destroy_revoke_caches();
> =A0 =A0 =A0 =A0jbd2_journal_destroy_jbd2_journal_head_cache();
> =A0 =A0 =A0 =A0jbd2_journal_destroy_handle_cache();
> + =A0 =A0 =A0 jbd2_journal_destroy_transaction_cache();
> =A0 =A0 =A0 =A0jbd2_journal_destroy_slabs();
> =A0}
>
> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> index 3eec82d..58fbec7 100644
> --- a/fs/jbd2/transaction.c
> +++ b/fs/jbd2/transaction.c
> @@ -131,7 +131,7 @@ static int start_this_handle(journal_t *journal, =
handle_t *handle,
>
> =A0alloc_transaction:
> =A0 =A0 =A0 =A0if (!journal->j_running_transaction) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 new_transaction =3D kzalloc(sizeof(*new=
_transaction), gfp_mask);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 new_transaction =3D jbd2_alloc_transact=
ion(gfp_mask);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!new_transaction) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * If __GFP_FS is not =
present, then we may be
> @@ -160,7 +160,7 @@ repeat:
> =A0 =A0 =A0 =A0if (is_journal_aborted(journal) ||
> =A0 =A0 =A0 =A0 =A0 =A0(journal->j_errno !=3D 0 && !(journal->j_flags=
 & JBD2_ACK_ERR))) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0read_unlock(&journal->j_state_lock);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(new_transaction);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 jbd2_free_transaction(new_transaction);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EROFS;
> =A0 =A0 =A0 =A0}
>
> @@ -282,7 +282,8 @@ repeat:
> =A0 =A0 =A0 =A0read_unlock(&journal->j_state_lock);
>
> =A0 =A0 =A0 =A0lock_map_acquire(&handle->h_lockdep_map);
> - =A0 =A0 =A0 kfree(new_transaction);
> + =A0 =A0 =A0 jbd2_free_transaction(new_transaction);
> +
> =A0 =A0 =A0 =A0return 0;
> =A0}
>
> diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
> index 4ecb7b1..803b5c4 100644
> --- a/include/linux/jbd2.h
> +++ b/include/linux/jbd2.h
> @@ -1184,6 +1184,23 @@ static inline void jbd2_free_handle(handle_t *=
handle)
> =A0}
>
> =A0/*
> + * transaction management
> + */
> +extern struct kmem_cache *jbd2_transaction_cache;
> +
> +static inline transaction_t *jbd2_alloc_transaction(gfp_t gfp_flags)
> +{
> + =A0 =A0 =A0 return kmem_cache_zalloc(jbd2_transaction_cache, gfp_fl=
ags);
> +}
> +
> +static inline void jbd2_free_transaction(transaction_t *transaction)
> +{
> + =A0 =A0 =A0 if (transaction)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 kmem_cache_free(jbd2_transaction_cache,=
 transaction);
> +}
> +
> +
> +/*
> =A0* jbd2_inode management (optional, for those file systems that wan=
t to use
> =A0* dynamically allocated jbd2_inode structures)
> =A0*/
> --
> 1.7.4.1
>
>

Hi Ted,

Any feedback on this ?


--=20
Thanks -
Manish
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
