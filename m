From: Jan Kara <jack@suse.cz>
Subject: Re: [v14 3/4] ext4: adds FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR
 interface support
Date: Wed, 29 Apr 2015 09:59:24 +0200
Message-ID: <20150429075924.GB31089@quack.suse.cz>
References: <1429728997-21464-1-git-send-email-lixi@ddn.com>
 <1429728997-21464-4-git-send-email-lixi@ddn.com>
 <20150426232033.GQ15810@dastard>
 <CAPTn0cAHOHP060cW8k0-HnyfKdVaUwAVOyLZU43AXtECK6_EaA@mail.gmail.com>
 <20150428044331.GV21261@dastard>
 <CAPTn0cBymWmQ5JKAPpFzqzivbEpjzY=s+M5O5bCsne7LbEeiLA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Chinner <david@fromorbit.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger@dilger.ca>, Jan Kara <jack@suse.cz>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"hch@infradead.org" <hch@infradead.org>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	John Stultz <john.stultz@linaro.org>,
	Thomas Gleixner <tglx@linutronix.de>
To: Li Xi <pkuelelixi@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPTn0cBymWmQ5JKAPpFzqzivbEpjzY=s+M5O5bCsne7LbEeiLA@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hi,

On Wed 29-04-15 13:49:08, Li Xi wrote:
> Thanks for the advices. I tried to run latest xfstests again. However,
  Dave actually asked you to update 'xfsprogs' not xfstests. Not that
updating xfstests would be a wrong thing to do but you still need to update
xfsprogs for xfstests to be able to run some tests. But that's unrelated to
the oops you reported below.

> the kernel crashed when runing generic/051 generic/054 and
> generic/055. And please note that the kernel also crashed on original
> linux-4.0 without any of my patches. Following is one of the dump
> stack:
  It looks like some issue with timers. John, Thomas, any idea?

								Honza

> run fstests generic/055 at 2015-04-29 13:43:39
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 31915 at lib/list_debug.c:33 __list_add+0xbe/0xd0()
> list_add corruption. prev->next should be next (ffffffff81e05018), but
> was           (null). (prev=ffff8800d8ff3ca0).
> Modules linked in: dm_flakey xfs exportfs libcrc32c nfsv3 nfs_acl
> rpcsec_gss_krb5 auth_rpcgss oid_registry nfsv4 nfs fscache lockd grace
> sunrpc ipv6 dm_mirror dm_region_hash dm_log dm_mod ppdev floppy
> parport_pc parport microcode pcspkr virtio_balloon sg 8139too 8139cp
> mii i2c_piix4 i2c_core ext4 jbd2 mbcache sr_mod cdrom sd_mod pata_acpi
> ata_generic ata_piix virtio_pci virtio_ring virtio [last unloaded:
> speedstep_lib]
> CPU: 0 PID: 31915 Comm: kworker/0:0 Not tainted 4.0.0+ #1
> Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2007
> Workqueue: events vmstat_shepherd
>  0000000000000021 ffff8800db177bf8 ffffffff815ccaf6 0000000000000021
>  ffff8800db177c48 ffff8800db177c38 ffffffff81059fc5 ffff8800db177c38
>  ffffffff81a8d480 ffffffff81e05018 ffff8800d8ff3ca0 0000000000000000
> Call Trace:
>  [<ffffffff815ccaf6>] dump_stack+0x48/0x5a
>  [<ffffffff81059fc5>] warn_slowpath_common+0x95/0xe0
>  [<ffffffff8105a0c6>] warn_slowpath_fmt+0x46/0x70
>  [<ffffffff812c04fe>] __list_add+0xbe/0xd0
>  [<ffffffff810bb84b>] __internal_add_timer+0x9b/0x110
>  [<ffffffff810bb8f9>] internal_add_timer+0x39/0x90
>  [<ffffffff810bd8c9>] mod_timer+0xf9/0x1d0
>  [<ffffffff810bd9b8>] add_timer+0x18/0x30
>  [<ffffffff81071a22>] __queue_delayed_work+0x92/0x1a0
>  [<ffffffff81071bcd>] queue_delayed_work_on+0x1d/0x40
>  [<ffffffff81160d5c>] vmstat_shepherd+0x10c/0x120
>  [<ffffffff810722ed>] process_one_work+0x14d/0x440
>  [<ffffffff810726ff>] worker_thread+0x11f/0x3d0
>  [<ffffffff815ccfaf>] ? __schedule+0x36f/0x800
>  [<ffffffff810725e0>] ? process_one_work+0x440/0x440
>  [<ffffffff810725e0>] ? process_one_work+0x440/0x440
>  [<ffffffff810774ce>] kthread+0xce/0xf0
>  [<ffffffff8104d96e>] ? __do_page_fault+0x17e/0x430
>  [<ffffffff81077400>] ? kthread_freezable_should_stop+0x70/0x70
>  [<ffffffff815d1052>] ret_from_fork+0x42/0x70
>  [<ffffffff81077400>] ? kthread_freezable_should_stop+0x70/0x70
> ---[ end trace 97c6b752be15ac57 ]---
> XFS (sdb2): Mounting V4 Filesystem
> XFS (sdb2): Ending clean mount
> XFS (sdb2): Quotacheck needed: Please wait.
> XFS (sdb2): Quotacheck: Done.
> XFS (sdb2): xfs_log_force: error -5 returned.
> XFS (sdb2): xfs_log_force: error -5 returned.
> XFS (sdb2): xfs_log_force: error -5 returned.
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
> IP: [<ffffffff810bbc88>] get_next_timer_interrupt+0x158/0x230
> PGD d8e7a067 PUD db654067 PMD 0
> Oops: 0000 [#1] SMP
> Modules linked in: dm_flakey xfs exportfs libcrc32c nfsv3 nfs_acl
> rpcsec_gss_krb5 auth_rpcgss oid_registry nfsv4 nfs fscache lockd grace
> sunrpc ipv6 dm_mirror dm_region_hash dm_log dm_mod ppdev floppy
> parport_pc parport microcode pcspkr virtio_balloon sg 8139too 8139cp
> mii i2c_piix4 i2c_core ext4 jbd2 mbcache sr_mod cdrom sd_mod pata_acpi
> ata_generic ata_piix virtio_pci virtio_ring virtio [last unloaded:
> speedstep_lib]
> CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W       4.0.0+ #1
> Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2007
> task: ffffffff81a134a0 ti: ffffffff81a00000 task.ti: ffffffff81a00000
> RIP: 0010:[<ffffffff810bbc88>]  [<ffffffff810bbc88>]
> get_next_timer_interrupt+0x158/0x230
> RSP: 0018:ffff88011fc03e48  EFLAGS: 00010013
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff81e05008
> RDX: 0000000000000001 RSI: 0000000000000011 RDI: ffffffff81e04ef8
> RBP: ffff88011fc03ea8 R08: 0000000000000011 R09: 0000000001000551
> R10: ffff88011fc03e60 R11: ffff88011fc03e78 R12: 0000000140055030
> R13: 0000000100055031 R14: ffffffff81e03ec0 R15: 0000000000000040
> FS:  0000000000000000(0000) GS:ffff88011fc00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000000000000018 CR3: 00000000d8d8f000 CR4: 00000000000006f0
> Stack:
>  ffff88011fc03e88 ffffffff810bbdf7 ffffffff81e04ef8 ffffffff81e052f8
>  ffffffff81e056f8 ffffffff81e05af8 0000000000000000 ffff88011fc0f8a0
>  0000000100055031 0000000000000000 ffff88011fc0bfc0 ffffffff81a00000
> Call Trace:
>  <IRQ>
>  [<ffffffff810bbdf7>] ? call_timer_fn+0x47/0x110
>  [<ffffffff810cdf1d>] tick_nohz_stop_sched_tick+0x1cd/0x310
>  [<ffffffff810ce108>] __tick_nohz_idle_enter+0xa8/0x150
>  [<ffffffff810ce1dd>] tick_nohz_irq_exit+0x2d/0x40
>  [<ffffffff8105deaf>] irq_exit+0x9f/0xc0
>  [<ffffffff815d34aa>] smp_apic_timer_interrupt+0x4a/0x59
>  [<ffffffff815d1a3b>] apic_timer_interrupt+0x6b/0x70
>  <EOI>
>  [<ffffffff8100f100>] ? default_idle+0x20/0xb0
>  [<ffffffff8100e74f>] arch_cpu_idle+0xf/0x20
>  [<ffffffff810986a9>] cpuidle_idle_call+0x89/0x220
>  [<ffffffff81078232>] ? __atomic_notifier_call_chain+0x12/0x20
>  [<ffffffff81098975>] cpu_idle_loop+0x135/0x1f0
>  [<ffffffff81098a43>] cpu_startup_entry+0x13/0x20
>  [<ffffffff815c5e1c>] rest_init+0x7c/0x80
>  [<ffffffff81b4e372>] start_kernel+0x3d8/0x3df
>  [<ffffffff81b4ddb8>] ? set_init_arg+0x5d/0x5d
>  [<ffffffff815cb906>] ? memblock_reserve+0x4c/0x51
>  [<ffffffff81b4d5ad>] x86_64_start_reservations+0x2a/0x2c
>  [<ffffffff81b4d6e4>] x86_64_start_kernel+0x135/0x13c
> Code: 00 48 89 45 c8 45 89 c8 41 83 e0 3f 44 89 c6 0f 1f 40 00 48 63
> ce 48 c1 e1 04 48 8b 04 39 48 8d 0c 0f 48 39 c8 74 22 0f 1f 40 00 <f6>
> 40 18 01 75 10 48 8b 50 10 48 39 da 48 0f 48 da ba 01 00 00
> RIP  [<ffffffff810bbc88>] get_next_timer_interrupt+0x158/0x230
>  RSP <ffff88011fc03e48>
> CR2: 0000000000000018
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
