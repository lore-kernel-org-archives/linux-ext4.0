From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH][RFC] jbd2: jbd2_journal_stop needs an exclusive control
 to synchronize around t_updates operations
Date: Fri, 16 Dec 2011 20:22:15 +0800
Message-ID: <CAGBYx2YZ4M8QwwOcnLAaf+934WAcZoNS_pPrw8j3Nkr3=6fA5g@mail.gmail.com>
References: <20111216201915.4a012154.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39348 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989Ab1LPMWQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Dec 2011 07:22:16 -0500
Received: by ggdk6 with SMTP id k6so2646821ggd.19
        for <linux-ext4@vger.kernel.org>; Fri, 16 Dec 2011 04:22:15 -0800 (PST)
In-Reply-To: <20111216201915.4a012154.toshi.okajima@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 16, 2011 at 7:19 PM, Toshiyuki Okajima
<toshi.okajima@jp.fujitsu.com> wrote:
> Hi.
>
> I found a bug by executing the following reproducer (needs tuning).
> (The reproducer never ends.)
>
> I wrote it for a confirmation of
> =A0"[PATCH 1/5] ext4: allocate delalloc blocks before changing journa=
l mode".
> Therefore, without
> =A0"[PATCH 1/5] ext4: allocate delalloc blocks before changing journa=
l mode"
> patch, the other problem (panic) which the patch describes can happen=
 more
> frequently:
> ---------------------------------------------------------------------=
----------
> #!/bin/sh
>
> date
> LOOP=3D100000
> dd if=3D/dev/zero of=3D/tmp/ext4.img bs=3D1k count=3D1000k
> /sbin/mkfs.ext4 -Fq /tmp/ext4.img
> mount -o loop /tmp/ext4.img /mnt
> rm -f /mnt/file
> echo "0" > /mnt/file
> (while [ 1 ]; do dd if=3D/dev/zero of=3D/mnt/file2 bs=3D4k > /dev/nul=
l 2>&1; done) &
> PID=3D$!
> for ((i=3D0; i < LOOP; i++));
> do
> =A0 =A0 =A0 =A0DATE=3D$(date)
> =A0 =A0 =A0 =A0echo -n "[LOOP $i] $DATE"
> =A0 =A0 =A0 =A0if ((i%2 =3D=3D 0));
> =A0 =A0 =A0 =A0then
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0chattr +j /mnt/file
> =A0 =A0 =A0 =A0else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0chattr -j /mnt/file
> =A0 =A0 =A0 =A0fi
> =A0 =A0 =A0 =A0echo "0" >> /mnt/file
> done
> kill -9 $PID
> rm -f /mnt/file*
> umount /mnt
> exit 0
> ---------------------------------------------------------------------=
----------
> Though I ran it, it never ended forever.
> (At one of my tries to reproduce the hang, the reproducer stopped in =
6
> hours.)
>
> Because jbd2_journal_lock_updates() never returns from schedule()
> after prepare_to_wait().
>
> The detailed explanation is as follows:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> Current implementation of jbd2_journal_stop() has a bug not to synchr=
onize
> t_updates with other operators, jbd2_journal_lock_updates(), start_th=
is_handle()
IMHO, the description is not very exactly, the problem is not due to
desync of t_updates, t_updates is a var of atomic_t.   The reason is
that we have a critical code section here:[operation on t_updates,
wait or wakeup], this section should be synchronized.

> and jbd2_journal_commit_transaction().
>
> This bug was derived from commit: c35a56a090eacefca07afeb994029b57d8d=
d8025 and
> =A0commit: 8dd420466c7bfc459fa04680bd5690bfc41a4553.
>
> ---------------------------
> jbd2_journal_lock_updates()
> ---------------------------
> =A0509 =A0 =A0 =A0 =A0 write_lock(&journal->j_state_lock);
> =A0510 =A0 =A0 =A0 =A0 ++journal->j_barrier_count;
> ...
> =A0513 =A0 =A0 =A0 =A0 while (1) {
> ...
> =A0519 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&transaction->t_hand=
le_lock);
> =A0520 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!atomic_read(&transaction-=
>t_updates)) {
> =A0521 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&t=
ransaction->t_handle_lock);
> =A0522 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> =A0523 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> =A0524 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 prepare_to_wait(&journal->j_wa=
it_updates, &wait,
> =A0525 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 TASK_UNINTERRUPTIBLE);
> =A0526 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&transaction->t_ha=
ndle_lock);
It seems that t_handle_lock is used to protect the critical section
here.   I think t_handle is not needed here at all.   t_handle_lock
should be used to protect transaction and j_state_lock should be used
to protect journal.  prepare_to_wait operates on journal, so we should
remove t_handle_lock here.

> =A0527 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 write_unlock(&journal->j_state=
_lock);
> =A0528 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 schedule();
> =A0529 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 finish_wait(&journal->j_wait_u=
pdates, &wait);
> =A0530 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 write_lock(&journal->j_state_l=
ock);
> =A0531 =A0 =A0 =A0 =A0 }
> =A0532 =A0 =A0 =A0 =A0 write_unlock(&journal->j_state_lock);
>
> * The operation of t_updates is protected by write_lock(&journal->j_s=
tate_lock)
> =A0and spin_lock(&transaction->t_handle_lock).
>
> -------------------
> start_this_handle()
> -------------------
> =A0160 =A0 =A0 =A0 =A0 read_lock(&journal->j_state_lock);
> ...
> =A0278 =A0 =A0 =A0 =A0 atomic_inc(&transaction->t_updates);
> ...
> =A0284 =A0 =A0 =A0 =A0 read_unlock(&journal->j_state_lock);
>
> * The operation of t_updates is protected by read_lock(&journal->j_st=
ate_lock).
>
> ---------------------------------
> jbd2_journal_commit_transaction()
> ---------------------------------
> =A0358 =A0 =A0 =A0 =A0 write_lock(&journal->j_state_lock);
> ...
> =A0367 =A0 =A0 =A0 =A0 spin_lock(&commit_transaction->t_handle_lock);
> =A0368 =A0 =A0 =A0 =A0 while (atomic_read(&commit_transaction->t_upda=
tes)) {
> =A0369 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 DEFINE_WAIT(wait);
> =A0370
> =A0371 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 prepare_to_wait(&journal->j_wa=
it_updates, &wait,
> =A0372 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 TASK_UNINTERRUPTIBLE);
> =A0373 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (atomic_read(&commit_transa=
ction->t_updates)) {
> =A0374 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&c=
ommit_transaction->t_handle_lock);
Also, t_handle_lock is used to protect the critical section.  I think
t_handle_lock is not needed here at all.

> =A0375 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 write_unlock(&=
journal->j_state_lock);
> =A0376 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 schedule();
> =A0377 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 write_lock(&jo=
urnal->j_state_lock);
> =A0378 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&com=
mit_transaction->t_handle_lock);
> =A0379 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> =A0380 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 finish_wait(&journal->j_wait_u=
pdates, &wait);
> =A0381 =A0 =A0 =A0 =A0 }
> =A0382 =A0 =A0 =A0 =A0 spin_unlock(&commit_transaction->t_handle_lock=
);
> ...
> =A0447 =A0 =A0 =A0 =A0 wake_up(&journal->j_wait_transaction_locked);
> =A0448 =A0 =A0 =A0 =A0 write_unlock(&journal->j_state_lock);
>
> * The operation of t_updates is protected by write_lock(&journal->j_s=
tate_lock)
> =A0and spin_lock(&transaction->t_handle_lock).
>
> -------------------
> jbd2_journal_stop()
> -------------------
> ...
> 1452 =A0 =A0 =A0 =A0 if (atomic_dec_and_test(&transaction->t_updates)=
) {
> 1453 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wake_up(&journal->j_wait_updates=
);
> 1454 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (journal->j_barrier_count)
> 1455 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wake_up(&journal=
->j_wait_transaction_locked);
> 1456 =A0 =A0 =A0 =A0 }
> 1457
> 1458 =A0 =A0 =A0 =A0 if (wait_for_commit)
> 1459 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D jbd2_log_wait_commit(jou=
rnal, tid);
> 1460
> 1461 =A0 =A0 =A0 =A0 lock_map_release(&handle->h_lockdep_map);
> 1462
> 1463 =A0 =A0 =A0 =A0 jbd2_free_handle(handle);
> 1464 =A0 =A0 =A0 =A0 return err;
> 1465 }
>
> * The operation of t_updates is not protected.
>
> Therefore,
> - jbd2_journal_lock_updates() sleeps if transaction->t_update is 0.
> - jbd2_journal_stop() tries to wake someone up
> (wake_up(&journal->j_wait_updates)) after transaction->t_updates beco=
mes 0.
> =3D> But jbd2_journal_lock_updates() isn't woken up and then sleeps f=
orever,
> =A0 if it has not yet slept completely.
>
> After we run the reproducer, we can see the processes which become ha=
ng-up.
>
> ---------------------------------------------------------------------=
----------
> crash> ps | grep UN
> =A016645 =A023737 =A0 1 =A0ffff88007a592b20 =A0UN =A0 0.0 =A0105136 =A0=
 =A0508 =A0dd
> =A016684 =A023727 =A0 1 =A0ffff88007a2a9480 =A0UN =A0 0.0 =A0107152 =A0=
 =A0512 =A0chattr
> =A023722 =A0 =A0 =A02 =A0 1 =A0ffff88007b496080 =A0UN =A0 0.0 =A0 =A0=
 =A0 0 =A0 =A0 =A00 =A0[flush-7:0]
>
> [1]
> crash> bt 16645
> PID: 16645 =A0TASK: ffff88007a592b20 =A0CPU: 1 =A0 COMMAND: "dd"
> =A0#0 [ffff88007b575878] __schedule at ffffffff814b9b77
> =A0#1 [ffff88007b575920] schedule at ffffffff814ba3cf
> =A0#2 [ffff88007b575930] start_this_handle at ffffffffa01acef5 [jbd2]
> =A0#3 [ffff88007b5759f0] jbd2__journal_start at ffffffffa01ad4cb [jbd=
2]
> =A0#4 [ffff88007b575a30] jbd2_journal_start at ffffffffa01ad523 [jbd2=
]
> =A0#5 [ffff88007b575a40] ext4_journal_start_sb at ffffffffa03a7d83 [e=
xt4]
> =A0#6 [ffff88007b575ab0] ext4_da_write_begin at ffffffffa038ddce [ext=
4]
> =A0#7 [ffff88007b575b50] generic_file_buffered_write at ffffffff81100=
5ce
> =A0#8 [ffff88007b575c10] __generic_file_aio_write at ffffffff81103418
> =A0#9 [ffff88007b575cd0] generic_file_aio_write at ffffffff811036b6
> #10 [ffff88007b575d50] ext4_file_write at ffffffffa0386ee9 [ext4]
> #11 [ffff88007b575de0] do_sync_write at ffffffff8115de52
> #12 [ffff88007b575f00] vfs_write at ffffffff8115e3e8
> #13 [ffff88007b575f30] sys_write at ffffffff8115e5b1
> #14 [ffff88007b575f80] system_call_fastpath at ffffffff814c3f42
> =A0 =A0RIP: 00000034930d4230 =A0RSP: 00007fffd8176980 =A0RFLAGS: 0000=
0206
> =A0 =A0RAX: 0000000000000001 =A0RBX: ffffffff814c3f42 =A0RCX: 0000000=
000000010
> =A0 =A0RDX: 0000000000001000 =A0RSI: 0000000001ac6000 =A0RDI: 0000000=
000000001
> =A0 =A0RBP: 0000000001ac6000 =A0 R8: 0000000000000003 =A0 R9: 0000000=
000040000
> =A0 =A0R10: 0000000000003003 =A0R11: 0000000000000246 =A0R12: 0000000=
001ac5fff
> =A0 =A0R13: 0000000000000000 =A0R14: 0000000000001000 =A0R15: 0000000=
000000246
> =A0 =A0ORIG_RAX: 0000000000000001 =A0CS: 0033 =A0SS: 002b
>
> [2]
> crash> bt 16684
> PID: 16684 =A0TASK: ffff88007a2a9480 =A0CPU: 1 =A0 COMMAND: "chattr"
> =A0#0 [ffff88007af87ca8] __schedule at ffffffff814b9b77
> =A0#1 [ffff88007af87d50] schedule at ffffffff814ba3cf
> =A0#2 [ffff88007af87d60] jbd2_journal_lock_updates at ffffffffa01acca=
6 [jbd2]
> =A0#3 [ffff88007af87de0] ext4_change_inode_journal_flag at ffffffffa0=
38faf1 [ext4]
> =A0#4 [ffff88007af87e10] ext4_ioctl at ffffffffa0392f48 [ext4]
> =A0#5 [ffff88007af87ea0] do_vfs_ioctl at ffffffff8116fb8a
> =A0#6 [ffff88007af87f30] sys_ioctl at ffffffff811700d1
> =A0#7 [ffff88007af87f80] system_call_fastpath at ffffffff814c3f42
> =A0 =A0RIP: 00000034930d95f7 =A0RSP: 00007fff8830e0d8 =A0RFLAGS: 0001=
0213
> =A0 =A0RAX: 0000000000000010 =A0RBX: ffffffff814c3f42 =A0RCX: 0000003=
4930d95f7
> =A0 =A0RDX: 00007fff8830e17c =A0RSI: 0000000040086602 =A0RDI: 0000000=
000000003
> =A0 =A0RBP: 0000000000084000 =A0 R8: 0000000000000000 =A0 R9: 0000000=
000000001
> =A0 =A0R10: 0000000000000000 =A0R11: 0000000000000246 =A0R12: 00007ff=
f8830f8db
> =A0 =A0R13: 0000000000000001 =A0R14: 0000000000000000 =A0R15: 0000000=
000000003
> =A0 =A0ORIG_RAX: 0000000000000010 =A0CS: 0033 =A0SS: 002b
>
> [3]
> crash> bt 23722
> PID: 23722 =A0TASK: ffff88007b496080 =A0CPU: 1 =A0 COMMAND: "flush-7:=
0"
> =A0#0 [ffff88007b4f7840] __schedule at ffffffff814b9b77
> =A0#1 [ffff88007b4f78e8] schedule at ffffffff814ba3cf
> =A0#2 [ffff88007b4f78f8] start_this_handle at ffffffffa01acef5 [jbd2]
> =A0#3 [ffff88007b4f79b8] jbd2__journal_start at ffffffffa01ad4cb [jbd=
2]
> =A0#4 [ffff88007b4f79f8] jbd2_journal_start at ffffffffa01ad523 [jbd2=
]
> =A0#5 [ffff88007b4f7a08] ext4_journal_start_sb at ffffffffa03a7d83 [e=
xt4]
> =A0#6 [ffff88007b4f7a78] ext4_da_writepages at ffffffffa0390b6d [ext4=
]
> =A0#7 [ffff88007b4f7bc8] do_writepages at ffffffff8110c261
> =A0#8 [ffff88007b4f7bd8] writeback_single_inode at ffffffff81185830
> =A0#9 [ffff88007b4f7c38] writeback_sb_inodes at ffffffff81185e21
> #10 [ffff88007b4f7ce8] __writeback_inodes_wb at ffffffff81185f7e
> #11 [ffff88007b4f7d38] wb_writeback at ffffffff81186223
> #12 [ffff88007b4f7db8] wb_do_writeback at ffffffff811864f9
> #13 [ffff88007b4f7e58] bdi_writeback_thread at ffffffff811865fa
> #14 [ffff88007b4f7ee8] kthread at ffffffff810828c6
> #15 [ffff88007b4f7f48] kernel_thread_helper at ffffffff814c60b4
>
> Step to reproduce a hang-up(figure):
> =A0=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> =A0( "chattr -j" process PID: 16684 ) =A0 =A0 | =A0( a certain proces=
s )
> t =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> i =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 |
> m =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 +---------------------------------------
> e =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 |jbd2_journal_start()
> | =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 +---------------------------------------
> | =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 | . . .
> | =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 | t_updates++ // t_updates =3D 1
> | =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 | . . .
> | =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 +---------------------------------------
> | =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0...
> |---------------------------------------+----------------------------=
-----------
> |jbd2_journal_lock_updates() =A0 =A0 =A0 =A0 =A0 =A0|jbd2_journal_sto=
p()
> |---------------------------------------+----------------------------=
-----------
> | write_lock(&journal->j_state_lock) =A0 =A0| =A0 =A0.
> | ++journal->j_barrier_count =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A0.
> | spin_lock(&tran->t_handle_lock) =A0 =A0 =A0 | =A0 =A0.
> | atomic_read(&tran->t_updates) //not 0 |
> | =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 | atomic_dec_and_test(&tran->t_updates)
> | =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 | =A0 =A0// t_updates =3D 0
> | =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 | wake_up(&journal->j_wait_updates)
> | prepare_to_wait() =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0 =A0=
// no process is woken up.
> | spin_unlock(&tran->t_handle_lock) =A0 =A0 + wake_up(&journal->j_wai=
t_tran_locked)
> | write_unlock(&journal->j_state_lock) =A0| =A0 =A0// no process is w=
oken up.
> | schedule() // never return =A0 =A0 =A0 =A0 =A0 =A0+----------------=
-----------------------
> | =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 | =A0( "dd" PID: 16645 or "flush-7:0" )
> | =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> | =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 |start_this_handle()
> | =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 +---------------------------------------
> | =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 | . . .
> | =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 | read_lock(&journal->j_state_lock)
> | =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 | if (journal->j_barrier_count)
> | =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 | =A0read_unlock(&journal->j_state_lock)
> | =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 | =A0wait_event(journal->j_wait_tran_locked)
> v =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 | =A0// never return
>
> Therefore, jbd2_journal_stop() needs spin_lock(&tran->t_handle_lock) =
or
> read_lock(&journal->j_state_lock) to synchronize trans->t_updates wit=
h other
> operators.
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
>
> Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
> ---
> =A0fs/jbd2/transaction.c | =A0 =A02 ++
> =A01 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> index a0e41a4..d48f395 100644
> --- a/fs/jbd2/transaction.c
> +++ b/fs/jbd2/transaction.c
> @@ -1448,12 +1448,14 @@ int jbd2_journal_stop(handle_t *handle)
> =A0 =A0 =A0 =A0 * once we do this, we must not dereference transactio=
n
> =A0 =A0 =A0 =A0 * pointer again.
> =A0 =A0 =A0 =A0 */
> + =A0 =A0 =A0 read_lock(&journal->j_state_lock);
> =A0 =A0 =A0 =A0tid =3D transaction->t_tid;
> =A0 =A0 =A0 =A0if (atomic_dec_and_test(&transaction->t_updates)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0wake_up(&journal->j_wait_updates);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (journal->j_barrier_count)
oops, j_barrier_count is not protected too in original code.  The
problem does not exists in patched code any more:-)


Yongqiang.
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0wake_up(&journal->j_wa=
it_transaction_locked);
> =A0 =A0 =A0 =A0}
> + =A0 =A0 =A0 read_unlock(&journal->j_state_lock);
>
> =A0 =A0 =A0 =A0if (wait_for_commit)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0err =3D jbd2_log_wait_commit(journal, =
tid);
> --
> 1.5.5.6
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
