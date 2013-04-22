From: Azat Khuzhin <dohardgopro@gmail.com>
Subject: Re: ext4, jbd2: task blocked for more than 120 seconds.
Date: Mon, 22 Apr 2013 09:40:03 +0400
Message-ID: <CAAW1UO_+_z8zyRhX-HZKWHsxiZ8fE54bZvxU_uuXTmMQ3=+qSA@mail.gmail.com>
References: <CAAW1UO8bbhfuw-J=0cxLB0uTps6aecTJe4ro2SgExpcK-SDouw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ia0-f172.google.com ([209.85.210.172]:39342 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303Ab3DVFkF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Apr 2013 01:40:05 -0400
Received: by mail-ia0-f172.google.com with SMTP id i20so905565ian.17
        for <linux-ext4@vger.kernel.org>; Sun, 21 Apr 2013 22:40:03 -0700 (PDT)
In-Reply-To: <CAAW1UO8bbhfuw-J=0cxLB0uTps6aecTJe4ro2SgExpcK-SDouw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Here is more that I tried to do:

$ umount /dev/sdb5 # finished successfully
$ debugfs
open_filesys /dev/sdb5 # finished successfully
# Then I copy some files that I need at that moment to another partition
# After I try to mount it
$ mount /dev/sdb5 # didn't finished
root:/sys# cat /proc/$(pgrep mount)/status | grep State
State:  D (disk sleep)

On Sat, Apr 20, 2013 at 8:05 PM, Azat Khuzhin <dohardgopro@gmail.com> wrote:
> Today I have "blocked for more than 120 seconds" in dmesg, while doing
> next things:
>
> - Run ktorrent
> - Download torrent, and don't have enough space to save
> - mv of 84 GiB folder into another parititon (not waiting for the end)
> - Continue downloading with ktorrent
> - When there is only 4.0K available on partition (where ktorrent
> saves), all jobs hangs
>   - ktorrent
>   - mv, that not finished
>   - mplayer, that try to get next file (seems that current one was in
> cache, about 130 MiB in size)
>
> And after this load avg was equal to 8.
>
> I've try to investigate further, see into some old patches, blame, but
> I don't have any ideas.
> So here is some more info about it:
>
> # Kernel version:
>
> $ uname -a
> Linux home-spb 3.8.0custom.x86-64.1.8-10206-gb0af9cd-dirty #1 SMP Sun
> Mar 3 20:39:58 MSK 2013 x86_64 GNU/Linux
> $ grep sdb5 /proc/mounts
> /dev/sdb5 /mnt/docs ext4 rw,relatime,data=ordered 0 0
>
> $ iostat 2 /dev/sdb
> Linux 3.8.0custom.x86-64.1.8-10206-gb0af9cd-dirty (home-spb)
> 04/20/2013      _x86_64_        (4 CPU)
>
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>            3.31    0.00    0.59    0.56    0.00   95.54
>
> Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
> sdb               0.76        34.68        32.07   29794122   27548981
>
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>            2.39    0.00    0.38    0.00    0.00   97.23
>
> Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
> sdb               0.00         0.00         0.00          0          0
>
> # dmesg snippets
>
> [836402.486062] INFO: task flush-8:16:24991 blocked for more than 120 seconds.
> [836402.486738] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [836402.488080] flush-8:16      D ffff88022ea93a40     0 24991      2 0x00000000
> [836402.489419]  ffff8801cb341c40 0000000000000046 ffff88020a20b9b8
> ffff8802258fc6a0
> [836402.490747]  0000000000013a40 ffff88020a20bfd8 ffff88020a20bfd8
> ffff8801cb341c40
> [836402.492091]  0000000000000092 ffff8801cb341c40 ffff8801fe8d2980
> 0000000000000001
> [836402.493457] Call Trace:
> [836402.494133]  [<ffffffff813a9701>] ? rwsem_down_failed_common+0x1bd/0x1f6
> [836402.494810]  [<ffffffff810c828b>] ? release_pages+0x159/0x168
> [836402.495485]  [<ffffffff811fcea3>] ? call_rwsem_down_write_failed+0x13/0x20
> [836402.496163]  [<ffffffff813a85c4>] ? down_write+0x25/0x27
> [836402.496838]  [<ffffffff8115e264>] ? ext4_map_blocks+0x1d0/0x30e
> [836402.497514]  [<ffffffff8116142d>] ? mpage_da_map_and_submit+0x8a/0x314
> [836402.498185]  [<ffffffff81161cc7>] ? ext4_da_writepages+0x2ab/0x44e
> [836402.498868]  [<ffffffff811e1f5e>] ? __blk_run_queue_uncond+0x1e/0x26
> [836402.499544]  [<ffffffff811e1fd0>] ? queue_unplugged+0x59/0x7d
> [836402.500297]  [<ffffffff8111d7a0>] ? __writeback_single_inode+0x4b/0x1d6
> [836402.501019]  [<ffffffff8111df91>] ? writeback_sb_inodes+0x1dd/0x30c
> [836402.501763]  [<ffffffff8111e129>] ? __writeback_inodes_wb+0x69/0xab
> [836402.502503]  [<ffffffff8111e2a2>] ? wb_writeback+0x137/0x28c
> [836402.503207]  [<ffffffff8111ecff>] ? wb_do_writeback+0x146/0x1bb
> [836402.503922]  [<ffffffff81046fbe>] ? del_timer_sync+0x27/0x44
> [836402.504636]  [<ffffffff8111ed74>] ? wb_do_writeback+0x1bb/0x1bb
> [836402.505345]  [<ffffffff8111ee1c>] ? bdi_writeback_thread+0xa8/0x1db
> [836402.506031]  [<ffffffff8111ed74>] ? wb_do_writeback+0x1bb/0x1bb
> [836402.506739]  [<ffffffff8111ed74>] ? wb_do_writeback+0x1bb/0x1bb
> [836402.507413]  [<ffffffff810551b0>] ? kthread+0x81/0x89
> [836402.508089]  [<ffffffff8105512f>] ? __kthread_parkme+0x5c/0x5c
> [836402.508795]  [<ffffffff813afafc>] ? ret_from_fork+0x7c/0xb0
> [836402.509467]  [<ffffffff8105512f>] ? __kthread_parkme+0x5c/0x5c
> [836402.510157] INFO: task mv:31543 blocked for more than 120 seconds.
> [836402.510848] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [836402.512206] mv              D ffff88022ea13a40     0 31543  30551 0x00000000
> [836402.513550]  ffff880224603170 0000000000000086 0000000000000000
> ffffffff81613400
> [836402.514900]  0000000000013a40 ffff880050b61fd8 ffff880050b61fd8
> ffff880224603170
> [836402.516237]  0000000000000246 ffff880225358800 0000000000000000
> ffff880225358868
> [836402.517598] Call Trace:
> [836402.518266]  [<ffffffff811973f8>] ? start_this_handle+0x2d0/0x46b
> [836402.518951]  [<ffffffff8105e78b>] ? should_resched+0x5/0x23
> [836402.519630]  [<ffffffff810557d1>] ? bit_waitqueue+0x82/0x82
> [836402.520305]  [<ffffffff8119772d>] ? jbd2__journal_start+0x94/0x154
> [836402.521027]  [<ffffffff8116218f>] ? ext4_dirty_inode+0x1e/0x51
> [836402.521743]  [<ffffffff8111d999>] ? __mark_inode_dirty+0x6e/0x1f1
> [836402.522449]  [<ffffffff811105f4>] ? update_time+0xa0/0xa9
> [836402.523121]  [<ffffffff81110cba>] ? touch_atime+0xe3/0x11c
> [836402.523795]  [<ffffffff810bfe8a>] ? generic_file_aio_read+0x55a/0x5b9
> [836402.524476]  [<ffffffff810fe062>] ? do_sync_read+0x62/0x9b
> [836402.525156]  [<ffffffff810fe663>] ? vfs_read+0x93/0xf5
> [836402.525842]  [<ffffffff810fe716>] ? sys_read+0x51/0x80
> [836402.526527]  [<ffffffff813afba9>] ? system_call_fastpath+0x16/0x1b
> [836522.558599] INFO: task jbd2/sdb5-8:1794 blocked for more than 120 seconds.
> [836522.559400] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [836522.560999] jbd2/sdb5-8     D ffff88022ea93a40     0  1794      2 0x00000000
> [836522.562591]  ffff8802253b3170 0000000000000046 0000000131cd9ccb
> ffff8802258fc6a0
> [836522.564169]  0000000000013a40 ffff880225161fd8 ffff880225161fd8
> ffff8802253b3170
> [836522.565565]  0000000000000246 ffff880225358800 ffff880225161d80
> ffff88008fd7ca70
> [836522.566953] Call Trace:
> [836522.567660]  [<ffffffff8119931d>] ?
> jbd2_journal_commit_transaction+0x22f/0x135e
> [836522.569014]  [<ffffffff8100d5ff>] ? __switch_to+0x18d/0x3f8
> [836522.569780]  [<ffffffff810557d1>] ? bit_waitqueue+0x82/0x82
> [836522.570519]  [<ffffffff81046e67>] ? lock_timer_base.isra.37+0x23/0x48
> [836522.571225]  [<ffffffff81046f8c>] ? try_to_del_timer_sync+0x4e/0x59
> [836522.571958]  [<ffffffff8119f0df>] ? kjournald2+0xb7/0x239
> [836522.572688]  [<ffffffff810557d1>] ? bit_waitqueue+0x82/0x82
> [836522.573386]  [<ffffffff8119f028>] ? journal_init_common+0x165/0x165
> [836522.574093]  [<ffffffff8119f028>] ? journal_init_common+0x165/0x165
> [836522.574772]  [<ffffffff810551b0>] ? kthread+0x81/0x89
> [836522.575447]  [<ffffffff8105512f>] ? __kthread_parkme+0x5c/0x5c
> [836522.576127]  [<ffffffff813afafc>] ? ret_from_fork+0x7c/0xb0
> [836522.576804]  [<ffffffff8105512f>] ? __kthread_parkme+0x5c/0x5c
> [836522.577526] INFO: task ktorrent:11063 blocked for more than 120 seconds.
> [836522.578205] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [836522.579569] ktorrent        D ffff88022eb93a40     0 11063      1 0x00000000
> [836522.580927]  ffff8801cb3454c0 0000000000000086 0000000000000292
> ffff8802258fd4c0
> [836522.582274]  0000000000013a40 ffff880050f73fd8 ffff880050f73fd8
> ffff8801cb3454c0
> [836522.583664]  0000000000000246 ffff880225358800 ffff880050f73ab0
> ffff880225358824
> [836522.585006] Call Trace:
> [836522.585694]  [<ffffffff8119def0>] ? jbd2_log_wait_commit+0xc3/0x118
> [836522.586371]  [<ffffffff810557d1>] ? bit_waitqueue+0x82/0x82
> [836522.587048]  [<ffffffff8119ff52>] ?
> jbd2_journal_force_commit_nested+0x63/0x91
> [836522.588388]  [<ffffffff8115d729>] ? ext4_da_get_block_prep+0x329/0x485
> [836522.589082]  [<ffffffff81122ef3>] ? alloc_buffer_head+0x18/0x5b
> [836522.589775]  [<ffffffff81124d80>] ? __block_write_begin+0x125/0x27d
> [836522.590467]  [<ffffffff81072724>] ? current_kernel_time+0x9/0x30
> [836522.591144]  [<ffffffff8115d400>] ? ext4_num_dirty_pages.isra.44+0x17f/0x17f
> [836522.592502]  [<ffffffff810ffe13>] ? __sb_start_write+0xb6/0xe8
> [836522.593195]  [<ffffffff810de216>] ? vma_gap_callbacks_propagate+0x13/0x2c
> [836522.593899]  [<ffffffff8115d400>] ? ext4_num_dirty_pages.isra.44+0x17f/0x17f
> [836522.595252]  [<ffffffff81124f4d>] ? __block_page_mkwrite+0x75/0xb7
> [836522.595932]  [<ffffffff81162382>] ? ext4_page_mkwrite+0x8e/0x2a4
> [836522.596614]  [<ffffffff810d8e36>] ? __do_fault+0x15b/0x35d
> [836522.597304]  [<ffffffff810db20d>] ? handle_pte_fault+0x28b/0x708
> [836522.597981]  [<ffffffff81033da9>] ? pte_alloc_one+0x2f/0x39
> [836522.598670]  [<ffffffff813aca20>] ? __do_page_fault+0x32d/0x375
> [836522.599346]  [<ffffffff810d3498>] ? vm_mmap_pgoff+0x82/0xab
> [836522.600023]  [<ffffffff813a9898>] ? _raw_spin_lock_irq+0xb/0x15
> [836522.600700]  [<ffffffff8104b8ca>] ? do_sigaction+0xc2/0x167
> [836522.601373]  [<ffffffff8105e82c>] ? finish_task_switch+0x83/0xb4
> [836522.602066]  [<ffffffff8105e78b>] ? should_resched+0x5/0x23
> [836522.602757]  [<ffffffff813a8dd8>] ? _cond_resched+0x6/0x1b
> [836522.603432]  [<ffffffff813a9e58>] ? page_fault+0x28/0x30
>
> # Pointers to sources
>
> (gdb) list *(jbd2_log_wait_commit+0xc3)
> 0xffffffff8119def0 is in jbd2_log_wait_commit (fs/jbd2/journal.c:699).
> 694             while (tid_gt(tid, journal->j_commit_sequence)) {
> 695                     jbd_debug(1, "JBD2: want %d, j_commit_sequence=%d\n",
> 696                                       tid, journal->j_commit_sequence);
> 697                     wake_up(&journal->j_wait_commit);
> 698                     read_unlock(&journal->j_state_lock);
> 699                     wait_event(journal->j_wait_done_commit,
> 700                                     !tid_gt(tid,
> journal->j_commit_sequence));
> 701                     read_lock(&journal->j_state_lock);
> 702             }
> 703             read_unlock(&journal->j_state_lock);
> (gdb) list *(jbd2_journal_commit_transaction+0x22f)
> 0xffffffff8119931d is in jbd2_journal_commit_transaction (fs/jbd2/commit.c:457).
> 452                                             TASK_UNINTERRUPTIBLE);
> 453                     if (atomic_read(&commit_transaction->t_updates)) {
> 454                             spin_unlock(&commit_transaction->t_handle_lock);
> 455                             write_unlock(&journal->j_state_lock);
> 456                             schedule();
> 457                             write_lock(&journal->j_state_lock);
> 458                             spin_lock(&commit_transaction->t_handle_lock);
> 459                     }
> 460                     finish_wait(&journal->j_wait_updates, &wait);
> 461             }
> (gdb) list *(start_this_handle+0x2d0)
> 0xffffffff811973f8 is in start_this_handle (fs/jbd2/transaction.c:237).
> warning: Source file is more recent than executable.
> 232
> 233                     prepare_to_wait(&journal->j_wait_transaction_locked,
> 234                                             &wait, TASK_UNINTERRUPTIBLE);
> 235                     read_unlock(&journal->j_state_lock);
> 236                     schedule();
> 237                     finish_wait(&journal->j_wait_transaction_locked, &wait);
> 238                     goto repeat;
> 239             }
> 240
> 241             /*
> (gdb) l *(ext4_map_blocks+0x1d0)
> 0xffffffff8115e264 is in ext4_map_blocks (fs/ext4/inode.c:609).
> 604              * if the caller is from delayed allocation writeout path
> 605              * we have already reserved fs blocks for allocation
> 606              * let the underlying get_block() function know to
> 607              * avoid double accounting
> 608              */
> 609             if (flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE)
> 610                     ext4_set_inode_state(inode,
> EXT4_STATE_DELALLOC_RESERVED);
> 611             /*
> 612              * We need to check for EXT4 here because migrate
> 613              * could have changed the inode type in between
> (gdb) l *(ext4_map_blocks+(0x1d0-8)) # I actually think that instead
> of previous command you want to see at this one.
> 0xffffffff8115e25c is in ext4_map_blocks (fs/ext4/inode.c:601).
> 596              * New blocks allocate and/or writing to uninitialized extent
> 597              * will possibly result in updating i_data, so we take
> 598              * the write lock of i_data_sem, and call get_blocks()
> 599              * with create == 1 flag.
> 600              */
> 601             down_write((&EXT4_I(inode)->i_data_sem));
> 602
> 603             /*
> 604              * if the caller is from delayed allocation writeout path
> 605              * we have already reserved fs blocks for allocation
>
> --
> Respectfully
> Azat Khuzhin
> Primary email a3at.mail@gmail.com



-- 
Respectfully
Azat Khuzhin
Primary email a3at.mail@gmail.com
