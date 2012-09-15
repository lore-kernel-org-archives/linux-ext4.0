From: Anatol Pomozov <anatol.pomozov@gmail.com>
Subject: Re: ext4_orphan_del() sleeps in non-journal mode
Date: Fri, 14 Sep 2012 19:15:05 -0700
Message-ID: <CAOMFOmVRRt2UQEZC=_ZYz+wHN=BaCG1DjD0tWv=Ad2DCus5Syw@mail.gmail.com>
References: <CAOMFOmWB4yxj65N2x5+KREmiQBdPoWsTiA7EBW6ONPBOyFo11w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:62814 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490Ab2IOCPI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Sep 2012 22:15:08 -0400
Received: by lbbgj3 with SMTP id gj3so3169775lbb.19
        for <linux-ext4@vger.kernel.org>; Fri, 14 Sep 2012 19:15:05 -0700 (PDT)
In-Reply-To: <CAOMFOmWB4yxj65N2x5+KREmiQBdPoWsTiA7EBW6ONPBOyFo11w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

BTW if we had a compile flag that turns off journal code in ext4 we
might add a stub functions

#ifdef CONFIG_EXT4_JOURNAL

ext4_orphan_add() { ...the code... }

#else

/* a stub here */

ext4_orphan_add() { no-op function }

#end

On Fri, Sep 14, 2012 at 2:06 PM, Anatol Pomozov
<anatol.pomozov@gmail.com> wrote:
> Hi,
>
> I am debugging one issue that happens on our servers. We use ext4 with
> non-journaling mode (2.6.34 kernel) and when we try to use
> asynchronous IO we see following oops in dmesg:
>
> <3>[ 3983.762966] bad: scheduling from the idle thread!
> <4>[ 3983.762968] Pid: 0, comm: swapper
> <4>[ 3983.762970] Call Trace:
> <4>[ 3983.762972]  <IRQ>  [<ffffffff811d3fde>] dequeue_task_idle+0x24/0x30
> <4>[ 3983.762980]  [<ffffffff81002f58>] schedule+0x2a98/0x3310
> <4>[ 3983.762985]  [<ffffffff8101a08a>] ? sched_clock_cpu+0x2a/0xe0
> <4>[ 3983.762988]  [<ffffffff8102b5d7>] ? mempool_alloc+0xa7/0x1a0
> <4>[ 3983.762992]  [<ffffffff8100441b>] __mutex_lock_common.isra.3+0x14b/0x1d0
> <4>[ 3983.762996]  [<ffffffff810045c3>] __mutex_lock_slowpath+0x13/0x20
> <4>[ 3983.762999]  [<ffffffff81004242>] mutex_lock+0x22/0x40
> <4>[ 3983.763004]  [<ffffffff8111918f>] ext4_orphan_del+0x4f/0x2e0
> <4>[ 3983.763008]  [<ffffffff810b2e8c>] ? insert_work+0x6c/0xb0
> <4>[ 3983.763011]  [<ffffffff81027af8>] ? diskmon_bio_complete+0x798/0xda0
> <4>[ 3983.763016]  [<ffffffff812a33e8>] ext4_end_io_dio+0xb7/0x1d7
> <4>[ 3983.763021]  [<ffffffff81050f3c>] dio_fast_end_async+0x1bc/0x1d0
> <4>[ 3983.763025]  [<ffffffff8112c93a>] ? blk_complete_request+0x1a/0x20
> <4>[ 3983.763028]  [<ffffffff81050a2d>] bio_endio+0x6d/0x80
> <4>[ 3983.763033]  [<ffffffff81129002>] req_bio_endio+0x62/0xb0
> <4>[ 3983.763036]  [<ffffffff81129202>] blk_update_request+0x142/0x3f0
> <4>[ 3983.763041]  [<ffffffff8114232e>] ? ata_qc_complete+0xae/0x1f0
> <4>[ 3983.763044]  [<ffffffff811299fc>] blk_end_bidi_request+0x2c/0xa0
> <4>[ 3983.763047]  [<ffffffff81129a80>] blk_end_request+0x10/0x20
> <4>[ 3983.763050]  [<ffffffff8113ffac>] scsi_io_completion+0xac/0x520
> <4>[ 3983.763053]  [<ffffffff8113dca7>] scsi_finish_command+0xb7/0x110
> <4>[ 3983.763056]  [<ffffffff8113fddf>] scsi_softirq_done+0x6f/0x140
> <4>[ 3983.763059]  [<ffffffff8112c7d7>] blk_done_softirq+0x77/0x80
> <4>[ 3983.763062]  [<ffffffff810156cf>] __do_softirq+0x37f/0x3e0
> <4>[ 3983.763066]  [<ffffffff8109e7bc>] ? ack_apic_level+0x7c/0x1f0
> <4>[ 3983.763070]  [<ffffffff810995cc>] call_softirq+0x1c/0x30
> <4>[ 3983.763072]  [<ffffffff81005cf1>] do_softirq+0x41/0x80
> <4>[ 3983.763074]  [<ffffffff81015879>] irq_exit+0x49/0xa0
> <4>[ 3983.763077]  [<ffffffff810055b2>] do_IRQ+0x72/0xe0
> <4>[ 3983.763083]  [<ffffffff814a0c13>] ret_from_intr+0x0/0xa
> <4>[ 3983.763084]  <EOI>  [<ffffffff81005da0>] ? c1e_idle+0x70/0x170
> <4>[ 3983.763089]  [<ffffffff81005860>] cpu_idle+0x90/0x130
> <4>[ 3983.763091]  [<ffffffff8117b45a>] rest_init+0x7e/0x80
> <4>[ 3983.763094]  [<ffffffff81b45c62>] start_kernel+0x3b7/0x3c3
> <4>[ 3983.763097]  [<ffffffff81b45331>] x86_64_start_reservations+0x141/0x145
> <4>[ 3983.763101]  [<ffffffff81b4544c>] x86_64_start_kernel+0x117/0x11e
>
>
>
> So the problem is that ext4_orphan_del() wants to sleep in softirq
> context. I started debugging and here are some questions.
>
> The first question is why ext4_orphan_del() sleeps in no-journal mode
> at all. It gets mutex to manipulate with i_orphan list but this list
> is used only in journaling mode. In non-journal mode (in my case) both
> ext4_orphan_del() and ext4_orphan_add() should be no-op.
>
> ext4_orphan_del() gets mutex in no-journal mode when it is called with
> NULL as a first parameter. There are 10 places in fs/ext4 where it
> happens:
>
> $ git grep "ext4_orphan_del(NULL"
> fs/ext4/indirect.c:845:                         ext4_orphan_del(NULL, inode);
> fs/ext4/inode.c:249:            ext4_orphan_del(NULL, inode);
> fs/ext4/inode.c:281:                    ext4_orphan_del(NULL, inode);
> fs/ext4/inode.c:956:                            ext4_orphan_del(NULL, inode);
> fs/ext4/inode.c:1069:                   ext4_orphan_del(NULL, inode);
> fs/ext4/inode.c:1111:                   ext4_orphan_del(NULL, inode);
> fs/ext4/inode.c:1177:                   ext4_orphan_del(NULL, inode);
> fs/ext4/inode.c:4338:
> ext4_orphan_del(NULL, inode);
> fs/ext4/inode.c:4365:           ext4_orphan_del(NULL, inode);
> fs/ext4/migrate.c:516:          ext4_orphan_del(NULL, tmp_inode);
>
>
> There was a change that fixes ext4_orphan_del(NULL) issue in
> ext4_setattr for no-journal mode 3d287de3b828 . And I think we should
> fix all other places as well.
>
> There are several possible solutions for this issue:
> 1) Pass handle received by ext4_journal_current_handle() or similar.
> Why do we pass NULL at all when we can use the handle? I see that in
> some functions we already have "handle" variable that we can re-use.
> 2) Follow the way used by Dmitry and call ext4_orphan_del only if
> ext4_orphan_add was successful *and* handle is valid. This is not
> always possible as not all _del() are paired with _add() in the same
> function.
> 3) Inside ext4_orphan_del() and ext4_orphan_add() check if journal is
> enabled. Do nothing if this is no-journal mode. What is the best way
> to check no-journal mode? Is it just "if (EXT4_SB(sb)->s_journal) ..."
>
> It seems that #1 is the best way.
>
> PS once this no-journal issue will be clarified I'll take a look at
> sleeping issue in journaling mode.
