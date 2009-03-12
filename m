From: Alexander Beregalov <a.beregalov@gmail.com>
Subject: 2.6.29-rc7: ext4 hangs on sparc (was: next-20090310: ext4 hangs)
Date: Thu, 12 Mar 2009 15:35:41 +0300
Message-ID: <a4423d670903120535v339a1e43x64cf018f07ee0b6b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>,
	"linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
	linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	"Rafael J. Wysocki" <rjw@sisk
Return-path: <linux-next-owner@vger.kernel.org>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

2009/3/11 Alexander Beregalov <a.beregalov@gmail.com>:
> 2009/3/10 Theodore Tso <tytso@mit.edu>:
>> On Tue, Mar 10, 2009 at 05:18:55PM +0300, Alexander Beregalov wrote:
>>> > Thanks for reporting this; does it show up on stock 2.6.29-rc7?
>>> No, I can not reproduce it.
>>> It is a slow system, I would not like to bisect it, only if it is the
>>> last possibility.
>>
>> Just to be clear; you weren't able to reproduce it on stock 2.6.29-rc7
>> ---- does it reproduce easily on linux-next?
> Right.
> But now I am not sure 2.6.29-rc7 is not affected, I will try to
> reproduce it again.

No! I run dbench many times for few hours and was able to reproduce it
on 2.6.29-rc7-00166-g16b71fd.

Rafael: ext4 hangs on sparc with 2.6.29-rc7. Still can not reproduce
it on x86_64.


Theodore, stacktraces look different, but it seems it is the same
problem, isn't it?

kjournald2    D 000000000055c3c8     0  1558      2
Call Trace:
 [000000000055668c] jbd2_journal_commit_transaction+0x208/0x1718
 [000000000055c3c8] kjournald2+0x13c/0x308
 [0000000000465a94] kthread+0x48/0x7c
 [000000000042b37c] kernel_thread+0x3c/0x54
 [00000000004659a4] kthreadd+0xe8/0x190
dbench        D 0000000000554938     0  1796      1
Call Trace:
 [000000000055bc04] jbd2_log_wait_commit+0x144/0x1a8
 [0000000000554938] jbd2_journal_stop+0x32c/0x37c
 [0000000000556210] jbd2_journal_force_commit+0x34/0x4c
 [0000000000535ba4] ext4_force_commit+0x30/0x50
 [0000000000528644] ext4_write_inode+0x80/0xa0
 [00000000004d0808] __writeback_single_inode+0x1e4/0x330
 [00000000004d0974] sync_inode+0x20/0x40
 [0000000000525674] ext4_sync_file+0xc4/0x118
 [00000000004d3eac] vfs_fsync+0x6c/0xa0
 [00000000004d3f08] do_fsync+0x28/0x44
 [00000000004d3f60] SyS_fsync+0x14/0x28
 [0000000000406154] linux_sparc_syscall32+0x34/0x40
dbench        D 0000000000554938     0  1797      1
Call Trace:
 [000000000055bc04] jbd2_log_wait_commit+0x144/0x1a8
 [0000000000554938] jbd2_journal_stop+0x32c/0x37c
 [0000000000556210] jbd2_journal_force_commit+0x34/0x4c
 [0000000000535ba4] ext4_force_commit+0x30/0x50
 [0000000000528644] ext4_write_inode+0x80/0xa0
 [00000000004d0808] __writeback_single_inode+0x1e4/0x330
 [00000000004d0974] sync_inode+0x20/0x40
 [0000000000525674] ext4_sync_file+0xc4/0x118
 [00000000004d3eac] vfs_fsync+0x6c/0xa0
 [00000000004d3f08] do_fsync+0x28/0x44
 [00000000004d3f60] SyS_fsync+0x14/0x28
 [0000000000406154] linux_sparc_syscall32+0x34/0x40
dbench        D 000000000055617c     0  1798      1
Call Trace:
 [0000000000555de8] start_this_handle+0x394/0x528
 [000000000055617c] jbd2_journal_start+0xbc/0x11c
 [00000000005391d8] ext4_journal_start_sb+0x5c/0x84
 [0000000000533328] ext4_unlink+0x2c/0x290
 [00000000004bd8f8] vfs_unlink+0x70/0xc8
 [00000000004bf984] do_unlinkat+0xc4/0x154
 [00000000004bfa28] SyS_unlink+0x14/0x24
 [0000000000406154] linux_sparc_syscall32+0x34/0x40
dbench        D 0000000000554938     0  1799      1
Call Trace:
 [000000000055bc04] jbd2_log_wait_commit+0x144/0x1a8
 [0000000000554938] jbd2_journal_stop+0x32c/0x37c
 [0000000000556210] jbd2_journal_force_commit+0x34/0x4c
 [0000000000535ba4] ext4_force_commit+0x30/0x50
 [0000000000528644] ext4_write_inode+0x80/0xa0
 [00000000004d0808] __writeback_single_inode+0x1e4/0x330
 [00000000004d0974] sync_inode+0x20/0x40
 [0000000000525674] ext4_sync_file+0xc4/0x118
 [00000000004d3eac] vfs_fsync+0x6c/0xa0
 [00000000004d3f08] do_fsync+0x28/0x44
 [00000000004d3f60] SyS_fsync+0x14/0x28
 [0000000000406154] linux_sparc_syscall32+0x34/0x40

dbench        D 000000000055617c     0  1800      1
Call Trace:
 [0000000000555de8] start_this_handle+0x394/0x528
 [000000000055617c] jbd2_journal_start+0xbc/0x11c
 [00000000005391d8] ext4_journal_start_sb+0x5c/0x84
 [0000000000529924] ext4_dirty_inode+0xd4/0xf0
 [00000000004d11d8] __mark_inode_dirty+0x2c/0x188
 [00000000004c6ec4] touch_atime+0x160/0x178
 [00000000004c21ec] vfs_readdir+0x88/0xb0
 [00000000004ea294] compat_sys_getdents+0x3c/0x8c
 [0000000000406154] linux_sparc_syscall32+0x34/0x40
pdflush       D 000000000055617c     0  1815      2
Call Trace:
 [0000000000555de8] start_this_handle+0x394/0x528
 [000000000055617c] jbd2_journal_start+0xbc/0x11c
 [00000000005391d8] ext4_journal_start_sb+0x5c/0x84
 [000000000052b7c8] ext4_da_writepages+0x1ac/0x408
 [0000000000490874] do_writepages+0x40/0x78
 [00000000004d07bc] __writeback_single_inode+0x198/0x330
 [00000000004d0d9c] generic_sync_sb_inodes+0x238/0x3c4
 [00000000004d1148] writeback_inodes+0xb0/0x114
 [0000000000490a70] wb_kupdate+0xdc/0x168
 [00000000004919b4] pdflush+0x128/0x1e0
 [0000000000465a94] kthread+0x48/0x7c
 [000000000042b37c] kernel_thread+0x3c/0x54
 [00000000004659a4] kthreadd+0xe8/0x190
pdflush       D 00000000005349b0     0  1818      2
Call Trace:
 [000000000055ac90] jbd2_journal_release_jbd_inode+0x94/0xd8
 [00000000005349b0] ext4_clear_inode+0x2c/0x3c
 [00000000004c72cc] clear_inode+0xac/0x124
 [0000000000526e2c] ext4_free_inode+0x7c/0x3c0
 [000000000052e758] ext4_delete_inode+0x218/0x29c
 [00000000004c7e64] generic_delete_inode+0x8c/0x124
 [00000000004c7f1c] generic_drop_inode+0x20/0x19c
 [00000000004c6f54] iput+0x78/0x88
 [00000000004d0e00] generic_sync_sb_inodes+0x29c/0x3c4
 [00000000004d1148] writeback_inodes+0xb0/0x114
 [0000000000490f74] background_writeout+0xc8/0x114
 [00000000004919b4] pdflush+0x128/0x1e0
 [0000000000465a94] kthread+0x48/0x7c
 [000000000042b37c] kernel_thread+0x3c/0x54
 [00000000004659a4] kthreadd+0xe8/0x190
