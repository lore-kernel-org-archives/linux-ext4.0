From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: Re: [PATCH][RFC] jbd2: jbd2_journal_stop needs an exclusive control
 to synchronize around t_updates operations
Date: Tue, 20 Dec 2011 19:44:00 +0900
Message-ID: <4EF066F0.5010809@jp.fujitsu.com>
References: <20111216201915.4a012154.toshi.okajima@jp.fujitsu.com> <CAGBYx2YZ4M8QwwOcnLAaf+934WAcZoNS_pPrw8j3Nkr3=6fA5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: toshi.okajima@jp.fujitsu.com, tytso@mit.edu,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58291 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209Ab1LTKkk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Dec 2011 05:40:40 -0500
Received: from m1.gw.fujitsu.co.jp (unknown [10.0.50.71])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 93D2A3EE0AE
	for <linux-ext4@vger.kernel.org>; Tue, 20 Dec 2011 19:40:38 +0900 (JST)
Received: from smail (m1 [127.0.0.1])
	by outgoing.m1.gw.fujitsu.co.jp (Postfix) with ESMTP id 7894A45DE56
	for <linux-ext4@vger.kernel.org>; Tue, 20 Dec 2011 19:40:38 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.fujitsu.co.jp [10.0.50.91])
	by m1.gw.fujitsu.co.jp (Postfix) with ESMTP id 5E92745DE55
	for <linux-ext4@vger.kernel.org>; Tue, 20 Dec 2011 19:40:38 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 2D26FE08003
	for <linux-ext4@vger.kernel.org>; Tue, 20 Dec 2011 19:40:38 +0900 (JST)
Received: from ml14.s.css.fujitsu.com (ml14.s.css.fujitsu.com [10.240.81.134])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id C69651DB804D
	for <linux-ext4@vger.kernel.org>; Tue, 20 Dec 2011 19:40:37 +0900 (JST)
In-Reply-To: <CAGBYx2YZ4M8QwwOcnLAaf+934WAcZoNS_pPrw8j3Nkr3=6fA5g@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi, Yongqiang.

Thanks for reviewing.

(2011/12/16 21:22), Yongqiang Yang wrote:
> On Fri, Dec 16, 2011 at 7:19 PM, Toshiyuki Okajima
> <toshi.okajima@jp.fujitsu.com> wrote:
>> Hi.
>>
>> I found a bug by executing the following reproducer (needs tuning).
>> (The reproducer never ends.)
>>
>> I wrote it for a confirmation of
>>  "[PATCH 1/5] ext4: allocate delalloc blocks before changing journal mode".
>> Therefore, without
>>  "[PATCH 1/5] ext4: allocate delalloc blocks before changing journal mode"
>> patch, the other problem (panic) which the patch describes can happen more
>> frequently:
>> -------------------------------------------------------------------------------
>> #!/bin/sh
>>
>> date
>> LOOP=100000
>> dd if=/dev/zero of=/tmp/ext4.img bs=1k count=1000k
>> /sbin/mkfs.ext4 -Fq /tmp/ext4.img
>> mount -o loop /tmp/ext4.img /mnt
>> rm -f /mnt/file
>> echo "0" > /mnt/file
>> (while [ 1 ]; do dd if=/dev/zero of=/mnt/file2 bs=4k > /dev/null 2>&1; done) &
>> PID=$!
>> for ((i=0; i < LOOP; i++));
>> do
>>        DATE=$(date)
>>        echo -n "[LOOP $i] $DATE"
>>        if ((i%2 == 0));
>>        then
>>                chattr +j /mnt/file
>>        else
>>                chattr -j /mnt/file
>>        fi
>>        echo "0" >> /mnt/file
>> done
>> kill -9 $PID
>> rm -f /mnt/file*
>> umount /mnt
>> exit 0
>> -------------------------------------------------------------------------------
>> Though I ran it, it never ended forever.
>> (At one of my tries to reproduce the hang, the reproducer stopped in 6
>> hours.)
>>
>> Because jbd2_journal_lock_updates() never returns from schedule()
>> after prepare_to_wait().
>>
>> The detailed explanation is as follows:
>> ===============================================================================
>> Current implementation of jbd2_journal_stop() has a bug not to synchronize
>> t_updates with other operators, jbd2_journal_lock_updates(), start_this_handle()

> IMHO, the description is not very exactly, the problem is not due to
> desync of t_updates, t_updates is a var of atomic_t.   The reason is
> that we have a critical code section here:[operation on t_updates,
> wait or wakeup], this section should be synchronized.
I understood. I will rewrite the description much better than this by 
applying your comment. 

> 
>> and jbd2_journal_commit_transaction().
>>
>> This bug was derived from commit: c35a56a090eacefca07afeb994029b57d8dd8025 and
>>  commit: 8dd420466c7bfc459fa04680bd5690bfc41a4553.
>>
>> ---------------------------
>> jbd2_journal_lock_updates()
>> ---------------------------
>>  509         write_lock(&journal->j_state_lock);
>>  510         ++journal->j_barrier_count;
>> ...
>>  513         while (1) {
>> ...
>>  519                 spin_lock(&transaction->t_handle_lock);
>>  520                 if (!atomic_read(&transaction->t_updates)) {
>>  521                         spin_unlock(&transaction->t_handle_lock);
>>  522                         break;
>>  523                 }
>>  524                 prepare_to_wait(&journal->j_wait_updates, &wait,
>>  525                                 TASK_UNINTERRUPTIBLE);
>>  526                 spin_unlock(&transaction->t_handle_lock);

> It seems that t_handle_lock is used to protect the critical section
> here.   I think t_handle is not needed here at all.   t_handle_lock
> should be used to protect transaction and j_state_lock should be used
> to protect journal.  prepare_to_wait operates on journal, so we should
> remove t_handle_lock here.
I think so, too. Then, I will write another patch which deletes the statements
of  t_handle_lock.

> 
>>  527                 write_unlock(&journal->j_state_lock);
>>  528                 schedule();
>>  529                 finish_wait(&journal->j_wait_updates, &wait);
>>  530                 write_lock(&journal->j_state_lock);
>>  531         }
>>  532         write_unlock(&journal->j_state_lock);
>>
>> * The operation of t_updates is protected by write_lock(&journal->j_state_lock)
>>  and spin_lock(&transaction->t_handle_lock).
>>
>> -------------------
>> start_this_handle()
>> -------------------
>>  160         read_lock(&journal->j_state_lock);
>> ...
>>  278         atomic_inc(&transaction->t_updates);
>> ...
>>  284         read_unlock(&journal->j_state_lock);
>>
>> * The operation of t_updates is protected by read_lock(&journal->j_state_lock).
>>
>> ---------------------------------
>> jbd2_journal_commit_transaction()
>> ---------------------------------
>>  358         write_lock(&journal->j_state_lock);
>> ...
>>  367         spin_lock(&commit_transaction->t_handle_lock);
>>  368         while (atomic_read(&commit_transaction->t_updates)) {
>>  369                 DEFINE_WAIT(wait);
>>  370
>>  371                 prepare_to_wait(&journal->j_wait_updates, &wait,
>>  372                                         TASK_UNINTERRUPTIBLE);
>>  373                 if (atomic_read(&commit_transaction->t_updates)) {
>>  374                         spin_unlock(&commit_transaction->t_handle_lock);

> Also, t_handle_lock is used to protect the critical section.  I think
> t_handle_lock is not needed here at all.
Yes.

> 
>>  375                         write_unlock(&journal->j_state_lock);
>>  376                         schedule();
>>  377                         write_lock(&journal->j_state_lock);
>>  378                         spin_lock(&commit_transaction->t_handle_lock);
>>  379                 }
>>  380                 finish_wait(&journal->j_wait_updates, &wait);
>>  381         }
>>  382         spin_unlock(&commit_transaction->t_handle_lock);
>> ...
>>  447         wake_up(&journal->j_wait_transaction_locked);
>>  448         write_unlock(&journal->j_state_lock);
>>
>> * The operation of t_updates is protected by write_lock(&journal->j_state_lock)
>>  and spin_lock(&transaction->t_handle_lock).
>>
>> -------------------
>> jbd2_journal_stop()
>> -------------------
>> ...
>> 1452         if (atomic_dec_and_test(&transaction->t_updates)) {
>> 1453                 wake_up(&journal->j_wait_updates);
>> 1454                 if (journal->j_barrier_count)
>> 1455                         wake_up(&journal->j_wait_transaction_locked);
>> 1456         }
>> 1457
>> 1458         if (wait_for_commit)
>> 1459                 err = jbd2_log_wait_commit(journal, tid);
>> 1460
>> 1461         lock_map_release(&handle->h_lockdep_map);
>> 1462
>> 1463         jbd2_free_handle(handle);
>> 1464         return err;
>> 1465 }
>>
>> * The operation of t_updates is not protected.
>>
>> Therefore,
>> - jbd2_journal_lock_updates() sleeps if transaction->t_update is 0.
>> - jbd2_journal_stop() tries to wake someone up
>> (wake_up(&journal->j_wait_updates)) after transaction->t_updates becomes 0.
>> => But jbd2_journal_lock_updates() isn't woken up and then sleeps forever,
>>   if it has not yet slept completely.
>>
>> After we run the reproducer, we can see the processes which become hang-up.
>>
>> -------------------------------------------------------------------------------
>> crash> ps | grep UN
>>  16645  23737   1  ffff88007a592b20  UN   0.0  105136    508  dd
>>  16684  23727   1  ffff88007a2a9480  UN   0.0  107152    512  chattr
>>  23722      2   1  ffff88007b496080  UN   0.0       0      0  [flush-7:0]
>>
>> [1]
>> crash> bt 16645
>> PID: 16645  TASK: ffff88007a592b20  CPU: 1   COMMAND: "dd"
>>  #0 [ffff88007b575878] __schedule at ffffffff814b9b77
>>  #1 [ffff88007b575920] schedule at ffffffff814ba3cf
>>  #2 [ffff88007b575930] start_this_handle at ffffffffa01acef5 [jbd2]
>>  #3 [ffff88007b5759f0] jbd2__journal_start at ffffffffa01ad4cb [jbd2]
>>  #4 [ffff88007b575a30] jbd2_journal_start at ffffffffa01ad523 [jbd2]
>>  #5 [ffff88007b575a40] ext4_journal_start_sb at ffffffffa03a7d83 [ext4]
>>  #6 [ffff88007b575ab0] ext4_da_write_begin at ffffffffa038ddce [ext4]
>>  #7 [ffff88007b575b50] generic_file_buffered_write at ffffffff811005ce
>>  #8 [ffff88007b575c10] __generic_file_aio_write at ffffffff81103418
>>  #9 [ffff88007b575cd0] generic_file_aio_write at ffffffff811036b6
>> #10 [ffff88007b575d50] ext4_file_write at ffffffffa0386ee9 [ext4]
>> #11 [ffff88007b575de0] do_sync_write at ffffffff8115de52
>> #12 [ffff88007b575f00] vfs_write at ffffffff8115e3e8
>> #13 [ffff88007b575f30] sys_write at ffffffff8115e5b1
>> #14 [ffff88007b575f80] system_call_fastpath at ffffffff814c3f42
>>    RIP: 00000034930d4230  RSP: 00007fffd8176980  RFLAGS: 00000206
>>    RAX: 0000000000000001  RBX: ffffffff814c3f42  RCX: 0000000000000010
>>    RDX: 0000000000001000  RSI: 0000000001ac6000  RDI: 0000000000000001
>>    RBP: 0000000001ac6000   R8: 0000000000000003   R9: 0000000000040000
>>    R10: 0000000000003003  R11: 0000000000000246  R12: 0000000001ac5fff
>>    R13: 0000000000000000  R14: 0000000000001000  R15: 0000000000000246
>>    ORIG_RAX: 0000000000000001  CS: 0033  SS: 002b
>>
>> [2]
>> crash> bt 16684
>> PID: 16684  TASK: ffff88007a2a9480  CPU: 1   COMMAND: "chattr"
>>  #0 [ffff88007af87ca8] __schedule at ffffffff814b9b77
>>  #1 [ffff88007af87d50] schedule at ffffffff814ba3cf
>>  #2 [ffff88007af87d60] jbd2_journal_lock_updates at ffffffffa01acca6 [jbd2]
>>  #3 [ffff88007af87de0] ext4_change_inode_journal_flag at ffffffffa038faf1 [ext4]
>>  #4 [ffff88007af87e10] ext4_ioctl at ffffffffa0392f48 [ext4]
>>  #5 [ffff88007af87ea0] do_vfs_ioctl at ffffffff8116fb8a
>>  #6 [ffff88007af87f30] sys_ioctl at ffffffff811700d1
>>  #7 [ffff88007af87f80] system_call_fastpath at ffffffff814c3f42
>>    RIP: 00000034930d95f7  RSP: 00007fff8830e0d8  RFLAGS: 00010213
>>    RAX: 0000000000000010  RBX: ffffffff814c3f42  RCX: 00000034930d95f7
>>    RDX: 00007fff8830e17c  RSI: 0000000040086602  RDI: 0000000000000003
>>    RBP: 0000000000084000   R8: 0000000000000000   R9: 0000000000000001
>>    R10: 0000000000000000  R11: 0000000000000246  R12: 00007fff8830f8db
>>    R13: 0000000000000001  R14: 0000000000000000  R15: 0000000000000003
>>    ORIG_RAX: 0000000000000010  CS: 0033  SS: 002b
>>
>> [3]
>> crash> bt 23722
>> PID: 23722  TASK: ffff88007b496080  CPU: 1   COMMAND: "flush-7:0"
>>  #0 [ffff88007b4f7840] __schedule at ffffffff814b9b77
>>  #1 [ffff88007b4f78e8] schedule at ffffffff814ba3cf
>>  #2 [ffff88007b4f78f8] start_this_handle at ffffffffa01acef5 [jbd2]
>>  #3 [ffff88007b4f79b8] jbd2__journal_start at ffffffffa01ad4cb [jbd2]
>>  #4 [ffff88007b4f79f8] jbd2_journal_start at ffffffffa01ad523 [jbd2]
>>  #5 [ffff88007b4f7a08] ext4_journal_start_sb at ffffffffa03a7d83 [ext4]
>>  #6 [ffff88007b4f7a78] ext4_da_writepages at ffffffffa0390b6d [ext4]
>>  #7 [ffff88007b4f7bc8] do_writepages at ffffffff8110c261
>>  #8 [ffff88007b4f7bd8] writeback_single_inode at ffffffff81185830
>>  #9 [ffff88007b4f7c38] writeback_sb_inodes at ffffffff81185e21
>> #10 [ffff88007b4f7ce8] __writeback_inodes_wb at ffffffff81185f7e
>> #11 [ffff88007b4f7d38] wb_writeback at ffffffff81186223
>> #12 [ffff88007b4f7db8] wb_do_writeback at ffffffff811864f9
>> #13 [ffff88007b4f7e58] bdi_writeback_thread at ffffffff811865fa
>> #14 [ffff88007b4f7ee8] kthread at ffffffff810828c6
>> #15 [ffff88007b4f7f48] kernel_thread_helper at ffffffff814c60b4
>>
>> Step to reproduce a hang-up(figure):
>>  =======================================+=======================================
>>  ( "chattr -j" process PID: 16684 )     |  ( a certain process )
>> t ======================================+=======================================
>> i                                       |
>> m                                       +---------------------------------------
>> e                                       |jbd2_journal_start()
>> |                                       +---------------------------------------
>> |                                       | . . .
>> |                                       | t_updates++ // t_updates = 1
>> |                                       | . . .
>> |                                       +---------------------------------------
>> |                                        ...
>> |---------------------------------------+---------------------------------------
>> |jbd2_journal_lock_updates()            |jbd2_journal_stop()
>> |---------------------------------------+---------------------------------------
>> | write_lock(&journal->j_state_lock)    |    .
>> | ++journal->j_barrier_count            |    .
>> | spin_lock(&tran->t_handle_lock)       |    .
>> | atomic_read(&tran->t_updates) //not 0 |
>> |                                       | atomic_dec_and_test(&tran->t_updates)
>> |                                       |    // t_updates = 0
>> |                                       | wake_up(&journal->j_wait_updates)
>> | prepare_to_wait()                     |    // no process is woken up.
>> | spin_unlock(&tran->t_handle_lock)     + wake_up(&journal->j_wait_tran_locked)
>> | write_unlock(&journal->j_state_lock)  |    // no process is woken up.
>> | schedule() // never return            +---------------------------------------
>> |                                       |  ( "dd" PID: 16645 or "flush-7:0" )
>> |                                       +=======================================
>> |                                       |start_this_handle()
>> |                                       +---------------------------------------
>> |                                       | . . .
>> |                                       | read_lock(&journal->j_state_lock)
>> |                                       | if (journal->j_barrier_count)
>> |                                       |  read_unlock(&journal->j_state_lock)
>> |                                       |  wait_event(journal->j_wait_tran_locked)
>> v                                       |  // never return
>>
>> Therefore, jbd2_journal_stop() needs spin_lock(&tran->t_handle_lock) or
>> read_lock(&journal->j_state_lock) to synchronize trans->t_updates with other
>> operators.
>> ===============================================================================
>>
>> Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
>> ---
>>  fs/jbd2/transaction.c |    2 ++
>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
>> index a0e41a4..d48f395 100644
>> --- a/fs/jbd2/transaction.c
>> +++ b/fs/jbd2/transaction.c
>> @@ -1448,12 +1448,14 @@ int jbd2_journal_stop(handle_t *handle)
>>         * once we do this, we must not dereference transaction
>>         * pointer again.
>>         */
>> +       read_lock(&journal->j_state_lock);
>>        tid = transaction->t_tid;
>>        if (atomic_dec_and_test(&transaction->t_updates)) {
>>                wake_up(&journal->j_wait_updates);
>>                if (journal->j_barrier_count)

> oops, j_barrier_count is not protected too in original code.  The
> problem does not exists in patched code any more:-)
OK. 
I will add the notice into the description which I will rewrite.

Best Regards,
Toshiyuki Okajima


> 
> 
> Yongqiang.
>>                        wake_up(&journal->j_wait_transaction_locked);
>>        }
>> +       read_unlock(&journal->j_state_lock);
>>
>>        if (wait_for_commit)
>>                err = jbd2_log_wait_commit(journal, tid);
>> --
>> 1.5.5.6
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 

