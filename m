From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: [BUG] Linux 2.6.25-rc6 - kernel BUG at
	fs/mpage.c:476! on powerpc
Date: Thu, 20 Mar 2008 13:13:01 +0530
Message-ID: <47E21585.1050603@linux.vnet.ibm.com>
References: <alpine.LFD.1.00.0803161651350.3020@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: jfs-discussion@lists.sourceforge.net, linuxppc-dev@ozlabs.org,
	shaggy@austin.ibm.com, Andy Whitcroft <apw@shadowen.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, Balbir Singh <balbir@linux.vnet.ibm.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Return-path: <jfs-discussion-bounces@lists.sourceforge.net>
In-Reply-To: <alpine.LFD.1.00.0803161651350.3020@woody.linux-foundation.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/jfs-discussion>,
	<mailto:jfs-discussion-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=jfs-discussion>
List-Post: <mailto:jfs-discussion@lists.sourceforge.net>
List-Help: <mailto:jfs-discussion-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/jfs-discussion>,
	<mailto:jfs-discussion-request@lists.sourceforge.net?subject=subscribe>
Sender: jfs-discussion-bounces@lists.sourceforge.net
Errors-To: jfs-discussion-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

When filesystem stress on ext2/3 mounted partition with the 2.6.25-rc6 kernel 
over the powerpc box, following calls traces are seen for more than 1000 times.

And when the file system stress in run on jfs mounted partition kernel bug is
seen.

INFO: task fsstress:30559 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Call Trace:
[c0000000ec09f580] [c0000000ec09f620] 0xc0000000ec09f620 (unreliable)
[c0000000ec09f750] [c0000000000108ec] .__switch_to+0x11c/0x154
[c0000000ec09f7e0] [c0000000004a644c] .schedule+0x7a4/0x888
[c0000000ec09f8d0] [c000000000111adc] .inode_wait+0x10/0x28multiple
[c0000000ec09f950] [c0000000004a6e64] .__wait_on_bit+0xa0/0x114
[c0000000ec09fa00] [c00000000011fc10] .__writeback_single_inode+0x124/0x360
[c0000000ec09faf0] [c000000000120308] .sync_sb_inodes+0x220/0x358
[c0000000ec09fba0] [c00000000012051c] .sync_inodes_sb+0xdc/0x120
[c0000000ec09fc80] [c000000000120614] .__sync_inodes+0xb4/0x164
[c0000000ec09fd20] [c00000000012419c] .do_sync+0x74/0xc0
[c0000000ec09fdb0] [c0000000001241fc] .sys_sync+0x14/0x28
[c0000000ec09fe30] [c000000000008734] syscall_exit+0x0/0x40
INFO: task fsstress:30853 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Call Trace:
[c000000096f1f1c0] [c000000096f1f280] 0xc000000096f1f280 (unreliable)
[c000000096f1f390] [c0000000000108ec] .__switch_to+0x11c/0x154
[c000000096f1f420] [c0000000004a644c] .schedule+0x7a4/0x888
[c000000096f1f510] [c0000000004a6a2c] .io_schedule+0x7c/0xe8
[c000000096f1f5a0] [c000000000126ce8] .sync_buffer+0x68/0x80
[c000000096f1f620] [c0000000004a6c80] .__wait_on_bit_lock+0x8c/0x110
[c000000096f1f6c0] [c0000000004a6d98] .out_of_line_wait_on_bit_lock+0x94/0xc0
[c000000096f1f7b0] [c000000000126fc0] .__lock_buffer+0x48/0x60
[c000000096f1f830] [c000000000128e24] .__bread+0x64/0x108
[c000000096f1f8b0] [c0000000001f0664] .ext2_get_inode+0xf8/0x194
[c000000096f1f950] [c0000000001f0764] .ext2_update_inode+0x64/0x4e4
[c000000096f1fa20] [c00000000011fcf0] .__writeback_single_inode+0x204/0x360
[c000000096f1fb10] [c000000000120af4] .sync_inode+0x44/0x88
[c000000096f1fba0] [c0000000001f0550] .ext2_sync_inode+0x44/0x60
[c000000096f1fc70] [c0000000001eee90] .ext2_sync_file+0x54/0x84
[c000000096f1fd00] [c000000000123f50] .do_fsync+0x90/0x10c
[c000000096f1fda0] [c000000000124000] .__do_fsync+0x34/0x60
[c000000096f1fe30] [c000000000008734] syscall_exit+0x0/0x40
INFO: task fsstress:30859 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Call Trace:
[c0000000b228f240] [c0000000b228f2e0] 0xc0000000b228f2e0 (unreliable)
[c0000000b228f410] [c0000000000108ec] .__switch_to+0x11c/0x154
[c0000000b228f4a0] [c0000000004a644c] .schedule+0x7a4/0x888
[c0000000b228f590] [c0000000004a6a2c] .io_schedule+0x7c/0xe8
[c0000000b228f620] [c000000000126ce8] .sync_buffer+0x68/0x80
[c0000000b228f6a0] [c0000000004a6e64] .__wait_on_bit+0xa0/0x114
[c0000000b228f750] [c0000000004a6f6c] .out_of_line_wait_on_bit+0x94/0xc0
[c0000000b228f840] [c000000000126bac] .__wait_on_buffer+0x30/0x48
[c0000000b228f8c0] [c00000000012a30c] .sync_dirty_buffer+0xf0/0x160
[c0000000b228f950] [c0000000001f0af8] .ext2_update_inode+0x3f8/0x4e4
[c0000000b228fa20] [c00000000011fcf0] .__writeback_single_inode+0x204/0x360
[c0000000b228fb10] [c000000000120af4] .sync_inode+0x44/0x88
[c0000000b228fba0] [c0000000001f0550] .ext2_sync_inode+0x44/0x60
[c0000000b228fc70] [c0000000001eee90] .ext2_sync_file+0x54/0x84
[c0000000b228fd00] [c000000000123f50] .do_fsync+0x90/0x10c
[c0000000b228fda0] [c000000000124000] .__do_fsync+0x34/0x60
[c0000000b228fe30] [c000000000008734] syscall_exit+0x0/0x40
INFO: task fsstress:30863 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Call Trace:
[c0000000b239f250] [c0000000b239f340] 0xc0000000b239f340 (unreliable)
[c0000000b239f420] [c0000000000108ec] .__switch_to+0x11c/0x154
[c0000000b239f4b0] [c0000000004a644c] .schedule+0x7a4/0x888
[c0000000b239f5a0] [c0000000004a6a2c] .io_schedule+0x7c/0xe8
[c0000000b239f630] [c000000000126ce8] .sync_buffer+0x68/0x80
[c0000000b239f6b0] [c0000000004a6c80] .__wait_on_bit_lock+0x8c/0x110
[c0000000b239f750] [c0000000004a6d98] .out_of_line_wait_on_bit_lock+0x94/0xc0
[c0000000b239f840] [c000000000126fc0] .__lock_buffer+0x48/0x60
[c0000000b239f8c0] [c00000000012a28c] .sync_dirty_buffer+0x70/0x160
[c0000000b239f950] [c0000000001f0af8] .ext2_update_inode+0x3f8/0x4e4
[c0000000b239fa20] [c00000000011fcf0] .__writeback_single_inode+0x204/0x360
[c0000000b239fb10] [c000000000120af4] .sync_inode+0x44/0x88
[c0000000b239fba0] [c0000000001f0550] .ext2_sync_inode+0x44/0x60
[c0000000b239fc70] [c0000000001eee90] .ext2_sync_file+0x54/0x84
[c0000000b239fd00] [c000000000123f50] .do_fsync+0x90/0x10c
[c0000000b239fda0] [c000000000124000] .__do_fsync+0x34/0x60
[c0000000b239fe30] [c000000000008734] syscall_exit+0x0/0x40

(gdb) p __switch_to
$1 = {struct task_struct *(struct task_struct *, struct task_struct *)} 0xc0000000000107d0 <__switch_to>
(gdb) p/x 0xc0000000000107d0+0x11c
$2 = 0xc0000000000108ec
(gdb) l *0xc0000000000108ec
0xc0000000000108ec is in __switch_to (arch/powerpc/kernel/process.c:356).
351
352             account_system_vtime(current);
353             account_process_vtime(current);
354             calculate_steal_time();
355
356             last = _switch(old_thread, new_thread);
357
358             local_irq_restore(flags);
359
360             return last;
(gdb) p schedule
$3 = {void (void)} 0xc0000000004a5ca8 <.schedule>
(gdb) p/x 0xc0000000004a5ca8+0x7a4
$4 = 0xc0000000004a644c
(gdb) l *0xc0000000004a644c
0xc0000000004a644c is at include/asm/current.h:22.
17
18      static inline struct task_struct *get_current(void)
19      {
20              struct task_struct *task;
21
22              __asm__ __volatile__("ld %0,%1(13)"
23              : "=r" (task)
24              : "i" (offsetof(struct paca_struct, __current)));
25
26              return task;



kernel BUG at fs/mpage.c:476!
cpu 0x0: Vector: 700 (Program Check) at [c0000000c28debd0]
    pc: c00000000012f588: .__mpage_writepage+0xd0/0x618
    lr: c0000000000c79c0: .write_cache_pages+0x228/0x3e8
    sp: c0000000c28dee50
   msr: 8000000000029032
  current = 0xc000000060ac5850
  paca    = 0xc000000000663b00
    pid   = 5254, comm = fsstress
kernel BUG at fs/mpage.c:476!
enter ? for help
[c0000000c28df3d0] c0000000000c79c0 .write_cache_pages+0x228/0x3e8
[c0000000c28df540] c00000000012fb84 .mpage_writepages+0x54/0x8c
[c0000000c28df5e0] c0000000001fe748 .jfs_writepages+0x1c/0x34
[c0000000c28df660] c0000000000c7c20 .do_writepages+0x68/0xa4
[c0000000c28df6e0] c0000000000bfbc0 .__filemap_fdatawrite_range+0x88/0xb8
[c0000000c28df7d0] c0000000000bfe9c .filemap_write_and_wait+0x2c/0x68
[c0000000c28df860] c0000000000c0848 .generic_file_buffered_write+0x65c/0x6c8
[c0000000c28df9a0] c0000000000c0bb4 .__generic_file_aio_write_nolock+0x300/0x3ec
[c0000000c28dfaa0] c0000000000c0d20 .generic_file_aio_write+0x80/0x114
[c0000000c28dfb60] c0000000000f7d7c .do_sync_write+0xc4/0x124
[c0000000c28dfcf0] c0000000000f85b0 .vfs_write+0xd8/0x1a4
[c0000000c28dfd90] c0000000000f8f3c .sys_write+0x4c/0x8c
[c0000000c28dfe30] c000000000008734 syscall_exit+0x0/0x40
--- Exception: c01 (System Call) at 000000000ff0d8c8
SP (ffb4c8a0) is in userspace


(gdb) p write_cache_pages
$1 = {int (struct address_space *, struct writeback_control *, writepage_t, void *)} 0xc0000000000c7798 <write_cache_pages>
(gdb) p/x 0xc0000000000c7798+0x228
$2 = 0xc0000000000c79c0
(gdb) l *0xc0000000000c79c0
0xc0000000000c79c0 is in write_cache_pages (mm/page-writeback.c:867).
862                                 !clear_page_dirty_for_io(page)) {
863                                     unlock_page(page);
864                                     continue;
865                             }
866
867                             ret = (*writepage)(page, wbc, data);
868
869                             if (unlikely(ret == AOP_WRITEPAGE_ACTIVATE)) {
870                                     unlock_page(page);
871                                     ret = 0;
(gdb) p __mpage_writepage
$3 = {int (struct page *, struct writeback_control *, void *)} 0xc00000000012f4b8 <__mpage_writepage>
(gdb) p/x 0xc00000000012f4b8+0xd0
$4 = 0xc00000000012f588
(gdb) l *0xc00000000012f588
0xc00000000012f588 is in __mpage_writepage (fs/mpage.c:476).
471                     struct buffer_head *bh = head;
472
473                     /* If they're all mapped and dirty, do it */
474                     page_block = 0;
475                     do {
476                             BUG_ON(buffer_locked(bh));
477                             if (!buffer_mapped(bh)) {
478                                     /*
479                                      * unmapped dirty buffers are created by
480                                      * __set_page_dirty_buffers -> mmapped data
(gdb) 



-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.

-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft
Defy all challenges. Microsoft(R) Visual Studio 2008.
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
