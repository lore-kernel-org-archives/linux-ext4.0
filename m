From: Jan Kara <jack@suse.cz>
Subject: Re: kernel/rcu/tree.c:1031 rcu_irq_enter() invoked with irqs
 enabled!!!!
Date: Wed, 26 Apr 2017 09:16:36 +0200
Message-ID: <20170426071636.GA21218@quack2.suse.cz>
References: <20170425201345.GB11773@linux.intel.com>
 <20170425202841.GF3956@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>,
        linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170425202841.GF3956@linux.vnet.ibm.com>
Sender: kvm-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue 25-04-17 13:28:41, Paul E. McKenney wrote:
> On Tue, Apr 25, 2017 at 02:13:45PM -0600, Ross Zwisler wrote:
> > I hit this RCU warning while running mkfs.ext4 on a PMEM namespace with
> > an unmodified v4.11-rc8 (passed through kasan_symbolize.py):
> > 
> > ===============================
> > [ ERR: suspicious RCU usage.  ]
> > 4.11.0-rc8 #1 Not tainted
> > -------------------------------
> > kernel/rcu/tree.c:1031 rcu_irq_enter() invoked with irqs enabled!!!!
> 
> Just in case there is any doubt, invoking rcu_irq_enter() with irqs
> enabled voids your kernel's RCU warranty.  ;-)
> 
> So please don't do that.

OK, but looking at the stack trace, this has nothing to do with ext4. The
problem seems to be in KVM - relevant CCs added.

								Honza

>
> > other info that might help us debug this:
> > 
> > 
> > rcu_scheduler_active = 2, debug_locks = 0
> > no locks held by mkfs.ext4/18493.
> > 
> > stack backtrace:
> > CPU: 10 PID: 18493 Comm: mkfs.ext4 Not tainted 4.11.0-rc8 #1
> > Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.3-1.fc25 04/01/2014
> > Call Trace:
> > [<     inline     >] __dump_stack project/linux/lib/dump_stack.c:16
> > [<      none      >] dump_stack+0x86/0xc3 project/linux/lib/dump_stack.c:52
> > [<      none      >] lockdep_rcu_suspicious+0xd7/0x110 project/linux/kernel/locking/lockdep.c:4461
> > [<      none      >] rcu_irq_enter+0x74/0x80 project/linux/kernel/rcu/tree.c:1031
> > [<      none      >] kvm_async_pf_task_wait+0x1af/0x240 project/linux/arch/x86/kernel/kvm.c:164
> > [<      none      >] do_async_page_fault+0x63/0x90 project/linux/arch/x86/kernel/kvm.c:269
> >  ?[<      none      >] do_async_page_fault+0x63/0x90 project/linux/arch/x86/kernel/kvm.c:269
> > [<      none      >] async_page_fault+0x28/0x30 project/linux_2/arch/x86/entry/entry_64.S:1014
> > RIP: 0010:copy_user_enhanced_fast_string+0x5/0x10
> > RSP: 0018:ffffc90008777c90 EFLAGS: 00010202
> > RAX: 0000000000000001 RBX: 0000000000001000 RCX: 0000000000001000
> > RDX: 0000000000001000 RSI: 00007f42a5d88010 RDI: ffff88007e82d000
> > RBP: ffffc90008777ce0 R08: ffff88007e82d000 R09: 0000000000000000
> > R10: 0000000000000000 R11: ffffea0001fa0b40 R12: 0000000000001000
> > R13: ffffc90008777e50 R14: ffff88007e82e000 R15: 0000000000001000
> >  ?[<     inline     >] copy_user_generic project/linux/./arch/x86/include/asm/uaccess_64.h:37
> >  ?[<     inline     >] __copy_from_user_nocheck project/linux/./arch/x86/include/asm/uaccess_64.h:59
> >  ?[<     inline     >] __copy_from_user_inatomic project/linux/./arch/x86/include/asm/uaccess_64.h:251
> >  ?[<      none      >] iov_iter_copy_from_user_atomic+0xbb/0x350 project/linux/lib/iov_iter.c:721
> > [<      none      >] generic_perform_write+0xf2/0x1d0 project/linux/mm/filemap.c:2843
> > [<      none      >] __generic_file_write_iter+0x185/0x1c0 project/linux/mm/filemap.c:2960
> > [<      none      >] blkdev_write_iter+0x96/0x110 project/linux/fs/block_dev.c:2008
> > [<     inline     >] call_write_iter project/linux/./include/linux/fs.h:1733
> > [<     inline     >] new_sync_write project/linux/fs/read_write.c:497
> > [<      none      >] __vfs_write+0xe8/0x160 project/linux/fs/read_write.c:510
> >  ?[<     inline     >] call_write_iter project/linux/./include/linux/fs.h:1733
> >  ?[<     inline     >] new_sync_write project/linux/fs/read_write.c:497
> >  ?[<      none      >] __vfs_write+0xe8/0x160 project/linux/fs/read_write.c:510
> > [<      none      >] vfs_write+0xcb/0x1f0 project/linux/fs/read_write.c:558
> > [<     inline     >] SYSC_pwrite64 project/linux/fs/read_write.c:647
> > [<      none      >] SyS_pwrite64+0x98/0xc0 project/linux/fs/read_write.c:634
> > [<      none      >] entry_SYSCALL_64_fastpath+0x1f/0xc2 project/linux_2/arch/x86/entry/entry_64.S:204
> > RIP: 0033:0x7f42acd4d213
> > RSP: 002b:00007ffc846e4e38 EFLAGS: 00000246 ORIG_RAX: 0000000000000012
> > RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f42acd4d213
> > RDX: 00000000001e0000 RSI: 00007f42a5c9f010 RDI: 0000000000000003
> > RBP: 0000559bd6c46380 R08: 00007f42a5c9f010 R09: 0000000000000200
> > R10: 0000000680820000 R11: 0000000000000246 R12: 00007ffc846e4f9c
> > R13: 0000000000000425 R14: 0000000000000200 R15: 0000559bd6c46380
> > 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
