From: Eunryoung Lim <eunryoung.lim@gmail.com>
Subject: JBD2 issue unnecessary journal commit mark I/O
Date: Wed, 28 Oct 2015 17:19:02 +0900
Message-ID: <CAJKSsyDG26b9n-me+U=nZw6ZNLzwXmGapU3J=8ejHjQjuRP1OQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:36565 "EHLO
	mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932588AbbJ1ITD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Oct 2015 04:19:03 -0400
Received: by ioll68 with SMTP id l68so2434154iol.3
        for <linux-ext4@vger.kernel.org>; Wed, 28 Oct 2015 01:19:02 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

I am Eunryoung Lim and have a question about EXT4 journaling source.
I will be appreciated for your any comments.

* ordered journaling mode, disabled async_jounral_commit
On my understating, below steps is the simple process of journal
transaction commit (jbd2_journal_commit_transaction() ).
Step 1,3,4 are optional.

1. Write journal revoke block (if it required).
2. Write journal descriptor + journal buffer=E2=80=99s page.
3. Submit all the data buffers of inode associated with the
transaction (journal_submit_data_buffers() ) (if it required).
4. Wait for data submitted for writeback page
(journal_finish_inode_data_buffers() ) (if it required).
5. Write journal commit mark.

The problem is that JBD2 issue unnecessary journal commit mark I/O.
=46or example, JBD2 write journal commit mark (step 5), even though
transaction (running ->commit state) has no journal buffer yet.
The I/O for journal descriptor + journal buffer=E2=80=99s page (step 2)=
 can be
skipped because JBD2 check whether the transaction has journal buffer
or not.
void jbd2_journal_commit_transaction(journal_t *journal)
{
            =E2=80=A6.
            /* start to commit transaction */
            while (commit_transaction->t_buffers) {
            /* Find the next buffer to be journaled... */
            jh =3D commit_transaction->t_buffers;
            .=E2=80=A6
}

I think, if the journal buffers do not exist in the transaction, JBD2
can skip step 5 to reduce amount of I/O.
Thus, the code can be modified as follows: (this is simple way, we can
optimize more)
(current)
        err =3D journal_submit_commit_record(journal, commit_transactio=
n,
(after)
        if ( IS_ERR_OR_NULL(commit_transaction->t_buffers) ) {
        err =3D journal_submit_commit_record(journal, commit_transactio=
n,
}
or we can simply return the function.
(add)if ( IS_ERR_OR_NULL(commit_transaction->t_buffers) )
            return ;

        /* start to commit transaction */
        while (commit_transaction->t_buffers) {
        ....

Note. Android uses SQLite, and it makes sure that directory entry
contains newly created journal file by calling fsync() to the
directory.
(However, SQLite call fsync() to directory even though the file is not =
created).
When fsync() is called to directory,
EXT4 calls ext4_sync_file() -> ext4_force_commit() ->
ext4_journal_force_commit() -> jbd2_journal_force_commit() -> ... and
finally, jbd2_journal_commit_transaction();
If journal transaction is empty, JBD2 only write journal commit mark
and it causes lots of I/Os.


Thanks,
Eunryoung Lim.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
