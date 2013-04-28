From: LuVar <luvar@plaintext.sk>
Subject: Re: sustained write to disk, frozen copy
Date: Sun, 28 Apr 2013 20:17:03 +0100 (GMT+01:00)
Message-ID: <1583229631.2661367176623695.JavaMail.root@shiva>
References: <20130428165023.GA5723@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.plaintext.sk ([85.248.156.6]:35980 "EHLO
	shiva.plaintext.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756238Ab3D1TRK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 28 Apr 2013 15:17:10 -0400
In-Reply-To: <20130428165023.GA5723@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fuf... Here are my deadlock things:

SysRq : Show Blocked State
  task                        PC stack   pid father
md3_raid5       D 0000000000000001     0 16779      2 0x00000000
 ffff88032f76fb70 0000000000000046 ffff88032f76e000 0000000000010c80
 ffff88032f144890 0000000000010c80 ffff88032f76ffd8 0000000000004000
 ffff88032f76ffd8 0000000000010c80 ffff8803330bb470 ffff88032f144890
Call Trace:
 [<ffffffff81355e2f>] ? __blk_run_queue+0x16/0x18
 [<ffffffff81358abe>] ? blk_queue_bio+0x29a/0x2b4
 [<ffffffff81356546>] ? generic_make_request+0x97/0xda
 [<ffffffff814ebc8c>] schedule+0x5f/0x61
 [<ffffffff8143bfa5>] md_super_wait+0x68/0x80
 [<ffffffff81041cac>] ? wake_up_bit+0x25/0x25
 [<ffffffff8144160f>] write_page+0x1d5/0x2be
 [<ffffffff81441365>] bitmap_update_sb+0x115/0x117
 [<ffffffff8143c27c>] md_update_sb+0x2bf/0x467
 [<ffffffff814ebab1>] ? __schedule+0x6b8/0x7be
 [<ffffffff8143ca00>] md_check_recovery+0x26b/0x5ff
 [<ffffffffa04a3624>] raid5d+0x1f/0x4c8 [raid456]
 [<ffffffff81034ca6>] ? try_to_del_timer_sync+0x77/0x83
 [<ffffffff81034cee>] ? del_timer_sync+0x3c/0x48
 [<ffffffff814e9fdd>] ? schedule_timeout+0x189/0x1a9
 [<ffffffff8143a69c>] md_thread+0xfd/0x11b
 [<ffffffff81041cac>] ? wake_up_bit+0x25/0x25
 [<ffffffff8143a59f>] ? md_register_thread+0xc8/0xc8
 [<ffffffff8104189d>] kthread+0x84/0x8c
 [<ffffffff814ee314>] kernel_thread_helper+0x4/0x10
 [<ffffffff81041819>] ? kthread_freezable_should_stop+0x4d/0x4d
 [<ffffffff814ee310>] ? gs_change+0xb/0xb
jbd2/dm-3-8     D 0000000000000002     0 17714      2 0x00000000
 ffff88032f647bb0 0000000000000046 ffff88032f646000 0000000000010c80
 ffff880330a70440 0000000000010c80 ffff88032f647fd8 0000000000004000
 ffff88032f647fd8 0000000000010c80 ffff8801a6c3e100 ffff880330a70440
Call Trace:
 [<ffffffff810dae71>] ? __find_get_block_slow+0x113/0x12a
 [<ffffffff81438706>] ? md_make_request+0xc4/0x1b9
 [<ffffffff810597da>] ? ktime_get_ts+0xa9/0xb5
 [<ffffffff810db7ad>] ? unmap_underlying_metadata+0x39/0x39
 [<ffffffff814ebc8c>] schedule+0x5f/0x61
 [<ffffffff814ebd15>] io_schedule+0x87/0xca
 [<ffffffff810db7b6>] sleep_on_buffer+0x9/0xd
 [<ffffffff814ea18f>] __wait_on_bit+0x43/0x76
 [<ffffffff814ea22b>] out_of_line_wait_on_bit+0x69/0x74
 [<ffffffff810db7ad>] ? unmap_underlying_metadata+0x39/0x39
 [<ffffffff81041ce0>] ? autoremove_wake_function+0x34/0x34
 [<ffffffff810db772>] __wait_on_buffer+0x21/0x23
 [<ffffffff8118acfb>] jbd2_journal_commit_transaction+0xd19/0x1182
 [<ffffffff810349e6>] ? lock_timer_base.clone.28+0x26/0x4b
 [<ffffffff81034ca6>] ? try_to_del_timer_sync+0x77/0x83
 [<ffffffff8118daf5>] kjournald2+0xc6/0x22e
 [<ffffffff81041cac>] ? wake_up_bit+0x25/0x25
 [<ffffffff8118da2f>] ? commit_timeout+0xb/0xb
 [<ffffffff8104189d>] kthread+0x84/0x8c
 [<ffffffff814ee314>] kernel_thread_helper+0x4/0x10
 [<ffffffff81041819>] ? kthread_freezable_should_stop+0x4d/0x4d
 [<ffffffff814ee310>] ? gs_change+0xb/0xb
flush-253:3     D ffff8803314e0024     0  6471      2 0x00000000
 ffff88011fedda50 0000000000000046 ffff88011fedc000 0000000000010c80
 ffff880130e02b90 0000000000010c80 ffff88011feddfd8 0000000000004000
 ffff88011feddfd8 0000000000010c80 ffffffff81671410 ffff880130e02b90
Call Trace:
 [<ffffffff8104b325>] ? try_to_wake_up+0x20a/0x21c
 [<ffffffff814ebc8c>] schedule+0x5f/0x61
 [<ffffffff8118d7ce>] jbd2_log_wait_commit+0xc1/0x113
 [<ffffffff81041cac>] ? wake_up_bit+0x25/0x25
 [<ffffffff8118ebae>] jbd2_journal_force_commit_nested+0x6a/0x7c
 [<ffffffff8115dd54>] ext4_da_writepages+0x376/0x447
 [<ffffffff81095d18>] do_writepages+0x1e/0x27
 [<ffffffff810d5c56>] __writeback_single_inode.clone.24+0x3a/0xda
 [<ffffffff810d6132>] writeback_sb_inodes+0x1b8/0x2f7
 [<ffffffff810ba680>] ? put_super+0x20/0x2b
 [<ffffffff810d62de>] __writeback_inodes_wb+0x6d/0xab
 [<ffffffff810d641f>] wb_writeback+0x103/0x194
 [<ffffffff810d6b48>] wb_do_writeback+0x111/0x16d
 [<ffffffff810d6c29>] bdi_writeback_thread+0x85/0x14a
 [<ffffffff810d6ba4>] ? wb_do_writeback+0x16d/0x16d
 [<ffffffff810d6ba4>] ? wb_do_writeback+0x16d/0x16d
 [<ffffffff8104189d>] kthread+0x84/0x8c
 [<ffffffff814ee314>] kernel_thread_helper+0x4/0x10
 [<ffffffff81041819>] ? kthread_freezable_should_stop+0x4d/0x4d
 [<ffffffff814ee310>] ? gs_change+0xb/0xb
kio_file        D ffffffffffffffff     0  6546   6443 0x00000000
 ffff880270a87b98 0000000000000082 ffff880270a86000 0000000000010c80
 ffff8800aa600c10 0000000000010c80 ffff880270a87fd8 0000000000004000
 ffff880270a87fd8 0000000000010c80 ffff8803330bb470 ffff8800aa600c10
Call Trace:
 [<ffffffff810349e6>] ? lock_timer_base.clone.28+0x26/0x4b
 [<ffffffff81034ca6>] ? try_to_del_timer_sync+0x77/0x83
 [<ffffffff814ebc8c>] schedule+0x5f/0x61
 [<ffffffff814e9fd5>] schedule_timeout+0x181/0x1a9
 [<ffffffff8103492a>] ? run_timer_softirq+0x1ef/0x1ef
 [<ffffffff814ebf5b>] io_schedule_timeout+0x93/0xe4
 [<ffffffff8138176e>] ? __percpu_counter_sum+0x4d/0x63
 [<ffffffff8109597c>] balance_dirty_pages_ratelimited_nr+0x54d/0x615
 [<ffffffff810d7fca>] generic_file_splice_write+0x11e/0x130
 [<ffffffff810d7acc>] do_splice_from+0x7d/0x8a
 [<ffffffff810d7af4>] direct_splice_actor+0x1b/0x1d
 [<ffffffff810d7dfb>] splice_direct_to_actor+0xd5/0x186
 [<ffffffff810d7ad9>] ? do_splice_from+0x8a/0x8a
 [<ffffffff810d8e01>] do_splice_direct+0x47/0x5a
 [<ffffffff810b8f63>] do_sendfile+0x12e/0x1c3
 [<ffffffff810b9bee>] sys_sendfile64+0x54/0x92
 [<ffffffff814ed062>] system_call_fastpath+0x16/0x1b
sync            D ffff88033089f3f0     0  6707   6477 0x00000000
 ffff8801b9651d08 0000000000000086 ffff8801b9650000 0000000000010c80
 ffff88033089f3f0 0000000000010c80 ffff8801b9651fd8 0000000000004000
 ffff8801b9651fd8 0000000000010c80 ffff8803330ba0c0 ffff88033089f3f0
Call Trace:
 [<ffffffff8108dc75>] ? find_get_pages_tag+0xf3/0x12f
 [<ffffffff81096d23>] ? release_pages+0x19c/0x1ab
 [<ffffffff81096691>] ? pagevec_lookup_tag+0x20/0x29
 [<ffffffff814ebc8c>] schedule+0x5f/0x61
 [<ffffffff814e9e7a>] schedule_timeout+0x26/0x1a9
 [<ffffffff81049017>] ? check_preempt_curr+0x3e/0x6c
 [<ffffffff814eb2e6>] wait_for_common+0xc8/0x13f
 [<ffffffff8104b337>] ? try_to_wake_up+0x21c/0x21c
 [<ffffffff810d9745>] ? __sync_filesystem+0x7a/0x7a
 [<ffffffff814eb3f7>] wait_for_completion+0x18/0x1a
 [<ffffffff810d657f>] writeback_inodes_sb_nr+0xb8/0xc1
 [<ffffffff810d6602>] writeback_inodes_sb+0x22/0x29
 [<ffffffff810d971c>] __sync_filesystem+0x51/0x7a
 [<ffffffff810d9756>] sync_one_sb+0x11/0x13
 [<ffffffff810bb6fa>] iterate_supers+0x68/0xb8
 [<ffffffff810d9695>] sync_filesystems+0x1b/0x1d
 [<ffffffff810d97ba>] sys_sync+0x17/0x33
 [<ffffffff814ed062>] system_call_fastpath+0x16/0x1b

Is there something eslse, what should I do before reboot?

LuVar

----- "Zheng Liu" <gnehzuil.liu@gmail.com> wrote:

> On Sat, Apr 27, 2013 at 08:16:02AM +0100, LuVar wrote:
> > Hi,
> > I have my desktop about 24 hours in "deadlock". I was copying (as
> root in krusader from USB key (mounted as [1]) data to filesystem [2])
> some files from one point to another. Now it is more than 24 hours
> with sustained disk write, see [3].
> > 
> > How can I help and "debug" this problem? I have 3.5.7 gentoo kernel
> ([4]).
> 
> Hi LuVar,
> 
> You could use 'echo w >/proc/sysrq-trigger' to look at which process
> has
> been deadlock.
> 
>  # echo w >/proc/sysrq-trigger (WARN: you need a root privilege)
>  # dmesg | vim -
> 
>  SysRq : Show Blocked State
>    task                        PC stack   pid father
> 
> Here is nothing because my system hasn't any deadlock.  Then you
> could
> use 'echo t >/proc/sysrq-trigger' to dump current tasks and their
> information.  That would be great if you could paste these details in
> mailing list.  They are very useful for us to dig this problem.
> 
> Thanks,
>                                                 - Zheng
> 
> > 
> > PS: I am an average user, so please by verbose to me.
> > 
> > [1] sudo mount -o rw,uid=luvar,gid=luvar,iocharset=utf8 /dev/sdg1
> /mnt/usbstick/
> > 
> > [2]:
> > luvar@blacktroja ~ $ mount | grep music
> > /dev/mapper/vg-music on /var/lib/mpd/music/local type ext4
> (rw,noatime,commit=0)
> > 
> > [3]:
> > iotop, two first records :
> > 17714 be/3 root        0.00 B/s    0.00 B/s  0.00 % 97.60 %
> [jbd2/dm-3-8]
> >  6546 be/4 root        0.00 B/s    0.00 B/s  0.00 % 93.48 %
> kdeinit4: kio_file [kdeinit] file local:/tmp/ksocket-root/~-socket
> local:/tmp/ksocket-root/krusaderZz6431.slave-socket
> > 
> > [4]:
> > luvar@blacktroja ~ $ uname -a
> > Linux blacktroja 3.5.7-gentoo #1 SMP Sun Oct 28 17:18:07 CET 2012
> x86_64 Intel(R) Core(TM) i7 CPU 930 @ 2.80GHz GenuineIntel GNU/Linux
> > 
> > Thanks, LuVar
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
