From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] fix panic in jbd by adding locks
Date: Thu, 16 Aug 2007 18:08:35 +0200
Message-ID: <20070816160835.GB26703@atrey.karlin.mff.cuni.cz>
References: <20070814152255.GB24127@dhcp-243-37.rdu.redhat.com> <20070815113737.GC7642@atrey.karlin.mff.cuni.cz> <20070815121704.GL24127@dhcp-243-37.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:36181 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755371AbXHPQIg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Aug 2007 12:08:36 -0400
Content-Disposition: inline
In-Reply-To: <20070815121704.GL24127@dhcp-243-37.rdu.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hello,

> > > It is possible to panic the box by a race condition that exists in the
> > > journalling code where we do not take the j_revoke_lock when traversing the
> > > journal's revoked record list.  This patch has been tested and we haven't seen
> > > the issue yet, its a rather straightforward and correct (at least I think so :)
> > > fix.  Thank you,
> >   In principle, the patch looks fine. The only thing I'm wondering about
> > is how that panic can happen... Journal write_revoke_records() is called
> > from journal_commit_transaction() when revoke table for the committing
> > transaction shouldn't see any further changes. So maybe the patch is
> > masking a different problem.
> >   Do you have a way of reproducing the problem? Any stack trace
> > available?
> 
> Reproducing the problem is tricky as theres no sure way to make it happen,
> basically we run the box with alot of memory pressure while doing alot
> operations that require journalling.  Here is the backtrace of the panic (note
> this is on a RHEL4 kernel so 2.6.9, but the same problem exists upstream)
  OK.

> <1>Unable to handle kernel paging request at virtual address 60000000002b1110
> <4>kjournald[1310]: Oops 11012296146944 [1]
> <4>Modules linked in: ltd(U) vfat fat dm_mod button uhci_hcd shpchp e1000
> bond1(U) bond0(U) ext3 jbd hfcldd(U) hfcldd_conf(U) sd_mod scsi_mod
> <4>
> <4>Pid: 1310, CPU 0, comm:            kjournald
> <4>psr : 0000121008026018 ifs : 8000000000000c9c ip  : [<a000000200045161>]
> Tainted: P     
> <4>ip is at journal_write_revoke_records+0x221/0x4e0 [jbd]
> <4>unat: 0000000000000000 pfs : 0000000000000c9c rsc : 0000000000000003
> <4>rnat: 0000000000000000 bsps: 0000000000000000 pr  : 000000000000a681
> <4>ldrs: 0000000000000000 ccv : 0000000000000000 fpsr: 0009804c8a70033f
> <4>csd : 0000000000000000 ssd : 0000000000000000
> <4>b0  : a000000200045270 b6  : a00000020026a240 b7  : a00000010000ee90
> <4>f6  : 0fffbe38e38e381b23800 f7  : 0ffe9edc3d22c00000000
> <4>f8  : 1000e86fb000000000000 f9  : 100029000000000000000
> <4>f10 : 1000aeff71c71b9e6e61a f11 : 1003e0000000000000eff
> <4>r1  : a000000200234000 r2  : 000000000000048c r3  : e0000002791a7a90
> <4>r8  : 0000000000000000 r9  : e0000002791a0400 r10 : 0000000000000000
> <4>r11 : e000000001000000 r12 : e0000002791a7b00 r13 : e0000002791a0000
> <4>r14 : e00000027b7ee6c0 r15 : e0000002791a7b00 r16 : e000000272d48018
> <4>r17 : 0000000000000000 r18 : 0000000000000000 r19 : 0009804c8a70033f
> <4>r20 : 60000000002b1118 r21 : a00000010006ad70 r22 : 0000000000000019
> <4>r23 : 0000000000000000 r24 : 0000000000000000 r25 : 0000000000000019
> <4>r26 : 0000000000000000 r27 : 0000000000000000 r28 : 0000000000006a41
> <4>r29 : 0000000000000000 r30 : 0000000000000000 r31 : e00000027b7ee5a4
> <4>
> <4>Call Trace:
> <4> [<a000000100016da0>] show_stack+0x80/0xa0
> <4>                                sp=e0000002791a7690 bsp=e0000002791a1170
> <4> [<a0000001000176b0>] show_regs+0x890/0x8c0
> <4>                                sp=e0000002791a7860 bsp=e0000002791a1128
> <4> [<a00000010003e910>] die+0x150/0x240
> <4>                                sp=e0000002791a7880 bsp=e0000002791a10e8
> <4> [<a0000001000644c0>] ia64_do_page_fault+0x8c0/0xbc0
> <4>                                sp=e0000002791a7880 bsp=e0000002791a1080
> <4> [<a00000010000f600>] ia64_leave_kernel+0x0/0x260
> <4>                                sp=e0000002791a7930 bsp=e0000002791a1080
> <4> [<a000000200045160>] journal_write_revoke_records+0x220/0x4e0 [jbd]
> <4>                                sp=e0000002791a7b00 bsp=e0000002791a0f98
> <4> [<a00000020003d940>] journal_commit_transaction+0xf80/0x3080 [jbd]
> <4>                                sp=e0000002791a7b10 bsp=e0000002791a0ea0
> <4> [<a0000002000458d0>] kjournald+0x170/0x580 [jbd]
> <4>                                sp=e0000002791a7d80 bsp=e0000002791a0e38
> <4> [<a000000100018c70>] kernel_thread_helper+0x30/0x60
> <4>                                sp=e0000002791a7e30 bsp=e0000002791a0e10
> <4> [<a000000100008c60>] start_kernel_thread+0x20/0x40
> <4>                                sp=e0000002791a7e30 bsp=e0000002791a0e10
  Do you know (or could you find out) where exactly in the code is
journal_write_revoke_records+0x221/0x4e0?

> While analyzing the problem, Hitachi came up with this explanation for the race
> condition
> 
> PID: 31401  TASK: e00000004fb30000  CPU: 1   COMMAND: "GET"
> #0 [BSP:e00000004fb314d8] context_switch at a00000010006ab90
> #1 [BSP:e00000004fb313b8] schedule at a000000100590f40
> #2 [BSP:e00000004fb31340] do_get_write_access at a0000002000388e0
> #3 [BSP:e00000004fb31300] journal_get_write_access at a000000200039680
> #4 [BSP:e00000004fb312b8] ext3_reserve_inode_write at a00000020013f180
> #5 [BSP:e00000004fb31290] ext3_mark_inode_dirty at a00000020013f2a0
> #6 [BSP:e00000004fb31260] ext3_dirty_inode at a000000200144310
> #7 [BSP:e00000004fb31210] __mark_inode_dirty at a000000100178200
> #8 [BSP:e00000004fb311e8] update_atime at a000000100165cc0
> #9 [BSP:e00000004fb31128] do_generic_mapping_read at a0000001000d40e0
> #10 [BSP:e00000004fb310c0] __generic_file_aio_read at a0000001000d8b40
> #11 [BSP:e00000004fb31088] generic_file_aio_read at a0000001000d8f60
> #12 [BSP:e00000004fb31048] do_sync_read at a0000001001238a0
> #13 [BSP:e00000004fb30ff0] vfs_read at a000000100123b90
> #14 [BSP:e00000004fb30f78] sys_read at a0000001001241d0
> 
> do_get_write_access() can call journal_revoke_cancel().
  I guess you mean journal_cancel_revoke()...

> revoke_record_cache variable is operated in journal_revoke_cancel().
> journal_revoke_cancel() is called in user process context, and
> journal_write_revoke_records() is called in kjournald context.
> Therefore, there is a race condition between journal_revoke_cancel() and
> journal_write_revoke_records() because journal_write_revoke_records()
> operates revoke_record_cache variable without lock.
  Thanks for details. I'm still not convinced. What they essentially
write is that slab cache revoke_record_cache is not guarded by any spin
lock. It's not and that should be fine as slab caches are SMP safe by
themselves.
  What could be a problem are hash tables of these revoke records kept
for the running and committing transaction. But as I've written above,
at the moment when journal_write_revoke_records() is called the currently
running transaction is locked, all handles of it are already released
and so nothing can touch the revoke table...
  I'm not saying there's not a bug somewhere but your patch does not
seem to help it in any way. Personally, what I find more suspicious is
that journal_cancel_revoke() is called from do_get_write_access()
without any locks. Similarly I don't see any locks around journal_revoke()
when called from ext3. Thus interesting things could possibly happen
when these two meet on the same buffer. I have to investigate more in
detail though.
								Honza
