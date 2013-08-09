From: Sage Weil <sage@inktank.com>
Subject: Re: crash in __jbd2_journal_file_buffer
Date: Fri, 9 Aug 2013 15:11:05 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1308091504320.14125@cobra.newdream.net>
References: <alpine.DEB.2.00.1307301540110.12830@cobra.newdream.net> <20130731190245.GC28018@quack.suse.cz> <alpine.DEB.2.00.1308091031450.17790@cobra.newdream.net> <20130809212425.GB1050@quack.suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cobra.newdream.net ([66.33.216.30]:38990 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031243Ab3HIWLH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Aug 2013 18:11:07 -0400
In-Reply-To: <20130809212425.GB1050@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 9 Aug 2013, Jan Kara wrote:
> On Fri 09-08-13 10:36:37, Sage Weil wrote:
> > Hi Jan,
> > 
> > Sorry for the slow response; took a while for this to happen again.  This 
> > time I'm keeping the machine sitting in kdb in case there is more 
> > information needed.
> > 
> > <4>[19307.314449] ------------[ cut here ]------------
> > <4>[19307.319114] WARNING: at /srv/autobuild-ceph/gitbuilder.git/build/fs/jbd2/transaction.c:1237 jbd2_journal_dirty_metadata+0x1ba/0x260()
> > 
> > <4>[19307.382324] CPU: 0 PID: 8877 Comm: ceph-osd Tainted: G        W    3.10.0-ceph-00049-g68d04c9 #1
> > <4>[19307.391256] Hardware name: Dell Inc. PowerEdge R410/01V648, BIOS 1.6.3 02/07/2011
> > <4>[19307.398879]  ffffffff81a1d3c8 ffff880214469928 ffffffff816311b0 ffff880214469968
> > <4>[19307.407572]  ffffffff8103fae0 ffff880214469958 ffff880170a9dc30 ffff8802240fbe80
> > <4>[19307.415153]  0000000000000000 ffff88020b366000 ffff8802256e7510 ffff880214469978
> > <4>[19307.422633] Call Trace:
> > <4>[19307.425209]  [<ffffffff816311b0>] dump_stack+0x19/0x1b
> > <4>[19307.430368]  [<ffffffff8103fae0>] warn_slowpath_common+0x70/0xa0
> > <4>[19307.436502]  [<ffffffff8103fb2a>] warn_slowpath_null+0x1a/0x20
> > <4>[19307.442356]  [<ffffffff81267c2a>] jbd2_journal_dirty_metadata+0x1ba/0x260
> > <4>[19307.449271]  [<ffffffff81245093>] __ext4_handle_dirty_metadata+0xa3/0x140
> > <4>[19307.456192]  [<ffffffff812561f3>] ext4_xattr_release_block+0x103/0x1f0
> > <4>[19307.462742]  [<ffffffff81256680>] ext4_xattr_block_set+0x1e0/0x910
> > <4>[19307.469049]  [<ffffffff8125795b>] ext4_xattr_set_handle+0x38b/0x4a0
> > <4>[19307.475445]  [<ffffffff810a319d>] ? trace_hardirqs_on+0xd/0x10
> > <4>[19307.481300]  [<ffffffff81257b32>] ext4_xattr_set+0xc2/0x140
> > <4>[19307.486995]  [<ffffffff81258547>] ext4_xattr_user_set+0x47/0x50
> > <4>[19307.492936]  [<ffffffff811935ce>] generic_setxattr+0x6e/0x90
> > <4>[19307.498734]  [<ffffffff81193ecb>] __vfs_setxattr_noperm+0x7b/0x1c0
> > <4>[19307.505049]  [<ffffffff811940d4>] vfs_setxattr+0xc4/0xd0
> > <4>[19307.510380]  [<ffffffff8119421e>] setxattr+0x13e/0x1e0
> > <4>[19307.515646]  [<ffffffff811719c7>] ? __sb_start_write+0xe7/0x1b0
> > <4>[19307.521587]  [<ffffffff8118f2e8>] ? mnt_want_write_file+0x28/0x60
> > <4>[19307.527812]  [<ffffffff8118c65c>] ? fget_light+0x3c/0x130
> > <4>[19307.533230]  [<ffffffff8118f2e8>] ? mnt_want_write_file+0x28/0x60
> > <4>[19307.539522]  [<ffffffff8118f1f8>] ? __mnt_want_write+0x58/0x70
> > <4>[19307.545492]  [<ffffffff811946be>] SyS_fsetxattr+0xbe/0x100
> > <4>[19307.551001]  [<ffffffff816407c2>] system_call_fastpath+0x16/0x1b
> > <4>[19307.557137] ---[ end trace 3e447f9462172c58 ]---
>   Hum, weird. So we returned EUCLEAN from jbd2_journal_dirty_metadata()
> meaning that buffer head passed in there didn't have journal head attached.
> However ext4_xattr_release_block() does call
> ext4_journal_get_write_access() for the bh before calling
> ext4_handle_dirty_xattr_block(). So we should have bh attached to the
> running transaction which also keeps journal head in place.
> 
> > <2>[19307.561776] EXT4-fs error (device sda1) in ext4_handle_dirty_xattr_block:167: error 117
> > <3>[19307.570181] Aborting journal on device sda1-8.
> > <2>[19307.604589] EXT4-fs (sda1): Remounting filesystem read-only
> > <2>[19307.610273] EXT4-fs error (device sda1) in ext4_xattr_release_block:558: error 117
> > <0>[19307.623337] journal commit I/O error
> > <0>[19307.623342] journal commit I/O error
> > <0>[19307.623405] journal commit I/O error
> > <0>[19307.623519] journal commit I/O error
> > <2>[19307.623585] EXT4-fs error (device sda1): __ext4_journal_start_sb:62: Detected aborted journal
> > <1>[19307.623642] BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
> > <1>[19307.623649] IP: [<ffffffff81267c4a>] jbd2_journal_dirty_metadata+0x1da/0x260
>   Can you possibly disassemble where exactly did we crash in this function?
> Apparently we didn't properly handle the fact that the journal got aborted
> here. But I'm not sure what exactly failed.

Hrm, I'm having trouble getting from a bzImage back to something I can 
objdump with inline code, so this is a separate compile with the same 
.config that is hopefully right:

                jh->b_modified = 1;
                J_ASSERT_JH(jh, handle->h_buffer_credits > 0);
    1e33:       0f 0b                   ud2    
         */
        if (jh->b_transaction != transaction) {
                JBUFFER_TRACE(jh, "already on other transaction");
                if (unlikely(jh->b_transaction !=
                             journal->j_committing_transaction)) {
                        printk(KERN_EMERG "JBD: %s: "
    1e35:       4d 85 c9                test   %r9,%r9
    1e38:       74 04                   je     1e3e <jbd2_journal_dirty_metadata+0x1de>
    1e3a:       41 8b 41 08             mov    0x8(%r9),%eax
**here^^^
    1e3e:       45 31 c0                xor    %r8d,%r8d
    1e41:       48 85 c9                test   %rcx,%rcx
    1e44:       74 04                   je     1e4a <jbd2_journal_dirty_metadata+0x1ea>
    1e46:       44 8b 41 08             mov    0x8(%rcx),%r8d
    1e4a:       48 8b 53 18             mov    0x18(%rbx),%rdx
                               "jh->b_transaction (%llu, %p, %u) != "
                               "journal->j_committing_transaction (%p, %u)",
                               journal->j_devname,
    1e4e:       49 8d b6 80 05 00 00    lea    0x580(%r14),%rsi
         */
        if (jh->b_transaction != transaction) {
                JBUFFER_TRACE(jh, "already on other transaction");
                if (unlikely(jh->b_transaction !=
                             journal->j_committing_transaction)) {
                        printk(KERN_EMERG "JBD: %s: "
    1e55:       89 04 24                mov    %eax,(%rsp)
    1e58:       48 c7 c7 00 00 00 00    mov    $0x0,%rdi
                        1e5b: R_X86_64_32S      .rodata.str1.8+0x160
    1e5f:       31 c0                   xor    %eax,%eax
    1e61:       e8 00 00 00 00          callq  1e66 <jbd2_journal_dirty_metadata+0x206>
                        1e62: R_X86_64_PC32     printk-0x4
                               jh->b_transaction,
                               jh->b_transaction ? jh->b_transaction->t_tid : 0,
                               journal->j_committing_transaction,
                               journal->j_committing_transaction ?
                               journal->j_committing_transaction->t_tid : 0);
                        ret = -EINVAL;
    1e66:       b8 ea ff ff ff          mov    $0xffffffea,%eax
    1e6b:       e9 a4 fe ff ff          jmpq   1d14 <jbd2_journal_dirty_metadata+0xb4>
                }
                if (unlikely(jh->b_next_transaction != transaction)) {
                        printk(KERN_EMERG "JBD: %s: "
    1e70:       45 31 c0                xor    %r8d,%r8d
    1e73:       48 85 c9                test   %rcx,%rcx
    1e76:       41 8b 44 24 08          mov    0x8(%r12),%eax
    1e7b:       74 04                   je     1e81 <jbd2_journal_dirty_metadata+0x221>
    1e7d:       44 8b 41 08             mov    0x8(%rcx),%r8d
    1e81:       48 8b 53 18             mov    0x18(%rbx),%rdx
                               "jh->b_next_transaction (%llu, %p, %u) != "
                               "transaction (%p, %u)",
                               journal->j_devname,
    1e85:       49 8d b6 80 05 00 00    lea    0x580(%r14),%rsi
                               journal->j_committing_transaction ?
                               journal->j_committing_transaction->t_tid : 0);
                        ret = -EINVAL;
                }
                if (unlikely(jh->b_next_transaction != transaction)) {
                        printk(KERN_EMERG "JBD: %s: "
    1e8c:       89 04 24                mov    %eax,(%rsp)
    1e8f:       4d 89 e1                mov    %r12,%r9
    1e92:       48 c7 c7 00 00 00 00    mov    $0x0,%rdi
                        1e95: R_X86_64_32S      .rodata.str1.8+0x1c0
    1e99:       31 c0                   xor    %eax,%eax
    1e9b:       e8 00 00 00 00          callq  1ea0 <jbd2_journal_dirty_metadata+0x240>
                        1e9c: R_X86_64_PC32     printk-0x4
                               (unsigned long long) bh->b_blocknr,
                               jh->b_next_transaction,
                               jh->b_next_transaction ?
                               jh->b_next_transaction->t_tid : 0,
                               transaction, transaction->t_tid);
                        ret = -EINVAL;
    1ea0:       b8 ea ff ff ff          mov    $0xffffffea,%eax
    1ea5:       e9 77 fe ff ff          jmpq   1d21 <jbd2_journal_dirty_metadata+0xc1>
 *  bit-based spin_unlock()
 */
static inline void bit_spin_unlock(int bitnum, unsigned long *addr)
{
#ifdef CONFIG_DEBUG_SPINLOCK
        BUG_ON(!test_bit(bitnum, addr));
    1eaa:       e8 00 00 00 00          callq  1eaf <jbd2_journal_dirty_metadata+0x24f>
                        1eab: R_X86_64_PC32     .text.unlikely-0x4
                 * transaction's data buffer, ever. */

Registers are

[4]kdb> rd
ax: 0000000000000000  bx: ffff8801f57837b8  cx: 0000000000000000
dx: 000000000091c029  si: 000000000091c029  di: 0000000000000001
bp: ffff880214469a58  sp: ffff880214469a08  r8: ffff8801f57837b8
r9: 0000000000000008  r10: 0000000000000000  r11: 0000000000000000
r12: ffff8802256e7870  r13: ffff8801893c52a0  r14: ffff8802256e76c0
r15: ffff8802256e7510  ip: ffffffff81267c4a  flags: 00010202  cs: 00000010
ss: 00000018  ds: 00000018  es: 00000018  fs: 00000018  gs: 00000018

journal == NULL?

sage


> 
> 								Honza
> 
> > <4>[19307.623653] PGD 20bc32067 PUD 2245fc067 PMD 0 
> > <4>[19307.623657] Oops: 0000 [#1] SMP 
> > [dumpcommon]kdb>   -bt
> > 
> > Stack traceback for pid 8877
> > 0xffff88020db7bf20     8877     8795  1    4   R  0xffff88020db7c3a8 *ceph-osd
> >  ffff880214469a08 0000000000000018 ffffffff81267ad0 ffffea000834d600
> >  ffff880226c03300 ffffffff81256562 0000000000000282 ffff880214469a68
> >  0000000000000000 00000000000011a5 ffffffff81825270 ffff8802256e7510
> > Call Trace:
> >  [<ffffffff81267ad0>] ? jbd2_journal_dirty_metadata+0x60/0x260
> >  [<ffffffff81256562>] ? ext4_xattr_block_set+0xc2/0x910
> >  [<ffffffff81245093>] ? __ext4_handle_dirty_metadata+0xa3/0x140
> >  [<ffffffff8121aeee>] ? ext4_mark_iloc_dirty+0x40e/0x660
> >  [<ffffffff81257835>] ? ext4_xattr_set_handle+0x265/0x4a0
> >  [<ffffffff81257b32>] ? ext4_xattr_set+0xc2/0x140
> >  [<ffffffff81258547>] ? ext4_xattr_user_set+0x47/0x50
> >  [<ffffffff811935ce>] ? generic_setxattr+0x6e/0x90
> >  [<ffffffff81193ecb>] ? __vfs_setxattr_noperm+0x7b/0x1c0
> >  [<ffffffff811940d4>] ? vfs_setxattr+0xc4/0xd0
> >  [<ffffffff8119421e>] ? setxattr+0x13e/0x1e0
> >  [<ffffffff811719c7>] ? __sb_start_write+0xe7/0x1b0
> >  [<ffffffff8118f2e8>] ? mnt_want_write_file+0x28/0x60
> >  [<ffffffff8118c65c>] ? fget_light+0x3c/0x130
> >  [<ffffffff8118f2e8>] ? mnt_want_write_file+0x28/0x60
> >  [<ffffffff8118f1f8>] ? __mnt_want_write+0x58/0x70
> >  [<ffffffff811946be>] ? SyS_fsetxattr+0xbe/0x100
> >  [<ffffffff816407c2>] ? system_call_fastpath+0x16/0x1b
> > 
> > 
> > The workload is a ceph-osd daemon, which tends to hammer pretty heavily on 
> > the xattr paths.  I don't have a nice self-contained reproducer or 
> > anything since this is is falling out of our integration tests.  
> > Hopefully there is enough here (or that can be gleaned from kdb) that it 
> > is clear what is going on.  It's v3.10 (plus some unrelated patches).
> > 
> > Thanks!
> > sage
> > 
> > 
> > 
> > On Wed, 31 Jul 2013, Jan Kara wrote:
> > >   Hello,
> > > 
> > > On Tue 30-07-13 15:41:40, Sage Weil wrote:
> > > > Hit this on 3.10.  Is this a known issue?
> > >   No, I haven't seen it. Why did the kernel crash?
> > > 
> > > 								Honza
> > > > 
> > > > Thanks-
> > > > sage
> > > > 
> > > > 
> > > > Stack traceback for pid 23944
> > > > 0xffff8802206edeb0    23944    23840  1    2   R  0xffff8802206ee338 
> > > > *ceph-osd
> > > >  ffff88020bf17b78 0000000000000018 ffffffff81267398 ffff8802256d40c0
> > > >  ffff88020b5a1230 ffff88020bf17bb8 ffffffff81325d9c ffff88020b5a1230
> > > >  ffff8802256d40c0 ffff88020b5a1230 00000000698a8d24 ffff88020bf17be8
> > > > Call Trace:
> > > >  [<ffffffff81267398>] ? __jbd2_journal_file_buffer+0x188/0x260
> > > >  [<ffffffff81325d9c>] ? do_raw_spin_lock+0x10c/0x150
> > > >  [<ffffffff81268118>] ? do_get_write_access+0x448/0x650
> > > >  [<ffffffff81213caf>] ? ext4_read_inode_bitmap+0x9f/0x5f0
> > > >  [<ffffffff81167849>] ? kmem_cache_alloc+0x39/0x160
> > > >  [<ffffffff81268490>] ? jbd2_journal_get_write_access+0x30/0x50
> > > >  [<ffffffff81244d43>] ? __ext4_journal_get_write_access+0x43/0x90
> > > >  [<ffffffff812143d7>] ? ext4_free_inode+0x1d7/0x5d0
> > > >  [<ffffffff8121e601>] ? ext4_evict_inode+0x341/0x4d0
> > > >  [<ffffffff8121b268>] ? ext4_mark_inode_dirty+0x88/0x230
> > > >  [<ffffffff8121e610>] ? ext4_evict_inode+0x350/0x4d0
> > > >  [<ffffffff8118a098>] ? evict+0xb8/0x1c0
> > > >  [<ffffffff8118a9d5>] ? iput+0x105/0x190
> > > >  [<ffffffff8117d341>] ? do_unlinkat+0x201/0x270
> > > >  [<ffffffff8131e9be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> > > >  [<ffffffff81180356>] ? SyS_unlink+0x16/0x20
> > > > 
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > -- 
> > > Jan Kara <jack@suse.cz>
> > > SUSE Labs, CR
> > > 
> > > 
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
> 
> 
