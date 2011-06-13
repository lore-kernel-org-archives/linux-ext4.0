From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd2:Make journal transaction allocations come from
 its own cache.
Date: Mon, 13 Jun 2011 15:31:00 +0200
Message-ID: <20110613133100.GB4907@quack.suse.cz>
References: <1307262510-16376-1-git-send-email-mkatiyar@gmail.com>
 <20110608164903.GG5361@quack.suse.cz>
 <BANLkTinoTeVUACvQ6OV1s8BNi9vmi8fd+Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, tytso@mit.edu, linux-ext4@vger.kernel.org
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58331 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580Ab1FMNbC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Jun 2011 09:31:02 -0400
Content-Disposition: inline
In-Reply-To: <BANLkTinoTeVUACvQ6OV1s8BNi9vmi8fd+Q@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 09-06-11 23:21:17, Manish Katiyar wrote:
> On Wed, Jun 8, 2011 at 9:49 AM, Jan Kara <jack@suse.cz> wrote:
> > On Sun 05-06-11 01:28:30, Manish Katiyar wrote:
> >> Add a cache for jbd2 journal transaction allocations. This also
> >> helps to leverage fault-injection framework to test various memory
> >> allocation failures in the jbd2 layer.
> >>
> >> Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
> >> ---
> >> =A0fs/jbd2/checkpoint.c =A0| =A0 =A02 +-
> >> =A0fs/jbd2/commit.c =A0 =A0 =A0| =A0 =A02 +-
> >> =A0fs/jbd2/journal.c =A0 =A0 | =A0 25 +++++++++++++++++++++++++
> >> =A0fs/jbd2/transaction.c | =A0 =A07 ++++---
> >> =A0include/linux/jbd2.h =A0| =A0 21 +++++++++++++++++++++
> >> =A05 files changed, 52 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
> >> index 6a79fd0..6f554ce 100644
> >> --- a/fs/jbd2/checkpoint.c
> >> +++ b/fs/jbd2/checkpoint.c
> >> @@ -716,7 +716,7 @@ int __jbd2_journal_remove_checkpoint(struct jo=
urnal_head *jh)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 transaction->t_tid, stats);
> >>
> >> =A0 =A0 =A0 __jbd2_journal_drop_transaction(journal, transaction);
> >> - =A0 =A0 kfree(transaction);
> >> + =A0 =A0 jbd2_free_transaction(transaction);
> >>
> >> =A0 =A0 =A0 /* Just in case anybody was waiting for more transacti=
ons to be
> >> =A0 =A0 =A0 =A0 =A0 =A0 checkpointed... */
> >> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> >> index 7f21cf3..8e33d84 100644
> >> --- a/fs/jbd2/commit.c
> >> +++ b/fs/jbd2/commit.c
> >> @@ -1037,7 +1037,7 @@ restart_loop:
> >> =A0 =A0 =A0 jbd_debug(1, "JBD: commit %d complete, head %d\n",
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 journal->j_commit_sequence, journa=
l->j_tail_sequence);
> >> =A0 =A0 =A0 if (to_free)
> >> - =A0 =A0 =A0 =A0 =A0 =A0 kfree(commit_transaction);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 jbd2_free_transaction(commit_transaction=
);
> >>
> >> =A0 =A0 =A0 wake_up(&journal->j_wait_done_commit);
> >> =A0}
> >> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> >> index 9a78269..c0ec463 100644
> >> --- a/fs/jbd2/journal.c
> >> +++ b/fs/jbd2/journal.c
> >> @@ -95,6 +95,7 @@ EXPORT_SYMBOL(jbd2_journal_init_jbd_inode);
> >> =A0EXPORT_SYMBOL(jbd2_journal_release_jbd_inode);
> >> =A0EXPORT_SYMBOL(jbd2_journal_begin_ordered_truncate);
> >> =A0EXPORT_SYMBOL(jbd2_inode_cache);
> >> +EXPORT_SYMBOL(jbd2_transaction_cache);
> >>
> >> =A0static int journal_convert_superblock_v1(journal_t *, journal_s=
uperblock_t *);
> >> =A0static void __journal_abort_soft (journal_t *journal, int errno=
);
> >> @@ -2371,6 +2372,27 @@ static void jbd2_journal_destroy_handle_cac=
he(void)
> >>
> >> =A0}
> >>
> >> +struct kmem_cache *jbd2_transaction_cache;
> >> +
> >> +static int journal_init_transaction_cache(void)
> >> +{
> >> + =A0 =A0 J_ASSERT(jbd2_transaction_cache =3D=3D NULL);
> >> + =A0 =A0 jbd2_transaction_cache =3D kmem_cache_create("jbd2_trans=
action",
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sizeof(transaction_t),
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00, SLAB_TEMPORARY, NULL);
> > =A0Transactions are not really short-lived in the memory-management=
 sense I
> > think. They usually live for seconds while I'd understand 'short-li=
ved' to
> > mean a milisecond or less. So just drop this flag (it doesn't do an=
ything
> > these days anyway).
> >
> >> + =A0 =A0 if (jbd2_transaction_cache =3D=3D NULL) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_EMERG "JBD2: failed to creat=
e transaction cache\n");
> >> + =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
> >> + =A0 =A0 }
> >> + =A0 =A0 return 0;
> >> +}
> >> +
> >> +static void jbd2_journal_destroy_transaction_cache(void)
> >> +{
> >> + =A0 =A0 if (jbd2_transaction_cache)
> > =A0How can this happen?
>=20
> Hi Jan,
>=20
> re-reading the code, I think its possible and we should be checking
> for it. Since in journal_init_caches() if any of the initialization
> fails we would call jbd2_journal_destroy_caches() on all the caches.
> So we should be destroying it only if its initialized.
  Ah, good point. Thanks for checking this.

								Honza
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
