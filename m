From: Mingming <cmm@us.ibm.com>
Subject: Re: Fwd: Ext4 bug with fallocate
Date: Tue, 20 Oct 2009 17:24:22 -0700
Message-ID: <1256084662.4316.4.camel@mingming-laptop>
References: <a125a870910180836i66781e1ey8113e7f8569f1fad@mail.gmail.com>
	 <a125a870910180847s5f3eaf6cxfe58e6ceb26419c6@mail.gmail.com>
	 <4ADB3AEC.8040901@redhat.com>
	 <a125a870910190249l39183927i8f042a9ace39904c@mail.gmail.com>
	 <a125a870910200949v5d9d0318q65b0ff6d5a1181e1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Fredrik Andersson <nablaman@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:37408 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755258AbZJUWsJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Oct 2009 18:48:09 -0400
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com [9.17.195.107])
	by e35.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n9LMbATZ020501
	for <linux-ext4@vger.kernel.org>; Wed, 21 Oct 2009 16:37:10 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n9LMm8CV169446
	for <linux-ext4@vger.kernel.org>; Wed, 21 Oct 2009 16:48:08 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id n9LMm5uo009962
	for <linux-ext4@vger.kernel.org>; Wed, 21 Oct 2009 16:48:05 -0600
In-Reply-To: <a125a870910200949v5d9d0318q65b0ff6d5a1181e1@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 2009-10-20 at 18:49 +0200, Fredrik Andersson wrote:
> I found the following post to the ext4 list. This seems to fit my
> experienced problems pretty exactly.
> 
> http://osdir.com/ml/linux-ext4/2009-08/msg00184.html
> 
> Is it the same problem?
> 

The link you provided about is related to a race between restart a
transaction from truncate, and the other process is doing something like
block allocation to the same file. Do you have another threads
allocating blocks while you are truncating? 

> /Fredrik
> 
> On Mon, Oct 19, 2009 at 11:49 AM, Fredrik Andersson <nablaman@gmail.com> wrote:
> > Hi, here is the data for this process:
> >
> > 5958816.744013] drdbmake      D ffff88021e4c7800     0 27019  13796
> > [5958816.744013]  ffff8801d1bcda88 0000000000000082 ffff8801f4ce9bf0
> > ffff8801678b1380
> > [5958816.744013]  0000000000010e80 000000000000c748 ffff8800404963c0
> > ffffffff81526360
> > [5958816.744013]  ffff880040496730 00000000f4ce9bf0 000000025819cebe
> > 0000000000000282
> > [5958816.744013] Call Trace:
> > [5958816.744013]  [<ffffffff813a9639>] schedule+0x9/0x20
> > [5958816.744013]  [<ffffffff81177ea5>] start_this_handle+0x365/0x5d0
> > [5958816.744013]  [<ffffffff8105b900>] ? autoremove_wake_function+0x0/
> > 0x40
> > [5958816.744013]  [<ffffffff811781ce>] jbd2_journal_restart+0xbe/0x150
> > [5958816.744013]  [<ffffffff8116243d>] ext4_ext_truncate+0x6dd/0xa20
> > [5958816.744013]  [<ffffffff81095b3b>] ? find_get_pages+0x3b/0xf0
> > [5958816.744013]  [<ffffffff81150a78>] ext4_truncate+0x198/0x680
> > [5958816.744013]  [<ffffffff810ac984>] ? unmap_mapping_range+0x74/0x280
> > [5958816.744013]  [<ffffffff811772c0>] ? jbd2_journal_stop+0x1e0/0x360
> > [5958816.744013]  [<ffffffff810acd25>] vmtruncate+0xa5/0x110
> > [5958816.744013]  [<ffffffff810dda10>] inode_setattr+0x30/0x180
> > [5958816.744013]  [<ffffffff8114d073>] ext4_setattr+0x173/0x310
> > [5958816.744013]  [<ffffffff810ddc79>] notify_change+0x119/0x330
> > [5958816.744013]  [<ffffffff810c6df3>] do_truncate+0x63/0x90
> > [5958816.744013]  [<ffffffff810d0cc3>] ? get_write_access+0x23/0x60
> > [5958816.744013]  [<ffffffff810c70cb>] sys_truncate+0x17b/0x180
> > [5958816.744013]  [<ffffffff8100bfab>] system_call_fastpath+0x16/0x1b
> >
> > Don't know if this has anything to do with it, but  I also noticed
> > that another process of mine,
> > which is working just fine, is executing a suspicious looking function
> > called raid0_unplug.
> > It operates on the same raid0/ext4 filesystem as the hung process. I
> > include the calltrace for it here too:
> >
> > [5958816.744013] nodeserv      D ffff880167bd7ca8     0 17900  13796
> > [5958816.744013]  ffff880167bd7bf8 0000000000000082 ffff88002800a588
> > ffff88021e5b56e0
> > [5958816.744013]  0000000000010e80 000000000000c748 ffff880100664020
> > ffffffff81526360
> > [5958816.744013]  ffff880100664390 000000008119bd17 000000026327bfa9
> > 0000000000000002
> > [5958816.744013] Call Trace:
> > [5958816.744013]  [<ffffffffa0039291>] ? raid0_unplug+0x51/0x70 [raid0]
> > [5958816.744013]  [<ffffffff813a9639>] schedule+0x9/0x20
> > [5958816.744013]  [<ffffffff813a9687>] io_schedule+0x37/0x50
> > [5958816.744013]  [<ffffffff81095e35>] sync_page+0x35/0x60
> > [5958816.744013]  [<ffffffff81095e69>] sync_page_killable+0x9/0x50
> > [5958816.744013]  [<ffffffff813a99d2>] __wait_on_bit_lock+0x52/0xb0
> > [5958816.744013]  [<ffffffff81095e60>] ? sync_page_killable+0x0/0x50
> > [5958816.744013]  [<ffffffff81095d74>] __lock_page_killable+0x64/0x70
> > [5958816.744013]  [<ffffffff8105b940>] ? wake_bit_function+0x0/0x40
> > [5958816.744013]  [<ffffffff81095c0b>] ? find_get_page+0x1b/0xb0
> > [5958816.744013]  [<ffffffff81097908>] generic_file_aio_read+0x3b8/0x6b0
> > [5958816.744013]  [<ffffffff810c7dc1>] do_sync_read+0xf1/0x140
> > [5958816.744013]  [<ffffffff8106a5e8>] ? do_futex+0xb8/0xb20
> > [5958816.744013]  [<ffffffff813ab78f>] ? _spin_unlock_irqrestore+0x2f/0x40
> > [5958816.744013]  [<ffffffff8105b900>] ? autoremove_wake_function+0x0/0x40
> > [5958816.744013]  [<ffffffff8105bc73>] ? add_wait_queue+0x43/0x60
> > [5958816.744013]  [<ffffffff81062a6c>] ? getnstimeofday+0x5c/0xf0
> > [5958816.744013]  [<ffffffff810c85b8>] vfs_read+0xc8/0x170
> > [5958816.744013]  [<ffffffff810c86fa>] sys_pread64+0x9a/0xa0
> > [5958816.744013]  [<ffffffff8100bfab>] system_call_fastpath+0x16/0x1b
> >

This stack seems to me this thread is doing IO but never come back.

> > Hope this makes sense to anyone, and please let me know if there is
> > more info I can provide.
> >
> > /Fredrik
> >
> > On Sun, Oct 18, 2009 at 5:57 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> >>
> >> Fredrik Andersson wrote:
> >>>
> >>> Hi, I'd like to report what I'm fairly certain is an ext4 bug. I hope
> >>> this is the right place to do so.
> >>>
> >>> My program creates a big file (around 30 GB) with posix_fallocate (to
> >>> utilize extents), fills it with data and uses ftruncate to crop it to
> >>> its final size (usually somewhere between 20 and 25 GB).
> >>> The problem is that in around 5% of the cases, the program locks up
> >>> completely in a syscall. The process can thus not be killed even with
> >>> kill -9, and a reboot is all that will do.
> >>
> >> does echo w > /proc/sysrq-trigger (this does sleeping processes; or use echo t for all processes) show you where the stuck threads are?
> >>
> >> -Eric
> >>
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


