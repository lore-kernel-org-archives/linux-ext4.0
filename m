From: Colin Cross <ccross@android.com>
Subject: Re: linux-next: Tree for Aug 7 [ call-trace on suspend: ext4 | pm
 related ? ]
Date: Wed, 7 Aug 2013 18:12:23 -0700
Message-ID: <CAMbhsRSP_YmaFaZ8mrXJdXjWYaXfhQHwuFL5q=QxVxDvQpygWQ@mail.gmail.com>
References: <CA+icZUW990rWKdQmppjkGTJzFBtTnW-tb0dRu2AbTYB8KSDN4w@mail.gmail.com>
	<2146168.3J7W6RtiZr@vostro.rjw.lan>
	<CAMbhsRSaJWUL2yBnEJ83TCjMJRSZNP0-XM3-mVYf7FuPtUYnUQ@mail.gmail.com>
	<CA+icZUVCBdFARueFRzAWT6Ax19s83ds5LFvqpQ-tOO96-ZhStA@mail.gmail.com>
	<CAMbhsRT6eki+oY4D-iRJz2iqS+N3YBmnC0eP4bMN69cbgj=UsQ@mail.gmail.com>
	<CA+icZUVqGpB9pgzO+Ou=k2jNQFMdjQvxxiuvZCcY4+-BZJDgdw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Linux PM List <linux-pm@lists.linux-foundation.org>,
	Tejun Heo <tj@kernel.org>
To: sedat.dilek@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-oa0-f49.google.com ([209.85.219.49]:56845 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757314Ab3HHBMY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Aug 2013 21:12:24 -0400
Received: by mail-oa0-f49.google.com with SMTP id n10so4494468oag.22
        for <linux-ext4@vger.kernel.org>; Wed, 07 Aug 2013 18:12:23 -0700 (PDT)
In-Reply-To: <CA+icZUVqGpB9pgzO+Ou=k2jNQFMdjQvxxiuvZCcY4+-BZJDgdw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 7, 2013 at 6:01 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Thu, Aug 8, 2013 at 1:34 AM, Colin Cross <ccross@android.com> wrote:
>> On Wed, Aug 7, 2013 at 4:15 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>> On Thu, Aug 8, 2013 at 12:58 AM, Colin Cross <ccross@android.com> wrote:
>>>> Can you try add a call to show_state_filter(TASK_UNINTERRUPTIBLE) in
>>>> the error path of try_to_freeze_tasks(), where it prints the "refusing
>>>> to freeze" message?  It will print the stack trace of every thread
>>>> since they are all in the freezer, so the output will be very long.
>>>>
>>>
>>> If you provide a patch, I will give it a try.
>>
>> Try the attached patch.
>
> This time I do not see ext4 related messages.
>
> - Sedat -

Can you describe your filesystem setup?  It looks like you have an
ntfs fuse filesystem and a loopback ext4 mount?  Is the file backing
the loopback ext4 filesystem located on the ntfs filesystem?

This looks like the interesting part, the process backing the fuse
filesystem is frozen (through the normal freeze path, not any of my
new freeze points), and the loop0 processes are blocked on it.  It
doesn't seem related to my patches.

[  125.336205] mount.ntfs      D ffffffff81811820     0   303      1 0x00000004
[  125.336209]  ffff8800d3e95d18 0000000000000002 0000000037a6b000
ffff8800d57a66b8
[  125.336212]  ffff8801185286c0 ffff8800d3e95fd8 ffff8800d3e95fd8
ffff8800d3e95fd8
[  125.336214]  ffffffff81c144a0 ffff8801185286c0 ffff8800d3e95d08
ffff8801185286c0
[  125.336217] Call Trace:
[  125.336225]  [<ffffffff816e81b9>] schedule+0x29/0x70
[  125.336230]  [<ffffffff810ba663>] __refrigerator+0x43/0xe0
[  125.336234]  [<ffffffff81078e19>] get_signal_to_deliver+0x5b9/0x600
[  125.336238]  [<ffffffff812c4b98>] ? fuse_dev_read+0x68/0x80
[  125.336242]  [<ffffffff810133b8>] do_signal+0x58/0x8f0
[  125.336246]  [<ffffffff8110906c>] ? acct_account_cputime+0x1c/0x20
[  125.336249]  [<ffffffff8137a90d>] ? do_raw_spin_unlock+0x5d/0xb0
[  125.336252]  [<ffffffff816e968e>] ? _raw_spin_unlock+0xe/0x10
[  125.336255]  [<ffffffff8109d00d>] ? vtime_account_user+0x6d/0x80
[  125.336258]  [<ffffffff81013cd8>] do_notify_resume+0x88/0xc0
[  125.336261]  [<ffffffff816f26da>] int_signal+0x12/0x17
[  125.336263] loop0           D ffffffff81811820     0   310      2 0x00000000
[  125.336265]  ffff8800d573d968 0000000000000002 0000000000000000
ffff8800d57aeb80
[  125.336268]  ffff880118bda740 ffff8800d573dfd8 ffff8800d573dfd8
ffff8800d573dfd8
[  125.336270]  ffff880119f98340 ffff880118bda740 ffff8800d573d968
ffff88011fad5118
[  125.336273] Call Trace:
[  125.336278]  [<ffffffff811443a0>] ? __lock_page+0x70/0x70
[  125.336280]  [<ffffffff816e81b9>] schedule+0x29/0x70
[  125.336283]  [<ffffffff816e828f>] io_schedule+0x8f/0xd0
[  125.336286]  [<ffffffff811443ae>] sleep_on_page+0xe/0x20
[  125.336288]  [<ffffffff816e49ed>] __wait_on_bit_lock+0x5d/0xc0
[  125.336291]  [<ffffffff81144397>] __lock_page+0x67/0x70
[  125.336294]  [<ffffffff8108a0e0>] ? wake_atomic_t_function+0x40/0x40
[  125.336298]  [<ffffffff811da79f>] __generic_file_splice_read+0x59f/0x5d0
[  125.336302]  [<ffffffff813656d8>] ? cpumask_next_and+0x38/0x50
[  125.336305]  [<ffffffff810a3b33>] ? update_sd_lb_stats+0x123/0x610
[  125.336309]  [<ffffffff81048143>] ? x2apic_send_IPI_mask+0x13/0x20
[  125.336312]  [<ffffffff8104029b>] ? native_smp_send_reschedule+0x4b/0x60
[  125.336315]  [<ffffffff810964b6>] ? resched_task+0x76/0x80
[  125.336318]  [<ffffffff811d8c80>] ? page_cache_pipe_buf_release+0x30/0x30
[  125.336321]  [<ffffffff811da80e>] generic_file_splice_read+0x3e/0x80
[  125.336324]  [<ffffffff811d8f6b>] do_splice_to+0x7b/0xa0
[  125.336326]  [<ffffffff811d91f7>] splice_direct_to_actor+0xa7/0x1c0
[  125.336330]  [<ffffffff81495780>] ? loop_thread+0x2a0/0x2a0
[  125.336333]  [<ffffffff81495292>] do_bio_filebacked+0xf2/0x340
[  125.336336]  [<ffffffff8137a79c>] ? do_raw_spin_lock+0x4c/0x120
[  125.336339]  [<ffffffff814955c5>] loop_thread+0xe5/0x2a0
[  125.336341]  [<ffffffff8108a060>] ? __init_waitqueue_head+0x40/0x40
[  125.336344]  [<ffffffff814954e0>] ? do_bio_filebacked+0x340/0x340
[  125.336346]  [<ffffffff81089848>] kthread+0xd8/0xe0
[  125.336348]  [<ffffffff81089770>] ? flush_kthread_worker+0xe0/0xe0
[  125.336351]  [<ffffffff816f236c>] ret_from_fork+0x7c/0xb0
[  125.336353]  [<ffffffff81089770>] ? flush_kthread_worker+0xe0/0xe0
[  125.336354] jbd2/loop0-8    D 0000000000000000     0   312      2 0x00000000
[  125.336357]  ffff8800d56c7b08 0000000000000002 ffff8800d56c7ab8
ffffffff8137a90d
[  125.336359]  ffff880037ba4240 ffff8800d56c7fd8 ffff8800d56c7fd8
ffff8800d56c7fd8
[  125.336362]  ffff88010d33e5c0 ffff880037ba4240 ffff8800d56c7b08
ffff88011fad5118
[  125.336364] Call Trace:
[  125.336367]  [<ffffffff8137a90d>] ? do_raw_spin_unlock+0x5d/0xb0
[  125.336369]  [<ffffffff811ddcb0>] ? __wait_on_buffer+0x30/0x30
[  125.336371]  [<ffffffff816e81b9>] schedule+0x29/0x70
[  125.336374]  [<ffffffff816e828f>] io_schedule+0x8f/0xd0
[  125.336376]  [<ffffffff811ddcbe>] sleep_on_buffer+0xe/0x20
[  125.336378]  [<ffffffff816e4c22>] __wait_on_bit+0x62/0x90
[  125.336380]  [<ffffffff811ddcb0>] ? __wait_on_buffer+0x30/0x30
[  125.336382]  [<ffffffff816e4ccc>] out_of_line_wait_on_bit+0x7c/0x90
[  125.336384]  [<ffffffff8108a0e0>] ? wake_atomic_t_function+0x40/0x40
[  125.336386]  [<ffffffff811ddcae>] __wait_on_buffer+0x2e/0x30
[  125.336390]  [<ffffffff812a02c1>]
jbd2_journal_commit_transaction+0x1051/0x1c60
[  125.336393]  [<ffffffff810a460b>] ? load_balance+0x14b/0x870
[  125.336397]  [<ffffffff816e97e4>] ? _raw_spin_lock_irqsave+0x24/0x30
[  125.336399]  [<ffffffff8107328f>] ? try_to_del_timer_sync+0x4f/0x70
[  125.336402]  [<ffffffff812a5a7b>] kjournald2+0x11b/0x350
[  125.336405]  [<ffffffff816e72e5>] ? __schedule+0x3e5/0x850
[  125.336407]  [<ffffffff8108a060>] ? __init_waitqueue_head+0x40/0x40
[  125.336410]  [<ffffffff812a5960>] ? jbd2_journal_clear_features+0x90/0x90
[  125.336412]  [<ffffffff81089848>] kthread+0xd8/0xe0
[  125.336414]  [<ffffffff81089770>] ? flush_kthread_worker+0xe0/0xe0
[  125.336416]  [<ffffffff816f236c>] ret_from_fork+0x7c/0xb0
[  125.336418]  [<ffffffff81089770>] ? flush_kthread_worker+0xe0/0xe0
