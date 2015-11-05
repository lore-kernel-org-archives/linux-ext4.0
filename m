From: Jan Kara <jack@suse.cz>
Subject: Re: JBD2 issue unnecessary journal commit mark I/O
Date: Thu, 5 Nov 2015 16:03:49 +0100
Message-ID: <20151105150349.GB23628@quack.suse.cz>
References: <CAJKSsyDG26b9n-me+U=nZw6ZNLzwXmGapU3J=8ejHjQjuRP1OQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Eunryoung Lim <eunryoung.lim@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50307 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1032707AbbKEPDw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Nov 2015 10:03:52 -0500
Content-Disposition: inline
In-Reply-To: <CAJKSsyDG26b9n-me+U=nZw6ZNLzwXmGapU3J=8ejHjQjuRP1OQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 28-10-15 17:19:02, Eunryoung Lim wrote:
> Hello,
>=20
> I am Eunryoung Lim and have a question about EXT4 journaling source.
> I will be appreciated for your any comments.
>=20
> * ordered journaling mode, disabled async_jounral_commit
> On my understating, below steps is the simple process of journal
> transaction commit (jbd2_journal_commit_transaction() ).
> Step 1,3,4 are optional.
>=20
> 1. Write journal revoke block (if it required).
> 2. Write journal descriptor + journal buffer=E2=80=99s page.
> 3. Submit all the data buffers of inode associated with the
> transaction (journal_submit_data_buffers() ) (if it required).
> 4. Wait for data submitted for writeback page
> (journal_finish_inode_data_buffers() ) (if it required).
> 5. Write journal commit mark.
>=20
> The problem is that JBD2 issue unnecessary journal commit mark I/O.
> For example, JBD2 write journal commit mark (step 5), even though
> transaction (running ->commit state) has no journal buffer yet.
> The I/O for journal descriptor + journal buffer=E2=80=99s page (step =
2) can be
> skipped because JBD2 check whether the transaction has journal buffer
> or not.
> void jbd2_journal_commit_transaction(journal_t *journal)
> {
>             =E2=80=A6.
>             /* start to commit transaction */
>             while (commit_transaction->t_buffers) {
>             /* Find the next buffer to be journaled... */
>             jh =3D commit_transaction->t_buffers;
>             .=E2=80=A6
> }
>=20
> I think, if the journal buffers do not exist in the transaction, JBD2
> can skip step 5 to reduce amount of I/O.
> Thus, the code can be modified as follows: (this is simple way, we ca=
n
> optimize more)
> (current)
>         err =3D journal_submit_commit_record(journal, commit_transact=
ion,
> (after)
>         if ( IS_ERR_OR_NULL(commit_transaction->t_buffers) ) {
>         err =3D journal_submit_commit_record(journal, commit_transact=
ion,
> }
> or we can simply return the function.
> (add)if ( IS_ERR_OR_NULL(commit_transaction->t_buffers) )
>             return ;
>=20
>         /* start to commit transaction */
>         while (commit_transaction->t_buffers) {
>         ....
>=20
> Note. Android uses SQLite, and it makes sure that directory entry
> contains newly created journal file by calling fsync() to the
> directory.
> (However, SQLite call fsync() to directory even though the file is no=
t created).
> When fsync() is called to directory,
> EXT4 calls ext4_sync_file() -> ext4_force_commit() ->
> ext4_journal_force_commit() -> jbd2_journal_force_commit() -> ... and
> finally, jbd2_journal_commit_transaction();
> If journal transaction is empty, JBD2 only write journal commit mark
> and it causes lots of I/Os.

However note that __jbd2_journal_force_commit() doesn't do anything if
there isn't running transaction. Are you sure the commit contains only =
the
commit block? It is possible but someone would have to call
jbd2_journal_start() and then don't dirty any buffers...

=46rankly, skipping empty commit seems like a rather special case and s=
olving
the problem at the wrong level. I think we rather shouldn't force the
transaction commit if the directory is unchanged. We can use i_sync_tid=
 in
a similar way as we do for regular files, we just have to add that trac=
king
into directory code. That would save us much more commits.

								Honza
--=20
Jan Kara <jack@suse.com>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
