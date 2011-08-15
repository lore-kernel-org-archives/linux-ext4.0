From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: [PATCH -v2] jbd2: instrument jh on wrong transaction BUG_ON's
Date: Mon, 15 Aug 2011 09:18:14 -0700
Message-ID: <CAO81RMYGK18-_5OKjeBzyku7AYUioJgGAic12Tyt87zMuvnVWQ@mail.gmail.com>
References: <CAO81RMauzwN6HmutW+3fqH_Oif0trm34G1BPUiyZz6qmiZkY8w@mail.gmail.com>
	<1313374319-1792-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:25938 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab1HOQSS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Aug 2011 12:18:18 -0400
Received: from wpaz24.hot.corp.google.com (wpaz24.hot.corp.google.com [172.24.198.88])
	by smtp-out.google.com with ESMTP id p7FGIG4c017281
	for <linux-ext4@vger.kernel.org>; Mon, 15 Aug 2011 09:18:16 -0700
Received: from qwc9 (qwc9.prod.google.com [10.241.193.137])
	by wpaz24.hot.corp.google.com with ESMTP id p7FGHOqK025296
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Mon, 15 Aug 2011 09:18:15 -0700
Received: by qwc9 with SMTP id 9so3173055qwc.41
        for <linux-ext4@vger.kernel.org>; Mon, 15 Aug 2011 09:18:15 -0700 (PDT)
In-Reply-To: <1313374319-1792-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted:

With your latest patch, here's the console output.  And no, there are
no interesting messages prior to the crash.

 [  727.933568] general protection fault: 0000 [#1] SMP
[  727.934001] CPU 2
[  727.934001] Modules linked in: loop tg3 msr cpuid ipv6 genrtc
[  727.934001]
[  727.934001] Pid: 9238, comm: flush-8:16 Not tainted 3.1.0-smp-ext4_t=
est
[  727.934001] RIP: 0010:[<ffffffff812a159f>]  [<ffffffff812a159f>]
jbd2_journal_dirty_metadata+0x19f/0x240
=2E..
[  727.934001] Process flush-8:16 (pid: 9238, threadinfo
ffff88076c8ec000, task ffff880852529800)
[  727.934001] Stack:
[  727.934001]  ffff88076c8ed840 ffffffff812a9d46 ffffffff8125c87c
ffff8808577de540
[  727.934001]  ffff880641c32850 0000000000000000 ffff880641c32850
ffff880663985958
[  727.934001]  000000000000033d ffffffff81640bea ffff88076c8ed8a0
ffffffff812848b3
[  727.934001] Call Trace:
[  727.934001]  [<ffffffff812a9d46>] ? jbd2_journal_add_journal_head+0x=
86/0x290
[  727.934001]  [<ffffffff8125c87c>] ? __ext4_journalled_writepage+0xac=
/0x390
[  727.934001]  [<ffffffff812848b3>] __ext4_handle_dirty_metadata+0x83/=
0x120
[  727.934001]  [<ffffffff81284c1e>] ? __ext4_journal_get_write_access+=
0x3e/0x80
[  727.934001]  [<ffffffff8125cac8>] __ext4_journalled_writepage+0x2f8/=
0x390
[  727.934001]  [<ffffffff8125e264>] ext4_writepage+0x234/0x2f0
[  727.934001]  [<ffffffff81155ad7>] __writepage+0x17/0x40
[  727.934001]  [<ffffffff811574ae>] write_cache_pages+0x29e/0x6d0
[  727.934001]  [<ffffffff813ec4d7>] ? scsi_request_fn+0xd7/0x580
[  727.934001]  [<ffffffff81155ac0>] ? set_page_dirty+0x70/0x70
[  727.934001]  [<ffffffff81157931>] generic_writepages+0x51/0x80
=2E..

where 0xffffffff812a159f is in the printk() , line 1126; it looks like
journal->j_committing_transaction is not NULL, but isn't valid either:

   0xffffffff812a1597 <+407>:   xor    %r8d,%r8d  ; put 0 into %r8d
   0xffffffff812a159a <+410>:   test   %rcx,%rcx  ; %rcx is
journal->j_committing_transaction, I think
   0xffffffff812a159d <+413>:   je     0xffffffff812a15a3
<jbd2_journal_dirty_metadata+419>  ; if 0, jump over next instruction
   0xffffffff812a159f <+415>:   mov    0x8(%rcx),%r8d ; put ->t_tid int=
o %r8d

I reformatted/mounted both the main and scratch devices before running
the test, and

export EXT_MOUNT_OPTIONS=3D"-o block_validity,data=3Djournal"
export MKFS_OPTIONS=3D"-t ext4 -O has_journal"

Curt

On Sun, Aug 14, 2011 at 7:11 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> These assertions have been reported as being tripped. =A0Instrument t=
hem
> so we get more information about what might be going on.
>
> Cc: curtw@google.com
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
> =A0fs/jbd2/transaction.c | =A0 46 +++++++++++++++++++++++++++++++++++=
++++++-----
> =A01 files changed, 41 insertions(+), 5 deletions(-)
>
> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> index 2d71094..a242f6f 100644
> --- a/fs/jbd2/transaction.c
> +++ b/fs/jbd2/transaction.c
> @@ -1093,8 +1093,20 @@ int jbd2_journal_dirty_metadata(handle_t *hand=
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
ansaction ? jh->b_transaction->t_tid : 0,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0journal-=
>j_running_transaction,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0journal-=
>j_running_transaction ?
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0jour=
nal->j_running_transaction->t_tid : 0);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUG_ON(1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out_unlock_bh;
> =A0 =A0 =A0 =A0}
>
> @@ -1108,9 +1120,33 @@ int jbd2_journal_dirty_metadata(handle_t *hand=
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
ansaction ? jh->b_transaction->t_tid : 0,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0journal-=
>j_committing_transaction,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0journal-=
>j_committing_transaction ?
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0jour=
nal->j_committing_transaction->t_tid : 0);
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
xt_transaction ?
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0jh->=
b_next_transaction->t_tid : 0,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0transact=
ion,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0transact=
ion ? transaction->t_tid : 0);
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
