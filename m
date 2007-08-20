From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] fix panic in jbd by adding locks
Date: Mon, 20 Aug 2007 17:20:21 +0200
Message-ID: <20070820152021.GF3784@duck.suse.cz>
References: <20070814152255.GB24127@dhcp-243-37.rdu.redhat.com> <20070815113737.GC7642@atrey.karlin.mff.cuni.cz> <20070815121704.GL24127@dhcp-243-37.rdu.redhat.com> <20070816160835.GB26703@atrey.karlin.mff.cuni.cz> <20070816163744.GB10817@dhcp-243-37.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:36254 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755002AbXHTPCH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Aug 2007 11:02:07 -0400
Content-Disposition: inline
In-Reply-To: <20070816163744.GB10817@dhcp-243-37.rdu.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu 16-08-07 12:37:45, Josef Bacik wrote:
> On Thu, Aug 16, 2007 at 06:08:35PM +0200, Jan Kara wrote:
> > > > > It is possible to panic the box by a race condition that exists in the
> > > > > journalling code where we do not take the j_revoke_lock when traversing the
> > > > > journal's revoked record list.  This patch has been tested and we haven't seen
> > > > > the issue yet, its a rather straightforward and correct (at least I think so :)
> > > > > fix.  Thank you,
> > > >   In principle, the patch looks fine. The only thing I'm wondering about
> > > > is how that panic can happen... Journal write_revoke_records() is called
> > > > from journal_commit_transaction() when revoke table for the committing
> > > > transaction shouldn't see any further changes. So maybe the patch is
> > > > masking a different problem.
> > > >   Do you have a way of reproducing the problem? Any stack trace
> > > > available?
> > > 
> > > Reproducing the problem is tricky as theres no sure way to make it happen,
> > > basically we run the box with alot of memory pressure while doing alot
> > > operations that require journalling.  Here is the backtrace of the panic (note
> > > this is on a RHEL4 kernel so 2.6.9, but the same problem exists upstream)
> >   OK.
> > 
> > > <1>Unable to handle kernel paging request at virtual address 60000000002b1110
> > > <4>kjournald[1310]: Oops 11012296146944 [1]
> > > <4>Modules linked in: ltd(U) vfat fat dm_mod button uhci_hcd shpchp e1000
> > > bond1(U) bond0(U) ext3 jbd hfcldd(U) hfcldd_conf(U) sd_mod scsi_mod
> > > <4>
> > > <4>Pid: 1310, CPU 0, comm:            kjournald
> > > <4>psr : 0000121008026018 ifs : 8000000000000c9c ip  : [<a000000200045161>]
> > > Tainted: P     
> > > <4>ip is at journal_write_revoke_records+0x221/0x4e0 [jbd]
> > > <4>unat: 0000000000000000 pfs : 0000000000000c9c rsc : 0000000000000003
> > > <4>rnat: 0000000000000000 bsps: 0000000000000000 pr  : 000000000000a681
> > > <4>ldrs: 0000000000000000 ccv : 0000000000000000 fpsr: 0009804c8a70033f
> > > <4>csd : 0000000000000000 ssd : 0000000000000000
> > > <4>b0  : a000000200045270 b6  : a00000020026a240 b7  : a00000010000ee90
> > > <4>f6  : 0fffbe38e38e381b23800 f7  : 0ffe9edc3d22c00000000
> > > <4>f8  : 1000e86fb000000000000 f9  : 100029000000000000000
> > > <4>f10 : 1000aeff71c71b9e6e61a f11 : 1003e0000000000000eff
> > > <4>r1  : a000000200234000 r2  : 000000000000048c r3  : e0000002791a7a90
> > > <4>r8  : 0000000000000000 r9  : e0000002791a0400 r10 : 0000000000000000
> > > <4>r11 : e000000001000000 r12 : e0000002791a7b00 r13 : e0000002791a0000
> > > <4>r14 : e00000027b7ee6c0 r15 : e0000002791a7b00 r16 : e000000272d48018
> > > <4>r17 : 0000000000000000 r18 : 0000000000000000 r19 : 0009804c8a70033f
> > > <4>r20 : 60000000002b1118 r21 : a00000010006ad70 r22 : 0000000000000019
> > > <4>r23 : 0000000000000000 r24 : 0000000000000000 r25 : 0000000000000019
> > > <4>r26 : 0000000000000000 r27 : 0000000000000000 r28 : 0000000000006a41
> > > <4>r29 : 0000000000000000 r30 : 0000000000000000 r31 : e00000027b7ee5a4
> > > <4>
> > > <4>Call Trace:
> > > <4> [<a000000100016da0>] show_stack+0x80/0xa0
> > > <4>                                sp=e0000002791a7690 bsp=e0000002791a1170
> > > <4> [<a0000001000176b0>] show_regs+0x890/0x8c0
> > > <4>                                sp=e0000002791a7860 bsp=e0000002791a1128
> > > <4> [<a00000010003e910>] die+0x150/0x240
> > > <4>                                sp=e0000002791a7880 bsp=e0000002791a10e8
> > > <4> [<a0000001000644c0>] ia64_do_page_fault+0x8c0/0xbc0
> > > <4>                                sp=e0000002791a7880 bsp=e0000002791a1080
> > > <4> [<a00000010000f600>] ia64_leave_kernel+0x0/0x260
> > > <4>                                sp=e0000002791a7930 bsp=e0000002791a1080
> > > <4> [<a000000200045160>] journal_write_revoke_records+0x220/0x4e0 [jbd]
> > > <4>                                sp=e0000002791a7b00 bsp=e0000002791a0f98
> > > <4> [<a00000020003d940>] journal_commit_transaction+0xf80/0x3080 [jbd]
> > > <4>                                sp=e0000002791a7b10 bsp=e0000002791a0ea0
> > > <4> [<a0000002000458d0>] kjournald+0x170/0x580 [jbd]
> > > <4>                                sp=e0000002791a7d80 bsp=e0000002791a0e38
> > > <4> [<a000000100018c70>] kernel_thread_helper+0x30/0x60
> > > <4>                                sp=e0000002791a7e30 bsp=e0000002791a0e10
> > > <4> [<a000000100008c60>] start_kernel_thread+0x20/0x40
> > > <4>                                sp=e0000002791a7e30 bsp=e0000002791a0e10
> >   Do you know (or could you find out) where exactly in the code is
> > journal_write_revoke_records+0x221/0x4e0?
> > 
> 
> Yeah sorry
> 
> 500 void journal_write_revoke_records(journal_t *journal, 
>  501                                   transaction_t *transaction)
>  502 {
>  503         struct journal_head *descriptor;
>  504         struct jbd_revoke_record_s *record;
>  505         struct jbd_revoke_table_s *revoke;
>  506         struct list_head *hash_list;
>  507         int i, offset, count;
>  508 
>  509         descriptor = NULL; 
>  510         offset = 0;
>  511         count = 0;
>  512 
>  513         /* select revoke table for committing transaction */
>  514         revoke = journal->j_revoke == journal->j_revoke_table[0] ?
>  515                 journal->j_revoke_table[1] : journal->j_revoke_table[0];
>  516 
>  517         for (i = 0; i < revoke->hash_size; i++) {
>  518                 hash_list = &revoke->hash_table[i];
>  519 
>  520                 while (!list_empty(hash_list)) {
>  521                         record = (struct jbd_revoke_record_s *) 
>  522                                 hash_list->next;
>  523                         write_one_revoke_record(journal, transaction,
>  524                                                 &descriptor, &offset, 
>  525                                                 record);
>  526                         count++;
>  527                         list_del(&record->hash); <-- here
  OK, thanks. So record probably points to an already freed memory which has
been overwritten by garbage...

> >   Thanks for details. I'm still not convinced. What they essentially
> > write is that slab cache revoke_record_cache is not guarded by any spin
> > lock. It's not and that should be fine as slab caches are SMP safe by
> > themselves.
> 
> No its the list_del thats not gaurded, so the hash list gets screwed up outside
> of a lock.  If there are other problems that need to be addressed then ok, but I
> still think that we should be protecting all of the list traversal/changing
> should be protected by the lock.  Thank you,
  But the traversal in journal_write_revoke_records() *is* in fact guarded
by the commit logic in journal_commit_transaction() handling code - it
doesn't allow anybody to mess with revoke lists when a transaction is
committing. So there's no need to guard the hash list again in
journal_write_revoke_records() by the spinlock. And if the logic does not
work and lets somebody modify revoke lists during commit, we have more
serious problems than hash list corruption. That's why I'm trying to find
out where's the real culprit of the Oops. But so far I cannot find out how
the corruption can happen...

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
