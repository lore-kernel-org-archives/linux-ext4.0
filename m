From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: [PATCH] jbd2: instrument jh on wrong transaction BUG_ON's
Date: Sun, 14 Aug 2011 13:01:01 -0700
Message-ID: <CAO81RMauzwN6HmutW+3fqH_Oif0trm34G1BPUiyZz6qmiZkY8w@mail.gmail.com>
References: <1313290418-12695-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:41696 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754958Ab1HNUBG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 14 Aug 2011 16:01:06 -0400
Received: from wpaz17.hot.corp.google.com (wpaz17.hot.corp.google.com [172.24.198.81])
	by smtp-out.google.com with ESMTP id p7EK13Qg015737
	for <linux-ext4@vger.kernel.org>; Sun, 14 Aug 2011 13:01:03 -0700
Received: from qyk31 (qyk31.prod.google.com [10.241.83.159])
	by wpaz17.hot.corp.google.com with ESMTP id p7EK11Od002536
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Sun, 14 Aug 2011 13:01:02 -0700
Received: by qyk31 with SMTP id 31so2799921qyk.4
        for <linux-ext4@vger.kernel.org>; Sun, 14 Aug 2011 13:01:01 -0700 (PDT)
In-Reply-To: <1313290418-12695-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted:

Unfortunately, some deref in your printk didn't go over too well:

[  970.871166] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000008
[  970.872139] IP: [<ffffffff812a158e>] jbd2_journal_dirty_metadata+0x1=
8e/0x220
[  970.872139] PGD 857b8d067 PUD 852f26067 PMD 0
[  970.872139] Oops: 0000 [#1] SMP
[  970.872139] CPU 14
=2E..
[  970.872139] Call Trace:
[  970.872139]  [<ffffffff812a9d26>] ? jbd2_journal_add_journal_head+0x=
86/0x290
[  970.872139]  [<ffffffff8125c87c>] ? __ext4_journalled_writepage+0xac=
/0x390
[  970.872139]  [<ffffffff812848b3>] __ext4_handle_dirty_metadata+0x83/=
0x120
[  970.872139]  [<ffffffff81284c1e>] ? __ext4_journal_get_write_access+=
0x3e/0x80
[  970.872139]  [<ffffffff8125cac8>] __ext4_journalled_writepage+0x2f8/=
0x390
[  970.872139]  [<ffffffff8125e264>] ext4_writepage+0x234/0x2f0
[  970.872139]  [<ffffffff81155ad7>] __writepage+0x17/0x40
=2E..

where the IP corresponds to:

(gdb) list *0xffffffff812a158e
0xffffffff812a158e is in jbd2_journal_dirty_metadata
(fs/jbd2/transaction.c:1124).
1119             */
1120            if (jh->b_transaction !=3D transaction) {
1121                    JBUFFER_TRACE(jh, "already on other transaction=
");
1122                    if (unlikely(jh->b_transaction !=3D
1123                                 journal->j_committing_transaction)=
) {
1124                            printk(KERN_EMERG "JBD: %s: "
1125                                   "jh->b_transaction (%llu, %p, %u=
) !=3D "
1126
"journal->j_committing_transaction (%p, %u)",
1127                                   journal->j_devname,
1128                                   (unsigned long long) bh->b_block=
nr,

It seems that  jh->b_transaction is NULL, and deferencing it to print
out jh->b_transaction->t_tid causes the NULL pointer deref.

Curt

On Sat, Aug 13, 2011 at 7:53 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> These assertions have been reported as being tripped. =A0Instrument t=
hem
> so we get more information about what might be going on.
>
> Cc: curtw@google.com
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>
> Curt, you might want to see if you can replicate that jbd2 crash with
> this patch applied. =A0Hopefully we'll get more information about wha=
t is
> going on.
>
> =A0fs/jbd2/transaction.c | =A0 42 +++++++++++++++++++++++++++++++++++=
++-----
> =A01 files changed, 37 insertions(+), 5 deletions(-)
>
> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> index 2d71094..693fe63 100644
> --- a/fs/jbd2/transaction.c
> +++ b/fs/jbd2/transaction.c
> @@ -1093,8 +1093,19 @@ int jbd2_journal_dirty_metadata(handle_t *hand=
le, struct buffer_head *bh)
> =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0if (jh->b_transaction =3D=3D transaction && jh->b_jlis=
t =3D=3D BJ_Metadata) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0JBUFFER_TRACE(jh, "fastpath");
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 J_ASSERT_JH(jh, jh->b_transaction =3D=3D
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 journal->j_running_transaction);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (unlikely(jh->b_transaction !=3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0journal->j_r=
unning_transaction)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_EMERG "JBD:=
 %s: "
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"jh->b_t=
ransaction (%llu, %p, %u) !=3D "
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"journal=
->j_running_transaction (%p, %u)",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0journal-=
>j_devname,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(unsigne=
d long long) bh->b_blocknr,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0jh->b_tr=
ansaction,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0jh->b_tr=
ansaction->t_tid,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0journal-=
>j_running_transaction,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0journal-=
>j_running_transaction->t_tid);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUG_ON(1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out_unlock_bh;
> =A0 =A0 =A0 =A0}
>
> @@ -1108,9 +1119,30 @@ int jbd2_journal_dirty_metadata(handle_t *hand=
le, struct buffer_head *bh)
> =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0if (jh->b_transaction !=3D transaction) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0JBUFFER_TRACE(jh, "already on other tr=
ansaction");
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 J_ASSERT_JH(jh, jh->b_transaction =3D=3D
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 journal->j_committing_transaction);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 J_ASSERT_JH(jh, jh->b_next_transaction =
=3D=3D transaction);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (unlikely(jh->b_transaction !=3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0journal->j_c=
ommitting_transaction)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_EMERG "JBD:=
 %s: "
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"jh->b_t=
ransaction (%llu, %p, %u) !=3D "
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"journal=
->j_committing_transaction (%p, %u)",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0journal-=
>j_devname,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(unsigne=
d long long) bh->b_blocknr,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0jh->b_tr=
ansaction,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0jh->b_tr=
ansaction->t_tid,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0journal-=
>j_committing_transaction,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0journal-=
>j_committing_transaction->t_tid);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUG_ON(1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (unlikely(jh->b_next_transaction !=3D=
 transaction)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_EMERG "JBD:=
 %s: "
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"jh->b_n=
ext_transaction (%llu, %p, %u) !=3D "
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"transac=
tion (%p, %u)",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0journal-=
>j_devname,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(unsigne=
d long long) bh->b_blocknr,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0jh->b_ne=
xt_transaction,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0jh->b_ne=
xt_transaction->t_tid,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0transact=
ion, transaction->t_tid);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUG_ON(1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* And this case is illegal: we can't =
reuse another
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * transaction's data buffer, ever. */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out_unlock_bh;
> --
> 1.7.4.1.22.gec8e1.dirty
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
