From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: 2.6.32.4 - still getting ext4 related crashes
Date: Thu, 28 Jan 2010 13:17:06 -0500
Message-ID: <4B61D4A2.5020407@redhat.com>
References: <20100122085035.GA5020@nik-nb2.linuxbox.cz> <20100122213827.GH21263@thunk.org> <20100124071943.GA4407@nik-comp.linuxbox.cz> <20100124094853.GA4382@thunk.org> <20100126204754.GA4637@nik-comp.linuxbox.cz> <4B60A4A6.3070001@redhat.com> <20100128172442.GA531@develbox.linuxbox.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
	ext4 maillist <linux-ext4@vger.kernel.org>,
	IDE/ATA development list <linux-ide@vger.kernel.org>,
	mzik@linuxbox.cz
To: Nikola Ciprich <extmaillist@linuxbox.cz>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20100128172442.GA531@develbox.linuxbox.cz>
Sender: linux-ide-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 01/28/2010 12:24 PM, Nikola Ciprich wrote:
>> If you only see this with an external S-ATA box and a long cable, we
>> might have issues with S-ATA (and knock on issues with error
>> handling up the stack).
>>
>> Can you summarize/repost the log of the panic with the linux-ide
>> people cc'ed (added above)?
> Hi Ric,
> sure, here's summary of the problem:
> After upgrading my box to 2.6.32.x, it started crashing while copying larger amounts of data (backtraces follow). I did a lot of testing, and it always happens, when the  target disk is connected using external eSATA box and using long (~1M) eSATA cable. In this case, it's enough to start 2 parallel copying processes, and crash follows within minutes (tested on two different machines, using two differrent boxes). I first thought it doesn't happen with shorter eSATA cable, but leaving copying running in cycle for hours invoked crash as well - so it just takes much longer. It never happens while using standard SATA cable with directly connected disk. So now my concerns are:
>
> - if the box is screwing data, then kernel maybe could behave in better way then just crashing with lots of backtraces.
> - it's strange that with older kernels (<= 2.6.31.x) it *SEEMED* to work. I plan to repeat tests with older kernels, and with checking MD5 of written data to see if it was writing data correctly, or just not noticing something is wrong.
> - the whole thing leads me to another question - what is the current state of block device integrity support?  I haven't found much information about it, do common SATA drives support it? Can filesystems like ext4 use it?
>
> Anyways, if there is anything else I could do/test, please let me know. Since I can reproduce the problem on testing box, I'm free to test new kernels, git snapshots, bisect, whatever :)
>
> cheers
>
> nik

Hi Nik,

The interesting thing (or lack of interesting thing) is that I do not see any IO 
errors. I would expect to see something if your e-SATA enclosure and the s-ata 
cable length are prducing bad data.

Are there any IO errors in the log before the stream of file system issues?

Thanks!

ric



>
>
> here are the traces:
> [ 2325.861079] ------------[ cut here ]------------
> [ 2325.865003] kernel BUG at fs/ext4/inode.c:1852!
> [ 2325.865003] invalid opcode: 0000 [#1] PREEMPT SMP
> [ 2325.865003] last sysfs file: /sys/devices/pci0000:00/0000:00:03.0/0000:0a:00.0/0000:0b:0e.0/host4/target4:0:3/4:0:3:0/type
> [ 2325.880011] CPU 1
> [ 2325.880011] Modules linked in: ext4 jbd2 crc16 sha256_generic krng ansi_cprng eseqiv rng cryptd crypto_wq aes_x86_64 aes_generic cbc cryptomgr crypto_hash aead pcompress dm_crypt crypto_blkcipher crypto_algapi ipmi_si ipmi_devintf ipmi_msghandler netconsole nfsd nfs_acl auth_rpcgss exportfs ipv6 autofs4 lockd sunrpc 8021q cpufreq_ondemand acpi_cpufreq freq_table reiserfs crc32 raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx video backlight output sbs sbshc fan battery ac piix pata_acpi ide_pci_generic container ide_core joydev ata_piix processor usbhid thermal button rng_core thermal_sys i2c_i801 i2c_core iTCO_wdt i3000_edac ata_generic shpchp pcspkr pci_hotplug e1000e edac_core sg arcmsr ahci libata sd_mod scsi_mod crc_t10dif raid1 dm_snapshot dm_zero 
 dm_mirror dm_region_hash dm_log dm_mod ext3 jbd uhci_hcd ohci_hcd ehci_hcd [last unloaded: scsi_wait_scan]
> [ 2325.880011] Pid: 4993, comm: mc Not tainted 2.6.32lb.05 #1 PDSM4+
> [ 2325.880011] RIP: 0010:[<ffffffffa06227ec>]  [<ffffffffa06227ec>] ext4_da_get_block_prep+0x29c/0x2b0 [ext4]
> [ 2325.880011] RSP: 0018:ffff880074acf9f8  EFLAGS: 00010202
> [ 2325.880011] RAX: 0000000000000054 RBX: ffff88005665f090 RCX: 0000000000000001
> [ 2325.880011] RDX: 0000000000000053 RSI: 0000000000000053 RDI: 0000000000000154
> [ 2325.880011] RBP: ffff880074acfa58 R08: 0000000000000153 R09: 0000000000000000
> [ 2325.880011] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000001000
> [ 2325.880011] R13: ffff88006ee711c0 R14: ffff88005665ef60 R15: 0000000000001000
> [ 2325.880011] FS:  00007fb72114d6e0(0000) GS:ffff880001f00000(0000) knlGS:0000000000000000
> [ 2325.880011] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 2325.880011] CR2: 00007f42d73d3000 CR3: 00000000743ba000 CR4: 00000000000006e0
> [ 2325.880011] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 2325.880011] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [ 2325.880011] Process mc (pid: 4993, threadinfo ffff880074ace000, task ffff88007c562720)
> [ 2325.880011] Stack:
> [ 2325.880011]  ffff88005665f090 ffff88005665f530 0000000074acfa28 ffffffffffff0000
> [ 2325.880011]<0>  ffff880071e5b800 ffffea0001d88e90 0000000074acfa58 0000000000001000
> [ 2325.880011]<0>  0000000000001000 0000000000000000 ffff880074acfad8 0000000000001000
> [ 2325.880011] Call Trace:
> [ 2325.880011]  [<ffffffff8113d15c>] __block_prepare_write+0x27c/0x440
> [ 2325.880011]  [<ffffffffa0622550>] ? ext4_da_get_block_prep+0x0/0x2b0 [ext4]
> [ 2325.880011]  [<ffffffff810dbb92>] ? __lru_cache_add+0x72/0xb0
> [ 2325.880011]  [<ffffffff8113d3b9>] block_write_begin+0x59/0xe0
> [ 2325.880011]  [<ffffffffa0621612>] ext4_da_write_begin+0x182/0x280 [ext4]
> [ 2325.880011]  [<ffffffffa0622550>] ? ext4_da_get_block_prep+0x0/0x2b0 [ext4]
> [ 2325.880011]  [<ffffffff810d29aa>] generic_file_buffered_write+0x10a/0x290
> [ 2325.880011]  [<ffffffff810d2ef6>] __generic_file_aio_write+0x266/0x420
> [ 2325.880011]  [<ffffffff810d30f6>] ? generic_file_aio_write+0x46/0xb0
> [ 2325.880011]  [<ffffffff810d310c>] generic_file_aio_write+0x5c/0xb0
> [ 2325.880011]  [<ffffffffa0617f06>] ext4_file_write+0x46/0xb0 [ext4]
> [ 2325.880011]  [<ffffffff81114f11>] do_sync_write+0xf1/0x130
> [ 2325.880011]  [<ffffffff8106e640>] ? autoremove_wake_function+0x0/0x40
> [ 2325.880011]  [<ffffffff810a4762>] ? audit_filter_syscall+0x92/0x190
> [ 2325.880011]  [<ffffffff810a470a>] ? audit_filter_syscall+0x3a/0x190
> [ 2325.880011]  [<ffffffff810a469f>] ? audit_filter_inodes+0x19f/0x1d0
> [ 2325.880011]  [<ffffffff81199491>] ? security_file_permission+0x11/0x20
> [ 2325.880011]  [<ffffffff81115737>] vfs_write+0xc7/0x1a0
> [ 2325.880011]  [<ffffffff81115e40>] sys_write+0x50/0x90
> [ 2325.880011]  [<ffffffff8100b2ab>] system_call_fastpath+0x16/0x1b
> [ 2325.880011] Code: 55 b8 49 89 55 18 48 8b 40 18 49 89 45 20 f0 41 80 4d 00 40 f0 41 80 4d 01 02 e9 69 ff ff ff c7 45 b4 86 ff ff ff e9 5d ff ff ff<0f>  0b eb fe 0f 0b eb fe 0f 0b eb fe 90 90 90 90 90 90 90 90 55
> [ 2325.880011] RIP  [<ffffffffa06227ec>] ext4_da_get_block_prep+0x29c/0x2b0 [ext4]
> [ 2325.880011]  RSP<ffff880074acf9f8>
> [ 2326.278501] ---[ end trace a098b7f7914465c3 ]---
> [ 2326.283355] note: mc[4993] exited with preempt_count 1
> [ 2326.288756] BUG: scheduling while atomic: mc/4993/0x10000002
> [ 2326.294693] INFO: lockdep is turned off.
> [ 2326.298967] Modules linked in: ...
> [ 2326.387665] Pid: 4993, comm: mc Tainted: G      D    2.6.32lb.05 #1
> [ 2326.394188] Call Trace:
> [ 2326.396801]  [<ffffffff8107e6d5>] ? __debug_show_held_locks+0x25/0x30
> [ 2326.403518]  [<ffffffff81041125>] __schedule_bug+0x65/0x70
> [ 2326.409275]  [<ffffffff81340495>] thread_return+0x6e8/0x823
> [ 2326.415134]  [<ffffffff81043993>] __cond_resched+0x13/0x30
> [ 2326.420870]  [<ffffffff81340648>] _cond_resched+0x28/0x30
> [ 2326.426542]  [<ffffffff810ee54b>] unmap_vmas+0x93b/0x9d0
> [ 2326.432097]  [<ffffffff810f347e>] exit_mmap+0xde/0x190
> [ 2326.437464]  [<ffffffff8104d444>] mmput+0x54/0x110
> [ 2326.442541]  [<ffffffff81052502>] exit_mm+0x102/0x130
> [ 2326.447814]  [<ffffffff8122ab0d>] ? tty_audit_exit+0x2d/0x90
> [ 2326.453718]  [<ffffffff81053c4d>] do_exit+0x18d/0x7d0
> [ 2326.459013]  [<ffffffff8100f8d7>] oops_end+0xa7/0xb0
> [ 2326.464195]  [<ffffffff8100fad6>] die+0x56/0x90
> [ 2326.468971]  [<ffffffff8100c820>] do_trap+0x130/0x150
> [ 2326.474260]  [<ffffffff8100ce90>] do_invalid_op+0x90/0xb0
> [ 2326.479929]  [<ffffffffa06227ec>] ? ext4_da_get_block_prep+0x29c/0x2b0 [ext4]
> [ 2326.487370]  [<ffffffff8100c0b5>] invalid_op+0x15/0x20
> [ 2326.492853]  [<ffffffffa06227ec>] ? ext4_da_get_block_prep+0x29c/0x2b0 [ext4]
> [ 2326.500290]  [<ffffffffa06226bb>] ? ext4_da_get_block_prep+0x16b/0x2b0 [ext4]
> [ 2326.507731]  [<ffffffff8113d15c>] __block_prepare_write+0x27c/0x440
> [ 2326.514280]  [<ffffffffa0622550>] ? ext4_da_get_block_prep+0x0/0x2b0 [ext4]
> [ 2326.521540]  [<ffffffff810dbb92>] ? __lru_cache_add+0x72/0xb0
> [ 2326.527519]  [<ffffffff8113d3b9>] block_write_begin+0x59/0xe0
> [ 2326.533545]  [<ffffffffa0621612>] ext4_da_write_begin+0x182/0x280 [ext4]
> [ 2326.540591]  [<ffffffffa0622550>] ? ext4_da_get_block_prep+0x0/0x2b0 [ext4]
> [ 2326.547857]  [<ffffffff810d29aa>] generic_file_buffered_write+0x10a/0x290
> [ 2326.556534]  [<ffffffff810d2ef6>] __generic_file_aio_write+0x266/0x420
> [ 2326.563380]  [<ffffffff810d30f6>] ? generic_file_aio_write+0x46/0xb0
> [ 2326.570055]  [<ffffffff810d310c>] generic_file_aio_write+0x5c/0xb0
> [ 2326.576548]  [<ffffffffa0617f06>] ext4_file_write+0x46/0xb0 [ext4]
> [ 2326.583036]  [<ffffffff81114f11>] do_sync_write+0xf1/0x130
> [ 2326.588834]  [<ffffffff8106e640>] ? autoremove_wake_function+0x0/0x40
> [ 2326.595559]  [<ffffffff810a4762>] ? audit_filter_syscall+0x92/0x190
> [ 2326.602112]  [<ffffffff810a470a>] ? audit_filter_syscall+0x3a/0x190
> [ 2326.608665]  [<ffffffff810a469f>] ? audit_filter_inodes+0x19f/0x1d0
> [ 2326.615228]  [<ffffffff81199491>] ? security_file_permission+0x11/0x20
> [ 2326.622061]  [<ffffffff81115737>] vfs_write+0xc7/0x1a0
> [ 2326.627451]  [<ffffffff81115e40>] sys_write+0x50/0x90
> [ 2326.632765]  [<ffffffff8100b2ab>] system_call_fastpath+0x16/0x1b
> [ 2326.639643] ------------[ cut here ]------------
> [ 2326.643044] kernel BUG at fs/jbd/transaction.c:280!
> [ 2326.643044] invalid opcode: 0000 [#2] PREEMPT SMP
> [ 2326.643044] last sysfs file: /sys/devices/pci0000:00/0000:00:03.0/0000:0a:00.0/0000:0b:0e.0/host4/target4:0:3/4:0:3:0/type
> [ 2326.643044] CPU 0
> [ 2326.643044] Modules linked in:...
> [ 2326.643044] Pid: 4993, comm: mc Tainted: G      D    2.6.32lb.05 #1 PDSM4+
> [ 2326.643044] RIP: 0010:[<ffffffffa002850c>]  [<ffffffffa002850c>] journal_start+0xec/0xf0 [jbd]
> [ 2326.643044] RSP: 0018:ffff880074acf2f8  EFLAGS: 00010206
> [ 2326.643044] RAX: ffff880073f1ba00 RBX: ffff88007aafae10 RCX: 0000000000000000
> [ 2326.643044] RDX: 0000000000000000 RSI: 0000000000000002 RDI: ffff88006de24000
> [ 2326.643044] RBP: ffff880074acf328 R08: 0000000000000001 R09: 0000000000000040
> [ 2326.643044] R10: 0000000000000001 R11: ffff880074acf480 R12: ffff88007aafae10
> [ 2326.643044] R13: ffff88006de24000 R14: ffff88007c562720 R15: 0000000000000002
> [ 2326.643044] FS:  00007fb72114d6e0(0000) GS:ffff880001e00000(0000) knlGS:0000000000000000
> [ 2326.643044] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 2326.643044] CR2: 00007fe90556b011 CR3: 0000000076954000 CR4: 00000000000006f0
> [ 2326.643044] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 2326.643044] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [ 2326.643044] Process mc (pid: 4993, threadinfo ffff880074ace000, task ffff88007c562720)
> [ 2326.643044] Stack:
> [ 2326.643044]  0000000000000202 0000000000000001 ffff88007aafae10 ffff8800784977a8
> [ 2326.643044]<0>  000000004b5961a7 ffff880079064500 ffff880074acf338 ffffffffa004c47c
> [ 2326.643044]<0>  ffff880074acf368 ffffffffa00461b8 000000000001bde0 0000000000000001
> [ 2326.643044] Call Trace:
> [ 2326.643044]  [<ffffffffa004c47c>] ext3_journal_start_sb+0x2c/0x50 [ext3]
> [ 2326.643044]  [<ffffffffa00461b8>] ext3_dirty_inode+0x38/0x90 [ext3]
> [ 2326.643044]  [<ffffffff81136995>] __mark_inode_dirty+0x35/0x180
> [ 2326.643044]  [<ffffffff8112c545>] file_update_time+0xe5/0x190
> [ 2326.643044]  [<ffffffff810d2ec2>] __generic_file_aio_write+0x232/0x420
> [ 2326.643044]  [<ffffffff810d30f6>] ? generic_file_aio_write+0x46/0xb0
> [ 2326.643044]  [<ffffffff810d30f6>] ? generic_file_aio_write+0x46/0xb0
> [ 2326.643044]  [<ffffffff810d310c>] generic_file_aio_write+0x5c/0xb0
> [ 2326.643044]  [<ffffffff81114f11>] do_sync_write+0xf1/0x130
> [ 2326.643044]  [<ffffffff8106e640>] ? autoremove_wake_function+0x0/0x40
> [ 2326.643044]  [<ffffffff810929bc>] ? do_acct_process+0x23c/0x4e0
> [ 2326.643044]  [<ffffffff81092af2>] do_acct_process+0x372/0x4e0
> [ 2326.643044]  [<ffffffff810928d0>] ? do_acct_process+0x150/0x4e0
> [ 2326.643044]  [<ffffffff81092ccc>] acct_process+0x6c/0xa0
> [ 2326.643044]  [<ffffffff810541d5>] do_exit+0x715/0x7d0
> [ 2326.643044]  [<ffffffff8100f8d7>] oops_end+0xa7/0xb0
> [ 2326.643044]  [<ffffffff8100fad6>] die+0x56/0x90
> [ 2326.643044]  [<ffffffff8100c820>] do_trap+0x130/0x150
> [ 2326.643044]  [<ffffffff8100ce90>] do_invalid_op+0x90/0xb0
> [ 2326.643044]  [<ffffffffa06227ec>] ? ext4_da_get_block_prep+0x29c/0x2b0 [ext4]
> [ 2326.643044]  [<ffffffff8100c0b5>] invalid_op+0x15/0x20
> [ 2326.643044]  [<ffffffffa06227ec>] ? ext4_da_get_block_prep+0x29c/0x2b0 [ext4]
> [ 2326.643044]  [<ffffffffa06226bb>] ? ext4_da_get_block_prep+0x16b/0x2b0 [ext4]
> [ 2326.643044]  [<ffffffff8113d15c>] __block_prepare_write+0x27c/0x440
> [ 2326.643044]  [<ffffffffa0622550>] ? ext4_da_get_block_prep+0x0/0x2b0 [ext4]
> [ 2326.643044]  [<ffffffff810dbb92>] ? __lru_cache_add+0x72/0xb0
> [ 2326.643044]  [<ffffffff8113d3b9>] block_write_begin+0x59/0xe0
> [ 2326.643044]  [<ffffffffa0621612>] ext4_da_write_begin+0x182/0x280 [ext4]
> [ 2326.643044]  [<ffffffffa0622550>] ? ext4_da_get_block_prep+0x0/0x2b0 [ext4]
> [ 2326.643044]  [<ffffffff810d29aa>] generic_file_buffered_write+0x10a/0x290
> [ 2326.643044]  [<ffffffff810d2ef6>] __generic_file_aio_write+0x266/0x420
> [ 2326.643044]  [<ffffffff810d30f6>] ? generic_file_aio_write+0x46/0xb0
> [ 2326.643044]  [<ffffffff810d310c>] generic_file_aio_write+0x5c/0xb0
> [ 2326.643044]  [<ffffffffa0617f06>] ext4_file_write+0x46/0xb0 [ext4]
> [ 2326.643044]  [<ffffffff81114f11>] do_sync_write+0xf1/0x130
> [ 2326.643044]  [<ffffffff8106e640>] ? autoremove_wake_function+0x0/0x40
> [ 2326.643044]  [<ffffffff810a4762>] ? audit_filter_syscall+0x92/0x190
> [ 2326.643044]  [<ffffffff810a470a>] ? audit_filter_syscall+0x3a/0x190
> [ 2326.643044]  [<ffffffff810a469f>] ? audit_filter_inodes+0x19f/0x1d0
> [ 2326.643044]  [<ffffffff81199491>] ? security_file_permission+0x11/0x20
> [ 2326.643044]  [<ffffffff81115737>] vfs_write+0xc7/0x1a0
> [ 2326.643044]  [<ffffffff81115e40>] sys_write+0x50/0x90
> [ 2326.643044]  [<ffffffff8100b2ab>] system_call_fastpath+0x16/0x1b
> [ 2326.643044] Code: ff ff 85 c0 41 89 c4 79 84 48 8b 3d 17 91 00 00 48 89 de 49 63 dc e8 14 31 0e e1 49 c7 86 08 16 00 00 00 00 00 00 e9 62 ff ff ff<0f>  0b eb fe 55 be 01 00 00 00 48 89 e5 e8 02 ff ff ff 48 3d 00
> [ 2326.643044] RIP  [<ffffffffa002850c>] journal_start+0xec/0xf0 [jbd]
> [ 2326.643044]  RSP<ffff880074acf2f8>
> [ 2327.196604] ---[ end trace a098b7f7914465c4 ]---
> [ 2327.202605] Fixing recursive fault but reboot is needed!
> [ 2327.208771] BUG: scheduling while atomic: mc/4993/0x00000002
> [ 2327.215260] INFO: lockdep is turned off.
> [ 2327.219481] Modules linked in:...
> [ 2327.316660] Pid: 4993, comm: mc Tainted: G      D    2.6.32lb.05 #1
> [ 2327.323275] Call Trace:
> [ 2327.325941]  [<ffffffff8107e6d5>] ? __debug_show_held_locks+0x25/0x30
> [ 2327.332718]  [<ffffffff81041125>] __schedule_bug+0x65/0x70
> [ 2327.338506]  [<ffffffff81340495>] thread_return+0x6e8/0x823
> [ 2327.344449]  [<ffffffff81054275>] do_exit+0x7b5/0x7d0
> [ 2327.349818]  [<ffffffff8100f8d7>] oops_end+0xa7/0xb0
> [ 2327.355610]  [<ffffffff8100fad6>] die+0x56/0x90
> [ 2327.360972]  [<ffffffff8100c820>] do_trap+0x130/0x150
> [ 2327.366358]  [<ffffffff8100ce90>] do_invalid_op+0x90/0xb0
> [ 2327.372602]  [<ffffffffa002850c>] ? journal_start+0xec/0xf0 [jbd]
> [ 2327.379599]  [<ffffffff81051055>] ? vprintk+0x3c5/0x4c0
> [ 2327.385178]  [<ffffffff8100c0b5>] invalid_op+0x15/0x20
> [ 2327.391134]  [<ffffffffa002850c>] ? journal_start+0xec/0xf0 [jbd]
> [ 2327.398091]  [<ffffffffa004c47c>] ext3_journal_start_sb+0x2c/0x50 [ext3]
> [ 2327.405184]  [<ffffffffa00461b8>] ext3_dirty_inode+0x38/0x90 [ext3]
> [ 2327.412338]  [<ffffffff81136995>] __mark_inode_dirty+0x35/0x180
> [ 2327.419145]  [<ffffffff8112c545>] file_update_time+0xe5/0x190
> [ 2327.425788]  [<ffffffff810d2ec2>] __generic_file_aio_write+0x232/0x420
> [ 2327.432710]  [<ffffffff810d30f6>] ? generic_file_aio_write+0x46/0xb0
> [ 2327.440027]  [<ffffffff810d30f6>] ? generic_file_aio_write+0x46/0xb0
> [ 2327.447403]  [<ffffffff810d310c>] generic_file_aio_write+0x5c/0xb0
> [ 2327.454457]  [<ffffffff81114f11>] do_sync_write+0xf1/0x130
> [ 2327.460357]  [<ffffffff8106e640>] ? autoremove_wake_function+0x0/0x40
> [ 2327.467694]  [<ffffffff810929bc>] ? do_acct_process+0x23c/0x4e0
> [ 2327.474443]  [<ffffffff81092af2>] do_acct_process+0x372/0x4e0
> [ 2327.481015]  [<ffffffff810928d0>] ? do_acct_process+0x150/0x4e0
> [ 2327.487292]  [<ffffffff81092ccc>] acct_process+0x6c/0xa0
> [ 2327.493438]  [<ffffffff810541d5>] do_exit+0x715/0x7d0
> [ 2327.499288]  [<ffffffff8100f8d7>] oops_end+0xa7/0xb0
> [ 2327.504642]  [<ffffffff8100fad6>] die+0x56/0x90
> [ 2327.510016]  [<ffffffff8100c820>] do_trap+0x130/0x150
> [ 2327.515443]  [<ffffffff8100ce90>] do_invalid_op+0x90/0xb0
> [ 2327.521683]  [<ffffffffa06227ec>] ? ext4_da_get_block_prep+0x29c/0x2b0 [ext4]
> [ 2327.529729]  [<ffffffff8100c0b5>] invalid_op+0x15/0x20
> [ 2327.535692]  [<ffffffffa06227ec>] ? ext4_da_get_block_prep+0x29c/0x2b0 [ext4]
> [ 2327.543317]  [<ffffffffa06226bb>] ? ext4_da_get_block_prep+0x16b/0x2b0 [ext4]
> [ 2327.551370]  [<ffffffff8113d15c>] __block_prepare_write+0x27c/0x440
> [ 2327.558548]  [<ffffffffa0622550>] ? ext4_da_get_block_prep+0x0/0x2b0 [ext4]
> [ 2327.566468]  [<ffffffff810dbb92>] ? __lru_cache_add+0x72/0xb0
> [ 2327.573107]  [<ffffffff8113d3b9>] block_write_begin+0x59/0xe0
> [ 2327.579265]  [<ffffffffa0621612>] ext4_da_write_begin+0x182/0x280 [ext4]
> [ 2327.586875]  [<ffffffffa0622550>] ? ext4_da_get_block_prep+0x0/0x2b0 [ext4]
> [ 2327.594734]  [<ffffffff810d29aa>] generic_file_buffered_write+0x10a/0x290
> [ 2327.602514]  [<ffffffff810d2ef6>] __generic_file_aio_write+0x266/0x420
> [ 2327.609481]  [<ffffffff810d30f6>] ? generic_file_aio_write+0x46/0xb0
> [ 2327.616754]  [<ffffffff810d310c>] generic_file_aio_write+0x5c/0xb0
> [ 2327.623814]  [<ffffffffa0617f06>] ext4_file_write+0x46/0xb0 [ext4]
> [ 2327.630806]  [<ffffffff81114f11>] do_sync_write+0xf1/0x130
> [ 2327.636631]  [<ffffffff8106e640>] ? autoremove_wake_function+0x0/0x40
> [ 2327.643976]  [<ffffffff810a4762>] ? audit_filter_syscall+0x92/0x190
> [ 2327.651166]  [<ffffffff810a470a>] ? audit_filter_syscall+0x3a/0x190
> [ 2327.657789]  [<ffffffff810a469f>] ? audit_filter_inodes+0x19f/0x1d0
> [ 2327.664872]  [<ffffffff81199491>] ? security_file_permission+0x11/0x20
> [ 2327.672317]  [<ffffffff81115737>] vfs_write+0xc7/0x1a0
> [ 2327.678300]  [<ffffffff81115e40>] sys_write+0x50/0x90
> [ 2327.683724]  [<ffffffff8100b2ab>] system_call_fastpath+0x16/0x1b
>
>
>
>>
>> Thanks!
>>
>> Ric
>>
>>>
>>> On Sun, Jan 24, 2010 at 04:48:53AM -0500, tytso@mit.edu wrote:
>>>> On Sun, Jan 24, 2010 at 08:19:43AM +0100, Nikola Ciprich wrote:
>>>>> Hi,
>>>>> yes, I can reproduce it reliably, I'll give it a try tomorrow and
>>>>> report.
>>>>> have a nice day.
>>>> Thanks, I appreciate it.  If it does reproduce on 2.6.33-rc3+, could
>>>> you send me the output of "dumpe2fs -h /dev/XXX"?
>>>>
>>>> Best regards,
>>>>
>>>> 					- Ted
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>

