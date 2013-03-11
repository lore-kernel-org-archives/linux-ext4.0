From: Jan Kara <jack@suse.cz>
Subject: Re: [BUG][data=journal] general protection fault is hitted when we
 run xfstests #074
Date: Mon, 11 Mar 2013 14:27:17 +0100
Message-ID: <20130311132717.GD29799@quack.suse.cz>
References: <20130307122019.GC2800@gmail.com>
 <20130307122638.GD6723@quack.suse.cz>
 <20130308125545.GA18986@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51850 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923Ab3CKN1U (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Mar 2013 09:27:20 -0400
Content-Disposition: inline
In-Reply-To: <20130308125545.GA18986@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 08-03-13 20:55:45, Zheng Liu wrote:
> On Thu, Mar 07, 2013 at 01:26:38PM +0100, Jan Kara wrote:
> > On Thu 07-03-13 20:20:19, Zheng Liu wrote:
> > > Hi all,
> > > 
> > > This bug can be hitted in 3.8 kernel, and it doesn't be fixed in dev
> > > branch.  When #074 runs in a ext4 file system with '-o data=journal', I
> > > will get a general protection fault in my sand box.  I need to run
> > > several times to hit this bug.
> > > 
> > > My sand box is a Dell Desktop with a Intel(R) Core(TM)2 Duo CPU E8400
> > > @ 3.00GHz, 4G memory, a 160G HDD and a Intel SSD.  The test runs against
> > > SSD.
> > > 
> > > The messages from dmesg:
> > > 
> > > wenqing: run xfstest 074
> > > kernel: EXT4-fs (sda1): mounted filesystem with journalled data mode.
> > > Opts: acl,user_xattr,data=journal
> > > kernel: EXT4-fs (sda1): mounted filesystem with journalled data mode.
> > > Opts: acl,user_xattr,data=journal
> > > kernel: EXT4-fs (sda1): mounted filesystem with journalled data mode.
> > > Opts: acl,user_xattr,data=journal
> > > kernel: EXT4-fs (sda1): mounted filesystem with journalled data mode.
> > > Opts: acl,user_xattr,data=journal
> > > kernel: general protection fault: 0000 [#1] SMP 
> > > kernel: Modules linked in: ext4 jbd2 crc16 cpufreq_ondemand ipv6
> > > dm_mirror dm_region_hash dm_log dm_mod parport_pc parport dcdbas
> > > acpi_cpufreq mperf sg button pcspkr serio_raw i2c_i801 i2c_core ehci_pci
> > > ehci_hcd e1000e ext3 jbd sd_mod ahci libahci libata scsi_mod uhci_hcd
> > > kernel: CPU 1 
> > > kernel: Pid: 2786, comm: flush-8:0 Not tainted 3.8.0 #1 Dell Inc.
> > > OptiPlex 780                 /0V4W66
> > > kernel: RIP: 0010:[<ffffffffa01da0a0>]  [<ffffffffa01da0a0>]
> > > jbd2_journal_dirty_metadata+0x147/0x211 [jbd2]
> > > kernel: RSP: 0000:ffff880107a93868  EFLAGS: 00010206
> > > kernel: RAX: 0000000000000000 RBX: ffff88010a674540 RCX: 5c5c5c5c5c5c5c5c
> > > kernel: RDX: 000000000034402d RSI: ffff88010a674540 RDI: ffff880105bd6ca0
> > > kernel: RBP: ffff880107a938b8 R08: 0000000000000000 R09: 0000000000000000
> > > kernel: R10: ffff880105bd6ca0 R11: 000000000000000c R12: ffff88008e4ee518
> > > kernel: R13: ffff8801114fb800 R14: ffff880105bd6ca0 R15: ffff88010a658c80
> > > kernel: FS:  0000000000000000(0000) GS:ffff880117c40000(0000)
> > > knlGS:0000000000000000
> > > kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > > kernel: CR2: 00007f60256a5000 CR3: 0000000117834000 CR4: 00000000000407e0
> > > kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > > kernel: Process flush-8:0 (pid: 2786, threadinfo ffff880107a92000, task
> > > ffff880112cde6b0)
> > > kernel: Stack:
> > > kernel: ffff880105bd6ca0 0000000000001000 ffff880107a938a8 ffffffffa01da6de
> > > kernel: ffff8801114fb868 0000000000000000 00000000000003bf ffffffffa023f0e0
> > > kernel: ffff88010a674540 0000000000001000 ffff880107a938f8 ffffffffa022bb07
> > > kernel: Call Trace:
> > > kernel: [<ffffffffa01da6de>] ? jbd2_journal_get_write_access+0x36/0x40 [jbd2]
> > > kernel: [<ffffffffa022bb07>] __ext4_handle_dirty_metadata+0xd7/0xe6 [ext4]
> > > kernel: [<ffffffffa01ff4a5>] write_end_fn+0x37/0x3d [ext4]
> > > kernel: [<ffffffffa01ff167>] ext4_walk_page_buffers+0x65/0x9b [ext4]
> > > kernel: [<ffffffffa01ff46e>] ? ext4_nonda_switch+0xbd/0xbd [ext4]
> > > kernel: [<ffffffffa0203367>] __ext4_journalled_writepage+0x156/0x1ee [ext4]
> > > kernel: [<ffffffffa0203c10>] ext4_writepage+0x1b8/0x20d [ext4]
> > > kernel: [<ffffffff820b7ab4>] __writepage+0x17/0x30
> > > kernel: [<ffffffff820b8554>] write_cache_pages+0x276/0x37f
> > > kernel: [<ffffffff820b7a9d>] ? set_page_dirty+0x64/0x64
> > > kernel: [<ffffffff820b86a2>] generic_writepages+0x45/0x5c
> > > kernel: [<ffffffff820b86e0>] do_writepages+0x27/0x29
> > > kernel: [<ffffffff8210fc93>] __writeback_single_inode+0x48/0x119
> > > kernel: [<ffffffff82110e7c>] writeback_sb_inodes+0x1ec/0x2fd
> > > kernel: [<ffffffff82110fff>] __writeback_inodes_wb+0x72/0xb0
> > > kernel: [<ffffffff821111ee>] wb_writeback+0x13e/0x230
> > > kernel: [<ffffffff820b8dae>] ? global_dirty_limits+0x36/0x134
> > > kernel: [<ffffffff821114aa>] wb_do_writeback+0x1ca/0x1ea
> > > kernel: [<ffffffff8211158c>] bdi_writeback_thread+0xc2/0x1e2
> > > kernel: [<ffffffff821114ca>] ? wb_do_writeback+0x1ea/0x1ea
> > > kernel: [<ffffffff821114ca>] ? wb_do_writeback+0x1ea/0x1ea
> > > kernel: [<ffffffff8204eadf>] kthread+0xb5/0xbd
> > > kernel: [<ffffffff8204ea2a>] ? kthread_freezable_should_stop+0x65/0x65
> > > kernel: [<ffffffff8238689c>] ret_from_fork+0x7c/0xb0
> > > kernel: [<ffffffff8204ea2a>] ? kthread_freezable_should_stop+0x65/0x65
> > > kernel: Code: 08 49 8b 4c 24 28 4c 39 f9 0f 84 81 00 00 00 4d 8b 4d 58 31 c0
> > > 4c 39 c9 74 36 4d 85 c9 74 04 41 8b 41 08 45 31 c0 48 85 c9 74 04 <44> 8b 41
> > > 08 48 8b 53 18 49 8d b5 58 03 00 00 89 04 24 48 c7 c7 
> > > kernel: RIP  [<ffffffffa01da0a0>] jbd2_journal_dirty_metadata+0x147/0x211 [jbd2]
> > > kernel: RSP <ffff880107a93868>
> > > kernel: ---[ end trace d8e02cf12f9b2b79 ]---
> >   Hum, clearly we hit some poison value (RCX which was dereferenced was
> > 0x5c5c5c5c5c5c5c5c). Can you post full disassembly of
> > jbd2_journal_dirty_metadata()? I was trying to match decoded 'Code' section
> > with the C code but I failed...
> 
> Sorry for the delay.  Here is the result that I use 'objdump -r -S -l
> --disassemble fs/jbd2/jbd2.ko' to generate.  Hope it's useful for you.
> 
> Sorry I don't have time to look at it carefully.  Please let me know if
> you need some details.
  Thanks for the debug data. So we oops on dereferencing jh->b_transaction
because it is 0x5c5c5c5c5c5c5c5c which is JBD2_POISON_FREE. So clearly the
journal head we have has been freed. Not sure yet how that can happen
though.

								Honza

> 0000000000000f59 <jbd2_journal_dirty_metadata>:
> jbd2_journal_dirty_metadata():
> /home/wenqing/projects/linux/fs/jbd2/transaction.c:1101
>  * data present for that commit).  In that case, we don't relink the
>  * buffer: that only gets done when the old transaction finally
>  * completes its commit.
>  */
> int jbd2_journal_dirty_metadata(handle_t *handle, struct buffer_head *bh)
> {
>      f59:	55                   	push   %rbp
>      f5a:	48 89 e5             	mov    %rsp,%rbp
>      f5d:	41 57                	push   %r15
>      f5f:	41 56                	push   %r14
>      f61:	41 55                	push   %r13
>      f63:	41 54                	push   %r12
>      f65:	53                   	push   %rbx
>      f66:	48 83 ec 28          	sub    $0x28,%rsp
>      f6a:	e8 00 00 00 00       	callq  f6f <jbd2_journal_dirty_metadata+0x16>
> 			f6b: R_X86_64_PC32	mcount-0x4
> /home/wenqing/projects/linux/fs/jbd2/transaction.c:1107
> 	transaction_t *transaction = handle->h_transaction;
> 	journal_t *journal = transaction->t_journal;
> 	struct journal_head *jh = bh2jh(bh);
> 	int ret = 0;
> 
> 	jbd_debug(5, "journal_head %p\n", jh);
>      f6f:	80 3d 00 00 00 00 04 	cmpb   $0x4,0x0(%rip)        # f76 <jbd2_journal_dirty_metadata+0x1d>
> 			f71: R_X86_64_PC32	jbd2_journal_enable_debug-0x5
> /home/wenqing/projects/linux/fs/jbd2/transaction.c:1102
>  * buffer: that only gets done when the old transaction finally
>  * completes its commit.
>  */
> int jbd2_journal_dirty_metadata(handle_t *handle, struct buffer_head *bh)
> {
> 	transaction_t *transaction = handle->h_transaction;
>      f76:	4c 8b 3f             	mov    (%rdi),%r15
> /home/wenqing/projects/linux/fs/jbd2/transaction.c:1101
>  * data present for that commit).  In that case, we don't relink the
>  * buffer: that only gets done when the old transaction finally
>  * completes its commit.
>  */
> int jbd2_journal_dirty_metadata(handle_t *handle, struct buffer_head *bh)
> {
>      f79:	49 89 fe             	mov    %rdi,%r14
>      f7c:	48 89 f3             	mov    %rsi,%rbx
> bh2jh():
> /home/wenqing/projects/linux/include/linux/jbd_common.h:37
>      f7f:	4c 8b 66 40          	mov    0x40(%rsi),%r12
> jbd2_journal_dirty_metadata():
> /home/wenqing/projects/linux/fs/jbd2/transaction.c:1103
> 	transaction_t *transaction = handle->h_transaction;
> 	journal_t *journal = transaction->t_journal;
>      f83:	4d 8b 2f             	mov    (%r15),%r13
> /home/wenqing/projects/linux/fs/jbd2/transaction.c:1107
> 	struct journal_head *jh = bh2jh(bh);
> 	int ret = 0;
> 
> 	jbd_debug(5, "journal_head %p\n", jh);
>      f86:	76 32                	jbe    fba <jbd2_journal_dirty_metadata+0x61>
>      f88:	48 c7 c6 00 00 00 00 	mov    $0x0,%rsi
> 			f8b: R_X86_64_32S	.rodata.str1.1
>      f8f:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
> 			f92: R_X86_64_32S	.rodata.str1.1+0x16
>      f96:	48 c7 c1 00 00 00 00 	mov    $0x0,%rcx
> 			f99: R_X86_64_32S	.rodata+0xc0
>      f9d:	ba 53 04 00 00       	mov    $0x453,%edx
>      fa2:	31 c0                	xor    %eax,%eax
>      fa4:	e8 00 00 00 00       	callq  fa9 <jbd2_journal_dirty_metadata+0x50>
> 			fa5: R_X86_64_PC32	printk-0x4
>      fa9:	4c 89 e6             	mov    %r12,%rsi
>      fac:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
> 			faf: R_X86_64_32S	.rodata.str1.1+0x178
>      fb3:	31 c0                	xor    %eax,%eax
>      fb5:	e8 00 00 00 00       	callq  fba <jbd2_journal_dirty_metadata+0x61>
> 			fb6: R_X86_64_PC32	printk-0x4
> is_handle_aborted():
> /home/wenqing/projects/linux/include/linux/jbd2.h:1246
> 	return journal->j_flags & JBD2_ABORT;
> }
> 
> static inline int is_handle_aborted(handle_t *handle)
> {
> 	if (handle->h_aborted)
>      fba:	41 f6 46 14 04       	testb  $0x4,0x14(%r14)
>      fbf:	0f 85 94 01 00 00    	jne    1159 <jbd2_journal_dirty_metadata+0x200>
> /home/wenqing/projects/linux/include/linux/jbd2.h:1248
> 		return 1;
> 	return is_journal_aborted(handle->h_transaction->t_journal);
>      fc5:	49 8b 06             	mov    (%r14),%rax
> is_journal_aborted():
> /home/wenqing/projects/linux/include/linux/jbd2.h:1241
>  * transactions.
>  */
> 
> static inline int is_journal_aborted(journal_t *journal)
> {
> 	return journal->j_flags & JBD2_ABORT;
>      fc8:	48 8b 00             	mov    (%rax),%rax
> jbd2_journal_dirty_metadata():
> /home/wenqing/projects/linux/fs/jbd2/transaction.c:1109
> 	JBUFFER_TRACE(jh, "entry");
> 	if (is_handle_aborted(handle))
>      fcb:	f6 00 02             	testb  $0x2,(%rax)
>      fce:	0f 85 85 01 00 00    	jne    1159 <jbd2_journal_dirty_metadata+0x200>
> constant_test_bit():
> /home/wenqing/projects/linux/arch/x86/include/asm/bitops.h:321
> }
> 
> static __always_inline int constant_test_bit(unsigned int nr, const volatile unsigned long *addr)
> {
> 	return ((1UL << (nr % BITS_PER_LONG)) &
> 		(addr[nr / BITS_PER_LONG])) != 0;
>      fd4:	48 8b 13             	mov    (%rbx),%rdx
> jbd2_journal_dirty_metadata():
> /home/wenqing/projects/linux/fs/jbd2/transaction.c:1111
> 		goto out;
> 	if (!buffer_jbd(bh)) {
>      fd7:	b8 8b ff ff ff       	mov    $0xffffff8b,%eax
>      fdc:	80 e6 40             	and    $0x40,%dh
>      fdf:	0f 84 5b 01 00 00    	je     1140 <jbd2_journal_dirty_metadata+0x1e7>
>      fe5:	eb 0c                	jmp    ff3 <jbd2_journal_dirty_metadata+0x9a>
> rep_nop():
> /home/wenqing/projects/linux/arch/x86/include/asm/processor.h:660
>      fe7:	f3 90                	pause  
> constant_test_bit():
> /home/wenqing/projects/linux/arch/x86/include/asm/bitops.h:321
>      fe9:	48 8b 03             	mov    (%rbx),%rax
> bit_spin_lock():
> /home/wenqing/projects/linux/include/linux/bit_spinlock.h:30
> 		preempt_enable();
> 		do {
> 			cpu_relax();
> 		} while (test_bit(bitnum, addr));
>      fec:	a9 00 00 10 00       	test   $0x100000,%eax
>      ff1:	75 f4                	jne    fe7 <jbd2_journal_dirty_metadata+0x8e>
> test_and_set_bit():
> /home/wenqing/projects/linux/arch/x86/include/asm/bitops.h:201
>  */
> static inline int test_and_set_bit(int nr, volatile unsigned long *addr)
> {
> 	int oldbit;
> 
> 	asm volatile(LOCK_PREFIX "bts %2,%1\n\t"
>      ff3:	f0 0f ba 2b 14       	lock btsl $0x14,(%rbx)
>      ff8:	19 c0                	sbb    %eax,%eax
> bit_spin_lock():
> /home/wenqing/projects/linux/include/linux/bit_spinlock.h:26
> 	 * busywait with less bus contention for a good time to
> 	 * attempt to acquire the lock bit.
> 	 */
> 	preempt_disable();
> #if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
> 	while (unlikely(test_and_set_bit_lock(bitnum, addr))) {
>      ffa:	85 c0                	test   %eax,%eax
>      ffc:	75 e9                	jne    fe7 <jbd2_journal_dirty_metadata+0x8e>
> jbd2_journal_dirty_metadata():
> /home/wenqing/projects/linux/fs/jbd2/transaction.c:1118
> 		goto out;
> 	}
> 
> 	jbd_lock_bh_state(bh);
> 
> 	if (jh->b_modified == 0) {
>      ffe:	41 83 7c 24 10 00    	cmpl   $0x0,0x10(%r12)
>     1004:	75 1b                	jne    1021 <jbd2_journal_dirty_metadata+0xc8>
> /home/wenqing/projects/linux/fs/jbd2/transaction.c:1124
> 		/*
> 		 * This buffer's got modified and becoming part
> 		 * of the transaction. This needs to be done
> 		 * once a transaction -bzzz
> 		 */
> 		jh->b_modified = 1;
>     1006:	41 c7 44 24 10 01 00 	movl   $0x1,0x10(%r12)
>     100d:	00 00 
> /home/wenqing/projects/linux/fs/jbd2/transaction.c:1125
> 		J_ASSERT_JH(jh, handle->h_buffer_credits > 0);
>     100f:	41 8b 46 08          	mov    0x8(%r14),%eax
>     1013:	85 c0                	test   %eax,%eax
>     1015:	7f 04                	jg     101b <jbd2_journal_dirty_metadata+0xc2>
>     1017:	0f 0b                	ud2a   
>     1019:	eb fe                	jmp    1019 <jbd2_journal_dirty_metadata+0xc0>
> /home/wenqing/projects/linux/fs/jbd2/transaction.c:1126
> 		handle->h_buffer_credits--;
>     101b:	ff c8                	dec    %eax
>     101d:	41 89 46 08          	mov    %eax,0x8(%r14)
> /home/wenqing/projects/linux/fs/jbd2/transaction.c:1136
> 	 * on the running transaction's metadata list there is nothing to do.
> 	 * Nobody can take it off again because there is a handle open.
> 	 * I _think_ we're OK here with SMP barriers - a mistaken decision will
> 	 * result in this test being false, so we go in and take the locks.
> 	 */
> 	if (jh->b_transaction == transaction && jh->b_jlist == BJ_Metadata) {
>     1021:	49 8b 4c 24 28       	mov    0x28(%r12),%rcx
>     1026:	4c 39 f9             	cmp    %r15,%rcx
>     1029:	75 46                	jne    1071 <jbd2_journal_dirty_metadata+0x118>
>     102b:	41 83 7c 24 0c 01    	cmpl   $0x1,0xc(%r12)
>     1031:	75 3e                	jne    1071 <jbd2_journal_dirty_metadata+0x118>
> /home/wenqing/projects/linux/fs/jbd2/transaction.c:1138
> 		JBUFFER_TRACE(jh, "fastpath");
> 		if (unlikely(jh->b_transaction !=
>     1033:	4d 8b 4d 50          	mov    0x50(%r13),%r9
>     1037:	31 c0                	xor    %eax,%eax
>     1039:	4d 39 cf             	cmp    %r9,%r15
>     103c:	0f 84 f5 00 00 00    	je     1137 <jbd2_journal_dirty_metadata+0x1de>
> /home/wenqing/projects/linux/fs/jbd2/transaction.c:1140
> 			     journal->j_running_transaction)) {
> 			printk(KERN_EMERG "JBD: %s: "
>     1042:	4d 85 c9             	test   %r9,%r9
>     1045:	74 04                	je     104b <jbd2_journal_dirty_metadata+0xf2>
>     1047:	41 8b 41 08          	mov    0x8(%r9),%eax
>     104b:	45 31 c0             	xor    %r8d,%r8d
>     104e:	48 85 c9             	test   %rcx,%rcx
>     1051:	74 04                	je     1057 <jbd2_journal_dirty_metadata+0xfe>
>     1053:	44 8b 41 08          	mov    0x8(%rcx),%r8d
>     1057:	48 8b 53 18          	mov    0x18(%rbx),%rdx
>     105b:	49 8d b5 58 03 00 00 	lea    0x358(%r13),%rsi
>     1062:	89 04 24             	mov    %eax,(%rsp)
>     1065:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
> 			1068: R_X86_64_32S	.rodata.str1.1+0x189
>     106c:	e9 86 00 00 00       	jmpq   10f7 <jbd2_journal_dirty_metadata+0x19e>
> set_bit():
> /home/wenqing/projects/linux/arch/x86/include/asm/bitops.h:65
>  */
> static __always_inline void
> set_bit(unsigned int nr, volatile unsigned long *addr)
> {
> 	if (IS_IMMEDIATE(nr)) {
> 		asm volatile(LOCK_PREFIX "orb %1,%0"
>     1071:	f0 80 4b 02 08       	lock orb $0x8,0x2(%rbx)
> jbd2_journal_dirty_metadata():
> /home/wenqing/projects/linux/fs/jbd2/transaction.c:1163
> 	 * Metadata already on the current transaction list doesn't
> 	 * need to be filed.  Metadata on another transaction's list must
> 	 * be committing, and will be refiled once the commit completes:
> 	 * leave it alone for now.
> 	 */
> 	if (jh->b_transaction != transaction) {
>     1076:	49 8b 4c 24 28       	mov    0x28(%r12),%rcx
>     107b:	4c 39 f9             	cmp    %r15,%rcx
>     107e:	0f 84 81 00 00 00    	je     1105 <jbd2_journal_dirty_metadata+0x1ac>
> /home/wenqing/projects/linux/fs/jbd2/transaction.c:1165
> 		JBUFFER_TRACE(jh, "already on other transaction");
> 		if (unlikely(jh->b_transaction !=
>     1084:	4d 8b 4d 58          	mov    0x58(%r13),%r9
>     1088:	31 c0                	xor    %eax,%eax
>     108a:	4c 39 c9             	cmp    %r9,%rcx
>     108d:	74 36                	je     10c5 <jbd2_journal_dirty_metadata+0x16c>
> /home/wenqing/projects/linux/fs/jbd2/transaction.c:1167
> 			     journal->j_committing_transaction)) {
> 			printk(KERN_EMERG "JBD: %s: "
>     108f:	4d 85 c9             	test   %r9,%r9
>     1092:	74 04                	je     1098 <jbd2_journal_dirty_metadata+0x13f>
>     1094:	41 8b 41 08          	mov    0x8(%r9),%eax
>     1098:	45 31 c0             	xor    %r8d,%r8d
>     109b:	48 85 c9             	test   %rcx,%rcx
>     109e:	74 04                	je     10a4 <jbd2_journal_dirty_metadata+0x14b>
>     10a0:	44 8b 41 08          	mov    0x8(%rcx),%r8d
>     10a4:	48 8b 53 18          	mov    0x18(%rbx),%rdx
>     10a8:	49 8d b5 58 03 00 00 	lea    0x358(%r13),%rsi
>     10af:	89 04 24             	mov    %eax,(%rsp)
>     10b2:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
> 			10b5: R_X86_64_32S	.rodata.str1.1+0x1e0
>     10b9:	31 c0                	xor    %eax,%eax
>     10bb:	e8 00 00 00 00       	callq  10c0 <jbd2_journal_dirty_metadata+0x167>
> 			10bc: R_X86_64_PC32	printk-0x4
>     10c0:	b8 ea ff ff ff       	mov    $0xffffffea,%eax
> /home/wenqing/projects/linux/fs/jbd2/transaction.c:1179
> 			       journal->j_committing_transaction,
> 			       journal->j_committing_transaction ?
> 			       journal->j_committing_transaction->t_tid : 0);
> 			ret = -EINVAL;
> 		}
> 		if (unlikely(jh->b_next_transaction != transaction)) {
>     10c5:	49 8b 4c 24 30       	mov    0x30(%r12),%rcx
>     10ca:	4c 39 f9             	cmp    %r15,%rcx
>     10cd:	74 68                	je     1137 <jbd2_journal_dirty_metadata+0x1de>
> /home/wenqing/projects/linux/fs/jbd2/transaction.c:1180
> 			printk(KERN_EMERG "JBD: %s: "
>     10cf:	45 31 c0             	xor    %r8d,%r8d
>     10d2:	48 85 c9             	test   %rcx,%rcx
>     10d5:	41 8b 47 08          	mov    0x8(%r15),%eax
>     10d9:	74 04                	je     10df <jbd2_journal_dirty_metadata+0x186>
>     10db:	44 8b 41 08          	mov    0x8(%rcx),%r8d
>     10df:	48 8b 53 18          	mov    0x18(%rbx),%rdx
>     10e3:	49 8d b5 58 03 00 00 	lea    0x358(%r13),%rsi
>     10ea:	89 04 24             	mov    %eax,(%rsp)
>     10ed:	4d 89 f9             	mov    %r15,%r9
>     10f0:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
> 			10f3: R_X86_64_32S	.rodata.str1.1+0x23a
>     10f7:	31 c0                	xor    %eax,%eax
>     10f9:	e8 00 00 00 00       	callq  10fe <jbd2_journal_dirty_metadata+0x1a5>
> 			10fa: R_X86_64_PC32	printk-0x4
>     10fe:	b8 ea ff ff ff       	mov    $0xffffffea,%eax
>     1103:	eb 32                	jmp    1137 <jbd2_journal_dirty_metadata+0x1de>
> /home/wenqing/projects/linux/fs/jbd2/transaction.c:1197
> 		 * transaction's data buffer, ever. */
> 		goto out_unlock_bh;
> 	}
> 
> 	/* That test should have eliminated the following case: */
> 	J_ASSERT_JH(jh, jh->b_frozen_data == NULL);
>     1105:	49 83 7c 24 18 00    	cmpq   $0x0,0x18(%r12)
>     110b:	74 04                	je     1111 <jbd2_journal_dirty_metadata+0x1b8>
>     110d:	0f 0b                	ud2a   
>     110f:	eb fe                	jmp    110f <jbd2_journal_dirty_metadata+0x1b6>
> spin_lock():
> /home/wenqing/projects/linux/include/linux/spinlock.h:285
>     1111:	49 8d bd 9c 03 00 00 	lea    0x39c(%r13),%rdi
>     1118:	e8 00 00 00 00       	callq  111d <jbd2_journal_dirty_metadata+0x1c4>
> 			1119: R_X86_64_PC32	_raw_spin_lock-0x4
> jbd2_journal_dirty_metadata():
> /home/wenqing/projects/linux/fs/jbd2/transaction.c:1201
> 
> 	JBUFFER_TRACE(jh, "file as BJ_Metadata");
> 	spin_lock(&journal->j_list_lock);
> 	__jbd2_journal_file_buffer(jh, handle->h_transaction, BJ_Metadata);
>     111d:	49 8b 36             	mov    (%r14),%rsi
>     1120:	ba 01 00 00 00       	mov    $0x1,%edx
>     1125:	4c 89 e7             	mov    %r12,%rdi
>     1128:	e8 00 00 00 00       	callq  112d <jbd2_journal_dirty_metadata+0x1d4>
> 			1129: R_X86_64_PC32	__jbd2_journal_file_buffer-0x4
> __ticket_spin_unlock():
> /home/wenqing/projects/linux/arch/x86/include/asm/spinlock.h:81
>     112d:	41 80 85 9c 03 00 00 	addb   $0x1,0x39c(%r13)
>     1134:	01 
>     1135:	31 c0                	xor    %eax,%eax
> clear_bit():
> /home/wenqing/projects/linux/arch/x86/include/asm/bitops.h:103
>  */
> static __always_inline void
> clear_bit(int nr, volatile unsigned long *addr)
> {
> 	if (IS_IMMEDIATE(nr)) {
> 		asm volatile(LOCK_PREFIX "andb %1,%0"
>     1137:	f0 80 63 02 ef       	lock andb $0xef,0x2(%rbx)
> jbd2_journal_dirty_metadata():
> /home/wenqing/projects/linux/fs/jbd2/transaction.c:1207
> 	spin_unlock(&journal->j_list_lock);
> out_unlock_bh:
> 	jbd_unlock_bh_state(bh);
> out:
> 	JBUFFER_TRACE(jh, "exit");
> 	WARN_ON(ret);	/* All errors are bugs, so dump the stack */
>     113c:	85 c0                	test   %eax,%eax
>     113e:	74 1b                	je     115b <jbd2_journal_dirty_metadata+0x202>
>     1140:	be b7 04 00 00       	mov    $0x4b7,%esi
>     1145:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
> 			1148: R_X86_64_32S	.rodata.str1.1
>     114c:	89 45 c8             	mov    %eax,-0x38(%rbp)
>     114f:	e8 00 00 00 00       	callq  1154 <jbd2_journal_dirty_metadata+0x1fb>
> 			1150: R_X86_64_PC32	warn_slowpath_null-0x4
>     1154:	8b 45 c8             	mov    -0x38(%rbp),%eax
>     1157:	eb 02                	jmp    115b <jbd2_journal_dirty_metadata+0x202>
>     1159:	31 c0                	xor    %eax,%eax
> /home/wenqing/projects/linux/fs/jbd2/transaction.c:1209
> 	return ret;
> }
>     115b:	48 83 c4 28          	add    $0x28,%rsp
>     115f:	5b                   	pop    %rbx
>     1160:	41 5c                	pop    %r12
>     1162:	41 5d                	pop    %r13
>     1164:	41 5e                	pop    %r14
>     1166:	41 5f                	pop    %r15
>     1168:	c9                   	leaveq 
>     1169:	c3                   	retq   
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
